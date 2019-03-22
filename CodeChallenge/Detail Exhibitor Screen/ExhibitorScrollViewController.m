//
//  ExhibitorScrollViewController.m
//  CodeChallenge
//

#import <Foundation/Foundation.h>
#import <os/log.h>

#import "ExhibitorScrollViewController.h"

#import "ExhibitorDescriptionCollectionViewCell.h"
#import "CodeChallenge-Swift.h"
#import "ExhibitorLabelCollectionViewCell.h"

static NSString *DescriptionCellIdentifier = @"ExhibitorDescriptionCollectionViewCell";
static NSString *ImageCellIdentifier = @"ExhibitorImageCollectionViewCell";
static NSString *LabelCellIdentifier = @"ExhibitorLabelCollectionViewCell";

static const NSInteger MaxNumberOfAttributesInExhibitor = 16;

typedef struct
{
    NSString *key;
    NSString *value;
    CGFloat height;
    NSString *cellIdentifier;
} Info;

@interface ExhibitorScrollViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;

@end


@implementation ExhibitorScrollViewController
{
    Info data[MaxNumberOfAttributesInExhibitor];
    NSInteger numberOfExhibitorAttributes;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    UICollectionViewFlowLayout *aFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    aFlowLayout.minimumLineSpacing = 0.0;

    self.flowLayout = aFlowLayout;
    [self.collectionView setCollectionViewLayout:aFlowLayout];

    {
        UINib *labelNib = [UINib nibWithNibName:@"ExhibitorLabelCollectionViewCell" bundle:nil];
        [self.collectionView registerNib:labelNib forCellWithReuseIdentifier:LabelCellIdentifier];
    }

    {
        UINib *descriptionNib = [UINib nibWithNibName:@"ExhibitorDescriptionCollectionViewCell" bundle:nil];
        [self.collectionView registerNib:descriptionNib forCellWithReuseIdentifier:DescriptionCellIdentifier];
    }

    {
        UINib *imageNib = [UINib nibWithNibName:@"ExhibitorImageCollectionViewCell" bundle:nil];
        [self.collectionView registerNib:imageNib forCellWithReuseIdentifier:ImageCellIdentifier];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculateAttributeCellSizes:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

/**
 * Calculate the sizes of all the cells.
 *
 * @param notification Dynamic type change notification or nil if we just initialized cells.
 */
- (void)calculateAttributeCellSizes:(nullable NSNotification *)notification
{
    const CGFloat defaultImageCellHeight = 100.0;
    const CGFloat defaultHeadlineCellHeight = 40.0;

    const CGFloat collectionViewWidth = [self.collectionView bounds].size.width;

    for (NSInteger i= 0; i<numberOfExhibitorAttributes; ++i) {
        NSString *cellIdentifier = data[i].cellIdentifier;
        if ([LabelCellIdentifier isEqualToString:cellIdentifier]) {
            data[i].height = [ExhibitorLabelCollectionViewCell heightThatFits:data[i].value inWidth:collectionViewWidth];
        }
        else if ([DescriptionCellIdentifier isEqualToString:cellIdentifier]) {
            data[i].height = [ExhibitorDescriptionCollectionViewCell heightThatFits:data[i].value inWidth:collectionViewWidth];
        }
        else if ([ImageCellIdentifier isEqualToString:cellIdentifier]) {
            data[i].height = defaultImageCellHeight;
        }

        if ([@"name" isEqualToString:data[i].key]) {
            if (data[i].height < defaultHeadlineCellHeight) {
                data[i].height = defaultHeadlineCellHeight;
            }
        }
    }

    if (notification != nil) {
        [[self.collectionView collectionViewLayout] invalidateLayout];
        [self.collectionView reloadData];
    }
}

/**
 * Use this to handle setting a db value to something that's not nil.
 *
 * @param value Value to make safe.
 * @return Value that's not nil and can be stored in db.
 */
+ (nonnull NSString *)safeValue:(nullable NSString *)value
{
    if (value == nil) {
        return @"---";
    }
    else {
        return value;
    }
}

/**
 * Store and display all available exhibitor information.
 *
 * @param exhibitor Obtain all information from this.
 */
- (void)populateWith:(nonnull Exhibitor *)exhibitor
{
    NSInteger index = 0;

    if (exhibitor.rowId != nil) {
        data[index].key = @"rowId";
        data[index].value = [ExhibitorScrollViewController safeValue:exhibitor.rowId];
        data[index].cellIdentifier = LabelCellIdentifier;
    }

    if (exhibitor.logoURL != nil) {
        ++index;
        data[index].key = @"logoURL";
        data[index].value = exhibitor.logoURL;
        data[index].cellIdentifier = ImageCellIdentifier;
    }

    if (exhibitor.name != nil) {
        ++index;
        data[index].key = @"name";
        data[index].value = [ExhibitorScrollViewController safeValue:exhibitor.name];
        data[index].cellIdentifier = LabelCellIdentifier;
    }

    if (exhibitor.address != nil) {
        ++index;
        data[index].key = @"address";
        data[index].value = [ExhibitorScrollViewController safeValue:exhibitor.address];
        data[index].cellIdentifier = LabelCellIdentifier;
    }

    if (exhibitor.city != nil) {
        ++index;
        data[index].key = @"city";
        data[index].value = [ExhibitorScrollViewController safeValue:exhibitor.city];
        data[index].cellIdentifier = LabelCellIdentifier;
    }

    if (exhibitor.state != nil) {
        ++index;
        data[index].key = @"state";
        data[index].value = [ExhibitorScrollViewController safeValue:exhibitor.state];
        data[index].cellIdentifier = LabelCellIdentifier;
    }

    if (exhibitor.zip != nil) {
        ++index;
        data[index].key = @"zip";
        data[index].value = [ExhibitorScrollViewController safeValue:exhibitor.zip];
        data[index].cellIdentifier = LabelCellIdentifier;
    }

    if (exhibitor.country != nil) {
        ++index;
        data[index].key = @"country";
        data[index].value = [ExhibitorScrollViewController safeValue:exhibitor.country];
        data[index].cellIdentifier = LabelCellIdentifier;
    }

    if (exhibitor.email != nil) {
        ++index;
        data[index].key = @"email";
        data[index].value = [ExhibitorScrollViewController safeValue:exhibitor.email];
        data[index].cellIdentifier = LabelCellIdentifier;
    }

    if (exhibitor.fax != nil) {
        ++index;
        data[index].key = @"fax";
        data[index].value = [ExhibitorScrollViewController safeValue:exhibitor.fax];
        data[index].cellIdentifier = LabelCellIdentifier;
    }

    if (exhibitor.website != nil) {
        ++index;
        data[index].key = @"website";
        data[index].value = [ExhibitorScrollViewController safeValue:exhibitor.website];
        data[index].cellIdentifier = LabelCellIdentifier;
    }

    if (exhibitor.contactName != nil) {
        ++index;
        data[index].key = @"contactName";
        data[index].value = [ExhibitorScrollViewController safeValue:exhibitor.contactName];
        data[index].cellIdentifier = LabelCellIdentifier;
    }

    if (exhibitor.contactTitle != nil) {
        ++index;
        data[index].key = @"contactTitle";
        data[index].value = [ExhibitorScrollViewController safeValue:exhibitor.contactTitle];
        data[index].cellIdentifier = LabelCellIdentifier;
    }

    if (exhibitor.phone != nil) {
        ++index;
        data[index].key = @"phone";
        data[index].value = [ExhibitorScrollViewController safeValue:exhibitor.phone];
        data[index].cellIdentifier = LabelCellIdentifier;
    }

    if (exhibitor.alpha != nil) {
        ++index;
        data[index].key = @"alpha";
        data[index].value = [ExhibitorScrollViewController safeValue:exhibitor.alpha];
        data[index].cellIdentifier = LabelCellIdentifier;
    }

    if (exhibitor.descriptionInfo != nil) {
        ++index;
        data[index].key = @"descriptionInfo";
        data[index].value = [ExhibitorScrollViewController safeValue:exhibitor.descriptionInfo];
        data[index].cellIdentifier = DescriptionCellIdentifier;
    }

    numberOfExhibitorAttributes = index + 1;

    // Sanity check to make sure we didn't overflow the data array.
    assert(numberOfExhibitorAttributes <= sizeof(data)/sizeof(Info));
    assert(numberOfExhibitorAttributes <= MaxNumberOfAttributesInExhibitor);

    [self calculateAttributeCellSizes:nil];
}

/**
 * Configure a simple single line of text cell.
 *
 * @param cell Configure this cell.
 * @param indexPath The index into the collection view.
 */
- (void)configureLabelCell:(nonnull ExhibitorLabelCollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    cell.label.text = data[indexPath.row].value;
    
    if ([data[indexPath.row].key isEqualToString:@"name"]) {
        [cell.label setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleLargeTitle]];
    }
}

/**
 * Configure a cell that will accept long text.
 *
 * @param cell Configure this cell.
 * @param indexPath The index into the collection view.
 */
- (void)configureDescriptionCell:(nonnull ExhibitorDescriptionCollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    cell.textView.text = data[indexPath.row].value;
}

/**
 * Configure a cell for an image.
 *
 * @param cell Configure this cell.
 * @param indexPath The index into the collection view.
 */
- (void)configureImageCell:(nonnull ExhibitorImageCollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSString *stringURL = data[indexPath.row].value;
    NSURL *url = [NSURL URLWithString:stringURL];
    if (url != nil) {
        [cell downloadImageFromURLWithUrlString:stringURL];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(nonnull UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return numberOfExhibitorAttributes;
}

- (__kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSString *cellIdentier = data[indexPath.row].cellIdentifier;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentier forIndexPath:indexPath];

    if ([cellIdentier isEqualToString:DescriptionCellIdentifier]) {
        [self configureDescriptionCell:(ExhibitorDescriptionCollectionViewCell *)cell forItemAtIndexPath:indexPath];
    }
    else if ([cellIdentier isEqualToString:ImageCellIdentifier])  {
        [self configureImageCell:(ExhibitorImageCollectionViewCell *)cell forItemAtIndexPath:indexPath];
    }
    else if ([cellIdentier isEqualToString:LabelCellIdentifier])  {
        [self configureLabelCell:(ExhibitorLabelCollectionViewCell *)cell forItemAtIndexPath:indexPath];
    }
    else {
        os_log_error(OS_LOG_DEFAULT, "CodeChallenge error: Can't configure ExhibitorScrollViewController cell.");
    }

    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(nonnull UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CGFloat collectionViewWidth = [self.collectionView bounds].size.width;
    CGFloat height = data[indexPath.row].height;
    return CGSizeMake(collectionViewWidth, height);
}

@end
