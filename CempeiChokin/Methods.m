//
//  Methods.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//
#import "Methods.h"

@interface Methods ()
@end

@implementation Methods

@synthesize pieChartData;

// 初期設定が必要かどうかを確認する
- (BOOL)searchGoal{
    [self makeDataPath];
    if( [[NSFileManager defaultManager] fileExistsAtPath:path] == NO ){
        // Data.plistがなかったら
        DNSLog(@"ファイルなかった！");
        return 0;
    }else{
        // Data.plistがあったら
        DNSLog(@"ファイルあった！");
        [self loadData];
        if([goal objectForKey:@"Name"]   == nil || [goal objectForKey:@"Value"] == nil ||
           [goal objectForKey:@"Period"] == nil || [now objectForKey:@"Start"]  == nil ||
           [now objectForKey:@"End"]     == nil || [now objectForKey:@"Budget"] == nil ){
            DNSLog(@"ぬけがあった！");
            return 0;
        }
        DNSLog(@"せっっていおわってる！");
        return 1;
    }
}

//  Date.plistへのpathを作成
- (void)makeDataPath{
    DNSLog(@"ファイルの場所の指示！");
    NSString *home = NSHomeDirectory();
    NSString *document = [home stringByAppendingPathComponent:@"Documents"];
    path = [document stringByAppendingPathComponent:@"Data.plist"];
}

//Data.plistの初期設定
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

// FIXME: 正直この3つはまとめたい
- (NSString *)loadName{return [goal objectForKey:@"Name"];}      //名前を読み込んで返す
- (NSString *)loadValue{return [goal objectForKey:@"Value"];}    //金額を読み込んで返す
- (NSString *)loadPeriod{return [goal objectForKey:@"Period"];}  //期限を読み込んで返す

//目標のあれこれを一気に保存する
- (void)saveName:(NSString *)name Value:(NSString *)value Period:(NSString *)period{
    DNSLog(@"プロパティリストに保存！");
    goal = [[NSMutableDictionary alloc] init];
    [goal setObject:name forKey:@"Name"];       //とりあえずgoalに値を上書き
    [goal setObject:value forKey:@"Value"];
    [goal setObject:period forKey:@"Period"];
    [root setObject:goal forKey:@"Goal"];
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
}

// FIXME: 正直この3つはまとめたい
- (NSString *)loadStart{return [now objectForKey:@"Start"];}      //名前を読み込んで返す
- (NSString *)loadEnd{return [now objectForKey:@"End"];}          //金額を読み込んで返す
- (NSString *)loadBudget{return [now objectForKey:@"Budget"];}    //期限を読み込んで返す

//予算のあれこれを一気に保存する
- (void)saveStart:(NSString *)start End:(NSString *)end Budget:(NSString *)budget{
    DNSLog(@"プロパティリストに保存！");
    now = [[NSMutableDictionary alloc] init];
    [now setObject:start forKey:@"Start"];      //とりあえずnowに値を上書き
    [now setObject:budget forKey:@"Budget"];
    [now setObject:end forKey:@"End"];
    [root setObject:now forKey:@"Now"];
    [root writeToFile:path atomically:YES];     //それでrootをdata.plistに書き込み
}

#pragma MainView系
//保存系
//金額を読み込んで返す
- (NSString *)loadMoneyValue:(NSUInteger *)cursor{
    tempMoneyValue = [log objectAtIndex:*cursor];
    return [tempMoneyValue objectForKey:@"MoneyValue"];
}

//日付を読み込んで返す
- (NSString *)loadDate:(NSUInteger *)cursor{
    tempMoneyValue = [log objectAtIndex:*cursor];
    return [tempMoneyValue objectForKey:@"Date"];
}

//種類を読み込んで返す
- (NSString *)loadKind:(NSUInteger *)cursor{
    tempMoneyValue = [log objectAtIndex:*cursor];
    return [tempMoneyValue objectForKey:@"Kind"];
}

