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
    TranslateFormat *_translateFormat;
    
    // 値を保存するための変数
    NSDate   *startDate;
    NSDate   *endDate;
    NSNumber *budget;
    
    // パーツたち
    UIActionSheet *actionSheet;
    UIDatePicker *datePicker;
    
}

@end

@implementation BudgetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _translateFormat = [TranslateFormat alloc];
    
    _method = [Methods alloc];
    [_method initData];
    //設定がしてあったらデータをとってくる
    
    if([_method loadStart]!=nil){
        startDate = [_method loadStart];
        startDateTextField.text = [_translateFormat formatterDate:startDate];
    }else{
        startDate = [NSDate date];
        startDateTextField.text = [_translateFormat formatterDate:startDate];
    }
    if([_method loadEnd] != nil){
        endDate = [_method loadEnd];
        endDateTextField.text = [_translateFormat formatterDate:endDate];
    }
    if([_method loadBudget] != nil){
        budget = [_method loadBudget];
        budgetTextField.text = [_translateFormat stringFromNumber:budget addComma:YES addYen:YES];
    }
    
    //データが入力されているかどうか判断して、入力されていなければ完了を押せないようにする
        if(startDate == NULL || endDate == NULL || budget == NULL){
        DoneButton.enabled = NO;
    }
    
        
    // ツールバーとかデータピッカー
    datePicker =[[UIDatePicker alloc] initWithFrame: CGRectMake(0, 44, 320, 216)];
    datePicker.datePickerMode = UIDatePickerModeDate;
}


- (void)viewDidUnload
{
    startDateTextField = nil;
    endDateTextField = nil;
    budgetTextField = nil;
    DoneButton = nil;
    laterButton = nil;
    [super viewDidUnload];
}

#pragma mark - Storyboardで画面遷移する前に呼ばれるあれ
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showMainView"]) {
        //FIXME:ここでデータを渡すといいんじゃないか
    }
    
    if ([segue.identifier isEqualToString:@"showMainView_done"]) {
        //FIXME:ここでデータを渡すといいんじゃないか
    }
    if ([segue.identifier isEqualToString:@"showMainView_skip"]) {
        //FIXME:ここでデータを渡すといいんじゃないか
    }
}

#pragma mark - StartDateTextField
- (IBAction)startDateTextField_begin:(id)sender {
    // DatePickerの設定
    datePicker.date = startDate;
    datePicker.minimumDate = [NSDate date]; // 設定できる範囲は今日から
    datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:86400*365]; // 1年後まで

    // ActionSheetを表示させる
    [self makeActionSheetWithDataPicker:@"次へ"
                                   Done:@selector(doneStartDateTextField)
                                 Cancel:@selector(cancelStartDateTextField)];
    [actionSheet showInView: self.view];         // 画面上に表示させる
    [actionSheet setBounds: CGRectMake(0, 0, 320, 500)]; // 場所とサイズ決める(x,y.width,height)
}

- (IBAction)startDateTextField_end:(id)sender {
    if(startDate != NULL && endDate != NULL && budget != NULL){
        DoneButton.enabled = YES;
    }
    [startDateTextField resignFirstResponder];
}


-(void)doneStartDateTextField{ // 値をテキストフィールドに入れる
    startDate = datePicker.date;
    startDateTextField.text = [_translateFormat formatterDate:startDate]; // 文字入力する
    [startDateTextField resignFirstResponder]; // フォーカス外す
    if([startDate earlierDate:endDate] == endDate ){
        endDate = [NSDate dateWithTimeInterval:86400 sinceDate:startDate];
        endDateTextField.text = [_translateFormat formatterDate:endDate];
    }
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES]; // ActionSheet消す
    [endDateTextField becomeFirstResponder]; // endDateTextFieldに移動

}

