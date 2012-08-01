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
    
    //スクロールビューをフィットさせる
    [LogScroll setScrollEnabled:YES];
    [LogScroll setContentSize:CGSizeMake(320,[_method fitScrollView])];
    
    [LogScroll addSubview:[_method makeGraph:@40 Balance:@40 Norma:@10]];
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
    UILabel *logDate      = (UILabel *)[cell viewWithTag:1];
    UILabel *logKind      = (UILabel *)[cell viewWithTag:2];
    UITextField *logValue = (UITextField *)[cell viewWithTag:3];
    if([_method loadMoneyValue:0] != NULL){
    logDate.text = [_method loadMoneyValue:0];
    logKind.text = [_method loadKind:0];
    logValue.text = [_method loadDate:0];
    }
    return cell;
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
    [logTableView reloadData];
    [expenseTextField resignFirstResponder]; // NumberPad消す
}

// Numberpadに追加したキャンセルボタンの動作
-(void)cancelNumberPad{

    [expenseTextField resignFirstResponder]; // NumberPad消す(=テキストフィールドを選択していない状態にする)
}

@end
