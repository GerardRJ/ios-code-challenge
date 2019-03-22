//
//  Exhibitor+CoreDataProperties.h
//  CodeChallenge
//

#import "Exhibitor+CoreDataClass.h"


@interface Exhibitor (CoreDataProperties)

+ (NSFetchRequest<Exhibitor *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *alpha;
@property (nullable, nonatomic, copy) NSString *city;
@property (nullable, nonatomic, copy) NSString *contactName;
@property (nullable, nonatomic, copy) NSString *contactTitle;
@property (nullable, nonatomic, copy) NSString *country;
@property (nullable, nonatomic, copy) NSString *descriptionInfo;
@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *fax;
@property (nullable, nonatomic, copy) NSString *logoURL;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *phone;
@property (nullable, nonatomic, copy) NSString *rowId;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSString *website;
@property (nullable, nonatomic, copy) NSString *zip;

@end