// DatePickerがキャンセルした時の
-(void)cancelStartDateTextField{ // 特に何もしない
    [startDateTextField resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - endDateTextField
- (IBAction)endDateTextField_begin:(id)sender {
    
    datePicker.minimumDate = [NSDate dateWithTimeInterval:86400 sinceDate:startDate]; // 設定できる範囲は今日から
    datePicker.maximumDate = [_method loadPeriod]; // 10年後まで

    [self makeActionSheetWithDataPicker:@"次へ"
                                   Done:@selector(doneEndDateTextField)
                                 Cancel:@selector(cancelEndDateTextField)];
    [actionSheet showInView: self.view];         // 画面上に表示させる
    [actionSheet setBounds: CGRectMake(0, 0, 320, 500)]; // 場所とサイズ決める(x,y.width,height)
}

- (IBAction)endDateTextField_end:(id)sender {
    
    //全ての欄が入力されていれば完了を押せるようにする
    if(startDate != NULL && endDate != NULL && budget != NULL){
        DoneButton.enabled = YES;
    }
    [endDateTextField resignFirstResponder];
}


- (void)doneEndDateTextField{ // 値をテキストフィールドに入れる
    endDate = datePicker.date;
    endDateTextField.text = [_translateFormat formatterDate:endDate]; // 文字入力する
    [endDateTextField resignFirstResponder]; // フォーカス外す
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES]; // ActionSheet消す
    [budgetTextField becomeFirstResponder];  //budgetTextFieldに移動
}

// DatePickerがキャンセルした時の
- (void)cancelEndDateTextField{ // 特に何もしない
    [endDateTextField resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - budgetTextField
- (IBAction)budgetTextField_begin:(id)sender{
    budgetTextField.inputAccessoryView =
    [self makeNumberPadToolbar:@"完了" Done:@selector(doneBudgetTextField) Cancel:@selector(cancelBudgetTextField)];
    // 既に値が入力されていた場合，表示されている値を数値に戻す
    if(budget != NULL)
        budgetTextField.text = [_translateFormat stringFromNumber:budget addComma:NO addYen:NO];
}

- (IBAction)budgetTextField_end:(id)sender{
    
    //全ての欄が入力されていれば完了を押せるようにする
    if(startDate != NULL && endDate != NULL && budget != NULL){
        DoneButton.enabled = YES;
    }
    
    if(budget != NULL){
        budgetTextField.text = [_translateFormat stringFromNumber:budget addComma:YES addYen:YES];   // 元に戻す
    }
    else{
        budgetTextField.text = @"";         // 値を消す
    }
    [budgetTextField resignFirstResponder]; // NumberPad消す(=テキストフィールドを選択していない状態にする)

}



// Numberpadに追加したボタンの動作
-(void)doneBudgetTextField{
    // 値が入っている場合
    if([budgetTextField.text length] >= 1) {
        budget = [_translateFormat numberFromString:budgetTextField.text];
        budgetTextField.text = [_translateFormat stringFromNumber:budget addComma:YES addYen:YES];
        [budgetTextField resignFirstResponder];  // NumberPad消す
    }
    [budgetTextField resignFirstResponder]; // NumberPad消す
}

// Numberpadに追加したキャンセルボタンの動作
-(void)cancelBudgetTextField{
    // 既に値が入っていた場合
    if(budget != NULL)
        budgetTextField.text = [_translateFormat stringFromNumber:budget addComma:YES addYen:YES];   // 元に戻す
    else
        budgetTextField.text = @"";         // 値を消す
    [budgetTextField resignFirstResponder]; // NumberPad消す(=テキストフィールドを選択していない状態にする)
}

#pragma mark - ボタン
- (IBAction)DoneButton_down:(id)sender {
    [_method saveStart:startDate End:endDate Budget:budget];
}

- (IBAction)laterButton_down:(id)sender {
    
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
        
    [actionSheet addSubview: datePickerToolbar]; // Toolbarのっける
    [actionSheet addSubview: datePicker];        // DatePickerのっける
}

@end
