//
//  MainViewController.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController (){
    Methods *_method;
}

@end

@implementation MainViewController

@synthesize pieChartData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _method = [Methods alloc];
    [_method makeDataPath];
    [_method loadData];
    
    [_method setData];
    
    BudgetLabel.text = [_method loadBudget];
    ExpensesLabel.text = @"0円";
    BalanceLabel.text = @"0円";
    QuotaLabel.text = @"0円";
    
    [_method loadLog];
    [_method fitScrollView];
    [_method makeGraph];
    
    [LogScroll setScrollEnabled:YES];
    [LogScroll setContentSize:CGSizeMake(320, 900)];
    
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
                         [NSNumber numberWithDouble:40.0],
                         [NSNumber numberWithDouble:30.0],
                         [NSNumber numberWithDouble:20.0],
                         nil];
    
    // イケメン度アップ
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient =
    [overlayGradient addColorStop :[[CPTColor blackColor] colorWithAlphaComponent:0.0] atPosition:0.9];
    overlayGradient =
    [overlayGradient addColorStop :[[CPTColor blackColor] colorWithAlphaComponent:0.4] atPosition:1.0];
    pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    
    // 画面にホスティングビューを追加します。
    [LogScroll addSubview:hostingView];
	// Do any additional setup after loading the view.
    
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


- (void)viewDidAppear:(BOOL)animated{
    // 初期設定画面の表示
    if([_method searchGoal] == 0){//初期設定がまだだったら，設定画面に遷移します
    [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Init"] animated:YES];
    }
}

- (void)viewDidUnload
{
    BudgetLabel = nil;
    ExpensesLabel = nil;
    BalanceLabel = nil;
    QuotaLabel = nil;
    KindSegment = nil;
    MoneyValueLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    // TODO:ここに円グラフの描画やら，値のセットが必要．その前にログを表示できるようにせなあかんですな
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView関係
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // TODO: とりあえず一個
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DNSLog(@"Cell for Row :%d",indexPath.row);
    static NSString *CellIdentifier = @"Log";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *logDate      = (UILabel *)[cell viewWithTag:1];
    UILabel *logKind      = (UILabel *)[cell viewWithTag:2];
    UITextField *logValue = (UITextField *)[cell viewWithTag:3];
    
    logDate.text = @"いつだよ！";
    logKind.text = @"出費だよ！";
    logValue.text = @"100円だよ！";
    
    return cell;
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

- (IBAction)expenseTextField_begin:(id)sender {
    // Toolbarつくる
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    
    // Toolbarのボタンたち
    UIBarButtonItem *done =
    [[UIBarButtonItem alloc] initWithTitle: @"次へ"
                                     style: UIBarButtonItemStyleDone
                                    target:self
                                    action:@selector(doneNumberPad)];
    UIBarButtonItem *cancel =
    [[UIBarButtonItem alloc] initWithTitle: @"キャンセル"
                                     style: UIBarButtonItemStyleBordered
                                    target: self
                                    action: @selector(cancelNumberPad)];
    UIBarButtonItem *frexibleSpace =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                  target: nil
                                                  action: nil];
    numberToolbar.items = @[cancel,frexibleSpace,done]; // ツールバーにのせる (キャンセル| [スペース] | 完了)
    [numberToolbar sizeToFit];                          // なんかフィットさせる
    expenseTextField.inputAccessoryView = numberToolbar;  // キーボードの上につけるときはこれ使うのかな？
    // TODO: Numberpad表示させてる時に期日のところ押したらなんかバグるからいつかどうにかしよう
}

// Numberpadに追加したボタンの動作
-(void)doneNumberPad{
    // 値が入っている場合
    if([expenseTextField.text length] >= 1) {
        expenseTextField.text = [NSString stringWithFormat:@"%@円",[_method addComma:expenseTextField.text]]; // 表示変える
        [_method saveMoneyValue:expenseTextField.text Date:[[NSDate date] description] Kind:@"出費"];
        [expenseTextField resignFirstResponder];  // NumberPad消す
        [expenseTextField becomeFirstResponder]; // PeriodTextFieldに移動
    }
    [expenseTextField resignFirstResponder]; // NumberPad消す
}

// Numberpadに追加したキャンセルボタンの動作
-(void)cancelNumberPad{

    [expenseTextField resignFirstResponder]; // NumberPad消す(=テキストフィールドを選択していない状態にする)
}

@end
