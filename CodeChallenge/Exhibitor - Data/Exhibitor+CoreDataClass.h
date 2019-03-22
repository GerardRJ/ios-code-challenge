//
//  Exhibitor+CoreDataClass.h
//  CodeChallenge
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Exhibitor : NSManagedObject

+ (BOOL)insertFromDictionary:(nonnull NSDictionary *)dictionary context:(nonnull NSManagedObjectContext *)context;

@end


#import "Exhibitor+CoreDataProperties.h"
