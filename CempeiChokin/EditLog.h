//
//  EditLog.h
//  CempeiChokin
//
//  Created by Takeshi on 12/08/04.
//  Copyright (c) 2012年 Nakano Asami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditLog : NSObject

// ファイルへ保存，読み込み
- (NSMutableArray *)loadLogFromFile;
- (void)saveLogToFile:(NSMutableArray *)array;

#pragma mark- 配列の編集
// 配列にデータを追加
- (NSMutableArray *)saveMoneyValueForArray:(NSMutableArray *)array
                                     Value:(NSNumber *)value Date:(NSDate *)date Kind:(NSString *)kind;
// 配列のデータを削除
- (NSMutableArray *)deleteLogArray:(NSMutableArray *)array atIndex:(NSUInteger)index;

#pragma mark - 読み込む系
// 金額を読み込む
- (NSNumber *)loadMoneyValueFromArray:(NSMutableArray *)array atIndex:(NSUInteger)index;
// 日付を読み込む
- (NSDate *)loadDateFromArray:(NSMutableArray *)array atIndex:(NSUInteger)index;
// 種類を読み込む
- (NSString *)loadKindFromArray:(NSMutableArray *)array atIndex:(NSUInteger)index;

#pragma mark - その他
// 中身の数が決められた数を超えてる時に削除する
- (NSMutableArray *)removeObjectsInArray:(NSMutableArray *)array count:(NSUInteger)count;

@end
