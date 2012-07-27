//
//  GoalViewController.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import "GoalViewController.h"

<<<<<<< master
@interface GoalViewController ()

=======
@interface GoalViewController (){
    @private
    NSString *tempValue; // 金額の保持に使う
}
>>>>>>> local
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
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    ValueTextField.inputAccessoryView = numberToolbar;
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)NameTextField_end:(id)sender {
<<<<<<< master
    [ValueTextField becomeFirstResponder];  //ValueTextFieldに移動
}

- (IBAction)ValueTextField_end:(id)sender {
    [PeriodTextField becomeFirstResponder];  //PeriodTextFieldに移動したい
}

=======
    // TODO: いつかここに値を保存する処理を書こう
    [ValueTextField becomeFirstResponder];  //ValueTextFieldに移動
}

// 金額の設定
- (IBAction)ValueTextField_begin:(id)sender {
    // 既に値が入力されていた場合，表示されている値を数値に戻す (例)10,000円→10000
    if([ValueTextField.text hasSuffix:@"円"]){
        tempValue = ValueTextField.text;
        NSString *tempValue2 = [tempValue substringToIndex:[tempValue length]-1]; // 円を消す(=語尾から一文字消す)
        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
        [fmt setPositiveFormat:@"#,##0"];
        NSNumber *temp = [fmt numberFromString:tempValue2];            // ,を消す感じにする
        ValueTextField.text = [NSString stringWithFormat:@"%@",temp];  // 消していく
    }
}

- (IBAction)ValueTextField_end:(id)sender {
    // TODO: いつかここに値を保存する処理を書こう
    [PeriodTextField becomeFirstResponder];  //PeriodTextFieldに移動したい
}

// 期間の設定
>>>>>>> local
- (IBAction)PeriodTextField_end:(id)sender {
    // TODO: ここでドラムを隠す
}



-(void)cancelNumberPad{
<<<<<<< master
    [ValueTextField resignFirstResponder];
    ValueTextField.text = @"";
=======
    // 既に値が入っていた場合
    if(tempValue != @"")
        ValueTextField.text = tempValue;   // 元に戻す
    // そうでもなかった場合
    else
        ValueTextField.text = @"";         // 値を消す
    [ValueTextField resignFirstResponder]; // NumberPad消す(=テキストフィールドを選択していない状態にする)
>>>>>>> local
}

-(void)doneWithNumberPad{
<<<<<<< master
    //NSString *numberFromTheKeyboard = ValueTextField.text;
    [ValueTextField resignFirstResponder];
=======
    // 値が入っている場合
    if([ValueTextField.text length] >= 1) {
        NSNumber *value = [NSNumber numberWithInt:[ValueTextField.text intValue]]; // 文字を数値に変換
        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];                 // 形式変えるアレ
        [fmt setPositiveFormat:@"#,##0"];                                          // 形式の指定
        NSString *temp = [fmt stringForObjectValue:value];                         // アレ
        ValueTextField.text = [NSString stringWithFormat:@"%@円",temp];            // 表示変える
        // TODO: いつかここに値を保存する処理を書こう
        // ???: ていうかここに移動するPeriodTextFieldに移動する処理書くんじゃね？
    }
    [ValueTextField resignFirstResponder];                                     // NumberPad消す
>>>>>>> local
}


@end
