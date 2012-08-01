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

@interface MainViewController : UIViewController <CPTPieChartDataSource,CPTPieChartDelegate>
{
    IBOutlet UIScrollView *LogScroll;
    __weak IBOutlet UILabel *BudgetLabel;
    __weak IBOutlet UILabel *ExpensesLabel;
    __weak IBOutlet UILabel *BalanceLabel;
    __weak IBOutlet UILabel *QuotaLabel;
    __weak IBOutlet UISegmentedControl *KindSegment;
    __weak IBOutlet UITextField *MoneyValueLabel;
}

@property (readwrite, nonatomic) NSMutableArray *pieChartData;

@end
