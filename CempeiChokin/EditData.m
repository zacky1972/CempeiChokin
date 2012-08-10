//
//  EditData.m
//  CempeiChokin
//
//  Created by Takeshi on 12/08/07.
//  Copyright (c) 2012年 Nakano Asami. All rights reserved.
//

#import "EditData.h"
#import "TranslateFormat.h"

@implementation EditData{
    TranslateFormat *_translateFormat;

    NSString *path;
    NSMutableDictionary *root;
    NSMutableDictionary *goal;
    NSMutableDictionary *now;
}

@synthesize expense,balance,norma,budget;
@synthesize deposit,depositLog;
@synthesize defaultSettings,nextAlert;

// 初期化
-(id)init{
    self = [super init];
    if(self){
        [self initData];
    }
    return self;
}

#pragma mark - ファイルの初期化系
// ファイルの初期化
- (void)initData{
    [self makeDataPath]; // ファイルの場所指定
    if( [[NSFileManager defaultManager] fileExistsAtPath:path] == NO ){ // ファイルがなかったら
        DNSLog(@"メインのデータの初期化！");
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil]; //作成する
    }
    [self loadData];
}
// ファイル名を返す
- (void)makeDataPath{
    NSString *home = NSHomeDirectory();
    NSString *document = [home stringByAppendingPathComponent:@"Documents"]; // フォルダ名
    path = [document stringByAppendingPathComponent:@"Data.plist"]; // ファイル名
    DNSLog(@"メインのファイル: %@",path);
}
// ファイルへデータの保存
- (void)saveData{
    DNSLog(@"メインのデータ保存！");
    [self saveValue];
    [self saveGoal];
    [self saveNow];
    [self saveNorma];
    [self saveDeposit];
    [self saveOthers];
    NSLog(@"\nRoot:%@",root);
    [root writeToFile:path atomically:YES];
}
// ファイルからデータの読み込み
- (void)loadData{
    DNSLog(@"メインのデータ読み込み！");
    root = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if(root == NULL){ // 読み込みに失敗した場合
        root = [[NSMutableDictionary alloc] init];
    }
    [self loadValue];
    [self loadGoal];
    [self loadNow];
    [self loadNorma];
    [self loadDeposit];
    [self loadOthers];
}

