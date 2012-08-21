//
//  MainViewController.h
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import <AudioToolbox/AudioServices.h>
#import "Methods.h"
#import "AddGraph.h"
#import "TranslateFormat.h"

@interface MainViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UINavigationBar *MainNavigationBar;
    __weak IBOutlet UIScrollView *LogScroll;
    __weak IBOutlet UILabel *BudgetLabel;
    __weak IBOutlet UILabel *ExpenseLabel;
    __weak IBOutlet UILabel *BalanceLabel;
    __weak IBOutlet UILabel *NormaLabel;
    __weak IBOutlet UILabel *DepositLabel;
    __weak IBOutlet UITextField *expenseTextField;
    __weak IBOutlet UISegmentedControl *KindSegment;
    __weak IBOutlet UITableView *logTableView;
    __weak IBOutlet UIImageView *exclamationImageView;
    
    __weak IBOutlet UIButton *pleaseDepositButton;
    __weak IBOutlet UIButton *pleaseNextButton;
    
}

- (IBAction)expenseTextField_begin:(id)sender;
- (IBAction)expenseTextField_end:(id)sender;
- (IBAction)pleaseDepositButton_down:(id)sender;
- (IBAction)pleaseNextBtton_down:(id)sender;

@end
