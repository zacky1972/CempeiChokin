//
//  GoalViewController.h
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Methods.h"
#import "TranslateFormat.h"

@interface GoalViewController : UITableViewController{
    //テキストフィールド
    __weak IBOutlet UITextField *NameTextField;     //名前
    __weak IBOutlet UITextField *ValueTextField;    //金額
    __weak IBOutlet UITextField *PeriodTextField;   //期限
    
    //ボタン
    __weak IBOutlet UIButton *DoneButton;           //完了
}

- (IBAction)NameTextField_end:(id)sender;
- (IBAction)ValueTextField_begin:(id)sender;
- (IBAction)PeriodTextField_begin:(id)sender;
- (IBAction)DoneButton_down:(id)sender;

- (IBAction)DoneButton_down_2:(id)sender;


@end
