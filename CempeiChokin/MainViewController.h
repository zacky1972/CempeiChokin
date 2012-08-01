//
//  MainViewController.h
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "Methods.h"

@interface MainViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIScrollView *LogScroll;
    __weak IBOutlet UILabel *BudgetLabel;
    __weak IBOutlet UILabel *ExpenseLabel;
    __weak IBOutlet UILabel *BalanceLabel;
    __weak IBOutlet UILabel *NormaLabel;
    __weak IBOutlet UITextField *expenseTextField;
    
    __weak IBOutlet UITableView *logTableView;
    
}

- (IBAction)expenseTextField_begin:(id)sender;

@end
