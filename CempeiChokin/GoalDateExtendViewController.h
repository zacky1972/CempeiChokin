//
//  GoalDateExtendViewController.h
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TranslateFormat.h"

@interface GoalDateExtendViewController : UITableViewController{
    //テキストフィールド
    
    __weak IBOutlet UILabel *NameLabel;             //名前
    __weak IBOutlet UILabel *ValueLabel;            //金額
    __weak IBOutlet UITextField *PeriodTextField;   //期限
    //ボタン
    __weak IBOutlet UIButton *DoneButton;
}
- (IBAction)PeriodTextField_down:(id)sender;
- (IBAction)DoneButton_down:(id)sender;


@end
