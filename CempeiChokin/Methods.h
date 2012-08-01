//
//  Methods.h
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"

@interface Methods : NSObject <CPTPieChartDataSource,CPTPieChartDelegate>{
    //値をいじる感じ用
    NSString *path;
    NSMutableDictionary *root;
    NSMutableDictionary *goal;
    NSMutableDictionary *now;
    NSMutableArray *log;
    NSDictionary *tempMoneyValue;
}

- (BOOL)searchGoal;                              //初期設定が必要かどうか

//値をいじる感じの
- (void)initData;                               //Data.plistを作成
- (void)makeDataPath;                           //Date.plistへのpathを作成
- (void)loadData;                               //Data.plistから引っ張ってくる
- (void)deleteData;                             //Data.plistを消す
- (NSString *)loadName;              //名前を読み込んで返す
- (NSString *)loadValue;             //金額を読み込んで返す
- (NSString *)loadPeriod;            //期限を読み込んで返す
- (void)saveName:(NSString *)name
           Value:(NSString *)value
          Period:(NSString *)period;            //目標のあれこれを一気に保存する
- (NSString *)loadStart;             //名前を読み込んで返す
- (NSString *)loadEnd;               //金額を読み込んで返す
- (NSString *)loadBudget;            //期限を読み込んで返す
- (void)saveStart:(NSString *)start
              End:(NSString *)end
           Budget:(NSString *)budget;          //予算のあれこれを一気に保存する

//メイン画面で値を保存するとか
- (NSString *)loadMoneyValue:(NSUInteger *)cursor;        //金額を読み込んで返す
- (NSString *)loadDate:(NSUInteger *)cursor;              //日付を読み込んで返す
- (NSString *)loadKind:(NSUInteger *)cursor;              //種類を読み込んで返す
- (void)saveMoneyValue:(NSString *)value
                  Date:(NSString *)date
                  Kind:(NSString *)kind;        //金額のあれこれを一気に保存する
//メイン画面の初期設定とか
- (void)setData;        //データから値をセット
- (void)loadLog;        //ログ読み込み
- (NSNumber *)fitScrollView;  //スクロールビューの大きさを変更
- (CPTGraphHostingView *)makeGraph:(NSNumber *)expense Balance:(NSNumber *)balance Norma:(NSNumber *)norma;  //グラフの生成

// 数字の表示をする感じの
- (NSString *)addComma:(NSString *)number;      // 10000 → 10,000 にするやつ
- (NSString *)deleteComma:(NSString *)string;   // 10,000 → 10000 にするやつ

// 日付の表示をする感じの
- (NSString *)formatterDate:(NSDate *)date;

@property (readwrite, nonatomic) NSMutableArray *pieChartData;

@end
