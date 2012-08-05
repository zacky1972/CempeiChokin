//
//  TranslateFormatTest.m
//  CempeiChokin
//
//  Created by Takeshi on 12/08/05.
//  Copyright (c) 2012年 Nakano Asami. All rights reserved.
//

#import "TranslateFormatTest.h"
#import "../CempeiChokin/TranslateFormat.h"

@implementation TranslateFormatTest{
    TranslateFormat *_translateFormat;
}

- (void)setUp{
    [super setUp];
    _translateFormat = [TranslateFormat alloc];
}

- (void)tearDown{
    [super tearDown];
}

- (void)testDateOnly{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";
    NSDate *inputDate = [formatter dateFromString:@"2012-01-01 00:00:00 +0000"];
    NSDate *outputDate = [_translateFormat timeTokaIranKattanYa:inputDate];
    NSDate *correctDate = [formatter dateFromString:@"2012-01-01 00:00:00 +0000"];
    STAssertEqualObjects(outputDate, correctDate, @"正しく変換できていません。");
    NSDate *now = [NSDate date];
    now = [_translateFormat timeTokaIranKattanYa:now];
    correctDate = [formatter dateFromString:@"2012-08-05 00:00:00 +0000"];
    STAssertEqualObjects(now, correctDate, @"正しく変換できていません。");
}

@end
