//
//  addGraph.m
//  CempeiChokin
//
//  Created by Takeshi on 12/08/02.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import "AddGraph.h"

@implementation AddGraph

@synthesize pieChartData;

// グラフの生成
- (CPTGraphHostingView *)makeGraph:(NSNumber *)expense Balance:(NSNumber *)balance Norma:(NSNumber *)norma{
    DNSLog(@"グラフ書き出し！");
    //　ホスティングビューを生成します。
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc]
                                        initWithFrame:CGRectMake(0, 0, 225, 250)];
    
    // グラフを生成します。
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:hostingView.bounds];
    hostingView.hostedGraph = graph;
    
    // 今回は円グラフなので、グラフの軸は使用しません。
    graph.axisSet = nil;
    
    // 円グラフのインスタンスを生成します。
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.pieRadius = 90.0;     // 円グラフの半径を設定します。
    pieChart.dataSource = self;    // データソースを設定します。
    pieChart.delegate = self;      // デリゲートを設定します。
    
    // グラフに円グラフを追加します。
    [graph addPlot:pieChart];
    
    // グラフに表示するデータを生成します。
    self.pieChartData = [NSMutableArray arrayWithObjects:
                         [NSNumber numberWithDouble:[expense floatValue]],
                         [NSNumber numberWithDouble:[balance floatValue]],
                         [NSNumber numberWithDouble:[norma floatValue]],
                         nil];
    
    // イケメン度アップ
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop : [[CPTColor blackColor] colorWithAlphaComponent:0.0]
                                         atPosition : 0.9 ];
    overlayGradient = [overlayGradient addColorStop : [[CPTColor blackColor] colorWithAlphaComponent:0.4]
                                         atPosition : 1.0 ];
    pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    
    // 生成したグラフを返す
    return hostingView;
}

// グラフの色設定
-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    CPTColor *color = [[CPTColor alloc] init];
    switch (index) {
        case 0:
            color = [CPTColor redColor];
            break;
        case 1:
            color = [CPTColor whiteColor];
            break;
        case 2:
            color = [CPTColor grayColor];
            break;
    }
    
    // 色を返す
	return [CPTFill fillWithColor:color];
}

// グラフに使用するデータの数を返すように実装します。
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self.pieChartData count];
}

// グラフに使用するデータの値を返すように実装します。
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    return [self.pieChartData objectAtIndex:index];
}

@end
