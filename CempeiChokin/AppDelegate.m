//
//  AppDelegate.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import "AppDelegate.h"
#import "EditLog.h"

@implementation AppDelegate{
}

@synthesize window = _window;

// アプリケーションがロードされて起動しようかとしているところ
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    self.editLog = [[EditLog alloc] init];

    // 60秒ごとにオートセーブ
    NSTimer *saveTimer;
    saveTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(saveAll) userInfo:nil repeats:YES];

    return YES;
}
// セーブするやつ(自作)
- (void)saveAll{
    NSLog(@"セーブやで");
    [self.editLog saveData];
}
// アプリ起動中に電話とかメールとかもしくはホームボタン押してバックグラウンドになる前(ゲームだったらタイマー停止とか)
- (void)applicationWillResignActive:(UIApplication *)application{
    // まあ書くことないかな
}
// まさにバックグラウンドになろうとしている(ここでデータの保存とか)
- (void)applicationDidEnterBackground:(UIApplication *)application{
    // セーブ
    [self saveAll];
}
// バックグラウンドから帰ってくるところ
- (void)applicationWillEnterForeground:(UIApplication *)application{
}
// これもバックグラウンドから帰ってくるところ(?) 上のやつのあと？
- (void)applicationDidBecomeActive:(UIApplication *)application{
}
// アプリが死ぬとき(タスクバーで×押された時)
- (void)applicationWillTerminate:(UIApplication *)application{
}
@end
