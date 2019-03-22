//
//  TitleViewController.m
//  CodeChallenge
//

#import "TitleViewController.h"

#import <os/log.h>

#import "AppDelegate.h"
#import "Exhibitor+CoreDataClass.h"


static NSString *DownloadURLString = @"https://static.coreapps.net/ioscodechallenge/exhibitors.json";

static NSString *CodeChallengeErrorDomain = @"CodeChallengeErrors";
typedef NS_ENUM(NSInteger, CodeChallengeErrorCodes){
    InvalidURLError = 100, // Using invalid URL.
    JSONArrayError = 101,  // JSON root was not an array
};


@interface TitleViewController ()

@property (nonatomic, weak) IBOutlet UIButton *showExhibitorsButton;

- (IBAction)showExhibitors:(id)sender;

@end


@implementation TitleViewController
{
    NSOperationQueue *dataProcessingQueue;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    dataProcessingQueue = [[NSOperationQueue alloc] init];
}

/**
 * Display some kind of dialog to let user know the application is downloading information.
 *
 * @return A UIAlertController that has been presented to user.  Use this return value to dismiss the alert when appropriate.
 */
- (nonnull UIAlertController *)displayDownloadingAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Downloading" message:@"\n\n\n" preferredStyle:UIAlertControllerStyleAlert];

    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:[alert.view bounds]];
    [activityIndicatorView setColor:[UIColor blackColor]];
    [activityIndicatorView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];

    [alert.view addSubview:activityIndicatorView];
    [activityIndicatorView setUserInteractionEnabled:NO];
    [activityIndicatorView startAnimating];

    [self presentViewController:alert animated:YES completion:nil];

    return alert;
}

/**
 * Display an alert dialog.
 *
 * @param error NSError associated with the alert.
 * @return an alert dialog that is being displayed.
 */
- (nonnull UIAlertController *)displayErrorAlert:(nullable NSError *)error
{
    NSString *errorString = [error localizedDescription];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorString preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:nil]];

    [self presentViewController:alert animated:YES completion:nil];

    return alert;
}

/**
 * Action to show the user the show exhibitors from information on server.
 *
 * @param sender UIButton that activates action.
 */
- (IBAction)showExhibitors:(id)sender
{
    // For now don't let user do anything until data is downloaded and ready.
    [self.showExhibitorsButton setEnabled:NO];
    __block UIAlertController *alert = [self displayDownloadingAlert];

    // Delete the existing data in the background from our Core Data store.
    NSOperation *batchDeleteOperation = [self createABatchDeleteOperation];
    [dataProcessingQueue addOperation:batchDeleteOperation];

    // This completion handler will be called when the data has finished downloading
    // in the background.  We can't have it run until we've deleted the previous data
    // so we'll kick off the UI work on the main queue by embedding that work in another
    // NSOperation dependent on the batch deletion operation completing first.
    __weak __typeof__(self) weakSelf = self;
    void (^finishedDownload)(NSError * _Nullable ) = ^(NSError  * _Nullable error) {

        NSBlockOperation *kickOffUIWorkOperation = [NSBlockOperation blockOperationWithBlock:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{

                __typeof__(self) strongUIWorkSelf = weakSelf;
                if (strongUIWorkSelf == nil) {
                    return;
                }

                // Renable UI controls.
                [alert dismissViewControllerAnimated:YES completion:^{
                    // If there's an error then we have to wait for the previous alert to disappear otherwise we get
                    // "Warning: Attempt to present <UIAlertController> on <TitleViewController> while a presentation is in progress!"
                    if (error != nil) {
                        [strongUIWorkSelf displayErrorAlert:error];
                    }
                }];
                [[strongUIWorkSelf showExhibitorsButton] setEnabled:YES];

                if (error != nil) {
                    // Because of a race condition when we present one alert after the other we handle this error in the code above.
                    // To be safe in case the code above gets changed we'll log the problem here too.
                    os_log_info(OS_LOG_DEFAULT, "CodeChallenge error: Download error occured.");
                    return;
                }

                // Transition to exhibitor list view controller.
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                if (mainStoryboard == nil) {
                    os_log_error(OS_LOG_DEFAULT, "CodeChallenge error: Unable to open Main.storyboard.");
                }
                UITableViewController *tableViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ExhibitorsTableViewController"];
                UINavigationController *navigationController = [self navigationController];
                [navigationController pushViewController:tableViewController animated:YES];
            }];
        }];

        // Have the UI work wait for the batch deletion to complete.
        [kickOffUIWorkOperation addDependency:batchDeleteOperation];

        // Queue up the UI work.
        __typeof__(self) strongKickOffUIWorkSelf = weakSelf;
        if (strongKickOffUIWorkSelf == nil) {
            return;
        }
        [strongKickOffUIWorkSelf->dataProcessingQueue addOperation:kickOffUIWorkOperation];
    };

    // Start downloading data.
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSPersistentContainer *persistentContainer = [appdelegate persistentContainer];
    [self loadExhibitorJSONFromURL:DownloadURLString to:persistentContainer completionHandler:finishedDownload];
}

