//
//  EditLog.m
//  CempeiChokin
//
//  Created by Takeshi on 12/08/04.
//  Copyright (c) 2012年 Nakano Asami. All rights reserved.
//

#import "EditLog.h"
#import "TranslateFormat.h"
#import "Methods.h"

@implementation EditLog

// ファイル名を返す
- (NSString *)makeDataPathOfLog{
    DNSLog(@"ログのファイルの場所の指示！");
    NSString *home = NSHomeDirectory();
    NSString *document = [home stringByAppendingPathComponent:@"Documents"];
    NSString *path = [document stringByAppendingPathComponent:@"Log.plist"]; // ファイル名
    return path;
}

// ファイルの初期化
- (void)initData{
    DNSLog(@"ログのデータの初期化！");
    NSString *path = [self makeDataPathOfLog];
    if( [[NSFileManager defaultManager] fileExistsAtPath:path] == NO ){ // ファイルがなかったら
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil]; //作成する
    }
}

// ファイルへデータの保存
- (void)saveData:(NSMutableDictionary *)root{
    DNSLog(@"ログのデータ保存！");
    NSString *path = [self makeDataPathOfLog];
    [root writeToFile:path atomically:YES];
}

// ファイルからデータの読み込み
- (NSMutableDictionary *)loadData{
    DNSLog(@"ログのデータ読み込み！");
    NSString *path = [self makeDataPathOfLog];
    NSMutableDictionary *root = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    return root;
}

#pragma mark - ログ
// ログの読み込み
- (NSMutableArray *)loadLogFromFile{
    NSMutableDictionary *root = [self loadData];
    NSMutableArray *log = [root objectForKey:@"Log"];
    return log;
}

// ログの保存
- (void)saveLogToFile:(NSMutableArray *)array{
    NSMutableDictionary *root = [self loadData];
    [root setObject:array forKey:@"Log"];
    [self saveData:root];
}

// 配列に値を保存する
- (NSMutableArray *)saveMoneyValueForArray:(NSMutableArray *)array Value:(NSNumber *)value Date:(NSDate *)date Kind:(NSString *)kind{
    DNSLog(@"金額のあれこれを保存！");
    
    NSDictionary *tempDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    value, @"MoneyValue",
                                    date,  @"Date",
                                    kind,  @"Kind",
                                    nil];
    [array insertObject:tempDictionary atIndex:0];       // 配列に入れる
    
    [self saveLogToFile:array]; // プロパティリストに保存
    return array;
}

// 削除するやつ
- (NSMutableArray *)deleteLogArray:(NSMutableArray *)array atIndex:(NSUInteger)index{
    DNSLog(@"%d番目のログを削除します！",index);
    
    [[Methods alloc] calcDeletevalue:[[array objectAtIndex:index] objectForKey:@"MoneyValue"] Kind:[[array objectAtIndex:index] objectForKey:@"Kind"]];
    [array removeObjectAtIndex:index]; //で，実際にログを消す

    [self saveLogToFile:array]; // プロパティリストに保存
    return array; // 削除後の配列を返す
}

#pragma mark - 読み込む系
// 金額を読み込んで返す
- (NSNumber *)loadMoneyValueFromArray:(NSMutableArray *)array atIndex:(NSUInteger)index{
    NSDictionary *tempDictionary = [array objectAtIndex:index];
    NSNumber *tempNumber = [tempDictionary objectForKey:@"MoneyValue"];
    DNSLog(@"MoneyValue:%@",tempNumber);
    return tempNumber;
}

//日付を読み込んで返す
- (NSDate *)loadDateFromArray:(NSMutableArray *)array atIndex:(NSUInteger)index{
    NSDictionary *tempDictionary = [array objectAtIndex:index];
    NSDate *tempDate = [tempDictionary objectForKey:@"Date"];
    DNSLog(@"Date:%@",[[TranslateFormat alloc] formatterDate:tempDate]);
    return tempDate;
}

//種類を読み込んで返す
- (NSString *)loadKindFromArray:(NSMutableArray *)array atIndex:(NSUInteger)index{
    NSDictionary *tempDictionary = [array objectAtIndex:index];
    NSString *tempString = [tempDictionary objectForKey:@"Kind"];
    DNSLog(@"%@",tempString)
    return tempString;
}

#pragma mark - その他
// 何個以上だったら消すみたいなやつ
- (NSMutableArray *)removeObjectsInArray:(NSMutableArray *)array count:(NSUInteger)count{
    NSUInteger startNumber = count - 1;
    NSUInteger deleteCount = [array count] - startNumber;
    [array removeObjectsInRange:NSMakeRange(startNumber,deleteCount)];
    return array;
}

@end
