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
    path = [[NSBundle mainBundle] pathForResource:@"Data" ofType:@"plist"];
    root = [[NSDictionary alloc] initWithContentsOfFile:path];
    goal = [root objectForKey:@"Goal"];
    initgoal = [root objectForKey:@"InitGoal"];
}


// FIXME: 正直この3つはまとめたい
- (NSString *)loadName:(id)sender{return [goal objectForKey:@"Name"];}//名前を読み込んで返す
- (NSString *)loadValue:(id)sender{return [goal objectForKey:@"Value"];}//金額を読み込んで返す
- (NSString *)loadPeriod:(id)sender{return [goal objectForKey:@"Period"];}//期限を読み込んで返す

//目標のあれこれを一気に保存する
- (void)saveName:(NSString *)name Value:(NSString *)value Period:(NSString *)period{
    [goal setObject:@"Name" forKey:name];
    [goal setObject:@"Value" forKey:value];
    [goal setObject:@"Period" forKey:period];
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
