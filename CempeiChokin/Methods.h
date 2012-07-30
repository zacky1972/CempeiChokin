//
//  Methods.h
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Methods : NSObject{
    // ???: こういうのってここであってるんだろうか？
    //値をいじる感じ用
    NSString *path;
    NSDictionary *root;
    NSMutableDictionary *goal;
    NSDictionary *now;
    NSNumber *initgoal;
}

//値をいじる感じの
- (void)loadData:(id)sender;                    //Data.plistを読み込む
- (NSString *)loadName:(id)sender;              //名前を読み込んで返す
- (NSString *)loadValue:(id)sender;             //金額を読み込んで返す
- (NSString *)loadPeriod:(id)sender;            //期限を読み込んで返す
- (void)saveName:(NSString *)name
            Value:(NSString *)value
            Period:(NSString *)period;          //目標のあれこれを一気に保存する

//数字の表示する感じの
- (NSString *)addComma:(NSString *)number;      // 10000 → 10,000 にするやつ
- (NSString *)deleteComma:(NSString *)string;   // 10,000 → 10000 にするやつ

@end
