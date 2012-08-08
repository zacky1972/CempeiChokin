//
//  MainViewController.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface MainViewController (){
    AppDelegate *appDelegate;
    Methods *_method;
    AddGraph *_graph;
    TranslateFormat *_translateFormat;

    UIView *graph;
    
    NSString *tempKind;
    
    NSInteger alertType;
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
    appDelegate = APP_DELEGATE;
    logTableView.delegate = self;
    logTableView.dataSource = self;
    _method = [Methods alloc];
    _translateFormat = [TranslateFormat alloc];
    _graph = [AddGraph alloc];
    [_method makeDataPath];
    [_method loadData];

    //スクロールビューをフィットさせる
    [LogScroll setScrollEnabled:YES];
    [LogScroll setContentSize:CGSizeMake(320,[_method fitScrollViewWithCount:[appDelegate.editLog.log count]])];
}

- (void)viewDidAppear:(BOOL)animated{
    // 初期設定画面の表示
    if(appDelegate.editData.defaultSettings == NO){//初期設定がまだだったら，設定画面に遷移します
        [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"First"] animated:NO];
    }else{
        //期限チェック
        if([appDelegate.editData searchNext] == YES){//期限をこえてたとき
            // FIXME: 誰かまじめに書いて
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"今日は"
                                                            message:@"期限日やで！"
                                                           delegate:self
                                                  cancelButtonTitle:@"貯金しよう"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            
        }else if([_method searchLastNorma] && [[appDelegate.editData loadEnd] isEqualToDate:[NSDate date]]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"今日は"
                                                            message:@"目標日やで！"
                                                           delegate:self
                                                  cancelButtonTitle:@"貯金しよう"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    //初期設定から戻ってきた時用
    [self labelReflesh];
    NSString *temp;
    temp = [[_translateFormat formatterDateUltimate:[appDelegate.editData loadStart] addYear:NO addMonth:YES addDay:YES addHour:NO addMinute:NO addSecond:NO] stringByAppendingString:@"~"];
    temp = [temp stringByAppendingString:[_translateFormat formatterDateUltimate:[appDelegate.editData loadEnd] addYear:NO addMonth:YES addDay:YES addHour:NO addMinute:NO addSecond:NO]];
    MainNavigationBar.topItem.title = temp;
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

#pragma mark - Storyboardで画面遷移する前に呼ばれるあれ
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showOptionView"]) {
        //FIXME:ここでデータを渡すといいんじゃないか
    }else if([segue destinationViewController] == [self.storyboard instantiateViewControllerWithIdentifier:@"Deposit"]){
        // TODO: 貯金画面行くときに渡すデータ
        
    }
}



#pragma mark - 出費・収入・残高調整 関係
- (IBAction)KindSegment_click:(id)sender {
    switch (KindSegment.selectedSegmentIndex) {
        case 0:
            tempKind = @"出費";
            break;
        case 1:
            tempKind = @"収入";
            break;
        case 2:
            tempKind = @"残高調整";
            break;
    }
}

- (IBAction)expenseTextField_begin:(id)sender {
    expenseTextField.inputAccessoryView =
    [self makeNumberPadToolbar:@"完了"
                          Done:@selector(doneExpenseTextField)
                        Cancel:@selector(cancelExpenseTextField)];
    CGPoint scrollPoint = CGPointMake(0.0,200.0);

    [LogScroll setContentOffset:scrollPoint animated:YES];
}

- (IBAction)expenseTextField_end:(id)sender {
    /* あとでかく
    expenseTextField.text = @"";             //テキストフィールドの値を消す
    [expenseTextField resignFirstResponder]; // NumberPad消す(=テキストフィールドを選択していない状態にする)

    [LogScroll setContentOffset:CGPointZero animated:YES];
     */
}

