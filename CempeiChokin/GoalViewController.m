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
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"キャンセル" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"完了" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
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
    // TODO: いつかここに値を保存する処理を書こう
    [ValueTextField becomeFirstResponder];  //ValueTextFieldに移動
}

// 金額の設定
- (IBAction)ValueTextField_begin:(id)sender {
    // 既に値が入力されていた場合，表示されている値を数値に戻す (例)10,000円→10000
    if([ValueTextField.text hasSuffix:@"円"]){
        tempValue = ValueTextField.text;
        NSString *tempValue2 = [tempValue substringToIndex:[tempValue length]-1]; // 円を消す(=語尾から一文字消す)
        ValueTextField.text = [NSString stringWithFormat:@"%@",[_method deleteComma:tempValue2]];  // ,消す
    }
}

// 期間の設定
- (IBAction)PeriodTextField_end:(id)sender {
    // TODO: ここでドラムを隠す
}

// Numberpadに追加したボタンの動作
-(void)cancelNumberPad{
    // 既に値が入っていた場合
    if(tempValue != @"")
        ValueTextField.text = tempValue;   // 元に戻す
    // そうでもなかった場合
    else
        ValueTextField.text = @"";         // 値を消す
    [ValueTextField resignFirstResponder]; // NumberPad消す(=テキストフィールドを選択していない状態にする)
}

-(void)doneWithNumberPad{
    // 値が入っている場合
    if([ValueTextField.text length] >= 1) {
        ValueTextField.text = [NSString stringWithFormat:@"%@円",[_method addComma:ValueTextField.text]]; // 表示変える
        [PeriodTextField becomeFirstResponder]; // PeriodTextFieldに移動
    }
    [ValueTextField resignFirstResponder]; // NumberPad消す
}


@end
