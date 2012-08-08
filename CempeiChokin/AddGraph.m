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
                         [NSNumber numberWithDouble:[expense intValue]],
                         [NSNumber numberWithDouble:[balance intValue]],
                         [NSNumber numberWithDouble:[norma intValue]],
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
    
    /*
     
     // グラデーションつけてかっこつけてみよう
     // 青～黒(テーマが黒いから)にわかりづらいけど...
     CPColor *areaColor1 = [CPColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:0.8];
     CPGradient *areaGradient1 = [CPGradient gradientWithBeginningColor:areaColor1 endingColor:[CPColor clearColor]];
     
     CPFill *areaGradientFill = [CPFill fillWithGradient:areaGradient1];
     scorePlot.areaFill = areaGradientFill;
     scorePlot.areaBaseValue = [[NSDecimalNumber zero] decimalValue];
     
     */
    
    CPTColor *color = [[CPTColor alloc] init];
    CPTFill *fill = [[CPTFill alloc] init];
    switch (index) {
        case 0:{
            color = [CPTColor colorWithComponentRed:0.3 green:0.7 blue:1.0 alpha:10];
            CPTColor *endingColor = [CPTColor colorWithComponentRed:0.3 green:0.3 blue:1.0 alpha:10];
            CPTGradient *areaGradient1 = [CPTGradient gradientWithBeginningColor:color endingColor:endingColor];
            fill = [CPTFill fillWithGradient:areaGradient1];}
            break;
        case 1:
            color = [CPTColor whiteColor];
            fill = [CPTFill fillWithColor:color];
            break;
        case 2:
            color = [CPTColor colorWithComponentRed:0.1 green:0.1 blue:0.1 alpha:0.2];
            fill = [CPTFill fillWithColor:color];
            break;
    }
    
    // 色を返す
	return fill;
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
