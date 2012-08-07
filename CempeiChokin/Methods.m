//
//  Methods.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//
#import "Methods.h"
#import "TranslateFormat.h"

@interface Methods (){
    TranslateFormat *_translateFormat;
    NSNumber *bud;
    NSNumber *expense;
    NSNumber *balance;
    NSNumber *norma;
}
@end

@implementation Methods

// Date.plistへのpathを作成
- (void)makeDataPath{
    DNSLog(@"ファイルの場所の指示！");
    NSString *home = NSHomeDirectory();
    NSString *document = [home stringByAppendingPathComponent:@"Documents"];
    path = [document stringByAppendingPathComponent:@"Data.plist"];
}

// Data.plistの存在確認的な
- (void)initData{
    DNSLog(@"データの初期化！");
    [self makeDataPath];
    if( [[NSFileManager defaultManager] fileExistsAtPath:path] == NO ){                     //Data.plistがなかったら
        [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil]; //作成する
        root = [[NSMutableDictionary alloc] init];
    }else{                      //あったら
        [self loadData];
    }
}

//Data.plistからひっぱってくる
- (void)loadData{
    DNSLog(@"データ読み込み！");
    root = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    goal = [root objectForKey:@"Goal"];
    now = [root objectForKey:@"Now"];
    log = [root objectForKey:@"Log"];
}

