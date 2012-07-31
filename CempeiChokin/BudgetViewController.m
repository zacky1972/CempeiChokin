//
//  BudgetViewController.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import "BudgetViewController.h"

@interface BudgetViewController (){
    Methods *_method;
    
    NSDate *tempStartDate;
    NSDate *tempEndDate;
    NSString *tempValue;
    
    UIActionSheet *actionSheet;
    UIDatePicker *datePicker;
    UIToolbar *datePickerToolbar;
}

@end

@implementation BudgetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _method = [Methods alloc];
    //設定がしてあったらデータをとってくる
    BOOL atodeKesu = [_method initData];
    atodeKesu = NO;
    // TODO: あとで消そう
    if([_method loadStart:nil]!=nil)startDateTextField.text = [_method loadName:nil];
    if([_method loadEnd:nil]!=nil)endDateTextField.text = [_method loadValue:nil];
    if([_method loadBudget:nil]!=nil)budgetTextField.text = [_method loadPeriod:nil];
    
    tempStartDate = [NSDate date];
    startDateTextField.text = [_method formatterDate:tempStartDate];
    
    // ツールバーとかデータピッカー
    datePickerToolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 44)];
    datePickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    datePicker =[[UIDatePicker alloc] initWithFrame: CGRectMake(0, 44, 320, 216)];
    datePicker.datePickerMode = UIDatePickerModeDate;
        
    // 空のActionSheetをつくる
    actionSheet =
    [[UIActionSheet alloc] initWithTitle: nil
                                delegate: nil
                       cancelButtonTitle: nil
                  destructiveButtonTitle: nil
                       otherButtonTitles: nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
}

- (void)viewDidUnload
{
    startDateTextField = nil;
    endDateTextField = nil;
    budgetTextField = nil;
    [super viewDidUnload];
}

#pragma mark - StartDateTextField
- (IBAction)startDateTextField_begin:(id)sender {
    // Toolbarのボタンつくる
    UIBarButtonItem *done =
    [[UIBarButtonItem alloc] initWithTitle: @"次へ"
                                     style: UIBarButtonItemStyleBordered
                                    target: self
                                    action: @selector(doneWithDatePicker)];
    UIBarButtonItem *cancel =
    [[UIBarButtonItem alloc] initWithTitle: @"キャンセル"
                                     style: UIBarButtonItemStyleBordered
                                    target: self
                                    action: @selector(cancelWithDatePicker)];
    UIBarButtonItem *frexibleSpace =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                  target: nil
                                                  action: nil];
    datePickerToolbar.items = @[cancel,frexibleSpace,done]; // ツールバーにのせる (キャンセル| [スペース] | 完了)
    [datePickerToolbar sizeToFit];
    
    // DatePickerの設定
    datePicker.date = tempStartDate;
    datePicker.minimumDate = [NSDate date]; // 設定できる範囲は今日から
    datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:86400*365*10]; // 10年後まで

    // ActionSheetを表示させる
    [actionSheet addSubview: datePickerToolbar]; // Toolbarのっける
    [actionSheet addSubview: datePicker];        // DatePickerのっける
    [actionSheet showInView: self.view];         // 画面上に表示させる
    [actionSheet setBounds: CGRectMake(0, 0, 320, 500)]; // 場所とサイズ決める(x,y.width,height)
}

-(void)doneWithDatePicker{ // 値をテキストフィールドに入れる
    tempStartDate = datePicker.date;
    startDateTextField.text = [_method formatterDate:tempStartDate]; // 文字入力する
    [startDateTextField resignFirstResponder]; // フォーカス外す
    if([tempStartDate earlierDate:tempEndDate] == tempEndDate ){
        tempEndDate = [NSDate dateWithTimeInterval:86400 sinceDate:tempStartDate];
        endDateTextField.text = [_method formatterDate:tempEndDate];
    }
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES]; // ActionSheet消す
}

