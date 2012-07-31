//
//  BudgetViewController.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import "BudgetViewController.h"

@interface BudgetViewController (){
    Methods *method;
    
    UIActionSheet *actionSheet;
    UIDatePicker *datePicker;
    UIToolbar *datePickerToolbar;
}

@end

@implementation BudgetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Toolbarつくる
    datePickerToolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, 320, 44)];
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
}

- (void)viewDidUnload
{
    startDateTextField = nil;
    endDateTextField = nil;
    budgetTextField = nil;
    [super viewDidUnload];
}

- (IBAction)startDateTextField_begin:(id)sender {
    // ActionSheetを表示させる
    [actionSheet addSubview: datePickerToolbar]; // Toolbarのっける
    [actionSheet addSubview: datePicker];        // DatePickerのっける
    [actionSheet showInView: self.view];         // 画面上に表示させる
    [actionSheet setBounds: CGRectMake(0, 0, 320, 500)]; // 場所とサイズ決める(x,y.width,height)
}

-(void)doneWithDatePicker{ // 値をテキストフィールドに入れる
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =@"yyyy年M月d日"; // 表示を変える
    startDateTextField.text = [formatter stringFromDate:datePicker.date]; // 文字入力する
    [startDateTextField resignFirstResponder]; // フォーカス外す
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES]; // ActionSheet消す
}

// DatePickerがキャンセルした時の
-(void)cancelWithDatePicker{ // 特に何もしない
    [startDateTextField resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (IBAction)endDateTextField_begin:(id)sender {
    [actionSheet addSubview: datePickerToolbar]; // Toolbarのっける
    [actionSheet addSubview: datePicker];        // DatePickerのっける
    [actionSheet showInView: self.view];         // 画面上に表示させる
    [actionSheet setBounds: CGRectMake(0, 0, 320, 500)]; // 場所とサイズ決める(x,y.width,height)
}

- (IBAction)budgetTextField_end:(id)sender {
    
}

@end
