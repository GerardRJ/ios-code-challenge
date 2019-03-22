//
//  ExhibitorScrollViewController.h
//  CodeChallenge
//

#ifndef ExhibitorScrollViewController_h
#define ExhibitorScrollViewController_h

#import <UIKit/UIKit.h>

#import "Exhibitor+CoreDataClass.h"

@interface ExhibitorScrollViewController : UICollectionViewController

- (void)populateWith:(nonnull Exhibitor *)exhibitor;

@end

#endif /* ExhibitorScrollViewController_h */
