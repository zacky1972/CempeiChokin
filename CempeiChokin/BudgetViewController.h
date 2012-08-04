//
//  BudgetViewController.h
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Methods.h"
#import "TranslateFormat.h"

@interface BudgetViewController : UITableViewController{
    __weak IBOutlet UITextField *startDateTextField;
    __weak IBOutlet UITextField *endDateTextField;
    __weak IBOutlet UITextField *budgetTextField;
    __weak IBOutlet UIButton *DoneButton;
    __weak IBOutlet UIButton *laterButton;
    
}
- (IBAction)startDateTextField_begin:(id)sender;
- (IBAction)endDateTextField_begin:(id)sender;
- (IBAction)budgetTextField_begin:(id)sender;
- (IBAction)DoneButton_down:(id)sender;
- (IBAction)laterButton_down:(id)sender;

@end
