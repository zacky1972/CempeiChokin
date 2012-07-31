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

- (BOOL)searchGoal{
    [self makeDataPath:nil];
    if( [[NSFileManager defaultManager] fileExistsAtPath:path] == NO ){                     //Data.plistがなかったら
        NSLog(@"ファイルなかった！");
        return 0;
    }else{                      //あったら
        NSLog(@"ファイるあった！");
        [self loadData:nil];
        if([goal objectForKey:@"Name"]==nil || [goal objectForKey:@"Value"] ==nil || [goal objectForKey:@"Period"] ==nil || [now objectForKey:@"Start"] ==nil || [now objectForKey:@"End"] ==nil || [now objectForKey:@"Budget"] ==nil ){
            NSLog(@"ぬけがあった！");
            return 0;
        }
        NSLog(@"せっっていおわってる！");
        return 1;
    }
}

//Date.plistへのpathを作成
- (void)makeDataPath:(id)sender{
    NSString *home = NSHomeDirectory();
    NSString *document = [home stringByAppendingPathComponent:@"Documents"];
    path = [document stringByAppendingPathComponent:@"Data.plist"];
}

//Data.plistの初期設定
- (BOOL)initData{
    [self makeDataPath:nil];
    if( [[NSFileManager defaultManager] fileExistsAtPath:path] == NO ){                     //Data.plistがなかったら
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil]; //作成する
        root = [[NSMutableDictionary alloc] init];
    }else{                      //あったら
        [self loadData:nil];
    }
    return 0;
}

//Data.plistからひっぱってくる
- (void)loadData:(id)sender{
    root = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    goal = [root objectForKey:@"Goal"];
    now = [root objectForKey:@"Now"];
}

// FIXME: 正直この3つはまとめたい
- (NSString *)loadName:(id)sender{return [goal objectForKey:@"Name"];}      //名前を読み込んで返す
- (NSString *)loadValue:(id)sender{return [goal objectForKey:@"Value"];}    //金額を読み込んで返す
- (NSString *)loadPeriod:(id)sender{return [goal objectForKey:@"Period"];}  //期限を読み込んで返す

//目標のあれこれを一気に保存する
- (void)saveName:(NSString *)name Value:(NSString *)value Period:(NSString *)period{
    goal = [[NSMutableDictionary alloc] init];
    [goal setObject:name forKey:@"Name"];       //とりあえずgoalに値を上書き
    [goal setObject:value forKey:@"Value"];
    [goal setObject:period forKey:@"Period"];
    [root setObject:goal forKey:@"Goal"];
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
}

// FIXME: 正直この3つはまとめたい
- (NSString *)loadStart:(id)sender{return [now objectForKey:@"Start"];}      //名前を読み込んで返す
- (NSString *)loadEnd:(id)sender{return [now objectForKey:@"End"];}          //金額を読み込んで返す
- (NSString *)loadBudget:(id)sender{return [now objectForKey:@"Budget"];}    //期限を読み込んで返す

//予算のあれこれを一気に保存する
- (void)saveStart:(NSString *)start End:(NSString *)end Budget:(NSString *)budget{
    now = [[NSMutableDictionary alloc] init];
    [now setObject:start forKey:@"Start"];      //とりあえずnowに値を上書き
    [now setObject:budget forKey:@"Budget"];
    [now setObject:end forKey:@"End"];
    [root setObject:now forKey:@"Now"];
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
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
