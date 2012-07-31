//
//  BudgetViewController.h
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Methods.h"

@interface BudgetViewController : UITableViewController{
    __weak IBOutlet UITextField *startDateTextField;
    __weak IBOutlet UITextField *endDateTextField;
    __weak IBOutlet UITextField *budgetTextField;
    
}
- (IBAction)startDateTextField_begin:(id)sender;
- (IBAction)endDateTextField_begin:(id)sender;
- (IBAction)budgetTextField_end:(id)sender;

@end
