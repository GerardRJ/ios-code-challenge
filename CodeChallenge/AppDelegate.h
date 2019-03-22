//
//  AppDelegate.h
//  CodeChallenge
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic, readonly) NSPersistentContainer *persistentContainer;

- (void)recreatePersistentStore;

@end

