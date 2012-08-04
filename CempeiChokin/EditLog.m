//
//  EditLog.m
//  CempeiChokin
//
//  Created by Takeshi on 12/08/04.
//  Copyright (c) 2012年 Nakano Asami. All rights reserved.
//

#import "EditLog.h"
#import "TranslateFormat.h"
#import "Methods.h"

@implementation EditLog

// ファイル名を返す
- (NSString *)makeDataPathOfLog{
    NSString *home = NSHomeDirectory();
    NSString *document = [home stringByAppendingPathComponent:@"Documents"]; // フォルダ名
    NSString *path = [document stringByAppendingPathComponent:@"Log.plist"]; // ファイル名
    DNSLog(@"ログのファイル: %@",path);
    return path;
}

// ファイルの初期化
- (void)initData{
    NSString *path = [self makeDataPathOfLog]; // ファイルの場所指定
    if( [[NSFileManager defaultManager] fileExistsAtPath:path] == NO ){ // ファイルがなかったら
        DNSLog(@"ログのデータの初期化！");
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil]; //作成する
    }
}

// ファイルへデータの保存
- (void)saveData:(NSMutableDictionary *)root{
    [self initData]; // ファイルの確認
    DNSLog(@"ログのデータ保存！");
    NSString *path = [self makeDataPathOfLog];
    [root writeToFile:path atomically:YES];
}

// ファイルからデータの読み込み
- (NSMutableDictionary *)loadData{
    [self initData];
    DNSLog(@"ログのデータ読み込み！");
    NSString *path = [self makeDataPathOfLog];
    NSMutableDictionary *root = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if(root == NULL){ // 読み込みに失敗した場合
        root = [[NSMutableDictionary alloc] init];
    }
    return root;
}

#pragma mark - ログ
// ログの読み込み
- (NSMutableArray *)loadLogFromFile{
    NSMutableDictionary *root = [self loadData];
    
    NSMutableArray *log = [root objectForKey:@"Log"];
    if(log == NULL){ // 読み込みに失敗した場合
        log = [[NSMutableArray alloc] init];
    }
    return log;
}

// ログの保存
- (void)saveLogToFile:(NSMutableArray *)array{
    NSMutableDictionary *root = [self loadData];

    [root setObject:array forKey:@"Log"];
    [self saveData:root];
}

// 配列に値を追加する
- (NSMutableArray *)saveMoneyValueForArray:(NSMutableArray *)array Value:(NSNumber *)value Date:(NSDate *)date Kind:(NSString *)kind{
    DNSLog(@"金額のあれこれを保存！");
    
    NSDictionary *tempDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    value, @"MoneyValue",
                                    date,  @"Date",
                                    kind,  @"Kind",
                                    nil];
    [array insertObject:tempDictionary atIndex:0];       // 配列に入れる
    
    [self saveLogToFile:array]; // プロパティリストに保存
    return array; // 追加後の値を返す
}

// 削除するやつ
- (NSMutableArray *)deleteLogArray:(NSMutableArray *)array atIndex:(NSUInteger)index{
    DNSLog(@"%d番目のログを削除します！",index);
    
    [array removeObjectAtIndex:index]; //で，実際にログを消す

    [self saveLogToFile:array]; // プロパティリストに保存
    return array; // 削除後の配列を返す
}

// 削除したあとにお墓から生き返らせる奴
- (NSMutableArray *)reviveToLogArray:(NSMutableArray *)array{
    if([self checkVault] == YES){
        NSDictionary *zombieLog = [self reviveFromVault];
        [array addObject:zombieLog];
    }
    return array;
}

#pragma mark - 読み込む系
// 金額を読み込んで返す
- (NSNumber *)loadMoneyValueFromArray:(NSMutableArray *)array atIndex:(NSUInteger)index{
    NSDictionary *tempDictionary = [array objectAtIndex:index];
    NSNumber *tempNumber = [tempDictionary objectForKey:@"MoneyValue"];
    return tempNumber;
}

//日付を読み込んで返す
- (NSDate *)loadDateFromArray:(NSMutableArray *)array atIndex:(NSUInteger)index{
    NSDictionary *tempDictionary = [array objectAtIndex:index];
    NSDate *tempDate = [tempDictionary objectForKey:@"Date"];
    return tempDate;
}

//種類を読み込んで返す
- (NSString *)loadKindFromArray:(NSMutableArray *)array atIndex:(NSUInteger)index{
    NSDictionary *tempDictionary = [array objectAtIndex:index];
    NSString *tempString = [tempDictionary objectForKey:@"Kind"];
    return tempString;
}

#pragma mark - お墓
// ログのお墓の読み込み
- (NSMutableArray *)loadVaultFromFile{
    NSMutableDictionary *root = [self loadData];
    
    NSMutableArray *vault = [root objectForKey:@"Vault"];
    if(vault == NULL){ // 読み込みに失敗した場合
        vault = [[NSMutableArray alloc] init];
    }
    DNSLog(@"\nVault:%@",vault);
    return vault;
}

// ログのお墓の保存
- (void)saveVaultToFile:(NSMutableArray *)array{
    NSMutableDictionary *root = [self loadData];

    [root setObject:array forKey:@"Vault"];
    [self saveData:root];
    DNSLog(@"\nRoot:%@",root);
}

// お墓行き
- (void)moveToVault:(NSDictionary *)dictionary{
    NSMutableArray *vault = [self loadVaultFromFile];
    [vault insertObject:dictionary atIndex:0]; // 墓に入れる

    [self saveVaultToFile:vault]; // プロパティリストに保存
}

// 生き返り
- (NSDictionary *)reviveFromVault{
    NSMutableArray *vault = [self loadVaultFromFile];

    NSDictionary *zombie = [vault objectAtIndex:0];
    [vault removeObjectAtIndex:0];
    [self saveVaultToFile:vault]; // プロパティリストに保存

    return zombie;
}

- (BOOL)checkVault{
    NSMutableArray *vault = [self loadVaultFromFile];
    if([vault count] >= 1){
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - その他
// 何個以上だったら消すみたいなやつ
- (NSMutableArray *)removeObjectsInArray:(NSMutableArray *)array count:(NSUInteger)count{
    DNSLog(@"配列から消しまーす！");
    NSUInteger startNumber = count - 1;
    NSUInteger endNumber = [array count];

    for(int i = startNumber;i < endNumber;i++){
        [self moveToVault:[array objectAtIndex:startNumber]];
        [array removeObjectAtIndex:startNumber];
    }
    return array;
}

- (void)deleteLogData{
    DNSLog(@"データ削除！");
    NSString *path = [self makeDataPathOfLog];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

@end
