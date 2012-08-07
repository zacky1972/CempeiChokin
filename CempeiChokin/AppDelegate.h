//
//  AppDelegate.h
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditLog.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    EditLog *editLog;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) EditLog *editLog;

@end
