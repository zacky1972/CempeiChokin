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

    NSString *NAME;
    NSNumber *VALUE;
    NSDate   *PERIOD;

    NSDate *START;
    NSDate *END;

    NSNumber *BUDGET;
    NSNumber *EXPENSE;
}

- (void)setUp{
    [super setUp];
    _editData = [[EditData alloc] init];
    [_editData deleteData];
    
    formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss ZZZ";

    // 初期設定
    NAME = @"Test";
    VALUE = @10000;
    PERIOD = [formatter dateFromString:@"2000-01-10 00:00:00 +0000"];
    
    START = [formatter dateFromString:@"2000-01-01 00:00:00 +0000"];
    END =   [formatter dateFromString:@"2000-01-05 00:00:00 +0000"];
    BUDGET = @50000;
    [_editData saveName:NAME Value:VALUE Period:PERIOD];
    [_editData saveStart:START End:END];

    [_editData calcForNextStage];
}

- (void)tearDown{
    [super tearDown];
}

// - (void)saveName:(NSString *)name Value:(NSNumber *)value Period:(NSDate *)period;
- (void)testSaveGoal{
    STAssertEqualObjects(NAME, [_editData loadGoalName], @"名前あってねーよ");
    STAssertEqualObjects(VALUE,[_editData loadGoalValue], @"値段あってねーよ");
    STAssertEqualObjects(PERIOD, [_editData loadGoalPeriod], @"日付あってねーよ");
}
// - (void)saveStart:(NSDate *)start End:(NSDate *)end;
- (void)testSaveNow{
    STAssertEqualObjects(START, [_editData loadStart], @"始まりあってねーよ");
    STAssertEqualObjects(END, [_editData loadEnd], @"終わりあってねーよ");
}
// - (void)calcForNextStage;
-(void) testCalcForNextStage{
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
// - (void)saveDepositDate:(NSDate *)date Value:(NSNumber *)value;
- (void)testSaveDeposit{
    _editData.didDeposit = NO;
    [_editData saveDepositDate:END Value:@1000];
    STAssertEqualObjects(_editData.deposit, @1000, @"貯金額おかしいで");

    [_editData saveDepositDate:END Value:@1500];
    STAssertEqualObjects(_editData.deposit, @1500, @"貯金額おかしいで");

    _editData.didDeposit = NO;
    NSDate *END_2 = [NSDate dateWithTimeInterval:60*60*24 sinceDate:END];
    [_editData saveStart:END End:END_2];

    [_editData saveDepositDate:END_2 Value:@1000];
    STAssertEqualObjects(_editData.deposit, @2500, @"貯金額おかしいで");
}
// - (void)skipDepositDate:(NSDate *)date;
- (void)testSkipDeposit{
    _editData.didDeposit = NO;
    [_editData skipDepositDate:END];
    STAssertEqualObjects(_editData.deposit, @0, @"貯金額おかしいで");

    NSDate *END_2 = [NSDate dateWithTimeInterval:60*60*24 sinceDate:END];
    [_editData saveStart:END End:END_2];

    [_editData saveDepositDate:END Value:@1000];
    STAssertEqualObjects(_editData.deposit, @1000, @"貯金額おかしいで");
    
    _editData.didDeposit = NO;
    [_editData saveDepositDate:END_2 Value:@1500];
    STAssertEqualObjects(_editData.deposit, @2500, @"貯金額おかしいで");
}

@end
