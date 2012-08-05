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
    return returnString;
}

// 10,000 → 10000 にするやつ
- (NSNumber *)deleteComma:(NSString *)string{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"#,##0"];
    NSNumber *returnNumber = [formatter numberFromString:string];
    return returnNumber;
}

// 文字列→数値の変換 (数字以外消す)
- (NSNumber *)numberFromString:(NSString *)string{
    DNSLog(@"Input:%@",string);
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@",円"]];
    NSNumber *returnNumber = [[NSNumberFormatter alloc] numberFromString:string];
    return returnNumber;
}

// 数値→文字列の変換　(,と円をつけるかどうか選択可)
- (NSString *)stringFromNumber:(NSNumber *)number addComma:(BOOL)comma addYen:(BOOL)yen{
    DNSLog(@"Input:%@ (Comma:%@,Yen:%@)",number,comma?@"YES":@"NO",yen?@"YES":@"NO");
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
    [formatter setLocale:[NSLocale currentLocale]];
    formatter.dateFormat =@"yyyy年M月d日"; // 表示を変える
    return [formatter stringFromDate:date];
}

- (NSString *)formatterDateUltimate:(NSDate *)date addYear:(BOOL)year addMonth:(BOOL)month addDay:(BOOL)day
                            addHour:(BOOL)hour addMinute:(BOOL)minute addSecond:(BOOL)second{
    DNSLog(@"Year:%@,Month:%@",year?@"YES":@"NO",month?@"YES":@"NO");
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    NSString *tempString = @"";
    if (year == YES){
        tempString = [tempString stringByAppendingFormat:@"yyyy年"];
    }
    if (month == YES){
        tempString = [tempString stringByAppendingString:@"M月"];
    }
    if (day == YES){
        tempString = [tempString stringByAppendingString:@"d日"];
    }
    if (hour == YES){
        tempString = [tempString stringByAppendingString:@"H時"];
    }
    if (minute == YES){
        tempString = [tempString stringByAppendingString:@"m分"];
    }
    if (second == YES){
        tempString = [tempString stringByAppendingString:@"s秒"];
    }
    DNSLog(@"Format:%@",tempString);
    
    formatter.dateFormat = tempString; // 表示を変える
    return [formatter stringFromDate:[self nineHoursEarly:date]];
}

#pragma mark - 許されない系
- (NSDate *)dateOnly:(NSDate *)date{
    DNSLog(@"%@を",date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *tempString = [formatter stringFromDate:date];
    date = [formatter dateFromString:tempString];
    // 何故か時間を消すと15:00:00になるの
    date = [NSDate dateWithTimeInterval:60*60*9 sinceDate:date];
    return date;
}

- (NSDate *)nineHoursLater:(NSDate *)date{
    date = [NSDate dateWithTimeInterval:60*60*9 sinceDate:date];
    return date;
}

- (NSDate *)nineHoursEarly:(NSDate *)date{
    date = [NSDate dateWithTimeInterval:-(60*60*9) sinceDate:date];
    return date;
}

- (BOOL)equalDate:(NSDate *)date1 Vs:(NSDate *)date2{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString1 = [formatter stringFromDate:date1];
    NSString *dateString2 = [formatter stringFromDate:date2];
    BOOL equal = [dateString1 isEqualToString:dateString2];
    NSLog(@"equal:%@",equal?@"YES":@"NO");
    return equal;
}
@end
