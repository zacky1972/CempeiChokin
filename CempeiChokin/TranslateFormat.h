//
//  TranslateFormat.h
//  CempeiChokin
//
//  Created by Takeshi on 12/08/02.
//  Copyright (c) 2012年 Nakano Asami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TranslateFormat : NSObject

// 数字の表示をする感じの
- (NSString *)addComma:(NSString *)number;      // 10000 → 10,000 にするやつ
- (NSNumber *)deleteComma:(NSString *)string;   // 10,000 → 10000 にするやつ

- (NSNumber *)numberFromString:(NSString *)string;
- (NSString *)stringFromNumber:(NSNumber *)number addComma:(BOOL)comma addYen:(BOOL)yen;

// 日付の表示をする感じの
- (NSString *)formatterDate:(NSDate *)date;     // NSDate → yyyy年M月dd日にする
- (NSString *)formatterDateUltimate:(NSDate *)date addYear:(BOOL)year addMonth:(BOOL)month addDay:(BOOL)day
                            addHour:(BOOL)hour addMinute:(BOOL)minute addSecond:(BOOL)second;

@end
