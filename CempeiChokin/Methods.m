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
    if( [[NSFileManager defaultManager] fileExistsAtPath:path] == NO ){
        // Data.plistがなかったら
        DNSLog(@"ファイルなかった！");
        return 0;
    }else{
        // Data.plistがあったら
        DNSLog(@"ファイルあった！");
        [self loadData];
        if([goal objectForKey:@"Name"]   == nil || [goal objectForKey:@"Value"] == nil ||
           [goal objectForKey:@"Period"] == nil || [now objectForKey:@"Start"]  == nil ||
           [now objectForKey:@"End"]     == nil || [now objectForKey:@"Budget"] == nil ){
            DNSLog(@"ぬけがあった！");
            return 0;
        }
        DNSLog(@"せっっていおわってる！");
        return 1;
    }
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
- (NSString *)loadValue{return [goal objectForKey:@"Value"];}    //金額を読み込んで返す
- (NSString *)loadPeriod{return [goal objectForKey:@"Period"];}  //期限を読み込んで返す

//目標のあれこれを一気に保存する
- (void)saveName:(NSString *)name Value:(NSString *)value Period:(NSString *)period{
    DNSLog(@"プロパティリストに保存！");
    goal = [[NSMutableDictionary alloc] init];
    [goal setObject:name forKey:@"Name"];       //とりあえずgoalに値を上書き
    [goal setObject:value forKey:@"Value"];
    [goal setObject:period forKey:@"Period"];
    [root setObject:goal forKey:@"Goal"];
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
}

// FIXME: 正直この3つはまとめたい
- (NSString *)loadStart{return [now objectForKey:@"Start"];}      //名前を読み込んで返す
- (NSString *)loadEnd{return [now objectForKey:@"End"];}          //金額を読み込んで返す
- (NSString *)loadBudget{return [now objectForKey:@"Budget"];}    //期限を読み込んで返す

//予算のあれこれを一気に保存する
- (void)saveStart:(NSString *)start End:(NSString *)end Budget:(NSString *)budget{
    DNSLog(@"プロパティリストに保存！");
    now = [[NSMutableDictionary alloc] init];
    [now setObject:start forKey:@"Start"];      //とりあえずnowに値を上書き
    [now setObject:budget forKey:@"Budget"];
    [now setObject:end forKey:@"End"];
    [root setObject:now forKey:@"Now"];
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
}

#pragma MainView系
//保存系
//金額を読み込んで返す
- (NSString *)loadManeyValue:(NSUInteger *)cursor{
    tempManeyValue = [log objectAtIndex:*cursor];
    return [tempManeyValue objectForKey:@"ManeyValue"];
}

//日付を読み込んで返す
- (NSString *)loadDate:(NSUInteger *)cursor{
    tempManeyValue = [log objectAtIndex:*cursor];
    return [tempManeyValue objectForKey:@"Date"];
}

//種類を読み込んで返す
- (NSString *)loadKind:(NSUInteger *)cursor{
    tempManeyValue = [log objectAtIndex:*cursor];
    return [tempManeyValue objectForKey:@"Kind"];
}

//金額のあれこれを一気に保存する
- (void)saveMoneyValue:(NSString *)value Date:(NSString *)date Kind:(NSString *)kind{
    DNSLog(@"金額のあれこれを保存！");
    log = [[NSMutableArray alloc] init];
    tempManeyValue = [NSDictionary dictionaryWithObjectsAndKeys:
                                    value, @"ManeyValue",
                                    date, @"Date",
                                    kind, @"Kind", nil];
    [log addObject:tempManeyValue];
    DNSLog(@"%@",log);
}

//初期設定系
//データから値をセット
- (void)setData{
    DNSLog(@"データをセット！");
}

//ログ読み込み
- (void)loadLog{
    DNSLog(@"ログ読み込み！");
}

//スクロールビューの大きさを変更
- (void)fitScrollView{
    DNSLog(@"ビューをフィット！");
}

//グラフの生成
- (void)makeGraph{
    DNSLog(@"グラフ書き出し！");
    //ここはグラフをイケメンにしてから
}

#pragma mark - Formatter系
// 10000 → 10,000 にするやつ
- (NSString *)addComma:(NSString *)number{
    NSNumber *value = [NSNumber numberWithInt:[number intValue]];     // 文字を数値に変換
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];  // 形式変えるアレ
    [formatter setPositiveFormat:@"#,##0"];                           // 形式の指定;
    return [formatter stringForObjectValue:value];                    // ,つけたのを返す
}

// 10,000 → 10000 にするやつ
- (NSNumber *)deleteComma:(NSString *)string{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"#,##0"];
    return [formatter numberFromString:string];
}

#pragma mark - DateFormatter系
- (NSString *)formatterDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =@"yyyy年M月d日"; // 表示を変える
    return [formatter stringFromDate:date];
}

@end
