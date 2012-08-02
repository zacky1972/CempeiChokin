//
//  TranslateFormat.m
//  CempeiChokin
//
//  Created by Takeshi on 12/08/02.
//  Copyright (c) 2012年 Nakano Asami. All rights reserved.
//

#import "TranslateFormat.h"

@implementation TranslateFormat

#pragma mark - Formatter系
// 10000 → 10,000 にするやつ
- (NSString *)addComma:(NSString *)number{
    NSNumber *value = [NSNumber numberWithInt:[number intValue]];     // 文字を数値に変換
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];  // 形式変えるアレ
    [formatter setPositiveFormat:@"#,##0"];                           // 形式の指定;
    NSString *returnString = [formatter stringForObjectValue:value];
    DNSLog(@"%@(%@)",returnString,number);
    return returnString;
}

// 10,000 → 10000 にするやつ
- (NSNumber *)deleteComma:(NSString *)string{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"#,##0"];
    NSNumber *returnNumber = [formatter numberFromString:string];
    DNSLog(@"%@(%@)",returnNumber,string);
    return returnNumber;
}

// 文字列→数値の変換 (数字以外消す)
- (NSNumber *)numberFromString:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",円"]];
    NSNumber *returnNumber = [[NSNumberFormatter alloc] numberFromString:string];
    return returnNumber;
}

// 数値→文字列の変換　(,と円をつけるかどうか選択可)
- (NSString *)stringFromNumber:(NSNumber *)number addComma:(BOOL)comma addYen:(BOOL)yen{
    NSString *returnString = [NSString stringWithFormat:@"%@",number];
    if(comma == YES)
        returnString = [self addComma:returnString];
    if(yen == YES){
        returnString = [returnString stringByAppendingString:@"円"];
    }
    return returnString;
}

#pragma mark - DateFormatter系
- (NSString *)formatterDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =@"yyyy年M月d日"; // 表示を変える
    return [formatter stringFromDate:date];
}

@end
