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

// 配列にデータの保存
- (NSMutableArray *)saveMoneyValueForArray:(NSMutableArray *)array Value:(NSNumber *)value Date:(NSDate *)date Kind:(NSString *)kind;
- (NSMutableArray *)deleteLogArray:(NSMutableArray *)array atIndex:(NSUInteger)index;

#pragma mark - 読み込む系
- (NSNumber *)loadMoneyValueFromArray:(NSMutableArray *)array atIndex:(NSUInteger)index;
- (NSDate *)loadDateFromArray:(NSMutableArray *)array atIndex:(NSUInteger)index;
- (NSString *)loadKindFromArray:(NSMutableArray *)array atIndex:(NSUInteger)index;

#pragma mark - その他
- (NSMutableArray *)removeObjectsInArray:(NSMutableArray *)array count:(NSUInteger)count;

@end
