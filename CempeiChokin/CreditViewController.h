//
//  CreditViewController.h
//  CempeiChokin
//
//  Created by CEMPEI on 12/08/08.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditViewController : UITableViewController{
    __weak IBOutlet UILabel *versionLabel;
    __weak IBOutlet UITableViewCell *licenceCell;
    __weak IBOutlet UITextView *licenceTextView;
}
- (IBAction)contactButton_down:(id)sender;
- (IBAction)aboutButton_down:(id)sender;

@end
