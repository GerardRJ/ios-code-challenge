//
//  AppDelegate.m
//  CodeChallenge
//

#import "AppDelegate.h"

#import <os/log.h>

#import "EncryptedStore.h"

@interface AppDelegate ()

@property (strong, nonatomic, readwrite) NSPersistentContainer *persistentContainer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ExhibitorsModel"];
    
    [self createPersistentStore];
    
    return YES;
}

/**
 * This method deletes the persistent store and then creates a new one.
 *
 * @note https://stackoverflow.com/questions/1077810/delete-reset-all-entries-in-core-data
 */
- (void)recreatePersistentStore
{
    NSArray *stores = [[self.persistentContainer persistentStoreCoordinator] persistentStores];
    os_log_debug(OS_LOG_DEFAULT, "Stores: %{public}@", stores);
    
    for(NSPersistentStore *store in stores) {
        [[self.persistentContainer persistentStoreCoordinator] removePersistentStore:store error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:store.URL.path error:nil];
    }
    
    [self createPersistentStore];
}

/**
 * This method creates a persistent store.
 */
- (void)createPersistentStore
{
    NSDictionary *cOpts = @{
                            [EncryptedStore optionPassphraseKey] : @"123deOliveira4", //your Key
                            [EncryptedStore optionFileManager] : [EncryptedStoreFileManager defaultManager]
                            };
    NSPersistentStoreDescription *desc = [EncryptedStore makeDescriptionWithOptions:cOpts configuration:@"Default" error:nil];
    
    [self.persistentContainer setPersistentStoreDescriptions:@[desc]];
    
    [self.persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *description, NSError *error) {
        if (error != nil) {
            NSLog(@"Failed to load Core Data stack: %@", error);
            abort();
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
