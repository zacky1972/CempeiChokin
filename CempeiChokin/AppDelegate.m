//
//  AppDelegate.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

// アプリケーションがロードされて起動しようかとしているところ
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // TODO: ここでデータの読み込みするのが正しいのかな？
    return YES;
}
// アプリ起動中に電話とかメールとかもしくはホームボタン押してバックグラウンドになる前(ゲームだったらタイマー停止とか)
- (void)applicationWillResignActive:(UIApplication *)application
{
    // まあ書くことないかな
}
// まさにバックグラウンドになろうとしている(ここでデータの保存とか)
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // TODO: ここでセーブさせる
}
// バックグラウンドから帰ってくるところ
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // ここにも特に無い気がせんでもない
}
// これもバックグラウンドから帰ってくるところ(?) 上のやつのあと？
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // ここにも特になくね？
}
// アプリが死ぬとき(タスクバーで×押された時)
- (void)applicationWillTerminate:(UIApplication *)application
{
    // ここに書く必要ないか
}
@end
