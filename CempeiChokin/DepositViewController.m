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

    // TODO: 棒グラフの生成
    
}

- (void)viewDidUnload
{
    depositTextField = nil;
    depositTableView = nil;
    DoneButton = nil;
    barGraphView = nil;
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
    NSString *temp;
    temp = [[_translateFormat formatterDate:[appDelegate.editData loadStart]] stringByAppendingString:@"~"];
    temp = [temp stringByAppendingString:[_translateFormat formatterDate:[appDelegate.editData loadEnd]]];
    return temp;
}
//フッターを決定する

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    NSString *temp;
    temp = [_translateFormat stringFromNumber:appDelegate.editData.deposit addComma:1 addYen:1];
    temp = [@"貯金総額は" stringByAppendingString:temp];
    temp = [temp stringByAppendingString:@"です"];
    return temp;
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
    DNSLog(@"depositValue:%@",depositValue);
    [appDelegate.editData saveDepositDate:[appDelegate.editData loadEnd] Value:depositValue]; //とりあえず値を保存
    
    if ([appDelegate.editData searchFinish] == YES) {
        DNSLog(@"達成したよ");
        [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FinishView_complete"] animated:YES];
    }else if ([appDelegate.editData searchLastNorma] == YES) {
        DNSLog(@"期限切れましたけど…");
        [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FinishView_miss"] animated:YES];
    }else{
        DNSLog(@"そして貯金へ……");
    }
    appDelegate.editData.didDeposit = YES;   //次の期間と予算の設定しました
}
// 後で貯金入力するときの動作 // TODO: あとでやります・・・
/*
- (IBAction)DoneButton2_down:(id)sender {
    DNSLog(@"完了きたで！");
    DNSLog(@"depositValue:%@",depositValue);
    [appDelegate.editData saveDepositDate:[ここで前回の期間のEndを入れるようにする] Value:depositValue]; //とりあえず値を保存

    if ([appDelegate.editData searchFinish] == YES) {
        DNSLog(@"達成したよ");
        [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FinishView_complete"] animated:YES];
    }else if ([appDelegate.editData searchLastNorma] == YES) {
        DNSLog(@"期限切れましたけど…");
        [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FinishView_miss"] animated:YES];
    }else{
        DNSLog(@"そして貯金へ……");
    }
}*/

- (IBAction)laterButton_down:(id)sender {
    [appDelegate.editData skipDepositDate:[appDelegate.editData loadEnd]];
    appDelegate.editData.didDeposit = NO;   //次の期間と予算の設定してない
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
