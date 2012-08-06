//
//  DepositViewController.h
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Methods.h"
#import "TranslateFormat.h"

@interface DepositViewController : UITableViewController{
    __weak IBOutlet UITableView *depositTableView;
    __weak IBOutlet UITextField *depositTextField;
    __weak IBOutlet UIView *DoneButton;
}

- (IBAction)depositTextField_begin:(id)sender;
- (IBAction)DoneButton_down:(id)sender;
- (IBAction)laterButton_down:(id)sender;

@end
