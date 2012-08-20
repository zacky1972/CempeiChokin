//
//  AddDepositGraph.h
//  CempeiChokin
//
//  Created by 森 龍志 on 12/08/15.
//  Copyright (c) 2012年 Nakano Asami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"

@interface AddDepositGraph : CPTGraphHostingView
{

    CPTXYGraph *graph;
    
    NSDictionary *data;
    NSDictionary *sets;
    NSArray *dates;
    
}

- (void)createGraph;

@end
