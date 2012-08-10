//
//  EditData.h
//  CempeiChokin
//
//  Created by Takeshi on 12/08/07.
//  Copyright (c) 2012年 Nakano Asami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EditData : NSObject{
    NSNumber *expense;
    NSNumber *balance;
    NSNumber *norma;
    NSNumber *budget;

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
@property (nonatomic,retain)NSMutableArray *depositLog;

@property (nonatomic,assign)BOOL defaultSettings;
@property (nonatomic,assign)BOOL nextAlert;

- (void)saveData;
- (void)saveName:(NSString *)name Value:(NSNumber *)value Period:(NSDate *)period;
- (void)saveStart:(NSDate *)start End:(NSDate *)end;
- (void)saveDepositDate:(NSDate *)date Value:(NSNumber *)value;
- (void)calcForNextStage;
- (void)calcValue:(NSNumber *)value Kind:(NSInteger)kind;
- (void)calcDeleteValue:(NSNumber *)value Kind:(NSString *)tempKind;
- (BOOL)searchNext;

- (NSString *)loadGoalName;
- (NSNumber *)loadGoalValue;
- (NSDate *)loadGoalPeriod;
- (NSDate *)loadStart;
- (NSDate *)loadEnd;

- (void)deleteData;

@end
