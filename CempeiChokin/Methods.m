//
//  Methods.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//
#import "Methods.h"

@interface Methods (){
    NSNumber *bud;
    NSNumber *expense;
    NSNumber *balance;
    NSNumber *norma;
}
@end

@implementation Methods

// Date.plistへのpathを作成
- (void)makeDataPath{
    DNSLog(@"ファイルの場所の指示！");
    NSString *home = NSHomeDirectory();
    NSString *document = [home stringByAppendingPathComponent:@"Documents"];
    path = [document stringByAppendingPathComponent:@"Data.plist"];
}

// Data.plistの存在確認的な
- (void)initData{
    DNSLog(@"データの初期化！");
    [self makeDataPath];
    if( [[NSFileManager defaultManager] fileExistsAtPath:path] == NO ){                     //Data.plistがなかったら
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil]; //作成する
        root = [[NSMutableDictionary alloc] init];
    }else{                      //あったら
        [self loadData];
    }
}

//Data.plistからひっぱってくる
- (void)loadData{
    DNSLog(@"データ読み込み！");
    root = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    goal = [root objectForKey:@"Goal"];
    now = [root objectForKey:@"Now"];
    log = [root objectForKey:@"Log"];
}

//Data.plistを消す
- (void)deleteData{
    DNSLog(@"データ削除！");
    [self makeDataPath];
    [self loadData];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

// 初期設定が必要かどうかを確認する
- (BOOL)searchGoal{
    [self makeDataPath];
    if( [[NSFileManager defaultManager] fileExistsAtPath:path] == NO){
        // Data.plistがなかったら
    }else{
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:nil];
        unsigned long long fileSize = [fileAttributes fileSize];
        DNSLog(@"filesize:%llu",fileSize);
        if (fileSize != 0) {//ファイルサイズが0バイトじゃなかったら
            [self loadData];
            
            if([goal objectForKey:@"Name"]   == nil || [goal objectForKey:@"Value"] == nil ||
               [goal objectForKey:@"Period"] == nil || [now objectForKey:@"Start"]  == nil ||
               [now objectForKey:@"End"]     == nil || [now objectForKey:@"Budget"] == nil ){return 0;}
            //ここで値をセット
            if([root objectForKey:@"Norma"] == nil){//初めだったら
                DNSLog(@"新規の目標なので初期設定！");
                DNSLog(@"%@",root);
                bud = [self loadBudget];
                expense = @0;  //出費
                NSTimeInterval since;
                NSInteger tempday1,tempday2;
                since = [[self loadStart] timeIntervalSinceDate:[self loadPeriod]];
                tempday1 = (int)(since / (60 * 60 * 24));
                since = [[self loadStart] timeIntervalSinceDate:[self loadEnd]];
                tempday2 = (int)(since / (60 * 60 * 24));
                
                //norma = @0;    //ノルマ
                norma = @( ( ( [[self loadValue] intValue] - [[self loadDeposit] intValue] ) / tempday1 ) * tempday2 );
                balance = @( [[self loadBudget] intValue] - [[self loadNorma] intValue] );
                depolog = [[NSMutableArray alloc] init];
                [self saveDeposit:@0 Date:[self loadStart]];
                
                [root setObject:expense forKey:@"Expense"];
                [root setObject:balance forKey:@"Balance"];
                [root setObject:norma forKey:@"Norma"];
                [root setObject:depolog forKey:@"Deposit"];
                [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
            }
            DNSLog(@"root:%@",root);
            return 1;
        }else{//0バイトだったら
            [self deleteData];
        }
    }
    return 0;
}

#pragma mark - 目標(Goal)関係
// FIXME: 正直この3つはまとめたい
- (NSString *)loadName{return [goal objectForKey:@"Name"];}      //名前を読み込んで返す
- (NSNumber *)loadValue{return [goal objectForKey:@"Value"];}    //金額を読み込んで返す
- (NSDate *)loadPeriod{return [goal objectForKey:@"Period"];}  //期限を読み込んで返す

//目標のあれこれを一気に保存する
- (void)saveName:(NSString *)name Value:(NSNumber *)value Period:(NSDate *)period{
    DNSLog(@"プロパティリストに保存！");
    goal = [[NSMutableDictionary alloc] init];
    [goal setObject:name forKey:@"Name"];       //とりあえずgoalに値を上書き
    [goal setObject:value forKey:@"Value"];
    [goal setObject:period forKey:@"Period"];
    [root setObject:goal forKey:@"Goal"];
    DNSLog(@"root:%@",root);
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
    
}

#pragma mark - 今回のアレ(Now)関係
// FIXME: 正直この3つはまとめたい
- (NSDate *)loadStart{return [now objectForKey:@"Start"];}      //名前を読み込んで返す
- (NSDate *)loadEnd{return [now objectForKey:@"End"];}          //金額を読み込んで返す
- (NSNumber *)loadBudget{return [now objectForKey:@"Budget"];}    //期限を読み込んで返す

//予算のあれこれを一気に保存する
- (void)saveStart:(NSDate *)start End:(NSDate *)end Budget:(NSNumber *)budget{
    DNSLog(@"プロパティリストに保存！");
    now = [[NSMutableDictionary alloc] init];
    [now setObject:start forKey:@"Start"];      //とりあえずnowに値を上書き
    [now setObject:budget forKey:@"Budget"];
    [now setObject:end forKey:@"End"];
    [root setObject:now forKey:@"Now"];
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
}

#pragma mark - 履歴(Log)関係
//保存系
//金額を読み込んで返す
- (NSNumber *)loadMoneyValue:(NSUInteger)cursor{
    tempMoneyValue = [log objectAtIndex:cursor];
    DNSLog(@"MoneyValue:%@",[tempMoneyValue objectForKey:@"MoneyValue"]);
    return [tempMoneyValue objectForKey:@"MoneyValue"];
}

//日付を読み込んで返す
- (NSDate *)loadDate:(NSUInteger)cursor{
    tempMoneyValue = [log objectAtIndex:cursor];
    return [tempMoneyValue objectForKey:@"Date"];
}

//種類を読み込んで返す
- (NSString *)loadKind:(NSUInteger)cursor{
    tempMoneyValue = [log objectAtIndex:cursor];
    return [tempMoneyValue objectForKey:@"Kind"];
}

//金額のあれこれを一気に保存する
- (void)saveMoneyValue:(NSNumber *)value Date:(NSDate *)date Kind:(NSString *)kind{
    DNSLog(@"金額のあれこれを保存！");
    // FIXME: Logの中身を新たに作って上書きしてるから値が一個にしかならんで！
    if(log == nil){
        log = [[NSMutableArray alloc] init];
    }
    tempMoneyValue = [NSDictionary dictionaryWithObjectsAndKeys:
                      value, @"MoneyValue",
                      date, @"Date",
                      kind, @"Kind", nil];
    [log insertObject:tempMoneyValue atIndex:0];
    if([log count] > 20)
        [log removeObjectAtIndex:20];
    [root setObject:log forKey:@"Log"];
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
    DNSLog(@"log:%@",log);
}

//指定のログを削除する
- (void)deleteLog:(NSUInteger)cursor{
    DNSLog(@"%d番目のログを削除します！",cursor);
    DNSLog(@"%@",log);
    //読み込んで
    [self calcDeletevalue:[[log objectAtIndex:cursor] objectForKey:@"MoneyValue"] Kind:[[log objectAtIndex:cursor] objectForKey:@"Kind"]];//値一致させて
    [log removeObjectAtIndex:cursor];           //で，実際にログを消す
    [root setObject:log forKey:@"Log"];
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
    DNSLog(@"%@",root)
}

#pragma mark - 初期設定関係
//わけわからんくなってきた
- (NSNumber *)loadExpense{return [root objectForKey:@"Expense"];}   //出費を返す
- (NSNumber *)loadBalance{return [root objectForKey:@"Balance"];}   //残りを返す
- (NSNumber *)loadNorma{return [root objectForKey:@"Norma"];}     //ノルマを返す

//計算やらやるよ
- (void)calcvalue:(NSNumber *)value Kind:(NSInteger)kind{
    DNSLog(@"計算するよ");
    DNSLog(@"\nRoot:%@",root);
    // FIXME: ここで読み込みかなんかしないと初回起動以外だと値が消えるっぽい
    expense = [self loadExpense];
    balance = [self loadBalance];
    bud = [self loadBudget];
    switch (kind) {
        case 0://出費
            DNSLog(@"出費の処理！");
            expense = @([expense intValue] + [value intValue]);
            balance = @([bud intValue] - [expense intValue]);
            break;
        case 1://収入
            DNSLog(@"収入の処理！");
            bud = @([bud intValue] + [value intValue]);
            balance = @([bud intValue] - [expense intValue]);
            [now setObject:bud forKey:@"Budget"];
            [root setObject:now forKey:@"Now"];
            break;
        case 2://調整
            DNSLog(@"調整の処理！");
            if ([balance intValue] > [value intValue]) {
                DNSLog(@"誤差:%d", [expense intValue] - [value intValue]);
                expense = @( [expense intValue] + ( [balance intValue] - [value intValue] ) );
                balance = @([bud intValue] - [expense intValue]);
            }else{
                DNSLog(@"誤差:%d", [expense intValue] - [value intValue]);
                expense = @( [expense intValue] - ( [value intValue] - [balance intValue] ) );
                balance = @([bud intValue] - [expense intValue]);
            }
            break;
            
    }
    [root setObject:expense forKey:@"Expense"];
    [root setObject:balance forKey:@"Balance"];
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
    DNSLog(@"%@",root);
}

//delete用，種類に応じた処理を行うよ
- (void)calcDeletevalue:(NSNumber *)value Kind:(NSString *)kind{
    //TODO: ここにdelete用の処理
    DNSLog(@"delete用の計算するよ");
    DNSLog(@"\nRoot:%@",root);
    // FIXME: ここで読み込みかなんかしないと初回起動以外だと値が消えるっぽい
    expense = [self loadExpense];
    balance = [self loadBalance];
    bud = [self loadBudget];
    
    NSInteger tempKind;
    if([kind isEqualToString:@"出費"])
        tempKind = 0;
    if([kind isEqualToString:@"収入"])
        tempKind = 1;
    if([kind isEqualToString:@"調整"])
        tempKind = 2;
    
    switch (tempKind) {
        case 0://出費
            DNSLog(@"出費のdelete処理！");
            expense = @([expense intValue] - [value intValue]);
            balance = @([bud intValue] - [expense intValue]);
            break;
        case 1://収入
            DNSLog(@"収入のdelete処理！");
            bud = @([bud intValue] - [value intValue]);
            balance = @([bud intValue] - [expense intValue]);
            [now setObject:bud forKey:@"Budget"];
            [root setObject:now forKey:@"Now"];
            break;
        case 2://調整
            DNSLog(@"調整のdelete処理！");
            //TODO: いくら誤差があったかがわからないので計算できない
            /*
             if ([balance intValue] > [value intValue]) {
             expense = @( [expense intValue] - 誤差 );
             balance = @([bud intValue] - [expense intValue]);
             }else{
             DNSLog(@"誤差:%d", [expense intValue] - [value intValue]);
             expense = @( [expense intValue] + 誤差 );
             balance = @([bud intValue] - [expense intValue]);
             }
             */
            break;
    }
    
    [root setObject:expense forKey:@"Expense"];
    [root setObject:balance forKey:@"Balance"];
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
    DNSLog(@"delete完了チェック:%@",root);
    
}

//ログ読み込み
- (NSInteger)loadLog{
    DNSLog(@"ログ読み込み！%d個です！",[log count]);
    return [log count];
}


#pragma mark - 貯金(Deposit)関係
//貯金額を保存
- (void)saveDeposit:(NSNumber *)value Date:(NSDate *)date{
    //???: 配列depolog使って記録とったがいいんかな…
    DNSLog(@"貯金保存！");
    NSArray *tempDepolog = [[NSArray alloc] initWithObjects:value, date,  nil];
    if ([root objectForKey:@"Deposit"] != nil) {
        DNSLog(@"%@",[root objectForKey:@"Deposit"]);
        depolog = [root objectForKey:@"Deposit"];
    }
    [depolog insertObject:tempDepolog atIndex:0];
    [root setObject:depolog forKey:@"Deposit"];
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
    DNSLog(@"Depolog:%@",root);
}

//貯金額を呼び出し
- (NSNumber *)loadDeposit{
    
    return [root objectForKey:@"Deposit"];
}

#pragma mark - その他
//スクロールビューの大きさを変更
- (float)fitScrollView{
    DNSLog(@"ビューをフィット！");
    [self makeDataPath];
    [self loadData];
    
    NSInteger height;
    
    //セルの個数をとってくる
    DNSLog(@"log:%@",log);
    height = [self loadLog];
    if ( height >= 10 ){ // logのセル数が10未満じゃなかったら
        height = 10;
    }
    height = 779 + 45 * height;
    return [[[NSNumber alloc] initWithInt:height] floatValue];
}


@end
