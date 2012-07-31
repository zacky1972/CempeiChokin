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

//Data.plistを読み込む
- (void)loadData:(id)sender{
    NSString *home = NSHomeDirectory();
    NSString *document = [home stringByAppendingPathComponent:@"Documents"];
    path = [document stringByAppendingPathComponent:@"data.plist"];
    root = [[NSDictionary alloc] initWithContentsOfFile:path];
    goal = [root objectForKey:@"Goal"];
    initgoal = [root objectForKey:@"InitGoal"];
}

// TODO: なぜか読み込みができない
// FIXME: 正直この3つはまとめたい
- (NSString *)loadName:(id)sender{NSLog(@"loadname"); return nil;/*[goal objectForKey:@"Name"];*/}      //名前を読み込んで返す
- (NSString *)loadValue:(id)sender{NSLog(@"loadvalue");return nil;/*[goal objectForKey:@"Value"];*/}    //金額を読み込んで返す
- (NSString *)loadPeriod:(id)sender{NSLog(@"loadperiod");return nil;/*[goal objectForKey:@"Period"];*/}  //期限を読み込んで返す

//目標のあれこれを一気に保存する
- (void)saveName:(NSString *)name Value:(NSString *)value Period:(NSString *)period{
    [goal setObject:name forKey:@"Name"];       //とりあえずgoalに値を上書き
    [goal setObject:value forKey:@"Value"];
    [goal setObject:period forKey:@"Period"];
    
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
}

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

@end
