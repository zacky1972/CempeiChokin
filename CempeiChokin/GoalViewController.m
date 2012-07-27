//
//  GoalViewController.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import "GoalViewController.h"

@interface GoalViewController ()
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
    
    // Numberpadが表示された時にキャンセルと完了のボタンがあるツールバーを表示させる
    // Toolbarの設定
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    // Barの上にキャンセルとバント完了ボタンを追加する
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"キャンセル" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"次へ" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    ValueTextField.inputAccessoryView = numberToolbar;
    // Toolbarの設定ここまで
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

// 名前の設定
- (IBAction)NameTextField_end:(id)sender {
    // いつかここに値を保存する処理を書こう
    [ValueTextField becomeFirstResponder];  //ValueTextFieldに移動
}

// 金額の設定
- (IBAction)ValueTextField_begin:(id)sender {
    // 既に値が入力されていた場合，表示されている値を数値に戻す (例)10,000円→10000
    if([ValueTextField.text hasSuffix:@"円"]){
        NSString *tempValue;
        tempValue = ValueTextField.text;
        tempValue = [tempValue substringToIndex:[tempValue length]-1];
        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
        [fmt setPositiveFormat:@"#,##0"];
        NSNumber *temp = [fmt numberFromString:tempValue];
        ValueTextField.text = [NSString stringWithFormat:@"%@",temp];
    }
}

- (IBAction)ValueTextField_end:(id)sender {
    // いつかここに値を保存する処理を書こう
    [PeriodTextField becomeFirstResponder];  //PeriodTextFieldに移動したい
}

//  期間の設定
- (IBAction)PeriodTextField_end:(id)sender {
    //ここでドラムを隠す
}

// Numberpadに追加したキャンセルボタンの動作
-(void)cancelNumberPad{
    [ValueTextField resignFirstResponder]; // NumberPad消す(=テキストフィールドを選択していない状態にする)
    ValueTextField.text = @"";             // で，値を消す
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
}

@end
