//
//  AddDepositGraph.m
//  CempeiChokin
//
//  Created by 森 龍志 on 12/08/15.
//  Copyright (c) 2012年 Nakano Asami. All rights reserved.
//

#import "AddDepositGraph.h"
@implementation AddDepositGraph

- (void)generateData
{
    
    
    NSMutableDictionary *dataTemp = [[NSMutableDictionary alloc] init];
    
    //Array containing all the dates that will be displayed on the X axis
    dates = [NSArray arrayWithObjects:@"2012-05-01", @"2012-05-02", @"2012-05-03",
             @"2012-05-04", @"2012-05-05", @"2012-05-06", @"2012-05-07", nil];
    
    //Dictionary containing the name of the two sets and their associated color
    //used for the demo
    sets = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor], @"Plot 1",
            [UIColor redColor], @"Plot 2",
            [UIColor greenColor], @"Plot 3", nil];
    
    //Generate random data for each set of data that will be displayed for each day
    //Numbers between 1 and 10
    for (NSString *date in dates) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (NSString *set in sets) {
            NSNumber *num = [NSNumber numberWithInt:arc4random_uniform(10)+1];
            [dict setObject:num forKey:set];
        }
        [dataTemp setObject:dict forKey:date];
    }
    
    data = [dataTemp copy];
    
    NSLog(@"%@", data);
}

@end
