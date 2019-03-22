//
//  ExhibitorDescriptionCollectionViewCell.m
//  CodeChallenge
//

#import <Foundation/Foundation.h>

#import "ExhibitorDescriptionCollectionViewCell.h"


@implementation ExhibitorDescriptionCollectionViewCell

/**
 * Calculate how large we should make a ExhibitorDescriptionCollectionViewCell to fully display
 * text.
 *
 * @param text Text being displayed in cell.
 * @param width Estimated width of the cell.
 * @return Height needed to fully display text.
 */
+ (CGFloat)heightThatFits:(nonnull NSString *)text inWidth:(CGFloat)width
{
    ExhibitorDescriptionCollectionViewCell *descriptionCell = [[[NSBundle mainBundle] loadNibNamed:@"ExhibitorDescriptionCollectionViewCell" owner:self options:nil] firstObject];
    UITextView *textView = [descriptionCell textView];
    [textView setText:text];

    return [textView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height;
}

@end
