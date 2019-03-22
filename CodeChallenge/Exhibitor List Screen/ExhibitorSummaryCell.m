//
//  ExhibitorSummaryCell.m
//  CodeChallenge
//

#import <Foundation/Foundation.h>

#import "ExhibitorSummaryCell.h"

@implementation ExhibitorSummaryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        return self;
    }
    else {
        return nil;
    }
}

@end
