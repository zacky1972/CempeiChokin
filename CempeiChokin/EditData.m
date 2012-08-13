//
//  EditData.m
//  CempeiChokin
//
//  Created by Takeshi on 12/08/07.
//  Copyright (c) 2012年 Nakano Asami. All rights reserved.
//

#import "EditData.h"
#import "AppDelegate.h"
#import "TranslateFormat.h"

@implementation EditData{
    AppDelegate *appDelegate;
    TranslateFormat *_translateFormat;

    NSString *path;
    NSMutableDictionary *root;
}

@synthesize expense,balance,norma,budget,deposit;
@synthesize defaultSettings,nextAlert;

// 初期化
-(id)init{
    self = [super init];
    if(self){
        [self initData];
    }
    return self;
}

#pragma mark - ファイル操作系
// ファイルの初期化
- (void)initData{
    [self makeDataPath]; // ファイルの場所指定
    if( [[NSFileManager defaultManager] fileExistsAtPath:path] == NO ){ // ファイルがなかったら
        DNSLog(@"メインのデータの初期化！");
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil]; //作成する
    }
    [self loadData];

    appDelegate = APP_DELEGATE;
    _translateFormat = [TranslateFormat alloc];
}
// ファイルの削除
- (void)deleteData{
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [self initData];
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
    [self saveValue];
    [self saveGoal];
    [self saveNow];
    [self saveNorma];
    [self saveDeposit];
    [self saveOthers];
    DNSLog(@"Data.plistに保存\nData.plist:%@",root);
    [root writeToFile:path atomically:YES];
}
// ファイルからデータの読み込み
- (void)loadData{
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
    DNSLog(@"Data.plistから読み込み \nData.plist:%@",root);
}

#pragma mark - 保存・読み込み系
// Expense & Balance & Budget
- (void)saveValue{
    [root setObject:expense forKey:@"Expense"];
    [root setObject:balance forKey:@"Balance"];
    [root setObject:budget forKey:@"Budget"];
}
- (void)loadValue{
    expense = [root objectForKey:@"Expense"];
    if(expense == NULL)
        expense = @-1;
    balance = [root objectForKey:@"Balance"];
    if(balance == NULL)
        balance = @-1;
    budget  = [root objectForKey:@"Budget"];
    if(budget == NULL)
        budget = @-1;
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
        norma = @-1;
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
// Goalに
- (void)saveName:(NSString *)name Value:(NSNumber *)value Period:(NSDate *)period{
    [goal setObject:name forKey:@"Name"];
    [goal setObject:value forKey:@"Value"];
    [goal setObject:[_translateFormat dateOnly:period] forKey:@"Period"];
}
// Nowに
- (void)saveStart:(NSDate *)start End:(NSDate *)end{
    [now setObject:[_translateFormat dateOnly:start] forKey:@"Start"];
    [now setObject:[_translateFormat dateOnly:end] forKey:@"End"];
}
// Deposit,DepositLogに
- (void)saveDepositDate:(NSDate *)date Value:(NSNumber *)value{
    NSDictionary *dictionaly = [[NSDictionary alloc] initWithObjectsAndKeys:date, @"Date", value, @"Value",nil];
    
    if (depositLog.count > 0) {
        NSDate *recentDeposit = [[depositLog objectAtIndex:0] objectForKey:@"Date"];
        if([date isEqualToDate:recentDeposit] == YES){
            // 既に同じ期間の貯金がしてあった場合
            deposit = @([deposit intValue] - [[[depositLog objectAtIndex:0] objectForKey:@"Value"] intValue] + [value intValue]); // 貯金額の計算
            [depositLog replaceObjectAtIndex:0 withObject:dictionaly]; // 上書きする
        }
    }else{
        [depositLog addObject:dictionaly]; // 新規追加する
        deposit = @([deposit intValue] + [value intValue]); // 貯金額を増やす
    }
}
#pragma mark - 自動で処理する系
// 設定し終わったあとの処理 (ノルマを決める)
- (void)calcForNextStage{
    // ノルマの計算
    if([[self loadGoalPeriod] compare:[self loadEnd]] == NSOrderedSame){
        // 最終期限と今回の期間が同じ場合
        norma = @([[self loadGoalValue] intValue] - [self.deposit intValue] ); // ノルマは残りの額
    }else{
        // 最終期限と今回の期間が同じじゃない場合
        
        // 最終期限までの日数を計算
        NSTimeInterval timeInterval = [[self loadGoalPeriod] timeIntervalSinceDate:[self loadStart]] + (60*60*24);
        NSNumber *daysToPeriod = [NSNumber numberWithInt:(timeInterval / (60*60*24))];
        // 今回の期限までの日数を計算
        timeInterval = [[self loadEnd] timeIntervalSinceDate:[self loadStart]] + (60*60*24);
        NSNumber *daysToEnd = [NSNumber numberWithInt:(timeInterval / (60*60*24))];
        // 一日分のノルマの計算
        NSNumber *normaOfOneDays = [NSNumber numberWithInt:(([[self loadGoalValue] intValue] - [self.deposit intValue]) / [daysToPeriod intValue])];
        DNSLog(@"最終期限までの日数:%@",daysToPeriod);
        DNSLog(@"今回期限までの日数:%@",daysToEnd);
        DNSLog(@"一日のノルマ:%@",normaOfOneDays);

        // ノルマの値を代入する
        norma = @([normaOfOneDays intValue] * [daysToEnd intValue]);
    }

    // 出費の値を入力
    if([expense isEqualToNumber:@-1] == YES){
        expense = @0;
    }
    
    balance = @([budget intValue] - [expense intValue]);
    defaultSettings = YES;

    DNSLog(@"今回のノルマ:%@",norma);
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
            expense = @([budget intValue] - [value intValue]);
            balance = value;
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
// 期限が来たかどうかを返す
- (BOOL)searchNext{
    NSDate *date = [_translateFormat dateOnly:[NSDate date]];

    if(nextAlert == YES)
        // 既にアラート済みの場合
        return NO;

    if ([date isEqualToDate:[self loadEnd]] == NO) {
        //今日が期限日じゃない場合
        if([date earlierDate:[self loadEnd]] != date){
            //期限日よりあとの場合
            nextAlert = YES;
            return YES;
        }
    }
    // 期限内
    return NO;
}
//貯金が溜まったかどうかを返す
- (BOOL)searchFinish{
    DNSLog(@"たまった？");
    if ([[self loadGoalValue] compare:deposit] !=  NSOrderedDescending) {
        DNSLog(@"たまった！");
        return YES;
    }else{
        DNSLog(@"たまってない…");
        return NO;
    }
}
// 最後の期間かどうかを返す
- (BOOL)searchLastNorma{
    DNSLog(@"最後の期間？");
    if ([[self loadEnd] isEqualToDate:[self loadGoalPeriod]] == YES) {
        DNSLog(@"最後！");
        return YES;
    }else{
        DNSLog(@"まだまだ！");
        return NO;
    }
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

@end
