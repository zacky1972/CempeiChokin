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
    NSString *tempValue; // 金額の保持に使う
    NSDate *tempDate;
    
    UIActionSheet *actionSheet;
    UIDatePicker *datePicker;
}

@end

@implementation GoalViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _method = [Methods alloc];
    
    //設定がしてあったらデータをとってくる
    [_method initData:nil];
    if([_method loadName:nil]!=nil)NameTextField.text = [_method loadName:nil];
    if([_method loadValue:nil]!=nil)ValueTextField.text = [_method loadValue:nil];
    if([_method loadPeriod:nil]!=nil)PeriodTextField.text = [_method loadPeriod:nil];
}

- (void)viewDidUnload
{
    NameTextField = nil;
    ValueTextField = nil;
    PeriodTextField = nil;
    DoneButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - 名前の設定
- (IBAction)NameTextField_end:(id)sender {
    // TODO: いつかここに値を保存する処理を書こう
    // ???: 一括で保存してみた！
    [ValueTextField becomeFirstResponder];  //ValueTextFieldに移動
}

#pragma mark - 金額の設定
// 金額の設定
- (IBAction)ValueTextField_begin:(id)sender {
    // 既に値が入力されていた場合，表示されている値を数値に戻す (例)10,000円→10000
    if([ValueTextField.text hasSuffix:@"円"]){
        tempValue = ValueTextField.text;
        NSString *tempValue2 = [tempValue substringToIndex:[tempValue length]-1]; // 円を消す(=語尾から一文字消す)
        ValueTextField.text = [NSString stringWithFormat:@"%@",[_method deleteComma:tempValue2]];  // ,消す
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
    ValueTextField.inputAccessoryView = numberToolbar;  // キーボードの上につけるときはこれ使うのかな？
    // TODO: Numberpad表示させてる時に期日のところ押したらなんかバグるからいつかどうにかしよう
}

// Numberpadに追加したボタンの動作
-(void)doneNumberPad{
    // 値が入っている場合
    if([ValueTextField.text length] >= 1) {
        ValueTextField.text = [NSString stringWithFormat:@"%@円",[_method addComma:ValueTextField.text]]; // 表示変える
        [ValueTextField resignFirstResponder];  // NumberPad消す
        [PeriodTextField becomeFirstResponder]; // PeriodTextFieldに移動
    }
    [ValueTextField resignFirstResponder]; // NumberPad消す
}

// Numberpadに追加したキャンセルボタンの動作
-(void)cancelNumberPad{
    // 既に値が入っていた場合
    if(tempValue != @"")
        ValueTextField.text = tempValue;   // 元に戻す
    // そうでもなかった場合
    else
        ValueTextField.text = @"";         // 値を消す
    [ValueTextField resignFirstResponder]; // NumberPad消す(=テキストフィールドを選択していない状態にする)
}

#pragma mark - 期日の設定
- (IBAction)PeriodTextField_begin:(id)sender {
    // Toolbarつくる
    UIToolbar* datePickerToolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 44)];
    datePickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    
    // Toolbarのボタンつくる
    UIBarButtonItem *done =
    [[UIBarButtonItem alloc] initWithTitle: @"完了"
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
    // ボタンをToolbarにつける
    datePickerToolbar.items = @[cancel,frexibleSpace,done]; // ツールバーにのせる (キャンセル| [スペース] | 完了)
    [datePickerToolbar sizeToFit]; // なんかフィットさせる
    
    // DatePickerつくる
    datePicker =[[UIDatePicker alloc] initWithFrame: CGRectMake(0, 44, 320, 216)];
    datePicker.datePickerMode = UIDatePickerModeDate; // 年月日までモード
    if(tempDate)
        datePicker.date = tempDate; // 入力しなおした時の初期値は前に入れた奴にする
    datePicker.minimumDate = [NSDate date]; // 設定できる範囲は今日から
    datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:86400*365*10]; // 10年後まで
    
    // 空のActionSheetをつくる
    actionSheet =
    [[UIActionSheet alloc] initWithTitle: nil
                                delegate: nil
                       cancelButtonTitle: nil
                  destructiveButtonTitle: nil
                       otherButtonTitles: nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    // ActionSheetを表示させる
    [actionSheet addSubview: datePickerToolbar]; // Toolbarのっける
    [actionSheet addSubview: datePicker];        // DatePickerのっける
    [actionSheet showInView: self.view];         // 画面上に表示させる
    [actionSheet setBounds: CGRectMake(0, 0, 320, 500)]; // 場所とサイズ決める(x,y.width,height)
}

// DatePickerが完了したときの
-(void)doneWithDatePicker{ // 値をテキストフィールドに入れる
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =@"yyyy年M月d日"; // 表示を変える
    tempDate = datePicker.date; // 保持しておく
    PeriodTextField.text = [formatter stringFromDate:tempDate]; // 文字入力する
    [PeriodTextField resignFirstResponder]; // フォーカス外す
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES]; // ActionSheet消す
}

// DatePickerがキャンセルした時の
-(void)cancelWithDatePicker{ // 特に何もしない
    [PeriodTextField resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

// 決定ボタンが押されたときの
- (IBAction)DoneButton_down:(id)sender {
    // TODO: 決定ボタンで保存するようにしたい
    //       入力途中でおちたら空になっちゃうので，それはどうしようか
    [_method saveName:NameTextField.text Value:ValueTextField.text Period:PeriodTextField.text]; // 保存する
}

@end
