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

    UIView *graph;

    NSNumber *budget;
    NSNumber *expense;
    NSNumber *balance;
    NSNumber *norma;
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
    _translateFormat = [TranslateFormat alloc];
    _graph = [AddGraph alloc];
    
    [_method makeDataPath];
    [_method loadData];
    
    //スクロールビューをフィットさせる
    [LogScroll setScrollEnabled:YES];
    [LogScroll setContentSize:CGSizeMake(320,[_method fitScrollView])];
    
}

- (void)viewDidAppear:(BOOL)animated{
    // 初期設定画面の表示
    if([_method searchGoal] == 0){//初期設定がまだだったら，設定画面に遷移します
        [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"First"] animated:YES];
    }else{
        //期限チェック
        if([_method searchNext] == YES){//期限をこえてたとき
            [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Deposit"] animated:NO];
        }
    }
    //初期設定から戻ってきた時用
    budget = [_method loadBudget];   // 予算
    expense = [_method loadExpense]; // 出費
    balance = [_method loadBalance]; // 残り
    norma = [_method loadNorma];     // ノルマ
    
    NSString *temp;
    temp = [[_translateFormat formatterDateUltimate:[_method loadStart] addYear:NO addMonth:YES addDay:YES addHour:NO addMinute:NO addSecond:NO] stringByAppendingString:@"~"];
    temp = [temp stringByAppendingString:[_translateFormat formatterDateUltimate:[_method loadEnd] addYear:NO addMonth:YES addDay:YES addHour:NO addMinute:NO addSecond:NO]];
    MainNavigationBar.topItem.title = temp;
    BudgetLabel.text = [_translateFormat stringFromNumber:budget addComma:YES addYen:YES];
    ExpenseLabel.text = [_translateFormat stringFromNumber:expense addComma:YES addYen:YES];
    BalanceLabel.text = [_translateFormat stringFromNumber:balance addComma:YES addYen:YES];
    NormaLabel.text = [_translateFormat stringFromNumber:norma addComma:YES addYen:YES];
    tempKind = @"出費";

    [self makeGraph];
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
    MainNavigationBar = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
#pragma mark - なんかよくする処理たち
- (void)makeGraph{
    if(graph != NULL)
        [graph removeFromSuperview];
    
    if([balance compare:norma] == NSOrderedDescending){
        balance = @([balance intValue] - [norma intValue]);
    }else{
        balance = @0;
        norma = @([budget intValue] - [expense intValue]);
    }
    graph = [_graph makeGraph:expense Balance:balance Norma:norma];
    
    [LogScroll addSubview:graph];
}

#pragma mark - UITableView関係
- (NSInteger)numberOfSectionsInTableiew:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [_method loadLog];
    if(count >= 10)
        count = 10;
    DNSLog(@"Number of Rows : %d",count);
    return count;
}

// セルの内容を返させる
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
            logValue.text = [_translateFormat stringFromNumber:[_method loadMoneyValue:indexPath.row] addComma:YES addYen:YES];
            logKind.text = [_method loadKind:indexPath.row];
            logDate.text = [_translateFormat formatterDate:[_method loadDate:indexPath.row]];
        }
    }
    return cell;
}

//なんかフリックで消したかった
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DNSLog(@"Delete At %d Row",indexPath.row);
        // TODO: 消したのに応じて予算とか計算し直さんとあかんな
        
        [_method deleteLog:indexPath.row];
        //ラベルの更新
        budget = [_method loadBudget];
        expense = [_method loadExpense];
        balance = [_method loadBalance];
        norma = [_method loadNorma];
        BudgetLabel.text = [_translateFormat stringFromNumber:budget addComma:YES addYen:YES];
        ExpenseLabel.text = [_translateFormat stringFromNumber:expense addComma:YES addYen:YES];
        BalanceLabel.text = [_translateFormat stringFromNumber:balance addComma:YES addYen:YES];
        NormaLabel.text = [_translateFormat stringFromNumber:norma addComma:YES addYen:YES];
        //グラフの更新
        
        [self makeGraph];
        
        // アニメーションさせたら落ちる
		// [tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
        [tableView reloadData];
        [LogScroll setContentSize:CGSizeMake(320,[_method fitScrollView])];
    }
}

//選択解除
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 出費・収入・残高調整 関係
- (IBAction)expenseTextField_begin:(id)sender {
    expenseTextField.inputAccessoryView =
    [self makeNumberPadToolbar:@"完了"
                          Done:@selector(doneExpenseTextField)
                        Cancel:@selector(cancelExpenseTextField)];
    
    CGPoint scrollPoint = CGPointMake(0.0,200.0);
    [LogScroll setContentOffset:scrollPoint animated:YES];
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

//ログのテキストフィールドを編集しようとしたとき
- (IBAction)valueTextField_begin:(id)sender {
//TODOログを選択したときのスクロールとか実装したいな
}

// Numberpadに追加したボタンの動作
-(void)doneExpenseTextField{
    // 値が入っている場合
    if([expenseTextField.text length] >= 1) {
        NSNumber *tempExpense = [_translateFormat numberFromString:expenseTextField.text];
        [_method saveMoneyValue:tempExpense Date:[NSDate date] Kind:tempKind];
        [_method calcvalue:tempExpense Kind:KindSegment.selectedSegmentIndex];
        expenseTextField.text = @""; //テキストフィールドの値を消す
        
        budget = [_method loadBudget];
        expense = [_method loadExpense];
        balance = [_method loadBalance];

        BudgetLabel.text = [_translateFormat stringFromNumber:budget addComma:YES addYen:YES];
        ExpenseLabel.text = [_translateFormat stringFromNumber:expense addComma:YES addYen:YES];
        BalanceLabel.text = [_translateFormat stringFromNumber:balance addComma:YES addYen:YES];

        [logTableView reloadData];               // TableViewをリロード

        [self makeGraph];

        [LogScroll setContentSize:CGSizeMake(320,[_method fitScrollView])]; //スクロールビューをフィットさせる
        CGPoint scrollPoint = CGPointMake(0.0,45.0);
        [LogScroll setContentOffset:scrollPoint animated:YES];
    }else{
        [LogScroll setContentOffset:CGPointZero animated:YES];
    }
    [expenseTextField resignFirstResponder]; // NumberPad消す
}

// Numberpadに追加したキャンセルボタンの動作
-(void)cancelExpenseTextField{
    expenseTextField.text = @""; //テキストフィールドの値を消す
    [expenseTextField resignFirstResponder]; // NumberPad消す(=テキストフィールドを選択していない状態にする)
    
    [LogScroll setContentOffset:CGPointZero animated:YES];

}

#pragma mark - その他
- (UIToolbar *)makeNumberPadToolbar:(NSString *)string Done:(SEL)done Cancel:(SEL)cancel{
    // Toolbarつくる
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;

    // Toolbarのボタンたち
    UIBarButtonItem *doneButton =
    [[UIBarButtonItem alloc] initWithTitle: string
                                     style: UIBarButtonItemStyleDone
                                    target: self
                                    action: done];
    UIBarButtonItem *cancelButton =
    [[UIBarButtonItem alloc] initWithTitle: @"キャンセル"
                                     style: UIBarButtonItemStyleBordered
                                    target: self
                                    action: cancel];

    UIBarButtonItem *frexibleSpace =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                  target: nil
                                                  action: nil];
    numberToolbar.items = @[cancelButton,frexibleSpace,doneButton];
    [numberToolbar sizeToFit];
    return numberToolbar;
}

//完了を押したときの動作
- (IBAction)End_down:(id)sender {
    [expenseTextField resignFirstResponder];
}


@end
