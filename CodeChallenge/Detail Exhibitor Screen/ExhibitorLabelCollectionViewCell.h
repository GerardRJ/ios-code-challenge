//
//  ExhibitorLabelCollectionViewCell.h
//  CodeChallenge
//

#ifndef ExhibitorLabelCollectionViewCell_h
#define ExhibitorLabelCollectionViewCell_h


#import <UIKit/UIKit.h>

@interface ExhibitorLabelCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel * _Nullable label;

+ (CGFloat)heightThatFits:(nonnull NSString *)text inWidth:(CGFloat)width;

@end

#endif /* ExhibitorLabelCollectionViewCell_h */