#pragma mark - 保存・読み込み系
// Expense & Balance
- (void)saveValue{
    [root setObject:expense forKey:@"Expense"];
    [root setObject:balance forKey:@"Balance"];
    [root setObject:budget forKey:@"Budget"];
}
- (void)loadValue{
    expense = [root objectForKey:@"Expense"];
    if(expense == NULL)
        expense = @0;
    balance = [root objectForKey:@"Balance"];
    if(balance == NULL)
        balance = @0;
    budget  = [root objectForKey:@"Budget"];
    if(budget == NULL)
        budget = @0;
}
// Goal系
- (void)saveGoal{
    [root setObject:goal forKey:@"Goal"];
}
- (void)loadGoal{
    goal = [root objectForKey:@"Goal"];
    if(goal == NULL)
        goal = [[NSMutableDictionary alloc] init];
}
// Now系
- (void)saveNow{
    [root setObject:now forKey:@"Now"];
}
- (void)loadNow{
    now = [root objectForKey:@"Now"];
    if(now == NULL)
        now = [[NSMutableDictionary alloc] init];
}
// ノルマ
- (void)saveNorma{
    [root setObject:norma forKey:@"Norma"];
}
- (void)loadNorma{
    norma = [root objectForKey:@"Norma"];
    if(norma == NULL)
        norma = @0;
}
// 貯金額
- (void)saveDeposit{
    [root setObject:deposit forKey:@"Deposit"];
    [root setObject:depositLog forKey:@"DepositLog"];
}
- (void)loadDeposit{
    deposit = [root objectForKey:@"Deposit"];
    if(deposit == NULL)
        deposit = @0;
    depositLog = [root objectForKey:@"DepositLog"];
    if(depositLog == NULL)
        depositLog = [[NSMutableArray alloc] init];
}
// その他
- (void)saveOthers{
    NSNumber *defaultSettingsNum = [NSNumber numberWithBool:defaultSettings];
    NSNumber *nextAlertNum = [NSNumber numberWithBool:nextAlert];
    [root setObject:defaultSettingsNum forKey:@"defaultSettings"];
    [root setObject:nextAlertNum forKey:@"nextAlert"];
}
- (void)loadOthers{
    defaultSettings = [[root objectForKey:@"defaultSettings"] boolValue];
    if ([root objectForKey:@"defaultSettings"] == NULL)
        defaultSettings = NO;
    nextAlert = [[root objectForKey:@"nextAlert"] boolValue];
    if ([root objectForKey:@"nextAlert"] == NULL)
        nextAlert = NO;
}
#pragma mark - 外から書き込む系
// Goal
- (void)saveName:(NSString *)name Value:(NSNumber *)value Period:(NSDate *)period{
    _translateFormat = [TranslateFormat alloc];
    [goal setObject:name forKey:@"Name"];
    [goal setObject:value forKey:@"Value"];
    [goal setObject:[_translateFormat dateOnly:[_translateFormat nineHoursLater:period]] forKey:@"Period"];
}
// Now
- (void)saveStart:(NSDate *)start End:(NSDate *)end Budget:(NSNumber *)tempBudget{
    _translateFormat = [TranslateFormat alloc];
    [now setObject:[_translateFormat dateOnly:[_translateFormat nineHoursLater:start]] forKey:@"Start"];
    [now setObject:[_translateFormat dateOnly:[_translateFormat nineHoursLater:end]] forKey:@"End"];
    budget = tempBudget;
    [self calcForNextStage];
}
// Deposit DepositLog
- (void)saveDepositDate:(NSDate *)date Value:(NSNumber *)value{
    _translateFormat = [TranslateFormat alloc];
    NSDictionary *dictionaly = [[NSDictionary alloc] initWithObjectsAndKeys:date, @"Date", value, @"Value",nil];

    if([date isEqualToDate:[[depositLog objectAtIndex:0] objectForKey:@"Date"]]){
        [depositLog replaceObjectAtIndex:0 withObject:dictionaly]; // 上書きする
        deposit = @([deposit intValue] - [[[depositLog objectAtIndex:0] objectForKey:@"Value"] intValue] + [value intValue]);
    }else{
        [depositLog addObject:dictionaly]; // 新規追加する
        deposit = @([deposit intValue] + [value intValue]);
    }
}
#pragma mark - 自動で処理する系
// 期限が来て設定し終わったあとの処理 (ノルマを決める)
- (void)calcForNextStage{
    NSTimeInterval timeInterval = [[self loadStart] timeIntervalSinceDate:[self loadGoalPeriod]];
    NSInteger daysToPeriod = (int)(timeInterval / (60*60*24)); // 最終期限までの日数
    timeInterval = [[self loadStart] timeIntervalSinceDate:[self loadEnd]];
    NSInteger daysToEnd = (int)(timeInterval / (60*60*24)); // 今回の期限までの日数
    NSInteger normaOfOneDays = (int)(([[self loadGoalValue] intValue] - [self.deposit intValue]) / daysToPeriod);
    norma = @( normaOfOneDays * daysToEnd );
    balance = budget;
    defaultSettings = YES;
}
// 出費・収入・残高調整
- (void)calcValue:(NSNumber *)value Kind:(NSInteger)kind{
    switch (kind){
        case 0: // 出費
            expense = @([expense intValue] + [value intValue]);
            balance = @([budget intValue] - [expense intValue]);
            break;
        case 1: // 収入
            budget = @([budget intValue] + [value intValue]);
            balance = @([budget intValue] - [expense intValue]);
            break;
        case 2: // 残高調整
            expense = @([expense intValue] + [balance intValue] - [value intValue]);
            balance = @([budget intValue] + [expense intValue]);
            break;
    }
}
// 出費・収入・残高調整の削除
- (void)calcDeleteValue:(NSNumber *)value Kind:(NSString *)tempKind{
    NSInteger kind;
    if([tempKind isEqualToString:@"出費"])
        kind = 0;
    else if([tempKind isEqualToString:@"収入"])
        kind = 1;
    else if([tempKind isEqualToString:@"残高調整"])
        kind = 2;
    
    switch (kind) {
        case 0: // 出費
            expense = @([expense intValue] - [value intValue]);
            balance = @([budget intValue] - [expense intValue]);
            break;
        case 1: // 収入
            budget = @([budget intValue] - [value intValue]);
            balance = @([budget intValue] - [expense intValue]);
            break;
        case 2: // 残高調整
            expense = @([expense intValue] - [value intValue]);
            balance = @([budget intValue] - [expense intValue]);
            break;
    }
}

#pragma mark - とりあえずコピーしただけ系シリーズ
- (BOOL)searchNext{
    _translateFormat = [TranslateFormat alloc];
    NSDate *date = [_translateFormat dateOnly:[_translateFormat nineHoursLater:[NSDate date]]];

    if ([_translateFormat equalDate:date Vs:[self loadEnd]] == NO) {//今日が期限日じゃなくて
        if([date earlierDate:[self loadEnd]] != date){//期限日より後
            if (nextAlert == NO) {
                nextAlert = YES;
                return YES;
            }else{
                return NO;
            }
        }else{//まだ期限内
            //DNSLog(@"期限内やわ！");
        }
    }
    return NO;
}
- (Boolean)loadNextAlert{
    [self makeDataPath];
    [self loadData];
    if ([root objectForKey:@"NextAlert"] == @1) {
        return NO;
    }
    return YES;
}

#pragma mark - 外から読み込む系
- (NSString *)loadGoalName{
    return [goal objectForKey:@"Name"];
}
- (NSNumber *)loadGoalValue{
    return [goal objectForKey:@"Value"];
}
- (NSDate *)loadGoalPeriod{
    return [goal objectForKey:@"Period"];
}
- (NSDate *)loadStart{
    return [now objectForKey:@"Start"];
}
- (NSDate *)loadEnd{
    return [now objectForKey:@"End"];
}

#pragma mark - その他
- (void)deleteData{
    DNSLog(@"データ削除！");
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [self initData];
}

@end