//Data.plistを消す
- (void)deleteData{
    DNSLog(@"データ削除！");
    [self makeDataPath];
    [self loadData];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

// 初期設定が必要かどうかを確認する
- (BOOL)searchGoal{
    [self makeDataPath];
    if( [[NSFileManager defaultManager] fileExistsAtPath:path] == NO){
        // Data.plistがなかったら
    }else{
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:nil];
        unsigned long long fileSize = [fileAttributes fileSize];
        DNSLog(@"filesize:%llu",fileSize);
        if (fileSize != 0) {//ファイルサイズが0バイトじゃなかったら
            [self loadData];
            
            if([goal objectForKey:@"Name"]   == nil || [goal objectForKey:@"Value"] == nil ||
               [goal objectForKey:@"Period"] == nil || [now objectForKey:@"Start"]  == nil ||
               [now objectForKey:@"End"]     == nil || [now objectForKey:@"Budget"] == nil ){return 0;}
            //ここで値をセット
            if([root objectForKey:@"Norma"] == nil){//初めだったら
                DNSLog(@"新規の目標なので初期設定！");
                DNSLog(@"%@",root);
                bud = [self loadBudget];
                expense = @0;  //出費
                NSTimeInterval since;
                NSInteger tempday1,tempday2;
                since = [[self loadStart] timeIntervalSinceDate:[self loadPeriod]];
                tempday1 = (int)(since / (60 * 60 * 24));
                since = [[self loadStart] timeIntervalSinceDate:[self loadEnd]];
                tempday2 = (int)(since / (60 * 60 * 24));
                norma = @( ( ( [[self loadValue] intValue] - [[self loadDeposit] intValue] ) / tempday1 ) * tempday2 );
                balance = @( [[self loadBudget] intValue] - [[self loadNorma] intValue] );
                depolog = [[NSMutableArray alloc] init];
                [self saveDeposit:@0 Date:[self loadEnd]];
                
                [root setObject:expense forKey:@"Expense"];
                [root setObject:balance forKey:@"Balance"];
                [root setObject:norma forKey:@"Norma"];
                [root setObject:depolog forKey:@"Deposit"];
                [root setObject:@0 forKey:@"NextAlert"];
                [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
            }
            DNSLog(@"root:%@",root);
            return 1;
        }else{//0バイトだったら
            [self deleteData];
        }
    }
    return 0;
}

#pragma mark - 目標(Goal)関係
// FIXME: 正直この3つはまとめたい
- (NSString *)loadName{return [goal objectForKey:@"Name"];}      //名前を読み込んで返す
- (NSNumber *)loadValue{return [goal objectForKey:@"Value"];}    //金額を読み込んで返す
- (NSDate *)loadPeriod{return [goal objectForKey:@"Period"];}  //期限を読み込んで返す

//目標のあれこれを一気に保存する
- (void)saveName:(NSString *)name Value:(NSNumber *)value Period:(NSDate *)period{
    DNSLog(@"プロパティリストに保存！");
    _translateFormat = [TranslateFormat alloc];
    goal = [[NSMutableDictionary alloc] init];
    [goal setObject:name forKey:@"Name"];       //とりあえずgoalに値を上書き
    [goal setObject:value forKey:@"Value"];
    [goal setObject:[_translateFormat dateOnly:[_translateFormat nineHoursLater:period]] forKey:@"Period"];
    [root setObject:goal forKey:@"Goal"];
    DNSLog(@"root:%@",root);
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
    
}

#pragma mark - 今回のアレ(Now)関係
// FIXME: 正直この3つはまとめたい
- (NSDate *)loadStart{return [now objectForKey:@"Start"];}      //名前を読み込んで返す
- (NSDate *)loadEnd{return [now objectForKey:@"End"];}          //金額を読み込んで返す
- (NSNumber *)loadBudget{return [now objectForKey:@"Budget"];}    //期限を読み込んで返す

//予算のあれこれを一気に保存する
- (void)saveStart:(NSDate *)start End:(NSDate *)end Budget:(NSNumber *)budget{
    DNSLog(@"プロパティリストに保存！");
    _translateFormat = [TranslateFormat alloc];
    now = [[NSMutableDictionary alloc] init];
    [now setObject:[_translateFormat dateOnly:[_translateFormat nineHoursLater:start]] forKey:@"Start"];      //とりあえずnowに値を上書き
    [now setObject:budget forKey:@"Budget"];
    [now setObject:[_translateFormat dateOnly:[_translateFormat nineHoursLater:end]] forKey:@"End"];
    [root setObject:now forKey:@"Now"];
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
}

#pragma mark - 初期設定関係
//わけわからんくなってきた
- (NSNumber *)loadExpense{return [root objectForKey:@"Expense"];}   //出費を返す
- (NSNumber *)loadBalance{
    [self makeDataPath];
    [self loadData];
    return [root objectForKey:@"Balance"];}   //残りを返す
- (NSNumber *)loadNorma{return [root objectForKey:@"Norma"];}     //ノルマを返す

//計算やらやるよ
- (void)calcvalue:(NSNumber *)value Kind:(NSInteger)kind{
    DNSLog(@"計算するよ");
    DNSLog(@"\nRoot:%@",root);
    // FIXME: ここで読み込みかなんかしないと初回起動以外だと値が消えるっぽい
    expense = [self loadExpense];
    balance = [self loadBalance];
    bud = [self loadBudget];
    switch (kind) {
        case 0://出費
            DNSLog(@"出費の処理！");
            expense = @([expense intValue] + [value intValue]);
            balance = @([bud intValue] - [expense intValue]);
            break;
        case 1://収入
            DNSLog(@"収入の処理！");
            bud = @([bud intValue] + [value intValue]);
            balance = @([bud intValue] - [expense intValue]);
            [now setObject:bud forKey:@"Budget"];
            [root setObject:now forKey:@"Now"];
            break;
        case 2://残高調整
            DNSLog(@"調整の処理！");
            DNSLog(@"誤差:%d", [balance intValue] - [value intValue]);
            expense = @( [expense intValue] + ( [balance intValue] - [value intValue] ) );
            balance = @([bud intValue] - [expense intValue]);
            break;
            
    }
    [root setObject:expense forKey:@"Expense"];
    [root setObject:balance forKey:@"Balance"];
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
    DNSLog(@"%@",root);
}

//delete用，種類に応じた処理を行うよ
- (void)calcDeletevalue:(NSNumber *)value Kind:(NSString *)kind{
    //TODO: ここにdelete用の処理
    DNSLog(@"delete用の計算するよ");
    DNSLog(@"\nRoot:%@",root);
    // FIXME: ここで読み込みかなんかしないと初回起動以外だと値が消えるっぽい

    expense = [self loadExpense];
    balance = [self loadBalance];
    bud = [self loadBudget];
    
    NSInteger tempKind;
    if([kind isEqualToString:@"出費"])
        tempKind = 0;
    if([kind isEqualToString:@"収入"])
        tempKind = 1;
    if([kind isEqualToString:@"残高調整"])
        tempKind = 2;
    
    switch (tempKind) {
        case 0://出費
            DNSLog(@"出費のdelete処理！");
            expense = @([expense intValue] - [value intValue]);
            balance = @([bud intValue] - [expense intValue]);
            break;
        case 1://収入
            DNSLog(@"収入のdelete処理！");
            bud = @([bud intValue] - [value intValue]);
            balance = @([bud intValue] - [expense intValue]);
            [now setObject:bud forKey:@"Budget"];
            [root setObject:now forKey:@"Now"];
            break;
        case 2://調整
            DNSLog(@"調整のdelete処理！");
            DNSLog(@"誤差:%@",value);
            expense = @( [expense intValue] - [value intValue] );
            balance = @([bud intValue] - [expense intValue]);
            
            /*
             DNSLog(@"調整の処理！");
             DNSLog(@"誤差:%d", [balance intValue] - [value intValue]);
             expense = @( [expense intValue] + ( [balance intValue] - [value intValue] ) );
             balance = @([bud intValue] - [expense intValue]);
             */
            break;
    }
    
    [root setObject:expense forKey:@"Expense"];
    [root setObject:balance forKey:@"Balance"];
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
    DNSLog(@"delete完了チェック:%@",root);
    
}

//ログ読み込み
- (NSInteger)loadLog{
    DNSLog(@"ログ読み込み！%d個です！",[log count]);
    return [log count];
}


#pragma mark - 貯金(Deposit)関係
//貯金額を保存
- (void)saveDeposit:(NSNumber *)value Date:(NSDate *)date{
    DNSLog(@"貯金保存！");
    NSArray *tempDepolog = [[NSArray alloc] initWithObjects:value, date,  nil];
    if ([root objectForKey:@"Deposit"] != nil) {
        DNSLog(@"%@",[root objectForKey:@"Deposit"]);
        depolog = [root objectForKey:@"Deposit"];
        if ([[[depolog objectAtIndex:0] objectAtIndex:1] isEqualToDate:date] ==YES ){
            DNSLog(@"詐欺貯金はいかんよ！");
            [depolog removeObjectAtIndex:0];
            DNSLog(@"depolog:%@",depolog);
        }
    }
    [depolog insertObject:tempDepolog atIndex:0];
    [root setObject:depolog forKey:@"Deposit"];
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
    DNSLog(@"Depolog:%@",root);
}

//貯金額を呼び出し
- (NSNumber *)loadDeposit{
    DNSLog(@"貯金総額計算するよ！");
    NSInteger sumDeposit = 0;
    depolog = [root objectForKey:@"Deposit"];
    DNSLog(@"%@",[[depolog objectAtIndex:0] objectAtIndex:0]);
    
    for (NSInteger i = 0; i < [depolog count]; i++) {
        sumDeposit = sumDeposit + [[[depolog objectAtIndex:i] objectAtIndex:0] intValue];
    }
    return [NSNumber numberWithInt:sumDeposit];
}


 #pragma mark - 〆
//期限を超えているかどうか調べる
 - (BOOL)searchNext{
     DNSLog(@"期限チェック！");
     _translateFormat = [TranslateFormat alloc];
     NSDate *date = [_translateFormat dateOnly:[_translateFormat nineHoursLater:[NSDate date]]];
     [self makeDataPath];
     [self loadData];
     DNSLog(@"今日:%@",date);
     DNSLog(@"期限日:%@",[self loadEnd]);
     DNSLog(@"はやいほう！：%@",[date earlierDate:[self loadEnd]]);
 
     DNSLog(@"date:%@",[self loadEnd]);
     if ([_translateFormat equalDate:date Vs:[self loadEnd]] == NO) {//今日が期限日じゃなくて
         DNSLog(@"同じ日やないわ！");
         if([date earlierDate:[self loadEnd]] != date){//期限日より後
             DNSLog(@"期限きれた！");
             //ここの処理は引っ越し予定
             if ([self loadNextAlert] == YES) {
                 DNSLog(@"催促するわ！");
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"期限が来ました！" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                 [root setObject:@1 forKey:@"NextAlert"];   //もう警告がでないようにする
                 [root writeToFile:path atomically:YES];    //それでrootをdata.plistに書き込み
                 return YES;
             }else{
                 DNSLog(@"もう催促したわ！");
                 return NO;
             }
             
         }else{//まだ期限内
             //DNSLog(@"期限内やわ！");
         }
     }
     DNSLog(@"期限きれてない！");
     [root setObject:@0 forKey:@"NextAlert"];   //もう警告がでないようにする
     [root writeToFile:path atomically:YES];    //それでrootをdata.plistに書き込み
     return NO;
 }
 
 
 //アラートするかどうか返す
 - (Boolean)loadNextAlert{
     [self makeDataPath];
     [self loadData];
     if ([root objectForKey:@"NextAlert"] == @1) {
         return NO;
     }
     return YES;
 }
 
//貯金が溜まったかどうか調べる
- (BOOL)searchFinish{
    DNSLog(@"たまった？");
    if ([self loadValue] ==  [self loadDeposit]) {
        DNSLog(@"たまった！");
        return YES;
    }else{
        DNSLog(@"たまってない…");
        return NO;
    }

}

- (BOOL)searchLastNorma{
    DNSLog(@"最後の期間？");
    if ([[self loadEnd] isEqualToDate:[self loadPeriod]] == YES) {
        DNSLog(@"最後！");
        return YES;
    }else{
        DNSLog(@"まだまだ！");
        return NO;
    }
}

#pragma mark - その他
/*
//スクロールビューの大きさを変更
- (float)fitScrollView{
    DNSLog(@"ビューをフィット！");
    [self makeDataPath];
    [self loadData];
    
    NSInteger height;
    
    //セルの個数をとってくる
    DNSLog(@"log:%@",log);
    height = [self loadLog];
    if ( height >= 10 ){ // logのセル数が10未満じゃなかったら
        height = 10;
    }
    height = 779 + 45 * height;
    return [[[NSNumber alloc] initWithInt:height] floatValue];
}*/

//スクロールビューの大きさを変更 改
- (float)fitScrollViewWithCount:(NSUInteger)count{
    DNSLog(@"ビューをフィット！");
    float height;
    height = 779 + 45 * count;
    return height;
}

@end
