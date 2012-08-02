//
//  Methods.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//
#import "Methods.h"

@interface Methods ()
@end

@implementation Methods

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
                expense = @"0円";  //出費
                norma = @"0円";    //ノルマ
                //norma = ( ([self loadValue] - [self load貯蓄]) / ([self loadPeriod] - [self loadStart]) ) * ([self loadEnd]-[self loadStart]);
                balance = @"0円";
                //balance = [self loadBudget] - norma;// 出費ひくノルマ;  //残り
                [root setObject:expense forKey:@"Expense"];
                [root setObject:balance forKey:@"Balance"];
                [root setObject:norma forKey:@"Norma"];
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

//  Date.plistへのpathを作成
- (void)makeDataPath{
    DNSLog(@"ファイルの場所の指示！");
    NSString *home = NSHomeDirectory();
    NSString *document = [home stringByAppendingPathComponent:@"Documents"];
    path = [document stringByAppendingPathComponent:@"Data.plist"];
}

//Data.plistの初期設定
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

#pragma mark - MainView系
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
    log = [[NSMutableArray alloc] init];
    tempMoneyValue = [NSDictionary dictionaryWithObjectsAndKeys:
                                    value, @"MoneyValue",
                                    date, @"Date",
                                    kind, @"Kind", nil];
    [log addObject:tempMoneyValue];
    [root setObject:log forKey:@"Log"];
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
    DNSLog(@"log:%@",log);
}

//指定のログを削除する
- (void)deleteLog:(NSUInteger)cursor{
    [log removeObjectAtIndex:cursor];
    [root setObject:log forKey:@"Log"];
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
    DNSLog(@"%@",root)
}

//初期設定系
//データから値をセット
- (void)setData{
    DNSLog(@"データをセット！");
}

//わけわからんくなってきた
- (NSNumber *)loadExpense{return [root objectForKey:@"Expense"];}   //出費を返す
- (NSNumber *)loadBalance{return [root objectForKey:@"Balance"];}   //残りを返す
- (NSNumber *)loadNorma{return [root objectForKey:@"Norma"];}     //ノルマを返す

//計算やらやるよ
- (void)calcVlue:(NSString *)value Kind:(NSInteger)kind{
    switch (kind) {
        case 0://出費
            DNSLog(@"出費の処理！");
            break;
        case 1://収入
            DNSLog(@"収入の処理！");
            break;
        case 2://調整
            DNSLog(@"調整の処理！");
            break;
            
        default://初期設定これはここにはいらない
            DNSLog(@"新規の目標なので初期設定！");
            expense = @"-0円";  //出費
            norma = @"0円";    //ノルマ
            //norma = ( ([self loadValue] - [self load貯蓄]) / ([self loadPeriod] - [self loadStart]) ) * ([self loadEnd]-[self loadStart]);
            balance = @"0円";
            //balance = [self loadBudget] - norma;// 出費ひくノルマ;  //残り
            [root setObject:expense forKey:@"Expense"];
            [root setObject:balance forKey:@"Balance"];
            [root setObject:norma forKey:@"Norma"];
            [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
            break;
    }
}

//ログ読み込み
- (NSInteger)loadLog{
    DNSLog(@"ログ読み込み！%d個です！",[log count]);
    return [log count];
}

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
