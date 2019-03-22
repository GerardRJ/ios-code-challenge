//
//  ExhibitorLabelCollectionViewCell.m
//  CodeChallenge
//

#import <Foundation/Foundation.h>

#import "ExhibitorLabelCollectionViewCell.h"


@implementation ExhibitorLabelCollectionViewCell

/**
 * Calculate how large we should make a ExhibitorLabelCollectionViewCell to fully display
 * text.
 *
 * @param text Text being displayed in cell.
 * @param width Estimated width of the cell.
 * @return Height needed to fully display text.
 */
+ (CGFloat)heightThatFits:(nonnull NSString *)text inWidth:(CGFloat)width
{
    ExhibitorLabelCollectionViewCell *labelCell = [[[NSBundle mainBundle] loadNibNamed:@"ExhibitorLabelCollectionViewCell" owner:self options:nil] firstObject];

    // The UILabel we get here is configured based on settings we made in .xib file.
    UILabel *label = [labelCell label];
    [label setText:text];

    return [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height;
}

@end
