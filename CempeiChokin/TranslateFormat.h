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
- (NSString *)deleteComma:(NSString *)string;   // 10,000 → 10000 にするやつ

// 日付の表示をする感じの
- (NSString *)formatterDate:(NSDate *)date;     // NSDate → yyyy年M月dd日にする

@end
