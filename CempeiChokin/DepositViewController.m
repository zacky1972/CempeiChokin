//
//  DepositViewController.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import "AppDelegate.h"
#import "DepositViewController.h"
#import "AppDelegate.h"

@interface DepositViewController (){
    AppDelegate *appDelegate;
    Methods *_method;
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
    _method = [Methods alloc];
    _translateFormat = [TranslateFormat alloc];
        
    [self makeNumberPadToolbar:depositTextField Return:@"完了"
                          Done:@selector(doneDepositTextField)
                        Cancel:@selector(cancelDepostiTextField)];
    
    if(depositValue == NULL){
        DoneButton.enabled = NO;
    }
}

- (void)viewDidUnload
{
    depositTextField = nil;
    depositTableView = nil;
    DoneButton = nil;
    [super viewDidUnload];

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
    temp = [_translateFormat stringFromNumber:[appDelegate.editData loadDepositValue] addComma:1 addYen:1];
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
    if(depositValue != NULL){
        DoneButton.enabled = YES;
    }
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
    // 既に値が入っていた場合
    if(depositValue != NULL)
        depositTextField.text = [_translateFormat stringFromNumber:depositValue addComma:YES addYen:YES]; // 元に戻す
    // そうでもなかった場合
    else
        depositTextField.text = @"";         // 値を消す
    [depositTextField resignFirstResponder]; // NumberPad消す(=テキストフィールドを選択していない状態にする)
}

#pragma mark - ボタンたち
- (IBAction)DoneButton_down:(id)sender {
    DNSLog(@"完了きたで！");
    DNSLog(@"depositValue:%@",depositValue);
    [appDelegate.editData saveDepositDate:[appDelegate.editData loadEnd] Value:depositValue];
    if ([appDelegate.editData searchFinish] == YES) {
        DNSLog(@"達成したよ");
    }
    /*
    if([_method searchFinish] == YES){//終了！
        DNSLog(@"達成したよ");
        [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FinishView_complete"] animated:YES];
    }else if ([appDelegate.editData searchLastNorma] == YES){
        DNSLog(@"期限きれんたんですけど");
        [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FinishView_miss"] animated:YES];
    }else{
        //まだ終わらないよ！
    }*/
}

- (IBAction)laterButton_down:(id)sender {
    // ???: ここはどうすんの？
    
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
