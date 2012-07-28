//
//  ModalDatePickerViewController.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/28.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import "ModalDatePickerViewController.h"

@interface ModalDatePickerViewController ()

@end

@implementation ModalDatePickerViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    picker.datePickerMode = UIDatePickerModeDate;
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.dispDate_ != nil)
        [picker setDate:self.dispDate_];
}

- (IBAction)commitButtonClicked:(id)sender{
    [self.delegate didCommitButtonClicked:self selectedDate:picker.date pickerName:self.pickerName_];
}

- (IBAction)cancelButtonClicked:(id)sender{
    [self.delegate didCancelButtonClicked:self pickerName:self.pickerName_];
}

- (IBAction)clearButtonClicked:(id)sender{
    [self.delegate didClearButtonClicked:self pickerName:self.pickerName_];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    pickerName_ = nil;
    dispDate_ = nil;
}


@end