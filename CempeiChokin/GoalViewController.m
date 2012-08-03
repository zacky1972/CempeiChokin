//
//  GoalViewController.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import "GoalViewController.h"
#import "Methods.h"

@interface GoalViewController (){
    @private
    Methods *_method;
    TranslateFormat *_translateFormat;
    
    // 値を保存するための変数
    NSString *name;
    NSNumber *value;
    NSDate   *period;
    
    // パーツたち
    UIActionSheet *actionSheet;
    UIDatePicker *datePicker;
}

@end

@implementation GoalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _translateFormat = [TranslateFormat alloc];
    _method = [Methods alloc];
    
    [_method initData];
    if([_method loadName]!=nil){
        name = [_method loadName];
        NameTextField.text = name;
    }
    if([_method loadValue]!=nil){
        value = [_method loadValue];
        ValueTextField.text = [_translateFormat stringFromNumber:value addComma:YES addYen:YES];
    }
    if([_method loadPeriod]!=nil){
        period = [_method loadPeriod];
        PeriodTextField.text = [_translateFormat formatterDate:period];
    }
}

- (void)viewDidUnload
{
    NameTextField = nil;
    ValueTextField = nil;
    PeriodTextField = nil;
    DoneButton = nil;
    [super viewDidUnload];
}

#pragma mark - 名前の設定
- (IBAction)NameTextField_end:(id)sender {
    name = NameTextField.text;
    [ValueTextField becomeFirstResponder];  //ValueTextFieldに移動
}

#pragma mark - 金額の設定
// 金額の設定
- (IBAction)ValueTextField_begin:(id)sender {
    // NumberPadにToolbarつける
    ValueTextField.inputAccessoryView =
    [self makeNumberPadToolbar:@"次へ"
                          Done:@selector(doneValueTextField)
                        Cancel:@selector(cancelValueTextField)];
    // 既に値が入力されていた場合，表示されている値を数値に戻す (例)10,000円→10000
    if(value != NULL)
        ValueTextField.text = [_translateFormat stringFromNumber:value addComma:NO addYen:NO];
}

// Numberpadに追加したボタンの動作
-(void)doneValueTextField{
    // 値が入っている場合
    if([ValueTextField.text length] >= 1) {
        value = [_translateFormat numberFromString:ValueTextField.text];
        ValueTextField.text = [_translateFormat stringFromNumber:value addComma:YES addYen:YES]; // 表示変える
        [ValueTextField resignFirstResponder];  // NumberPad消す
        [PeriodTextField becomeFirstResponder]; // PeriodTextFieldに移動
    }
    [ValueTextField resignFirstResponder]; // NumberPad消す
}

// Numberpadに追加したキャンセルボタンの動作
-(void)cancelValueTextField{
    // 既に値が入っていた場合
    if(value != NULL)
        ValueTextField.text = [_translateFormat stringFromNumber:value addComma:YES addYen:YES];   // 元に戻す
    // そうでもなかった場合
    else
        ValueTextField.text = @"";         // 値を消す
    [ValueTextField resignFirstResponder]; // NumberPad消す(=テキストフィールドを選択していない状態にする)
}

#pragma mark - 期日の設定
- (IBAction)PeriodTextField_begin:(id)sender {
    [self makeActionSheetWithDataPicker:@"完了"
                                   Done:@selector(doneWithDatePicker)
                                 Cancel:@selector(cancelWithDatePicker)];
    [actionSheet showInView: self.view];         // 画面上に表示させる
    [actionSheet setBounds: CGRectMake(0, 0, 320, 500)]; // 場所とサイズ決める(x,y.width,height)
}

// DatePickerが完了したときの
-(void)doneWithDatePicker{
    period = datePicker.date; // 保持しておく
    PeriodTextField.text = [_translateFormat formatterDate:period]; // 文字入力する
    [PeriodTextField resignFirstResponder]; // フォーカス外す
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES]; // ActionSheet消す
}

// DatePickerがキャンセルした時の
-(void)cancelWithDatePicker{
    [PeriodTextField resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - ボタン
// 決定ボタンが押されたときの
- (IBAction)DoneButton_down:(id)sender {
     [_method saveName:name Value:value Period:period];
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

- (void)makeActionSheetWithDataPicker:(NSString *)string Done:(SEL)done Cancel:(SEL)cancel{
    // 空のActionSheetをつくる
    actionSheet =
    [[UIActionSheet alloc] initWithTitle: nil
                                delegate: nil
                       cancelButtonTitle: nil
                  destructiveButtonTitle: nil
                       otherButtonTitles: nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    // Toolbar作る
    UIToolbar *datePickerToolbar = [self makeNumberPadToolbar:string Done:done Cancel:cancel];
    
    // DatePickerつくる
    datePicker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0, 44, 320, 216)];
    datePicker.datePickerMode = UIDatePickerModeDate; // 年月日までモード
    if(period)
        datePicker.date = period; // 入力しなおした時の初期値は前に入れた奴にする
    
    datePicker.minimumDate = [NSDate date]; // 設定できる範囲は今日から
    datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:86400*365*10]; // 10年後まで
    
    [actionSheet addSubview: datePickerToolbar]; // Toolbarのっける
    [actionSheet addSubview: datePicker];        // DatePickerのっける
}



@end
