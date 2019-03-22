//
//  AppDelegate.m
//  CodeChallenge
//

#import "AppDelegate.h"


#import <os/log.h>

#import "User+CoreDataClass.h"

@interface AppDelegate ()

@property (strong, nonatomic, readwrite) NSPersistentContainer *persistentContainer;

@end

@implementation AppDelegate

/**
 * Create a single model sqlite store.
 *
 * @param modelName Name of the object model file.
 * @param storeName Name of the sqlite store.
 * @return Container for store.
 */
+ (NSPersistentContainer *)createPersistentStoreWithModel:(NSString *)modelName inFile:(NSString *)storeName {
    
    // Get model
    NSManagedObjectModel *model = nil;
    {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
        NSLog(@"Model URL: %@", modelURL);
        model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    // Load model.
    NSPersistentContainer *persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Bob" managedObjectModel:model];
    
    // Get sqlite url.
    // NSApplicationSupportDirectory might have to change in shipping app.
    NSArray *storeDescriptions = nil;
    {
        NSURL *storeURL = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        storeURL = [storeURL URLByAppendingPathComponent:storeName];
        NSLog(@"Calc url: %@", storeURL);
        NSPersistentStoreDescription *storeDescription = [NSPersistentStoreDescription persistentStoreDescriptionWithURL:storeURL];
        
        storeDescriptions = @[storeDescription];
    }
    
    // Set sqllite urls.
    [persistentContainer setPersistentStoreDescriptions:storeDescriptions];
    
    // Load stores.
    [persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *description, NSError *error) {
        if (error != nil) {
            NSLog(@"Failed to load Core Data stack: %@", error);
            abort();
        }
    }];
    
    NSURL *storeURL = [[[[persistentContainer persistentStoreCoordinator] persistentStores] firstObject] URL];
    NSLog(@"Real url: %@", storeURL);
    
    return persistentContainer;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Seed the LoginModel database.  If this isn't done everything ends up in the other database.
    // Hint from: https://stackoverflow.com/questions/8439866/one-application-with-two-databases
    {
        NSPersistentContainer *persistentContainer = [AppDelegate createPersistentStoreWithModel:@"LoginModel" inFile:@"LoginModel.sqlite"];
        [self saveUserInformation:persistentContainer];
        persistentContainer = nil;
        
        [AppDelegate createPersistentStoreWithModel:@"ExhibitorsModel" inFile:@"ExhibitorsModel.sqlite"];
    }
    
    // Get model
    NSManagedObjectModel *model = nil;
    {
        NSURL *exhibitorModelURL = [[NSBundle mainBundle] URLForResource:@"ExhibitorsModel" withExtension:@"momd"];
        NSManagedObjectModel *exhibitorModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:exhibitorModelURL];
        
        NSURL *loginModelURL = [[NSBundle mainBundle] URLForResource:@"LoginModel" withExtension:@"momd"];
        NSManagedObjectModel *loginModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:loginModelURL];
        
        model = [NSManagedObjectModel modelByMergingModels:@[exhibitorModel, loginModel]];
    }

    // Load model.
    self.persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Bob" managedObjectModel:model];
    
    // Get sqlite url.
    // NSApplicationSupportDirectory might have to change in shipping app.
    NSArray *storeDescriptions = nil;
    {
        NSURL *exhibitorStoreURL = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        exhibitorStoreURL = [exhibitorStoreURL URLByAppendingPathComponent:@"ExhibitorsModel.sqlite"];
        NSLog(@"Calc url: %@", exhibitorStoreURL);
        NSPersistentStoreDescription *exhibitorStoreDescription = [NSPersistentStoreDescription persistentStoreDescriptionWithURL:exhibitorStoreURL];

        NSURL *loginStoreURL = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        loginStoreURL = [loginStoreURL URLByAppendingPathComponent:@"LoginModel.sqlite"];
        NSLog(@"Calc url: %@", loginStoreURL);
        NSPersistentStoreDescription *loginStoreDescription = [NSPersistentStoreDescription persistentStoreDescriptionWithURL:loginStoreURL];
        
        storeDescriptions = @[exhibitorStoreDescription, loginStoreDescription];
    }
    
    // Set sqllite urls.
    [self.persistentContainer setPersistentStoreDescriptions:storeDescriptions];
    
    // Load stores.
    [self.persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *description, NSError *error) {
        if (error != nil) {
            NSLog(@"Failed to load Core Data stack: %@", error);
            abort();
        }
    }];
    
    NSURL *exhibitorStoreURL = [[[[self.persistentContainer persistentStoreCoordinator] persistentStores] firstObject] URL];
    NSLog(@"Real url: %@", exhibitorStoreURL);
    
    NSURL *loginStoreURL = [[[[self.persistentContainer persistentStoreCoordinator] persistentStores] lastObject] URL];
    NSLog(@"Real url: %@", loginStoreURL);
    
    [self printUserInformation];
    
    return YES;
}

/**
 * Strictly to test out saving stuff.
 *
 * @param persistentContainer Container to save user information to.
 */
- (void)saveUserInformation:(NSPersistentContainer *)persistentContainer {
    
    NSManagedObjectContext *context = [persistentContainer newBackgroundContext];
    
    [context performBlockAndWait:^{
        User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        [user setName:@"me"];
        [user setPassword:@"1234"];
        
        NSError *saveError = nil;
        [context save:&saveError];
        if (saveError != nil) {
            os_log_error(OS_LOG_DEFAULT, "CodeChallenge error: Unable to save exhibitor.");
        }
    }];
}

/*
 * Print the user information we should have saved.
 */
- (void)printUserInformation {
    
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSPersistentContainer *persistentContainer = [appdelegate persistentContainer];
    
    NSManagedObjectContext *context = [persistentContainer newBackgroundContext];
    
    [context performBlockAndWait:^{
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:request error:&error];
        if (!results) {
            NSLog(@"Error fetching Employee objects: %@\n%@", [error localizedDescription], [error userInfo]);
            abort();
        }
        else {
            User *user = (User *)[results lastObject];
            NSLog(@"Result: (%@, %@)", [user name], [user password]);
        }
    }];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
