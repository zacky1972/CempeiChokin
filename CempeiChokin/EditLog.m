//
//  EditLog.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import "EditLog.h"
#import "AppDelegate.h"
#import "TranslateFormat.h"

@implementation EditLog{
    AppDelegate *appDelegate;
    TranslateFormat *translateFormat;

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
    [self makeDataPath]; // ファイルの場所指定

    // ファイルの存在確認
    if( [[NSFileManager defaultManager] fileExistsAtPath:path] == NO ){
        // ファイルがなかったら
        DNSLog(@"ログのデータの初期化！");
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil]; //作成する
    }

    // データの読み込み
    [self loadData];

    // 利用するクラスのインスタンス化
    appDelegate = APP_DELEGATE;
    translateFormat = [TranslateFormat alloc];
}
// ファイル名を返す
- (void)makeDataPath{
    NSString *home = NSHomeDirectory();                                         // ホームディレクトリ
    NSString *document = [home stringByAppendingPathComponent:@"Documents"];    // フォルダ名
    path = [document stringByAppendingPathComponent:@"Log.plist"];              // ファイル名
    DNSLog(@"ログのファイル: %@",path);
}
// ファイルへデータの保存
- (void)saveData{
    DNSLog(@"ログのデータ保存！");
    // データをRootに入れる
    [self saveLog];
    [self saveVault];

    // ファイルの保存
    [root writeToFile:path atomically:YES];

    // 中身の確認
    DNSLog(@"\nLog.plist:%@",root);
}
// ファイルからデータの読み込み
- (void)loadData{
    DNSLog(@"ログのデータ読み込み！");
    // データをRootに読み込ませる
    root = [[NSMutableDictionary alloc] initWithContentsOfFile:path]; // ファイルからRootを作成
    if(root == NULL)
        // 読み込みに失敗した場合
        root = [[NSMutableDictionary alloc] init]; // 空のRootを作成する

    // Rootからデータを読み込む
    [self loadLog];
    [self loadVault];

    // 中身の確認
    DNSLog(@"\nLog.plist:%@",root);
}

#pragma mark - Log
// ログの保存・読み込み
- (void)saveLog{
    [root setObject:log forKey:@"Log"];
}
- (void)loadLog{
    log = [root objectForKey:@"Log"];

    // ログの初期化
    if(log == NULL){
        // 読み込みに失敗した場合
        log = [[NSMutableArray alloc] init];
    }
}

#pragma mark - 配列の操作
// 配列に値を追加する
- (void)saveMoneyValue:(NSNumber *)value Date:(NSDate *)date Kind:(NSInteger)kindNum{
    DNSLog(@"金額のあれこれを保存！");

    // 数値から文字列に変換
    NSString *kind = [NSString alloc];
    switch (kindNum) {
        case 0:
            kind = @"出費";
            break;
        case 1:
            kind = @"収入";
            break;
        case 2:
            kind = @"残高調整";
            break;
    }

    // 値の整形
    date = [translateFormat dateOnly:date];
    // 入力されたデータからNSDictionaryを作成する
    NSDictionary *tempDictionary = [NSDictionary alloc];

    // 計算方式の選択
    if ([kind isEqualToString:@"残高調整"] == NO) {
        // 出費・支出の場合
        tempDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        value, @"MoneyValue",
                                        date,  @"Date",
                                        kind,  @"Kind",
                                        nil];
    }else{
        //残高調整の場合
        value = @( [appDelegate.editData.balance intValue] - [value intValue] ); // 誤差を計算してそれを値にする
        tempDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                          value, @"MoneyValue",
                          date,  @"Date",
                          kind,  @"Kind",
                          nil];
    }

    // ログに入れる
    [log insertObject:tempDictionary atIndex:0];       // 配列に入れる
}
// 選択されたセルを削除
- (void)deleteLogAtIndex:(NSUInteger)index{
    DNSLog(@"%d番目のログを削除します！",index);
    [log removeObjectAtIndex:index]; // ログを消す
}
// 何個以上だったらお墓に送るみたいな
- (void)removeObjectsCount:(NSUInteger)count{
    // Countから後の番号の配列をすべてVaultに送る
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
        // Vaultにデータが存在する場合
        NSDictionary *zombieLog = [self reviveFromVault];
        [log addObject:zombieLog]; // Vaultからログに移動させる
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
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    [self initData];
}

@end
