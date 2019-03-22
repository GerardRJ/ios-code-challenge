//
//  Exhibitor+CoreDataClass.m
//  CodeChallenge
//

#import "Exhibitor+CoreDataClass.h"

@implementation Exhibitor

/**
 * Return a representation of the value passed in that's appropriate to store in our Core Data db.
 *
 * @param value Value that needs to be stored in db.
 * @return A db appropriate version of value.
 */
+ (NSString *)databaseValue:(NSString *)value
{
    if (value == nil || [value isEqualToString:@"NULL"]) {
        return nil;
    }
    else {
        return value;
    }
}

/**
 * From a dictionary insert an exhibitor into a managed object context.
 *
 * @param dictionary Dictionary containing information to populate Exhibitor with
 * @param context Managed object context to insert the Exhibitor into
 * @return true if successfully added the information and inserted the Exhibitor into context.
 * @note Save must be called on context to save Exhibitor.
 */
+ (BOOL)insertFromDictionary:(nonnull NSDictionary *)dictionary context:(nonnull NSManagedObjectContext *)context {

    __block BOOL exhibitorCreated = NO;

    [context performBlockAndWait:^{
        Exhibitor *exhibitor = [NSEntityDescription insertNewObjectForEntityForName:@"Exhibitor" inManagedObjectContext:context];

        [exhibitor setDescriptionInfo:[Exhibitor databaseValue:dictionary[@"description"]]];
        [exhibitor setRowId:[Exhibitor databaseValue:dictionary[@"rowid"]]];
        [exhibitor setState:[Exhibitor databaseValue:dictionary[@"state"]]];
        [exhibitor setPhone:[Exhibitor databaseValue:dictionary[@"phone"]]];
        [exhibitor setZip:[Exhibitor databaseValue:dictionary[@"zip"]]];
        [exhibitor setContactTitle:[Exhibitor databaseValue:dictionary[@"contactTitle"]]];
        [exhibitor setContactName:[Exhibitor databaseValue:dictionary[@"contactName"]]];
        [exhibitor setLogoURL:[Exhibitor databaseValue:dictionary[@"logoUrl"]]];
        [exhibitor setFax:[Exhibitor databaseValue:dictionary[@"fax"]]];
        [exhibitor setAddress:[Exhibitor databaseValue:dictionary[@"address"]]];
        [exhibitor setAlpha:[Exhibitor databaseValue:dictionary[@"alpha"]]];
        [exhibitor setCity:[Exhibitor databaseValue:dictionary[@"city"]]];
        [exhibitor setWebsite:[Exhibitor databaseValue:dictionary[@"website"]]];
        [exhibitor setCountry:[Exhibitor databaseValue:dictionary[@"country"]]];
        [exhibitor setEmail:[Exhibitor databaseValue:dictionary[@"email"]]];
        [exhibitor setName:[Exhibitor databaseValue:dictionary[@"name"]]];

        exhibitorCreated = YES;
    }];

    return exhibitorCreated;
}

@end
