//
//  BudgetViewController.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import "BudgetViewController.h"
#import "AppDelegate.h"

@interface BudgetViewController (){
    AppDelegate *appDelegate;

    TranslateFormat *_translateFormat;
    
    // 値を保存するための変数
    NSDate   *startDate;
    NSDate   *endDate;
    
    // パーツたち
    UIActionSheet *actionSheet;
    UIDatePicker *datePicker;
}

@end

@implementation BudgetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = APP_DELEGATE;
    _translateFormat = [TranslateFormat alloc];

    [self dataInitialize];
    [self dataCheck];

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

#pragma mark - よく使う処理たち
// 値の読み込みとか
- (void)dataInitialize{
    if([appDelegate.editData loadStart] != nil){
        // Startがある
        startDate = [appDelegate.editData loadStart];
        startDateTextField.text = [_translateFormat formatterDate:startDate];
    }else{
        // 初期設定
        startDate = [NSDate date];
        startDateTextField.text = [_translateFormat formatterDate:startDate];
    }
    if([appDelegate.editData loadEnd] != nil){
        // Endがある
        endDate = [appDelegate.editData loadEnd];
        endDateTextField.text = [_translateFormat formatterDate:endDate];
    }
    if([appDelegate.editData.budget isEqualToNumber:@-1] == NO){
        // 予算が決まっている
        budgetTextField.text = [_translateFormat stringFromNumber:appDelegate.editData.budget addComma:YES addYen:YES];
    }
}
// データの確認 & 完了ボタンの設定変更
- (BOOL)dataCheck{
    if(startDate == NULL || endDate == NULL || [appDelegate.editData.budget isEqualToNumber:@-1] == YES){
        // データが揃っていないとき
        DoneButton.enabled = NO;
        DoneButton.alpha = 0.3;
        return NO;
    }else{
        // データが揃っているとき
        DoneButton.enabled = YES;
        DoneButton.alpha = 1;
        return YES;
    }
}

#pragma mark - StartDateTextField
// StartDateTextFieldを選択したとき
- (IBAction)startDateTextField_begin:(id)sender {
    // DatePickerの設定
    datePicker.date = startDate;
    datePicker.minimumDate = [NSDate date]; // 設定できる範囲は今日から
    datePicker.maximumDate = [NSDate dateWithTimeInterval:-60*60*24 sinceDate:[appDelegate.editData loadGoalPeriod]]; // 最終期限の前日まで

    // ActionSheetを表示させる
    [self makeActionSheetWithDataPicker:@"次へ"
                                   Done:@selector(doneStartDateTextField)
                                 Cancel:@selector(cancelStartDateTextField)];
    [actionSheet showInView: self.view];         // 画面上に表示させる
    [actionSheet setBounds: CGRectMake(0, 0, 320, 500)]; // 場所とサイズ決める(x,y.width,height)
}
// StartDateTextField以外を選択した時
- (IBAction)startDateTextField_end:(id)sender {
    // FIXME: ここ実行されないんじゃないか説
}