/**
 * Batch delete previous exhibitor data.
 *
 * @return operation to delete exhibitor data
 * @note Exhibitor data should not be deleted when exhibitor data is being accessed.
 */
- (nonnull NSOperation *)createABatchDeleteOperation
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSPersistentContainer *persistentContainer = [appdelegate persistentContainer];

    NSBlockOperation *batchDeleteOperation = [NSBlockOperation blockOperationWithBlock:^{
        // We might hold on to this operation for a while but we don't need anything in it
        // so we'll make sure everything is released.
        @autoreleasepool {
            // https://developer.apple.com/library/archive/featuredarticles/CoreData_Batch_Guide/BatchDeletes/BatchDeletes.html
            NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Exhibitor"];
            NSBatchDeleteRequest *request = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetch];

            NSManagedObjectContext *managedObjectContext = [persistentContainer viewContext];
            NSError *batchDeleteError = nil;
            [managedObjectContext executeRequest:request error:&batchDeleteError];
            if (batchDeleteError != nil) {
                os_log_error(OS_LOG_DEFAULT, "CodeChallenge error: Unable to batch delete.");
            }
        }
    }];
    batchDeleteOperation.qualityOfService = NSQualityOfServiceUtility;

    return batchDeleteOperation;
}

/**
 * Load exhibitor information given URL.
 *
 * @param urlString URL (as NSString) for getting exhibitor information.
 * @param persistentContainer Core Data persistent container for storing information.
 * @param finishedDownload Callback indicating download has completed.
 * @note This is an async method.
 * @see https://www.simplifiedios.net/swift-json-tutorial/
 */
- (void)loadExhibitorJSONFromURL:(nonnull NSString *)urlString to:(nonnull NSPersistentContainer *)persistentContainer completionHandler:(nonnull void (^)(NSError * _Nullable error))finishedDownload
{
    NSURL *url = [NSURL URLWithString:urlString];
    if (url == nil) {
        NSError *invalidURL = [NSError errorWithDomain:CodeChallengeErrorDomain code:InvalidURLError userInfo:nil];
        finishedDownload(invalidURL);
        return;
    }

    NSURLSession *sharedSession = [NSURLSession sharedSession];
    NSURLSessionDataTask * dataTask = [sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable downloadError) {

        // Make sure download didn't fail.
        if (downloadError != nil) {
            finishedDownload(downloadError);
            return;
        }

        // Make sure we have some valid JSON.  No JSON fragments are accepted (options 0).
        NSError *jsonError = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError != nil) {
            finishedDownload(jsonError);
            return;
        }

        // Make sure our JSON root is an array since we are assuming that's what we have.
        if (![jsonObject isKindOfClass:[NSArray class]]) {
            NSError *invalidClassError = [NSError errorWithDomain:CodeChallengeErrorDomain code:JSONArrayError userInfo:nil];
            finishedDownload(invalidClassError);
            return;
        }

        NSArray *jsonArray = jsonObject;

        NSManagedObjectContext *managedObjectContext = [persistentContainer newBackgroundContext];

        for (NSDictionary *exhibitorDictionary in jsonArray) {
            BOOL exhibitorCreated = [Exhibitor insertFromDictionary:exhibitorDictionary context:managedObjectContext];
            if (exhibitorCreated) {
                NSError *saveError = nil;
                [managedObjectContext save:&saveError];
                if (saveError != nil) {
                    os_log_error(OS_LOG_DEFAULT, "CodeChallenge error: Unable to save exhibitor.");
                }
            }
        }

        finishedDownload(nil);
        return;
    }];
    [dataTask resume];
}

@end
