//
//  ExhibitorsTableViewController.m
//  CodeChallenge
//

#import <Foundation/Foundation.h>
#import <os/log.h>
#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "Exhibitor+CoreDataClass.h"
#import "ExhibitorSummaryCell.h"
#import "ExhibitorsTableViewController.h"

#import "exhibitorScrollViewController.h"


static NSString *ExhibitorSummaryCellIdentifier = @"ExhibitorSummaryCell";


@interface ExhibitorsTableViewController ()

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end


// search controller https://stackoverflow.com/questions/29664315/how-to-implement-uisearchcontroller-in-uitableview-swift
//
@implementation ExhibitorsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerClass:[ExhibitorSummaryCell class] forCellReuseIdentifier:ExhibitorSummaryCellIdentifier];

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.navigationItem.searchController = self.searchController;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = NO;

    // Apple debug message says:
    // "The topViewController (<ExhibitorsTableViewController>) of the navigation controller containing the
    // presented search controller (<UISearchController) must have definesPresentationContext set to YES."
    // Without this, when we pop this view controller, UIAlertController(s) don't show up properly.
    [self setDefinesPresentationContext:YES];

    [self initializeFetchedResultsController];
}

/**
 * Set up the NSFetchedResults controller to allow us to examine the exhibitors list.
 *
 * @see https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/nsfetchedresultscontroller.html
 */
- (void)initializeFetchedResultsController
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSPersistentContainer *persistentContainer = [appdelegate persistentContainer];
    NSManagedObjectContext *managedObjectContext = [persistentContainer viewContext];

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Exhibitor"];

    NSSortDescriptor *exhibitorName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    [request setSortDescriptors:@[exhibitorName]];

    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil]];
    [[self fetchedResultsController] setDelegate:self];

    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}


#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController
{
    NSString *searchTerm = searchController.searchBar.text;
    if (searchTerm == nil) {
        searchTerm = @"";
    }
    // We'll ignore leading and trailing spaces.  User will have to add character to indicate embedded white space.
    searchTerm = [searchTerm stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([searchTerm isEqualToString:@""]) {
        [self.fetchedResultsController.fetchRequest setPredicate:nil];
        NSError *error = nil;
        if (![[self fetchedResultsController] performFetch:&error]) {
            NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
        }
    }
    else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@",searchTerm];
        [self.fetchedResultsController.fetchRequest setPredicate:predicate];
        NSError *error = nil;
        if (![[self fetchedResultsController] performFetch:&error]) {
            NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
        }
    }

    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ExhibitorSummaryCell *cell = (ExhibitorSummaryCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    Exhibitor *exhibitor = cell.exhibitor;

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ExhibitorScrollViewController *exhibitorScrollViewController = (ExhibitorScrollViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"ExhibitorScrollViewController"];
    if (exhibitorScrollViewController == nil) {
        os_log_error(OS_LOG_DEFAULT, "CodeChallenge error: Unable to create Main.storyboard ExhibitorViewController.");
    }
    [exhibitorScrollViewController populateWith:exhibitor];

    UINavigationController *navigationController = [self navigationController];
    [navigationController pushViewController:exhibitorScrollViewController animated:YES];
}


#pragma mark - UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    ExhibitorSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:ExhibitorSummaryCellIdentifier];

    Exhibitor *exhibitor = (Exhibitor *)[self.fetchedResultsController objectAtIndexPath:indexPath];

    [[cell textLabel] setText:[exhibitor name]];
    cell.exhibitor = exhibitor;

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger exhibitorCount = [[[self fetchedResultsController] sections] count];
    return exhibitorCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id< NSFetchedResultsSectionInfo> sectionInfo = [[self fetchedResultsController] sections][section];
    return [sectionInfo numberOfObjects];
}

@end
