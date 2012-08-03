//
//  DepositViewController.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import "DepositViewController.h"

@interface DepositViewController (){
    Methods *_method;
    TranslateFormat *_translateFormat;
    
    NSNumber *depositValue; // 貯金額
}

@end

@implementation DepositViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _method = [Methods alloc];
    _translateFormat = [TranslateFormat alloc];
    
    [_method makeDataPath];
    [_method loadData];
    
    [self makeNumberPadToolbar:depositTextField Return:@"完了"
                          Done:@selector(doneDepositTextField)
                        Cancel:@selector(cancelDepostiTextField)];
}

- (void)viewDidUnload
{
    depositTextField = nil;
    depositTableView = nil;
    [super viewDidUnload];

}

//タイトルを決定する
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *temp;
    temp = [[_translateFormat formatterDate:[_method loadStart]] stringByAppendingString:@"~"];
    temp = [temp stringByAppendingString:[_translateFormat formatterDate:[_method loadEnd]]];
    return temp;
}
//フッターを決定する
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    NSString *temp;
    temp = [_translateFormat stringFromNumber:[_method loadDeposit] addComma:1 addYen:1];
    temp = [@"貯金総額は" stringByAppendingString:temp];
    temp = [temp stringByAppendingString:@"です"];
    return temp;
}
//選択解除
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - depositTextField関係
- (IBAction)depositTextField_begin:(id)sender {
    // 既に値が入力されていた場合，表示されている値を数値に戻す
    if(depositValue != NULL)
        depositTextField.text = [NSString stringWithFormat:@"%@",depositValue];
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
- (IBAction)doneButton:(id)sender {
    // TODO: ここに保存する処理書いてね
    [_method saveDeposit:depositValue];
}

- (IBAction)laterButton:(id)sender {
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
