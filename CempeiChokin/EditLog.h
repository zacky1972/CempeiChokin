//
//  EditLog.h
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditLog : NSObject

@property(nonatomic, retain)NSMutableArray *log;

// ファイルにデータを保存する
- (void)saveData;

// 配列にデータを追加
- (void)saveMoneyValue:(NSNumber *)value Date:(NSDate *)date Kind:(NSInteger)kind;
// 配列のデータを削除
- (void)deleteLogAtIndex:(NSUInteger)index;
// 中身の数が決められた数を超えてる時に削除する
- (void)removeObjectsCount:(NSUInteger)count;
// 消していた配列を復活させる
- (void)reviveToLog;

#pragma mark - 読み込む系
// 金額を読み込む
- (NSNumber *)loadMoneyValueAtIndex:(NSUInteger)index;
// 日付を読み込む
- (NSDate *)loadDateAtIndex:(NSUInteger)index;
// 種類を読み込む
- (NSString *)loadKindAtIndex:(NSUInteger)index;

#pragma mark - その他
// データ・ファイルを削除する
- (void)deleteLogData;

@end