// DatePickerがキャンセルした時の
-(void)cancelWithDatePicker{ // 特に何もしない
    [startDateTextField resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - endDateTextField
- (IBAction)endDateTextField_begin:(id)sender {
    // Toolbarのボタンつくる
    UIBarButtonItem *done =
    [[UIBarButtonItem alloc] initWithTitle: @"次へ"
                                     style: UIBarButtonItemStyleBordered
                                    target: self
                                    action: @selector(doneWithDatePicker2)];
    UIBarButtonItem *cancel =
    [[UIBarButtonItem alloc] initWithTitle: @"キャンセル"
                                     style: UIBarButtonItemStyleBordered
                                    target: self
                                    action: @selector(cancelWithDatePicker2)];
    UIBarButtonItem *frexibleSpace =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                  target: nil
                                                  action: nil];
    // ボタンをToolbarにつける
    datePickerToolbar.items = @[cancel,frexibleSpace,done]; // ツールバーにのせる (キャンセル| [スペース] | 完了)
    [datePickerToolbar sizeToFit];
    
    // DatePickerつくる
    datePicker =[[UIDatePicker alloc] initWithFrame: CGRectMake(0, 44, 320, 216)];
    datePicker.datePickerMode = UIDatePickerModeDate; // 年月日までモード
    
    datePicker.minimumDate = [NSDate dateWithTimeInterval:86400 sinceDate:tempStartDate]; // 設定できる範囲は今日から
    datePicker.maximumDate = [NSDate dateWithTimeInterval:86400*365*10 sinceDate:tempStartDate]; // 10年後まで

    [actionSheet addSubview: datePickerToolbar]; // Toolbarのっける
    [actionSheet addSubview: datePicker];        // DatePickerのっける
    [actionSheet showInView: self.view];         // 画面上に表示させる
    [actionSheet setBounds: CGRectMake(0, 0, 320, 500)]; // 場所とサイズ決める(x,y.width,height)
}


- (void)doneWithDatePicker2{ // 値をテキストフィールドに入れる
    tempEndDate = datePicker.date;
    endDateTextField.text = [_method formatterDate:tempEndDate]; // 文字入力する
    [endDateTextField resignFirstResponder]; // フォーカス外す
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES]; // ActionSheet消す
    [budgetTextField becomeFirstResponder];  //budgetTextFieldに移動
}

// DatePickerがキャンセルした時の
- (void)cancelWithDatePicker2{ // 特に何もしない
    [endDateTextField resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - budgetTextField

- (IBAction)budgetTextField_begin:(id)sender{
    // 既に値が入力されていた場合，表示されている値を数値に戻す (例)10,000円→10000
    if([budgetTextField.text hasSuffix:@"円"]){
        tempValue = budgetTextField.text;
        NSString *tempValue2 = [tempValue substringToIndex:[tempValue length]-1]; // 円を消す(=語尾から一文字消す)
        budgetTextField.text = [NSString stringWithFormat:@"%@",[_method deleteComma:tempValue2]];  // ,消す
    }
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
    budgetTextField.inputAccessoryView = numberToolbar;  // キーボードの上につけるときはこれ使うのかな？
}

// Numberpadに追加したボタンの動作
-(void)doneNumberPad{
    // 値が入っている場合
    if([budgetTextField.text length] >= 1) {
        budgetTextField.text = [NSString stringWithFormat:@"%@円",[_method addComma:budgetTextField.text]]; // 表示変える
        [budgetTextField resignFirstResponder];  // NumberPad消す
    }
    [budgetTextField resignFirstResponder]; // NumberPad消す
}

// Numberpadに追加したキャンセルボタンの動作
-(void)cancelNumberPad{
    // 既に値が入っていた場合
    if(tempValue != @"")
        budgetTextField.text = tempValue;   // 元に戻す
    // そうでもなかった場合
    else
        budgetTextField.text = @"";         // 値を消す
    [budgetTextField resignFirstResponder]; // NumberPad消す(=テキストフィールドを選択していない状態にする)
}

#pragma DoneButton

- (IBAction)DoneButton_down:(id)sender {
    
    [_method saveStart:startDateTextField.text End:endDateTextField.text Budget:budgetTextField.text];
}

@end
