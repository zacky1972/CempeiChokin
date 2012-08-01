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

}

@property (readwrite, nonatomic) NSMutableArray *pieChartData;

@end
