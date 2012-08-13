//
//  GoalDateExtendViewController.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import "GoalDateExtendViewController.h"
#import "AppDelegate.h"

@interface GoalDateExtendViewController (){
    AppDelegate *appDelegate;
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

@implementation GoalDateExtendViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    appDelegate = APP_DELEGATE;
    
    _translateFormat = [TranslateFormat alloc];
    
    [self dateInitialize];
    [self dateCheck];
}

- (void)viewDidUnload{
    PeriodTextField = nil;
    DoneButton = nil;
    DoneButton = nil;
    NameLabel = nil;
    ValueLabel = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - よく使う処理たち
- (void)dateInitialize{
    name = [appDelegate.editData loadGoalName];
    NameLabel.text = name;
    value = [appDelegate.editData loadGoalValue];
    ValueLabel.text = [_translateFormat stringFromNumber:value addComma:YES addYen:YES];
    /*ここは読み込まなくて委員じゃないか説
    if([appDelegate.editData loadGoalPeriod] != nil){
        period = [appDelegate.editData loadGoalPeriod];
        PeriodTextField.text = [_translateFormat formatterDate:period];
    }*/
}

- (BOOL)dateCheck{
    if(period == NULL){
        DoneButton.enabled = NO;
        //[DoneButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        return NO;
    }else{
        DoneButton.enabled = YES;
        return YES;
    }
}

#pragma mark - 期日の設定
- (IBAction)PeriodTextField_down:(id)sender {
    
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
    [self dateCheck];
}

// DatePickerがキャンセルした時の
-(void)cancelWithDatePicker{
    [PeriodTextField resignFirstResponder];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}


- (IBAction)DoneButton_down:(id)sender {
     [appDelegate.editData saveName:name Value:value Period:period];
     [appDelegate.editData calcForNextStage];
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
    
    datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:86400*7]; // 設定できる範囲は来週から
    datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:86400*365*10]; // 10年後まで
    
    [actionSheet addSubview: datePickerToolbar]; // Toolbarのっける
    [actionSheet addSubview: datePicker];        // DatePickerのっける
}
@end
