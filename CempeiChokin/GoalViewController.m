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
    numberToolbar.items = @[cancel,frexibleSpace,done]; // キャンセル [スペース] 完了
    [numberToolbar sizeToFit];                          // なんかフィットさせる
    ValueTextField.inputAccessoryView = numberToolbar;  // キーボードの上につけるときはこれ使うのかな？
    // TODO: Numberpad表示させてる時に期日のところ押したらなんかバグるからいつかどうにかしよう
}

//  期間の設定
- (IBAction)PeriodTextField_end:(id)sender {
    //ここでドラムを隠す
}

-(void)cancelNumberPad{
    // 既に値が入っていた場合
    if(tempValue != @"")
        ValueTextField.text = tempValue;   // 元に戻す
    // そうでもなかった場合
    else
        ValueTextField.text = @"";         // 値を消す
    [ValueTextField resignFirstResponder]; // NumberPad消す(=テキストフィールドを選択していない状態にする)
}

// 完了ボタンの動作
-(void)doneWithNumberPad{
    [ValueTextField resignFirstResponder];                                     // NumberPad消す
    NSNumber *value = [NSNumber numberWithInt:[ValueTextField.text intValue]]; // テキストフィールドの文字を数値に変換
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];                 // 形式変えるアレ
    [fmt setPositiveFormat:@"#,##0"];                                          // 形式の指定
    NSString *temp = [fmt stringForObjectValue:value];                         // アレ
    ValueTextField.text = [NSString stringWithFormat:@"%@円",temp];            // 表示変える
    // いつかここに値を保存する処理を書こう
    [PeriodTextField becomeFirstResponder];                                    // PeriodTextFieldに移動する
}

@end
