//
//  Exhibitor+CoreDataProperties.m
//  CodeChallenge
//

#import "Exhibitor+CoreDataProperties.h"

@implementation Exhibitor (CoreDataProperties)

+ (NSFetchRequest<Exhibitor *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Exhibitor"];
}

@dynamic address;
@dynamic alpha;
@dynamic city;
@dynamic contactName;
@dynamic contactTitle;
@dynamic country;
@dynamic descriptionInfo;
@dynamic email;
@dynamic fax;
@dynamic logoURL;
@dynamic name;
@dynamic phone;
@dynamic rowId;
@dynamic state;
@dynamic website;
@dynamic zip;

@end
