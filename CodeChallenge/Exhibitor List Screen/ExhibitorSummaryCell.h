//
//  ExhibitorSummaryCell.h
//  CodeChallenge
//

#ifndef ExhibitorSummaryCell_h
#define ExhibitorSummaryCell_h

#import <UIKit/UIKit.h>

#import "Exhibitor+CoreDataClass.h"

@interface ExhibitorSummaryCell : UITableViewCell

@property (nonatomic, weak) Exhibitor *exhibitor;

@end


#endif /* ExhibitorSummaryCell_h */
