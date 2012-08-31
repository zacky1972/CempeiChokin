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
    
    NSInteger alertType;
    NSTimer *timeLimitCheckTimer;
    BOOL didAlert;
    
    SystemSoundID soundID; // 効果音用
}

@end

@implementation MainViewController

- (void)viewDidLoad{
    [super viewDidLoad];

    // データソース・デリゲート
    logTableView.dataSource = self;
    logTableView.delegate = self;

    // メソッド
    appDelegate = APP_DELEGATE;
    _method = [Methods alloc];
    _translateFormat = [TranslateFormat alloc];
    _graph = [AddGraph alloc];

    timeLimitCheckTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeLimitChecker) userInfo:nil repeats:YES];
    
    //スクロールビューをフィットさせる
    [LogScroll setScrollEnabled:YES];
    [LogScroll setContentSize:CGSizeMake(320,[_method fitScrollViewWithCount:[appDelegate.editLog.log count]])];
    
    //効果音のセット
    NSString *path = [[NSBundle mainBundle]pathForResource:@"se_click" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);

}

- (void)viewWillAppear:(BOOL)animated{
    DNSLog(@"viewWillAppear");
    
    [self timeLimitChecker];
    
    [self labelReflesh];
    [self depositAndNextChecker];
    [self makeGraphChecker];
    [timeLimitCheckTimer fire];
}

- (void)viewDidAppear:(BOOL)animated{
    DNSLog(@"viewDidAppear");

    // 初期設定画面の表示
    if(appDelegate.editData.defaultSettings == NO){//初期設定がまだだったら，設定画面に遷移します
        [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"First"] animated:NO];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [timeLimitCheckTimer invalidate];
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
    DepositLabel = nil;
    pleaseDepositButton = nil;
    pleaseNextButton = nil;
    exclamationImageView = nil;
    questionImageView = nil;
    pushDepositImage = nil;
    pleaseNextImage = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Storyboardで画面遷移する前に呼ばれるあれ
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showOptionView"]) {
        // FIXME:ここでデータを渡すといいんじゃないか
    }else if([segue destinationViewController] == [self.storyboard instantiateViewControllerWithIdentifier:@"Deposit"]){
        // TODO: 貯金画面行くときに渡すデータ
        
    }
}

#pragma mark - 出費・収入・残高調整 関係
// ExpenseTextFieldを選択した時の動作
- (IBAction)expenseTextField_begin:(id)sender {
    // Toolbarを作成する
    expenseTextField.inputAccessoryView =
    [self makeNumberPadToolbar:@"完了"
                          Done:@selector(doneExpenseTextField)
                        Cancel:@selector(cancelExpenseTextField)];

    // 画面のスクロール
    [LogScroll setContentOffset:CGPointMake(0.0,200.0) animated:YES];   // 入力が見えるところまでスクロールする
    [LogScroll setContentSize:CGSizeMake(320,230+[_method fitScrollViewWithCount:[appDelegate.editLog.log count]])];
}
// ExpenseTextFieldの選択が外れたときの動作
- (IBAction)expenseTextField_end:(id)sender {
    /*
    [self cancelExpenseTextField]; // キャンセルボタンと同じ動作
     */
    [LogScroll setContentSize:CGSizeMake(320,[_method fitScrollViewWithCount:[appDelegate.editLog.log count]])];
}

