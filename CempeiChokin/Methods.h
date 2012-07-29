//
//  Methods.h
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Methods : NSObject{

}

- (NSString *)addComma:(NSString *)number;
- (NSString *)deleteComma:(NSString *)string;

- (void)LoadData:(id)sender;                //データを読み込む
- (void)WriteData:(id)sender;               //初期化をする時の動作

@end
