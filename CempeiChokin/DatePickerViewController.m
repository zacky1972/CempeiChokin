//
//  DatePickerViewController.m
//  CempeiChokin
//
//  Created by Takeshi on 12/07/28.
//  Copyright (c) 2012年 Nakano Asami. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    picker.datePickerMode = UIDatePickerModeDate;
}

- (void)viewDidUnload
{
    picker = nil;
    buttonCancel = nil;
    buttonDone = nil;
    view = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)buttonCancel:(id)sender {
    [self.delegate didCancelButtonClicked:self pickerName:self.pickerName_];
}

- (IBAction)buttonDone:(id)sender {
    [self.delegate didCommitButtonClicked:self selectedDate:picker.date pickerName:self.pickerName_];
}

@end
