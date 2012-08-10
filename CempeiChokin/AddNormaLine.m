//
//  AddNormaLine.m
//  CempeiChokin
//
//  Created by 中野 麻美 on 12/08/10.
//  Copyright (c) 2012年 Nakano Asami. All rights reserved.
//

#import "AddNormaLine.h"

@implementation AddNormaLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 0.5, 0.0, 1.0);
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.5, 1.0);
    CGContextSetLineWidth(context, 10.0);
    CGRect r1 = CGRectMake(50.0, 50.0, 100.0, 100.0);
    CGContextAddRect(context, r1);
    CGContextFillPath(context);
    CGRect r2 = CGRectMake(100.0, 100.0, 100.0, 100.0);
    CGContextAddRect(context, r2);
    CGContextStrokePath(context);
    
}


@end
