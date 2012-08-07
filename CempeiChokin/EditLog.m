//
//  EditLog.m
//  CempeiChokin
//
//  Created by Takeshi on 12/08/04.
//  Copyright (c) 2012年 Nakano Asami. All rights reserved.
//

#import "EditLog.h"

@implementation EditLog{
    NSString *path;
    NSMutableDictionary *root;
    NSMutableArray *vault;
}

@synthesize log;

// 初期化
-(id)init{
    self = [super init];
    if(self){
        [self initData];
    }
    return self;
}

#pragma mark - ファイルの初期化系
// ファイルの初期化
- (void)initData{
    path = [self makeDataPathOfLog]; // ファイルの場所指定
    if( [[NSFileManager defaultManager] fileExistsAtPath:path] == NO ){ // ファイルがなかったら
        DNSLog(@"ログのデータの初期化！");
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil]; //作成する
    }else{
        [self loadData];
    }
}
// ファイル名を返す
- (NSString *)makeDataPathOfLog{
    NSString *home = NSHomeDirectory();
    NSString *document = [home stringByAppendingPathComponent:@"Documents"]; // フォルダ名
    NSString *logPath = [document stringByAppendingPathComponent:@"Log.plist"]; // ファイル名
    DNSLog(@"ログのファイル: %@",logPath);
    return logPath;
}
// ファイルへデータの保存
- (void)saveData{
    DNSLog(@"ログのデータ保存！");
    [self saveLog];
    [self saveVault];
    [root writeToFile:path atomically:YES];
}
// ファイルからデータの読み込み
- (void)loadData{
    DNSLog(@"ログのデータ読み込み！");
    root = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if(root == NULL){ // 読み込みに失敗した場合
        root = [[NSMutableDictionary alloc] init];
    }
    [self loadLog];
    [self loadVault];
}

#pragma mark - Log
// ログの保存・読み込み
- (void)saveLog{
    [root setObject:log forKey:@"Log"];
}
- (void)loadLog{
    log = [root objectForKey:@"Log"];
    if(log == NULL){ // 読み込みに失敗した場合
        log = [[NSMutableArray alloc] init];
    }
}

#pragma mark - 配列の操作
// 配列に値を追加する
- (void)saveMoneyValue:(NSNumber *)value Date:(NSDate *)date Kind:(NSString *)kind{
    DNSLog(@"金額のあれこれを保存！");
    
    NSDictionary *tempDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    value, @"MoneyValue",
                                    date,  @"Date",
                                    kind,  @"Kind",
                                    nil];
    [log insertObject:tempDictionary atIndex:0];       // 配列に入れる
}
// 選んで削除するやつ
- (void)deleteLogAtIndex:(NSUInteger)index{
    DNSLog(@"%d番目のログを削除します！",index);
    [log removeObjectAtIndex:index]; //で，実際にログを消す
}
// 何個以上だったらお墓に送るみたいな
- (void)removeObjectsCount:(NSUInteger)count{
    NSUInteger startNumber = count - 1;
    NSUInteger endNumber = [log count];

    for(int i = startNumber;i < endNumber;i++){
        [self moveToVault:[log objectAtIndex:startNumber]];
        [log removeObjectAtIndex:startNumber];
    }
}
// お墓から生き返らせる奴
- (void)reviveToLog{
    if([self checkVault] == YES){
        NSDictionary *zombieLog = [self reviveFromVault];
        [log addObject:zombieLog];
    }
}

#pragma mark - 読み込む系
// 金額を読み込んで返す
- (NSNumber *)loadMoneyValueAtIndex:(NSUInteger)index{
    return [[log objectAtIndex:index] objectForKey:@"MoneyValue"];
}
//日付を読み込んで返す
- (NSDate *)loadDateAtIndex:(NSUInteger)index{
    return [[log objectAtIndex:index] objectForKey:@"Date"];
}
//種類を読み込んで返す
- (NSString *)loadKindAtIndex:(NSUInteger)index{
    return [[log objectAtIndex:index] objectForKey:@"Kind"];
}

#pragma mark - お墓
// ログのお墓の保存・読み込み
- (void)saveVault{
    [root setObject:vault forKey:@"Vault"];
}
- (void)loadVault{
    vault = [root objectForKey:@"Vault"];
    if(vault == NULL){ // 読み込みに失敗した場合
        vault = [[NSMutableArray alloc] init];
    }
}
// お墓行き
- (void)moveToVault:(NSDictionary *)dictionary{
    [vault insertObject:dictionary atIndex:0]; // 墓に入れる
}
// 生き返り
- (NSDictionary *)reviveFromVault{
    NSDictionary *zombie = [vault objectAtIndex:0];
    [vault removeObjectAtIndex:0];
    return zombie;
}
- (BOOL)checkVault{
    if([vault count] >= 1)
        return YES;
    else
        return NO;
}

#pragma mark - その他
- (void)deleteLogData{
    DNSLog(@"データ削除！");
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [self initData];
}

@end
