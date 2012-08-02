//
//  addGraph.h
//  CempeiChokin
//
//  Created by Takeshi on 12/08/02.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"

@interface addGraph : NSObject <CPTPieChartDataSource,CPTPieChartDelegate>

@property (readwrite, nonatomic) NSMutableArray *pieChartData;

// グラフの生成
- (CPTGraphHostingView *)makeGraph:(NSNumber *)expense Balance:(NSNumber *)balance Norma:(NSNumber *)norma;


@end