// Numberpadに追加したボタンの動作
-(void)doneExpenseTextField{
    // 数値の処理
    if([expenseTextField.text length] >= 1) {
        // 値が入力されている場合
        NSNumber *tempExpense = [_translateFormat numberFromString:expenseTextField.text];  // tempExpenseに値を保存

        // 入力されたデータの処理
        if(KindSegment.selectedSegmentIndex == 2 && [tempExpense compare:appDelegate.editData.budget] == NSOrderedDescending){
            // 残高調整で予算以上になる場合
            // 100万以下の場合 // TODO: なんか書き方がアレかな
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"入力エラー"
                                                                   message:@"残高が予算を超えています"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
            [errorAlert show];   // アラートを表示
        }else if([tempExpense compare:@1000000] == NSOrderedAscending){
            // ログの数を調整
            if([appDelegate.editLog.log count] >= 10){
                // セルの個数が10個以上の場合
                [appDelegate.editLog removeObjectsCount:10]; // 10個未満に減らす
                [logTableView reloadData];                   // LogTableViewの更新
            }
            // データの処理
            [appDelegate.editLog saveMoneyValue:tempExpense Date:[NSDate date] Kind:KindSegment.selectedSegmentIndex];  // Logにデータを追加
            [appDelegate.editData calcValue:tempExpense Kind:KindSegment.selectedSegmentIndex]; // 数値の再計算

            // 表示の処理
            expenseTextField.text = @"";    // テキストフィールドの値を消す
            [self labelReflesh];            // 数値の更新
            [self makeGraphChecker];
            //[self makeGraph];               // グラフの更新
            [expenseTextField resignFirstResponder]; // NumberPad消す
            [LogScroll setContentSize:CGSizeMake(320,[_method fitScrollViewWithCount:[appDelegate.editLog.log count]])];    // LogScrollのサイズ調整
            [LogScroll setContentOffset:CGPointMake(0.0, 45.0) animated:YES];   // 一個目のセルまでスクロール
            
            //効果音の処理
            AudioServicesPlaySystemSound(soundID);
            
            // アニメーションの処理
            [logTableView insertRowsAtIndexPaths: [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]]
                                withRowAnimation: UITableViewRowAnimationRight]; // 一個目のセルにアニメーションさせてセルを追加
        }else{
            // 100万以上の場合
            // アラートの表示 // FIXME: 誰かまじめに書いて
            UIAlertView *expenseAlert = [[UIAlertView alloc] initWithTitle:@"100万以上の出費とか"
                                                            message:@"お前どんだけ金持ちやねん"
                                                           delegate:nil
                                                  cancelButtonTitle:@"反省する"
                                                  otherButtonTitles:nil];
            [expenseAlert show];   // アラートを表示
        }
    }else{
        // 値が入力されていない場合
        [expenseTextField resignFirstResponder]; // NumberPad消す
        [LogScroll setContentOffset:CGPointZero animated:YES];  // 画面を一番上に移動
    }
}
// Numberpadに追加したキャンセルボタンの動作
-(void)cancelExpenseTextField{
    expenseTextField.text = @""; //テキストフィールドの値を消す
    [expenseTextField resignFirstResponder]; // NumberPad消す(=テキストフィールドを選択していない状態にする)
    
    [LogScroll setContentOffset:CGPointZero animated:YES]; // 一番上に移動する
}

#pragma mark - UIAlertView関係
// アラートビューのボタンの動作
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    appDelegate.editData.didDeposit= NO;
    appDelegate.editData.didSetPeriod = NO;
    appDelegate.editData.skipDeposit = NO;
    appDelegate.editData.nextAlert = NO;
    [appDelegate.editLog deleteLogData];
    [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Deposit"] animated:NO]; // 貯金画面へ移動する
}

#pragma mark - 催促ボタン関係
- (void)depositAndNextChecker{
    //一度催促後，貯金をしたかどうか，と次の期間の設定をしたかどうかをチェックして，まだなら催促ボタンを表示する
    if (appDelegate.editData.didDeposit == YES){ pleaseDepositButton.hidden = YES;
        pushDepositImage.hidden = YES;
    }else{
        pleaseDepositButton.hidden = NO;
        pushDepositImage.hidden = NO;
    }
    if (appDelegate.editData.didSetPeriod == YES) {
        pleaseNextButton.hidden = YES;
        pleaseNextImage.hidden = YES;
    }else{
        pleaseNextButton.hidden = NO;
        pleaseNextImage.hidden = NO;
    }
}

