//
//  SaveAndLoadOfMainView.m
//  CempeiChokin
//
//  Created by Takeshi on 12/08/04.
//  Copyright (c) 2012年 Nakano Asami. All rights reserved.
//

#import "SaveAndLoadOfMainView.h"
#import "TranslateFormat.h"
#import "Methods.h"

@implementation SaveAndLoadOfMainView{
    Methods *_methods;
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
    
    if(_methods == nil){
        _methods = [Methods alloc];
    }
    
    [_methods saveLogArrayForPropertyList:array]; // プロパティリストに保存
    return array;
}

// 何個以上だったら消すみたいなやつ
- (NSMutableArray *)removeObjectsInArray:(NSMutableArray *)array count:(NSUInteger)count{
    NSUInteger startNumber = count - 1;
    NSUInteger deleteCount = [array count] - startNumber;
    [array removeObjectsInRange:NSMakeRange(startNumber,deleteCount)];
    return array;
}

// 削除するやつ
- (NSMutableArray *)deleteLogArray:(NSMutableArray *)array atIndex:(NSUInteger)index{
    DNSLog(@"%d番目のログを削除します！",index);
    
    if(_methods == nil){
        _methods = [Methods alloc];
    }
    
    [_methods calcDeletevalue:[[array objectAtIndex:index] objectForKey:@"MoneyValue"] Kind:[[array objectAtIndex:index] objectForKey:@"Kind"]];
    [array removeObjectAtIndex:index]; //で，実際にログを消す

    [_methods saveLogArrayForPropertyList:array]; // プロパティリストに保存
    return array; // 削除した配列を返す
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

@end