// StartDateTextField - DatePicker - Done
-(void)doneStartDateTextField{
    // 値をテキストフィールドに入れる
    startDate = datePicker.date;
    startDateTextField.text = [_translateFormat formatterDate:startDate]; // 文字入力する

    if([startDate earlierDate:endDate] == endDate ){
        // Endより後にStartを設定した時
        endDate = [NSDate dateWithTimeInterval:86400 sinceDate:startDate];
        endDateTextField.text = [_translateFormat formatterDate:endDate];
    }
    [startDateTextField resignFirstResponder]; // フォーカス外す
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES]; // ActionSheet消す

    if([self dataCheck] == NO){
        // データが揃っていない時
        [endDateTextField becomeFirstResponder]; // endDateTextFieldに移動
    }
}
// StartDateTextField - DatePicker - Cancel
-(void)cancelStartDateTextField{ // 特に何もしない
    [startDateTextField resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - endDateTextField
// EndDateTextFieldを選択したとき
- (IBAction)endDateTextField_begin:(id)sender {
    
    datePicker.minimumDate = [NSDate dateWithTimeInterval:60*60*24 sinceDate:startDate]; // 設定できる範囲はStartの一日後から
    datePicker.maximumDate = [appDelegate.editData loadGoalPeriod]; // 最終期限まで

    // アクションシートの表示
    [self makeActionSheetWithDataPicker:@"次へ"
                                   Done:@selector(doneEndDateTextField)
                                 Cancel:@selector(cancelEndDateTextField)];
    [actionSheet showInView: self.view];         // 画面上に表示させる
    [actionSheet setBounds: CGRectMake(0, 0, 320, 500)]; // 場所とサイズ決める(x,y.width,height)
}
// EndDateTextField以外を選択した時
- (IBAction)endDateTextField_end:(id)sender {
    // FIXME: ここ実行されないんじゃないか説
}
// EndDateTextField - DatePicker - Done
- (void)doneEndDateTextField{
    // 値をテキストフィールドに入れる
    endDate = datePicker.date;
    endDateTextField.text = [_translateFormat formatterDate:endDate]; // 文字入力する

    [endDateTextField resignFirstResponder]; // フォーカス外す
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES]; // ActionSheet消す
    
    if([self dataCheck] == NO){
        // データが揃っていない時
        [budgetTextField becomeFirstResponder];  //budgetTextFieldに移動
    }
}
// EndDateTextField - DatePicker - Cancel
- (void)cancelEndDateTextField{ // 特に何もしない
    [endDateTextField resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - budgetTextField
// BudgetTextFieldを選択したとき
- (IBAction)budgetTextField_begin:(id)sender{
    budgetTextField.inputAccessoryView = [self makeNumberPadToolbar:@"完了" Done:@selector(doneBudgetTextField) Cancel:@selector(cancelBudgetTextField)];

    // 既に値が入力されていた場合，表示されている値を数値に戻す
    if([appDelegate.editData.budget isEqualToNumber:@-1] == NO){
        budgetTextField.text = [_translateFormat stringFromNumber:appDelegate.editData.budget addComma:NO addYen:NO];
    }else{
        budgetTextField.text = @"";
    }
}
// BudgetTextField以外を選択した時
- (IBAction)budgetTextField_end:(id)sender{
    [self dataCheck];

    if([appDelegate.editData.budget isEqualToNumber:@-1] == NO){
        budgetTextField.text = [_translateFormat stringFromNumber:appDelegate.editData.budget addComma:YES addYen:YES];   // 元に戻す
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
        appDelegate.editData.budget = [_translateFormat numberFromString:budgetTextField.text];
        budgetTextField.text = [_translateFormat stringFromNumber:appDelegate.editData.budget addComma:YES addYen:YES];
    }
    [self dataCheck];
    [budgetTextField resignFirstResponder]; // NumberPad消す
}

// Numberpadに追加したキャンセルボタンの動作
-(void)cancelBudgetTextField{
    // 既に値が入っていた場合
    if([appDelegate.editData.budget isEqualToNumber:@-1] == NO){
        budgetTextField.text = [_translateFormat stringFromNumber:appDelegate.editData.budget addComma:YES addYen:YES];   // 元に戻す
    }else{
        budgetTextField.text = @"";         // 値を消す
    }
    [budgetTextField resignFirstResponder]; // NumberPad消す(=テキストフィールドを選択していない状態にする)
}

#pragma mark - ボタン
- (IBAction)DoneButton_down:(id)sender {
    [appDelegate.editData saveStart:startDate End:endDate];
    [appDelegate.editData calcForNextStage];
    
    appDelegate.editData.didSetPeriod = YES;    //貯金した
    appDelegate.editData.nextAlert = YES;
}

- (IBAction)laterButton_down:(id)sender {
    appDelegate.editData.didSetPeriod = NO;     //貯金してない
    appDelegate.editData.nextAlert = YES;
}

#pragma mark - その他
// NumberPadにつけるツールバーを生成する
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

// DatePickerつきのアクションシートを生成する
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