- (IBAction)pleaseDepositButton_down:(id)sender {
    [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Deposit"] animated:YES]; // 貯金画面へ移動する
}

- (IBAction)pleaseNextBtton_down:(id)sender {
    
    [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"NextBudget"] animated:YES]; // 貯金画面へ移動する
    //次の期間の設定へ
}

#pragma mark - よく使う処理
- (void)makeGraphChecker{
    if (appDelegate.editData.didDeposit == YES && appDelegate.editData.didSetPeriod == YES){
        [self makeGraph];
        questionImageView.hidden = YES;
    }
    else questionImageView.hidden = NO;
}

// グラフの表示
- (void)makeGraph{
    // 計算用に数値を確保
    NSNumber *budget = appDelegate.editData.budget;
    NSNumber *expense = appDelegate.editData.expense;
    NSNumber *balance = appDelegate.editData.balance;
    NSNumber *norma = appDelegate.editData.norma;

    // グラフに渡す値の計算
    if([balance compare:norma] == NSOrderedDescending){
        // (残金)＞(ノルマ) の時
        balance = @([balance intValue] - [norma intValue]); // 残金 - ノルマ
    
        // グラフの表示
        if(graph != NULL){
            // グラフが既に存在していた時
            [graph removeFromSuperview]; // グラフを消去する
        }
        graph = [_graph makeGraph:expense Balance:balance Norma:norma]; // グラフを生成
        [LogScroll addSubview:graph];                                   // LogScrollにグラフを表示させる
        exclamationImageView.hidden = YES;
    }else{
        // (残金)≦(ノルマ) の時
        if ([balance intValue] <= 0) {//残金が0以下のとき
            [graph removeFromSuperview]; // グラフを消去する
            exclamationImageView.hidden = NO;
        }else{
            
            balance = @0;                                       // 残金を 0
            norma = @([budget intValue] - [expense intValue]);  // 残りを全部ノルマに
            // グラフの表示
            if(graph != NULL){
                // グラフが既に存在していた時
                [graph removeFromSuperview]; // グラフを消去する
            }
            graph = [_graph makeGraph:expense Balance:balance Norma:norma]; // グラフを生成
            [LogScroll addSubview:graph];                                   // LogScrollにグラフを表示させる
            exclamationImageView.hidden = YES;
        }
    }
}

// ラベルの更新
- (void)labelReflesh{
    NSString *temp;
    
    if(appDelegate.editData.didSetPeriod == YES){
        BudgetLabel.text = [_translateFormat stringFromNumber:appDelegate.editData.budget addComma:YES addYen:YES];
        ExpenseLabel.text = [_translateFormat stringFromNumber:appDelegate.editData.expense addComma:YES addYen:YES];
        BalanceLabel.text = [_translateFormat stringFromNumber:appDelegate.editData.balance addComma:YES addYen:YES];
        
        temp = [NSString stringWithFormat:@"%@~%@",
                [_translateFormat formatterDateUltimate:[appDelegate.editData loadStart]
                                                addYear:NO addMonth:YES addDay:YES
                                                addHour:NO addMinute:NO addSecond:NO],
                [_translateFormat formatterDateUltimate:[appDelegate.editData loadEnd]
                                                addYear:NO addMonth:YES addDay:YES
                                                addHour:NO addMinute:NO addSecond:NO]];
    }else{
        BudgetLabel.text = @"??????";
        ExpenseLabel.text = @"??????";
        BalanceLabel.text = @"??????";

        temp = @"??月??日~??月??日";
    }
    MainNavigationBar.topItem.title = temp;

    if(appDelegate.editData.didDeposit == YES){
        DepositLabel.text = [_translateFormat stringFromNumber:appDelegate.editData.deposit addComma:YES addYen:YES];
    }else{
        DepositLabel.text = @"??????";
    }
    if(appDelegate.editData.didDeposit == YES && appDelegate.editData.didSetPeriod == YES){
        NormaLabel.text = [_translateFormat stringFromNumber:appDelegate.editData.norma addComma:YES addYen:YES];
    }else{
        NormaLabel.text = @"??????";
    }
}

