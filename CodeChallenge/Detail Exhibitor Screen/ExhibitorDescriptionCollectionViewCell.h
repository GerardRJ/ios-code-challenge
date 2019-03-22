//
//  ExhibitorDescriptionCollectionViewCell.h
//  CodeChallenge
//

#ifndef ExhibitorDescriptionCollectionViewCell_h
#define ExhibitorDescriptionCollectionViewCell_h


#import <UIKit/UIKit.h>

@interface ExhibitorDescriptionCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UITextView *textView;

+ (CGFloat)heightThatFits:(nonnull NSString *)text inWidth:(CGFloat)width;

@end

#endif /* ExhibitorDescriptionCollectionViewCell_h */
