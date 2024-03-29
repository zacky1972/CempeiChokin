//
//  DepositViewController.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import "AppDelegate.h"
#import "DepositViewController.h"

@interface DepositViewController (){
    AppDelegate *appDelegate;

    TranslateFormat *_translateFormat;
    
    NSNumber *depositValue; // 貯金額
    NSInteger alertType;
}

@end

@implementation DepositViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = APP_DELEGATE;
    _translateFormat = [TranslateFormat alloc];
        
    [self makeNumberPadToolbar:depositTextField Return:@"完了"
                          Done:@selector(doneDepositTextField)
                        Cancel:@selector(cancelDepositTextField)];
    [self dataCheck];

    // 後でボタンは最後の時
    if([appDelegate.editData searchLastNorma] == YES){
        LaterButton.enabled = NO;
        LaterButton.alpha = 0.0;
    }else{
        LaterButton.enabled = YES;
        LaterButton.alpha = 1;
    }

    [self setLabel];
    // TODO: 棒グラフの生成
}

- (void)viewDidUnload
{
    depositTextField = nil;
    depositTableView = nil;
    DoneButton = nil;
    barGraphView = nil;
    balanceLabel = nil;
    depositLabel = nil;
    LaterButton = nil;
    [super viewDidUnload];

}

#pragma mark - よく使う処理たち
- (BOOL)dataCheck{
    if(depositValue == nil){
        DoneButton.enabled = NO;
        DoneButton.alpha = 0.3;
        return NO;
    }else{
        DoneButton.enabled = YES;
        DoneButton.alpha = 1;
        return YES;
    }
}

#pragma mark - Storyboardで画面遷移する前に呼ばれるあれ
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showBudgetView_done"]) {
        //FIXME:ここでデータを渡すといいんじゃないか
    }
    if ([segue.identifier isEqualToString:@"showBudgetView_skip"]) {
        //FIXME:ここでデータを渡すといいんじゃないか
    }
}

//タイトルを決定する
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //後での時値がおかしい
    NSString *temp;
    if(appDelegate.editData.skipDeposit == NO){
        temp = [NSString stringWithFormat:@"%@~%@",[_translateFormat formatterDate:[appDelegate.editData loadStart]],[_translateFormat formatterDate:[appDelegate.editData loadEnd]]];
    }else{
        temp = [NSString stringWithFormat:@"%@~%@",[_translateFormat formatterDate:[appDelegate.editData loadStartFromRecentDepositData]],[_translateFormat formatterDate:[appDelegate.editData loadEndFromRecentDepositData]]];
    }
    return temp;
}

//フッターを決定する
- (void)setLabel{
    if(appDelegate.editData.skipDeposit == NO){
        // 普通の場合
        balanceLabel.text = [NSString stringWithFormat:@"残金は%@です。",[_translateFormat stringFromNumber:appDelegate.editData.balance addComma:YES addYen:YES]];
        depositTextField.placeholder = [_translateFormat stringFromNumber:appDelegate.editData.norma addComma:YES addYen:YES];
    }else{
        // 後での場合(前回の値を表示)
        balanceLabel.text = [NSString stringWithFormat:@"残金は%@です。",[_translateFormat stringFromNumber:[appDelegate.editData loadBalanceFromRecentDepositData] addComma:YES addYen:YES]];
        depositTextField.placeholder = [_translateFormat stringFromNumber:[appDelegate.editData loadNormaFromRecentDepositData] addComma:YES addYen:YES];
    }
    depositLabel.text = [NSString stringWithFormat:@"貯金総額は%@です。",[_translateFormat stringFromNumber:appDelegate.editData.deposit addComma:YES addYen:YES]];
}

#pragma mark - depositTextField関係
- (IBAction)depositTextField_begin:(id)sender {
    
    // 既に値が入力されていた場合，表示されている値を数値に戻す
    if(depositValue != NULL)
        depositTextField.text = [NSString stringWithFormat:@"%@",depositValue];
}

- (IBAction)depositTextField_end:(id)sender {
    [self dataCheck];
}

-(void)doneDepositTextField{
    // 値が入っている場合
    if([depositTextField.text length] >= 1) {
        depositValue = @([depositTextField.text intValue]);
        depositTextField.text = [_translateFormat stringFromNumber:depositValue addComma:YES addYen:YES]; // 表示変える
        [depositTextField resignFirstResponder];  // NumberPad消す
    }
    [depositTextField resignFirstResponder]; // NumberPad消す
}

-(void)cancelDepositTextField{
    if(depositValue != NULL){
        // 既に値が入っていた場合
        depositTextField.text = [_translateFormat stringFromNumber:depositValue addComma:YES addYen:YES]; // 元に戻す
    }else{
        // そうでもなかった場合
        depositTextField.text = @"";         // 値を消す
    }
    [depositTextField resignFirstResponder]; // NumberPad消す(=テキストフィールドを選択していない状態にする)
}

#pragma mark - ボタンたち
- (IBAction)DoneButton_down:(id)sender {
    DNSLog(@"完了きたで！");
    
    [appDelegate.editData saveDepositDate:[appDelegate.editData loadEnd] Value:depositValue]; // 貯金を保存

    // 目標日が来たかどうかの判断
    if ([appDelegate.editData searchFinish] == YES) {
        DNSLog(@"達成したよ");
        [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FinishView_complete"] animated:YES];
    }else if ([appDelegate.editData searchLastNorma] == YES) {
        DNSLog(@"期限切れましたけど…");
        [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FinishView_miss"] animated:YES];
    }else{
        DNSLog(@"そして貯金へ……");
    }
    
    appDelegate.editData.didDeposit = YES; // 貯金の設定したフラグを立てる
    [self decideNextViewController];       // 次の画面へ
}

- (IBAction)laterButton_down:(id)sender {
    [appDelegate.editData skipDepositDate:[appDelegate.editData loadEnd]]; // 貯金せずにそれまでの状態を保存する
    [self decideNextViewController];                                       // 次の画面へ
}
- (void)decideNextViewController{
    // どの画面に行くかの判断
    if (appDelegate.editData.didSetPeriod == NO){
        // 次の期間を設定していない場合
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"NextBudgetView"] animated:YES]; // 次の期間の設定へ
        [appDelegate.editData clearPreviousData]; // 前回のデータを消す
    }else{
        // 次の期間の設定が終わっていた場合
        [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"MainView"] animated:YES]; // メイン画面へ移動する
    }
}

#pragma mark - その他
- (void)makeNumberPadToolbar:(UITextField *)textField Return:(NSString *)string Done:(SEL)done Cancel:(SEL)cancel{
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
    numberToolbar.items = @[cancelButton,frexibleSpace,doneButton]; // ツールバーにのせる (キャンセル| [スペース] | 完了)
    [numberToolbar sizeToFit];                          // なんかフィットさせる
    textField.inputAccessoryView = numberToolbar;
}

@end