// Numberpadに追加したボタンの動作
-(void)doneExpenseTextField{
    // 値が入っている場合
    if([expenseTextField.text length] >= 1) {
        NSNumber *tempExpense = [_translateFormat numberFromString:expenseTextField.text];
        if([tempExpense compare:@1000000] == NSOrderedAscending){ // 100万以下なら
            // セルの個数が10個以上のとき9個に減らす
            if([appDelegate.editLog.log count] >= 10){
                [appDelegate.editLog removeObjectsCount:10];
                [logTableView reloadData];
            }
            NSNumber *tempExpense = [_translateFormat numberFromString:expenseTextField.text];
            [appDelegate.editLog saveMoneyValue:tempExpense Date:[NSDate date] Kind:tempKind];

            [appDelegate.editData calcValue:tempExpense Kind:KindSegment.selectedSegmentIndex];
            expenseTextField.text = @""; //テキストフィールドの値を消す

            [self labelReflesh];

            [LogScroll setContentSize:CGSizeMake(320,[_method fitScrollViewWithCount:[appDelegate.editLog.log count]])]; //スクロールビューをフィットさせる

            // FIXME: なんかガクッと移動して美しくない
            [LogScroll setContentOffset:CGPointMake(0.0, 45.0) animated:YES];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [logTableView insertRowsAtIndexPaths: [NSArray arrayWithObject:indexPath]
                                withRowAnimation: UITableViewRowAnimationRight];
            [self makeGraph];
        }else{ // 100万以上なら
            // FIXME: 誰かまじめに書いて //ワロタ
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"100万以上の出費とか"
                                                            message:@"お前どんだけ金持ちやねん"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"反省する", nil];
            [alert show];
            return;
        }
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

#pragma mark - アラート関係
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Deposit"] animated:NO];
}


#pragma mark - なんかよくする処理たち
- (void)makeGraph{
    NSNumber *budget = appDelegate.editData.budget;
    NSNumber *expense = appDelegate.editData.expense;
    NSNumber *balance = appDelegate.editData.balance;
    NSNumber *norma = appDelegate.editData.balance;

    if([balance compare:norma] == NSOrderedDescending){
        balance = @([balance intValue] - [norma intValue]);
    }else{
        balance = @0;
        norma = @([budget intValue] - [expense intValue]);
    }
    if(graph != NULL)
        [graph removeFromSuperview];
    graph = [_graph makeGraph:expense Balance:balance Norma:norma];
    [LogScroll addSubview:graph];
}

- (void)labelReflesh{
    BudgetLabel.text = [_translateFormat stringFromNumber:appDelegate.editData.budget addComma:YES addYen:YES];
    ExpenseLabel.text = [_translateFormat stringFromNumber:appDelegate.editData.expense addComma:YES addYen:YES];
    BalanceLabel.text = [_translateFormat stringFromNumber:appDelegate.editData.balance addComma:YES addYen:YES];
    NormaLabel.text = [_translateFormat stringFromNumber:appDelegate.editData.norma addComma:YES addYen:YES];
}

#pragma mark - UITableView関係
// セクションの数
- (NSInteger)numberOfSectionsInTableiew:(UITableView *)tableView
{
    return 1; // 1固定
}

// セルの数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return appDelegate.editLog.log.count;
}

// セルの内容を返させる
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Log";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if( [appDelegate.editLog.log count] != 0 ){
        UILabel *logDate      = (UILabel *)[cell viewWithTag:1];
        UILabel *logKind      = (UILabel *)[cell viewWithTag:2];
        UITextField *logValue = (UITextField *)[cell viewWithTag:3];
        if(appDelegate.editLog.log != nil){
            logValue.text = [_translateFormat stringFromNumber:[appDelegate.editLog loadMoneyValueAtIndex:indexPath.row] addComma:YES addYen:YES];
            logKind.text = [appDelegate.editLog loadKindAtIndex:indexPath.row];
            logDate.text = [_translateFormat formatterDate:[appDelegate.editLog loadDateAtIndex:indexPath.row]];
        }
    }
    return cell;
}

// フリックで消すやつ
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DNSLog(@"Delete At %d Row",indexPath.row);
        [_method calcDeletevalue:[appDelegate.editLog loadMoneyValueAtIndex:indexPath.row]
                            Kind:[appDelegate.editLog loadKindAtIndex:indexPath.row]];

        [appDelegate.editLog reviveToLog]; // お墓から生き返らせる
        [tableView reloadData]; // 生き返ったのを反映させる
        [appDelegate.editLog deleteLogAtIndex:indexPath.row];

        [self labelReflesh];
        
        //グラフの更新
        [self makeGraph];

        // アニメーション
		[tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];

        //FIXME: なんかキモい
        [LogScroll setContentSize:CGSizeMake(320,[_method fitScrollViewWithCount:[appDelegate.editLog.log count]])];
    }
}

//選択解除
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

@end
