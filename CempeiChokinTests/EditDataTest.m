//
//  EditDataTest.m
//  CempeiChokin
//
//  Created by Takeshi on 12/08/11.
//  Copyright (c) 2012年 Nakano Asami. All rights reserved.
//

#import "EditDataTest.h"
#import "../CempeiChokin/EditData.h"
#import "../CempeiChokin/EditData.m"

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
    NSDate *DATE = [formatter dateFromString:@"2000-01-20 00:00:00 +0900"];
    // 期間
    NSDate *START = [formatter dateFromString:@"2000-01-01 00:00:00 +0900"];
    NSDate *END = [formatter dateFromString:@"2000-01-10 00:00:00 +0900"];
    
    [_editData saveName:@"Test" Value:VALUE Period:DATE];
    [_editData saveStart:START End:END];

    [_editData calcForNextStage];
    STAssertEqualObjects(_editData.norma,@5000, @"ノルマ計算ミスってるで");
}
// - (void)calcValue:(NSNumber *)value Kind:(NSInteger)kind;
- (void)testCalcValue{
    _editData.budget = @100000;
    _editData.expense = @50000;
    _editData.balance = @50000;

    // 出費
    [_editData calcValue:@10000 Kind:0];
    STAssertEqualObjects(_editData.expense, @60000, @"出費が");
    STAssertEqualObjects(_editData.balance, @40000, @"残金が");

    _editData.budget = @100000;
    _editData.expense = @50000;
    _editData.balance = @50000;
    // 収入
    [_editData calcValue:@10000 Kind:1];
    STAssertEqualObjects(_editData.budget, @110000, @"出費が");
    STAssertEqualObjects(_editData.balance, @60000, @"残金が");

    _editData.budget = @100000;
    _editData.expense = @50000;
    _editData.balance = @50000;
    // 残高調整
    [_editData calcValue:@10000 Kind:2];
    STAssertEqualObjects(_editData.expense, @90000, @"出費が");
    STAssertEqualObjects(_editData.balance, @10000, @"残高が");
}
// - (void)calcDeleteValue:(NSNumber *)value Kind:(NSString *)tempKind;
- (void)testCalcDeleteValue{

    _editData.budget = @100000;
    _editData.expense = @50000;
    _editData.balance = @50000;

    // 出費
    [_editData calcDeleteValue:@10000 Kind:@"出費"];
    STAssertEqualObjects(_editData.expense, @40000, @"出費が");
    STAssertEqualObjects(_editData.balance, @60000, @"残金が");

    _editData.budget = @100000;
    _editData.expense = @50000;
    _editData.balance = @50000;
    // 収入
    [_editData calcDeleteValue:@10000 Kind:@"収入"];
    STAssertEqualObjects(_editData.budget, @90000, @"出費が");
    STAssertEqualObjects(_editData.balance, @40000, @"残金が");

    _editData.budget = @100000;
    _editData.expense = @50000;
    _editData.balance = @50000;
    // 残高調整
    [_editData calcDeleteValue:@10000 Kind:@"残高調整"];
    STAssertEqualObjects(_editData.expense, @40000, @"出費が");
    STAssertEqualObjects(_editData.balance, @60000, @"残高が");
}

@end
