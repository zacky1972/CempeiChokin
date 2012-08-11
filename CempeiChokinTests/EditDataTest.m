//
//  EditDataTest.m
//  CempeiChokin
//
//  Created by Takeshi on 12/08/11.
//  Copyright (c) 2012年 Nakano Asami. All rights reserved.
//

#import "EditDataTest.h"
#import "../CempeiChokin/EditData.h"

@implementation EditDataTest{
    EditData *_editData;

    NSDateFormatter *formatter;
}

- (void)setUp{
    [super setUp];
    _editData = [[EditData alloc] init];

    formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";
}

- (void)tearDown{
    [super tearDown];

}

// - (void)saveName:(NSString *)name Value:(NSNumber *)value Period:(NSDate *)period;
- (void)testSaveGoal{
    NSString *NAME = @"Test";
    NSNumber *VALUE = @10000;
    NSDate *DATE = [formatter dateFromString:@"2000-01-01 00:00:00 +0000"];
    NSDate *inputDate = [NSDate alloc];
    for(int i = 0; i<24; i++){
        if(i == 0)
            inputDate = [formatter dateFromString:@"2000-01-01 00:00:00 +0900"];
        else
            inputDate = [inputDate dateByAddingTimeInterval:60*60*1];
        DNSLog(@"\n【Input】\ninputDate:%@",inputDate);
        [_editData saveName:NAME Value:VALUE Period:inputDate];
        STAssertEqualObjects(NAME, [_editData loadGoalName], @"名前あってねーよ");
        STAssertEqualObjects(VALUE,[_editData loadGoalValue], @"値段あってねーよ");
        STAssertEqualObjects(DATE, [_editData loadGoalPeriod], @"日付あってねーよ");
    }
}
// - (void)saveStart:(NSDate *)start End:(NSDate *)end;
- (void)testSaveNow{
    NSDate *DATE = [formatter dateFromString:@"2000-01-01 00:00:00 +0000"];
    NSDate *DATE_2 = [NSDate dateWithTimeInterval:60*60*24*7 sinceDate:DATE];
    NSDate *inputDate1 = [NSDate alloc];
    NSDate *inputDate2 = [NSDate alloc];
    for(int i = 0; i<24; i++){
        if(i == 0){
            inputDate1 = [formatter dateFromString:@"2000-01-01 00:00:00 +0900"];
            inputDate2 = [NSDate dateWithTimeInterval:60*60*24*7 sinceDate:inputDate1];
        }else{
            inputDate1 = [inputDate1 dateByAddingTimeInterval:60*60*1];
            inputDate2 = [NSDate dateWithTimeInterval:60*60*24*7 sinceDate:inputDate1];
        }
        DNSLog(@"\n【Input】\nStart:%@ \nEnd  :%@",inputDate1,inputDate2);
        [_editData saveStart:inputDate1 End:inputDate2];
        DNSLog(@"\n【Saved】\nStart:%@ \nEnd  :%@",[_editData loadStart],[_editData loadEnd]);
        STAssertEqualObjects(DATE, [_editData loadStart], @"始まりあってねーよ");
        STAssertEqualObjects(DATE_2, [_editData loadEnd], @"終わりあってねーよ");
    }
}

// - (void)calcForNextStage;
-(void) testCalcForNextStage{
    // 値段
    NSNumber *VALUE = @10000;
    // 期限
    NSDate *DATE = [formatter dateFromString:@"2000-01-20 00:00:00 +0000"];
    // 期間
    NSDate *START = [formatter dateFromString:@"2000-01-01 00:00:00 +0000"];
    NSDate *END = [formatter dateFromString:@"2000-01-10 00:00:00 +0000"];
    
    [_editData saveName:@"Test" Value:VALUE Period:DATE];
    [_editData saveStart:START End:END];

    [_editData calcForNextStage];
    STAssertEqualObjects(@5000, _editData.norma, @"ノルマ計算ミスってるで");
}

@end
