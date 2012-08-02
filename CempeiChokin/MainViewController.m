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
    AddGraph *_graph;
    TranslateFormat *_translateFormat;
    
    NSString *tempKind;
}

@end

@implementation MainViewController

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
    logTableView.delegate = self;
    logTableView.dataSource = self;
    
    _method = [Methods alloc];
    [_method makeDataPath];
    [_method loadData];
    
    //値の設定
    BudgetLabel.text = [_method loadBudget];
    ExpenseLabel.text = @"";
    BalanceLabel.text = @"";
    NormaLabel.text = @"";
    tempKind = @"出費";
    
    //スクロールビューをフィットさせる
    [LogScroll setScrollEnabled:YES];
    [LogScroll setContentSize:CGSizeMake(320,[_method fitScrollView])];
    
    _graph = [AddGraph alloc];
    [LogScroll addSubview:[_graph makeGraph:@40 Balance:@40 Norma:@10]];
}

- (void)viewDidAppear:(BOOL)animated{
    // 初期設定画面の表示
    if([_method searchGoal] == 0){//初期設定がまだだったら，設定画面に遷移します
        [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"First"] animated:YES];
    }
}

- (void)viewDidUnload
{
    expenseTextField = nil;
    BudgetLabel = nil;
    ExpenseLabel = nil;
    BalanceLabel = nil;
    NormaLabel = nil;
    logTableView = nil;
    KindSegment = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    // TODO:ここに円グラフの描画やら，値のセットが必要．その前にログを表示できるようにせなあかんですな
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView関係
- (NSInteger)numberOfSectionsInTableiew:(UITableView *)tableView
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
    if( [_method loadLog] != 0 ){
        UILabel *logDate      = (UILabel *)[cell viewWithTag:1];
        UILabel *logKind      = (UILabel *)[cell viewWithTag:2];
        UITextField *logValue = (UITextField *)[cell viewWithTag:3];
        if([_method loadMoneyValue:0] != NULL){
            logValue.text = [_method loadMoneyValue:0];
            logKind.text = [_method loadKind:0];
            logDate.text = [_method loadDate:0];
            [LogScroll setContentSize:CGSizeMake(320,[_method fitScrollView])];//スクロールビューをフィットさせる
        }
    }
    return cell;
}

//なんかフリックで消したかった
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    DNSLog(@"%d",indexPath.row);
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [_method deleteLog:indexPath.row];
        DNSLog(@"イマココ");
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
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

- (IBAction)KindSegment_click:(id)sender {
    switch (KindSegment.selectedSegmentIndex) {
        case 0:
            tempKind = @"出費";
            break;
        case 1:
            tempKind = @"収入";
            break;
        case 2:
            tempKind = @"調整";
            break;
    }
}

// Numberpadに追加したボタンの動作
-(void)doneNumberPad{
    // 値が入っている場合
    if([expenseTextField.text length] >= 1) {
        expenseTextField.text = [NSString stringWithFormat:@"%@円",[_translateFormat addComma:expenseTextField.text]]; // 表示変える
        [_method saveMoneyValue:expenseTextField.text Date:[_translateFormat formatterDate:[NSDate date]] Kind:tempKind];
        [expenseTextField resignFirstResponder];  // NumberPad消す
        [expenseTextField becomeFirstResponder]; // PeriodTextFieldに移動
    }
    [logTableView reloadData];
    [expenseTextField resignFirstResponder]; // NumberPad消す
}

// Numberpadに追加したキャンセルボタンの動作
-(void)cancelNumberPad{

    [expenseTextField resignFirstResponder]; // NumberPad消す(=テキストフィールドを選択していない状態にする)
}

@end
