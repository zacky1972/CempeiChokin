//
//  EditData.h
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

////////////////////////////////////////////////////////////
//
// EditData ┬ Expense (出費)   @property済み
//          ├ Balance (残り)   @property済み
//          ├ Norma   (ノルマ) @property済み
//          ├ Budget  (予算)   @property済み
//          │
//          ├ Goal ┬ Name   (名前)
//          │      ├ Value  (値段)
//          │      └ Period (期限)
//          ├ Now  ┬ Start  (始まり)
//          │      └ Goal   (終わり)
//          │
//          ├ deposit (総貯金額) @property済み
//          ├ depositLog ┬ Value  (貯金額)
//          │            └ Date   (貯金したときのStartあたり)
//          │
//          ├ defaultSettings (初期設定したかどうか) @property済み
//          └ nextAlert (アラートを表示したかどうか) @property済み
//
////////////////////////////////////////////////////////////


#import <Foundation/Foundation.h>

@interface EditData : NSObject{
    NSNumber *expense;
    NSNumber *balance;
    NSNumber *norma;
    NSNumber *budget;

    NSMutableDictionary *goal;
    NSMutableDictionary *now;

    NSNumber *deposit;
    NSMutableArray *depositLog;

    BOOL defaultSettings;
    BOOL nextAlert;
}

@property (nonatomic,retain)NSNumber *expense;
@property (nonatomic,retain)NSNumber *balance;
@property (nonatomic,retain)NSNumber *norma;
@property (nonatomic,retain)NSNumber *budget;

@property (nonatomic,retain)NSNumber *deposit;

@property (nonatomic,assign)BOOL defaultSettings;
@property (nonatomic,assign)BOOL nextAlert;

#pragma mark - ファイルの操作
// データの保存
- (void)saveData;
// データの削除
- (void)deleteData;

#pragma mark - データの保存・読み込み
// 欲しい物の設定
- (void)saveName:(NSString *)name Value:(NSNumber *)value Period:(NSDate *)period;
- (NSString *)loadGoalName;
- (NSNumber *)loadGoalValue;
- (NSDate *)loadGoalPeriod;
// 今回の期限の設定
- (void)saveStart:(NSDate *)start End:(NSDate *)end;
- (NSDate *)loadStart;
- (NSDate *)loadEnd;
// 貯金したときの
- (void)saveDepositDate:(NSDate *)date Value:(NSNumber *)value;
- (void)skipDepositDate:(NSDate *)date;
#pragma mark - 計算系
// ノルマとかの計算・再計算
- (void)calcForNextStage;
// 出費・収入・残高調整の入力
- (void)calcValue:(NSNumber *)value Kind:(NSInteger)kind;
// 出費・収入・残高調整の削除
- (void)calcDeleteValue:(NSNumber *)value Kind:(NSString *)tempKind;

#pragma mark - その他
- (BOOL)searchNext;
- (BOOL)searchFinish;       //貯金が溜まったかどうか調べる
- (BOOL)searchLastNorma;    //最後の期間かどうか調べる


@end
