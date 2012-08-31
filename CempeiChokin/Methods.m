//
//  Methods.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//
#import "Methods.h"
#import "TranslateFormat.h"

@interface Methods (){
}
@end

@implementation Methods

//スクロールビューの大きさを変更 改
- (float)fitScrollViewWithCount:(NSUInteger)count{
    DNSLog(@"ビューをフィット！");
    float height;
    height = 779 + 45 * count;
    return height;
}

@end