//金額のあれこれを一気に保存する
- (void)saveMoneyValue:(NSString *)value Date:(NSString *)date Kind:(NSString *)kind{
    DNSLog(@"金額のあれこれを保存！");
    log = [[NSMutableArray alloc] init];
    tempMoneyValue = [NSDictionary dictionaryWithObjectsAndKeys:
                                    value, @"MoneyValue",
                                    date, @"Date",
                                    kind, @"Kind", nil];
    [log addObject:tempMoneyValue];
    DNSLog(@"%@",log);
}

//初期設定系
//データから値をセット
- (void)setData{
    DNSLog(@"データをセット！");
}

//ログ読み込み
- (void)loadLog{
    DNSLog(@"ログ読み込み！");
}

//スクロールビューの大きさを変更
- (float)fitScrollView{
    DNSLog(@"ビューをフィット！");
    [self makeDataPath];
    [self loadData];
    
    NSInteger height;
    
    //セルの個数をとってくる
    DNSLog(@"log:%@",log);
    height = [log count];
    if ( height >= 10 ){ // logのセル数が10未満じゃなかったら
        height = 10;
    }
    
    height = 779 + 45 * height;
    return [[[NSNumber alloc] initWithInt:height] floatValue];
}

//グラフの生成
- (CPTGraphHostingView *)makeGraph:(NSNumber *)expense Balance:(NSNumber *)balance Norma:(NSNumber *)norma{
    
    DNSLog(@"グラフ書き出し！");
    //　ホスティングビューを生成します。
    CPTGraphHostingView *hostingView = [[CPTGraphHostingView alloc]
                                        initWithFrame:CGRectMake(0, 0, 225, 250)];
    
    // グラフを生成します。
    CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame:hostingView.bounds];
    hostingView.hostedGraph = graph;
    
    // 今回は円グラフなので、グラフの軸は使用しません。
    graph.axisSet = nil;
    
    // 円グラフのインスタンスを生成します。
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    
    // 円グラフの半径を設定します。
    pieChart.pieRadius = 90.0;
    
    // データソースを設定します。
    pieChart.dataSource = self;
    
    // デリゲートを設定します。
    pieChart.delegate = self;
    
    // グラフに円グラフを追加します。
    [graph addPlot:pieChart];
    
    // グラフに表示するデータを生成します。
    self.pieChartData = [NSMutableArray arrayWithObjects:
                         [NSNumber numberWithDouble:[expense floatValue]],
                         [NSNumber numberWithDouble:[balance floatValue]],
                         [NSNumber numberWithDouble:[norma floatValue]],
                         nil];
    
    // イケメン度アップ
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient =
    [overlayGradient addColorStop :[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient =
    [overlayGradient addColorStop :[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    //ここはグラフをイケメンにしてから
    return hostingView;
}

-(CPTFill *)sliceFillForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index {
    CPTColor *color = [[CPTColor alloc] init];
    if(index == 0){
        color = [CPTColor redColor];
    }else if (index == 1){
        color = [CPTColor whiteColor];
    }else if (index == 2){
        color = [CPTColor grayColor];
    }
	return [CPTFill fillWithColor:color];
}

// グラフに使用するデータの数を返すように実装します。
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [self.pieChartData count];
}

// グラフに使用するデータの値を返すように実装します。
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    return [self.pieChartData objectAtIndex:index];
}

#pragma mark - Formatter系
// 10000 → 10,000 にするやつ
- (NSString *)addComma:(NSString *)number{
    NSNumber *value = [NSNumber numberWithInt:[number intValue]];     // 文字を数値に変換
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];  // 形式変えるアレ
    [formatter setPositiveFormat:@"#,##0"];                           // 形式の指定;
    return [formatter stringForObjectValue:value];                    // ,つけたのを返す
}

// 10,000 → 10000 にするやつ
- (NSNumber *)deleteComma:(NSString *)string{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"#,##0"];
    return [formatter numberFromString:string];
}

#pragma mark - DateFormatter系
- (NSString *)formatterDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =@"yyyy年M月d日"; // 表示を変える
    return [formatter stringFromDate:date];
}

@end