// 期限チェック
- (void)timeLimitChecker{
    DNSLog(@"期限のチェック");
    //期限をこえてたとき
    if([appDelegate.editData searchNext] == YES){
        DNSLog(@"期限のチェック2");
        [timeLimitCheckTimer invalidate];
        if(appDelegate.editData.nextAlert == NO){
            DNSLog(@"期限のチェック3");
            appDelegate.editData.nextAlert = YES;
            if([appDelegate.editData searchLastNorma] == YES){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"目標日を過ぎました"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"貯金する"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"期限日を過ぎました"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"貯金する"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }
}


#pragma mark - UITableView関係
// セクションの数を返させる
- (NSInteger)numberOfSectionsInTableiew:(UITableView *)tableView{
    return 1; // 1固定
}
// セルの数を返させる(必須)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return appDelegate.editLog.log.count; // ログの数
}
// セルの内容を返させる(必須)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // セルの生成
    static NSString *CellIdentifier = @"Log";                                               // 利用するセルのidentifierを指定
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];   // セルを再利用するために必要

    // セルの中身を返す
    if( [appDelegate.editLog.log count] != 0 ){
        // 1つ以上セルが存在していた場合
        UILabel *logDate      = (UILabel *)[cell viewWithTag:1];        // セルのパーツを選択する
        UILabel *logKind      = (UILabel *)[cell viewWithTag:2];        // 〃
        UITextField *logValue = (UITextField *)[cell viewWithTag:3];    // 〃

        if(appDelegate.editLog.log != nil){
            // ログが存在して場合
            logDate.text = [_translateFormat formatterDate:[appDelegate.editLog loadDateAtIndex:indexPath.row]];
            logKind.text = [appDelegate.editLog loadKindAtIndex:indexPath.row];
            logValue.text = [_translateFormat stringFromNumber:[appDelegate.editLog loadMoneyValueAtIndex:indexPath.row] addComma:YES addYen:YES];
        }
    }
    
    return cell;
}
// セルの編集・削除時の動作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    // 削除する場合
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 出費，残金，予算の再計算
        [appDelegate.editData calcDeleteValue:[appDelegate.editLog loadMoneyValueAtIndex:indexPath.row]
                            Kind:[appDelegate.editLog loadKindAtIndex:indexPath.row]];
        // ログの消去
        [appDelegate.editLog reviveToLog];                      // お墓から生き返らせる
        [tableView reloadData];                                 // 生き返ったのを反映させる
        [appDelegate.editLog deleteLogAtIndex:indexPath.row];   // ログを削除する
        [self labelReflesh];
        // グラフの更新
        [self makeGraphChecker];
        //[self makeGraph];
        // セルを削除するアニメーションの実行
		[tableView deleteRowsAtIndexPaths: [NSArray arrayWithObject:indexPath] withRowAnimation: UITableViewRowAnimationFade];
        // LogScrollのサイズを再計算 // FIXME: 一個目とかのせる消した時にガクってなる
        [LogScroll setContentSize:CGSizeMake(320,[_method fitScrollViewWithCount:[appDelegate.editLog.log count]])];
    }
}
// セルが選択された時の動作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // TODO: ログの数値を変更する動作を書く
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; // 選択解除
}

#pragma mark - その他
// NumberPadにつけるToolbarを生成する
- (UIToolbar *)makeNumberPadToolbar:(NSString *)string Done:(SEL)done Cancel:(SEL)cancel{
    // Toolbarを確保する
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    
    // Toolbarのボタンの生成
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

    numberToolbar.items = @[cancelButton,frexibleSpace,doneButton]; // Toolbarにボタンをのせる

    return numberToolbar;
}

@end
