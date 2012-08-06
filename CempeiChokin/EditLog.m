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

@implementation EditLog{
    NSString *path;
    NSMutableDictionary *root;
}

@synthesize log;

// 初期化
-(id)init{
    self = [super init];
    if(self){
        [self initData];
        log = [self loadLogFromFile];
    }
    return self;
}

#pragma mark - ファイルの初期化
// ファイル名を返す
- (NSString *)makeDataPathOfLog{
    NSString *home = NSHomeDirectory();
    NSString *document = [home stringByAppendingPathComponent:@"Documents"]; // フォルダ名
    NSString *datePath = [document stringByAppendingPathComponent:@"Log.plist"]; // ファイル名
    DNSLog(@"ログのファイル: %@",datePath);
    return datePath;
}

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

// ファイルへデータの保存
- (void)saveData{
    DNSLog(@"ログのデータ保存！");
    [root writeToFile:path atomically:YES];
}

// ファイルからデータの読み込み
- (void)loadData{
    DNSLog(@"ログのデータ読み込み！");
    root = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if(root == NULL){ // 読み込みに失敗した場合
        root = [[NSMutableDictionary alloc] init];
    }
}

#pragma mark - ログ
// ログの読み込み
- (NSMutableArray *)loadLogFromFile{
    NSMutableArray *tempArray = [root objectForKey:@"Log"];
    if(tempArray == NULL){ // 読み込みに失敗した場合
        tempArray = [[NSMutableArray alloc] init];
    }
    return tempArray;
}

// ログの保存
- (void)saveLogToFile{
    [root setObject:log forKey:@"Log"];
    [self saveData];
}

#pragma mark - 配列の操作
// 配列に値を追加する
- (void)saveMoneyValue:(NSNumber *)value Date:(NSDate *)date Kind:(NSString *)kind{
    DNSLog(@"金額のあれこれを保存！");
    NSDictionary *tempDictionary;
    if ([kind isEqualToString:@"調整"] == NO) {
        tempDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        value, @"MoneyValue",
                                        date,  @"Date",
                                        kind,  @"Kind",
                                        nil];

    }else{//残高調整の場合，誤差を保存する
        value = @( [[[Methods alloc] loadBalance] intValue] - [value intValue] );
        DNSLog(@"balance:%@ \n value:%@",[[Methods alloc] loadBalance],value);
        tempDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                          value, @"MoneyValue",
                          date,  @"Date",
                          kind,  @"Kind",
                          nil];
    }
    
    [log insertObject:tempDictionary atIndex:0];       // 配列に入れる
    DNSLog(@"log:%@",log);
    [self saveLogToFile]; // プロパティリストに保存
}

// 削除するやつ
- (void)deleteLogAtIndex:(NSUInteger)index{
    DNSLog(@"%d番目のログを削除します！",index);
    [log removeObjectAtIndex:index]; //で，実際にログを消す
    [self saveLogToFile];
}

// 削除したあとにお墓から生き返らせる奴
- (void)reviveToLog{
    if([self checkVault] == YES){
        NSDictionary *zombieLog = [self reviveFromVault];
        [log addObject:zombieLog];
    }
}

#pragma mark - 読み込む系
// 金額を読み込んで返す
- (NSNumber *)loadMoneyValueAtIndex:(NSUInteger)index{
    NSDictionary *tempDictionary = [log objectAtIndex:index];
    NSNumber *tempNumber = [tempDictionary objectForKey:@"MoneyValue"];
    return tempNumber;
}

//日付を読み込んで返す
- (NSDate *)loadDateAtIndex:(NSUInteger)index{
    NSDictionary *tempDictionary = [log objectAtIndex:index];
    NSDate *tempDate = [tempDictionary objectForKey:@"Date"];
    return tempDate;
}

//種類を読み込んで返す
- (NSString *)loadKindAtIndex:(NSUInteger)index{
    NSDictionary *tempDictionary = [log objectAtIndex:index];
    NSString *tempString = [tempDictionary objectForKey:@"Kind"];
    return tempString;
}

#pragma mark - お墓
// ログのお墓の読み込み
- (NSMutableArray *)loadVaultFromFile{    
    NSMutableArray *vault = [root objectForKey:@"Vault"];
    if(vault == NULL){ // 読み込みに失敗した場合
        vault = [[NSMutableArray alloc] init];
    }
    DNSLog(@"\nVault:%@",vault);
    return vault;
}

// ログのお墓の保存
- (void)saveVaultToFile:(NSMutableArray *)array{
    [root setObject:array forKey:@"Vault"];
    [self saveData];
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
- (void)removeObjectsCount:(NSUInteger)count{
    DNSLog(@"配列から消しまーす！");
    NSUInteger startNumber = count - 1;
    NSUInteger endNumber = [log count];

    for(int i = startNumber;i < endNumber;i++){
        [self moveToVault:[log objectAtIndex:startNumber]];
        [log removeObjectAtIndex:startNumber];
    }
}

- (void)deleteLogData{
    DNSLog(@"データ削除！");
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

@end
