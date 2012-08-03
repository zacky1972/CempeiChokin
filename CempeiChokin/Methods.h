//
//  Methods.h
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TranslateFormat.h"

@interface Methods : NSObject {
    //値をいじる感じ用
    NSString *path;
    NSMutableDictionary *root;
    NSMutableDictionary *goal;
    NSMutableDictionary *now;
    NSMutableArray *log;
    NSMutableDictionary *depolog;
    NSMutableDictionary *tempMoneyValue;
}

- (BOOL)searchGoal;                              //初期設定が必要かどうか

//値をいじる感じの
- (void)initData;                               //Data.plistを作成
- (void)makeDataPath;                           //Date.plistへのpathを作成
- (void)loadData;                               //Data.plistから引っ張ってくる
- (void)deleteData;                             //Data.plistを消す
- (NSString *)loadName;              //名前を読み込んで返す
- (NSNumber *)loadValue;             //金額を読み込んで返す
- (NSDate *)loadPeriod;            //期限を読み込んで返す
- (void)saveName:(NSString *)name
           Value:(NSNumber *)value
          Period:(NSDate *)period;            //目標のあれこれを一気に保存する
- (NSDate *)loadStart;             //名前を読み込んで返す
- (NSDate *)loadEnd;               //金額を読み込んで返す
- (NSNumber *)loadBudget;            //期限を読み込んで返す
- (void)saveStart:(NSDate *)start
              End:(NSDate *)end
           Budget:(NSNumber *)budget;          //予算のあれこれを一気に保存する

//メイン画面で値を保存するとか
- (NSNumber *)loadMoneyValue:(NSUInteger)cursor;        //金額を読み込んで返す
- (NSDate *)loadDate:(NSUInteger)cursor;              //日付を読み込んで返す
- (NSString *)loadKind:(NSUInteger)cursor;              //種類を読み込んで返す
- (void)saveMoneyValue:(NSNumber *)value
                  Date:(NSDate *)date
                  Kind:(NSString *)kind;        //金額のあれこれを一気に保存する
- (void)deleteLog:(NSUInteger)cursor;           //指定のログを削除する

//メイン画面の初期設定とか
- (NSNumber *)loadExpense;   //出費を返す
- (NSNumber *)loadBalance;   //残りを返す
- (NSNumber *)loadNorma;     //ノルマを返す
- (void)calcvalue:(NSNumber *)value Kind:(NSInteger)kind;        //種類に応じた処理を行うよ
- (void)calcDeletevalue:(NSNumber *)value Kind:(NSString *)kind;  //delete用，種類に応じた処理を行うよ

- (NSInteger)loadLog;        //ログ読み込み
- (float)fitScrollView;  //スクロールビューの大きさを変更

//貯金(Deposit)関係
- (void)saveDeposit:(NSNumber *)value;    //貯金額を保存
- (NSNumber *)loadDeposit;                //貯金額を呼び出し
//〆
- (BOOL)searchNext;             //期限を超えているかどうか調べる
- (Boolean)loadNextAlert;    //アラートするかどうか返す

@end
