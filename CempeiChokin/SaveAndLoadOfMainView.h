//
//  SaveAndLoadOfMainView.h
//  CempeiChokin
//
//  Created by Takeshi on 12/08/04.
//  Copyright (c) 2012年 Nakano Asami. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveAndLoadOfMainView : NSObject

- (NSMutableArray *)saveMoneyValueForArray:(NSMutableArray *)array Value:(NSNumber *)value Date:(NSDate *)date Kind:(NSString *)kind;
- (NSMutableArray *)removeObjectsInArray:(NSMutableArray *)array count:(NSUInteger)count;
- (NSMutableArray *)deleteLogArray:(NSMutableArray *)array atIndex:(NSUInteger)index;

#pragma mark - 読み込む系
- (NSNumber *)loadMoneyValueFromArray:(NSMutableArray *)array atIndex:(NSUInteger)index;
- (NSDate *)loadDateFromArray:(NSMutableArray *)array atIndex:(NSUInteger)index;
- (NSString *)loadKindFromArray:(NSMutableArray *)array atIndex:(NSUInteger)index;
@end
