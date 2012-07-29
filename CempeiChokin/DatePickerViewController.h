//
//  DatePickerViewController.h
//  CempeiChokin
//
//  Created by Takeshi on 12/07/28.
//  Copyright (c) 2012年 Nakano Asami. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DatePickerViewController;
@protocol DatePickerViewControllerDelegate

- (void)didCommitButtonClicked:(DatePickerViewController *)controller selectedDate:(NSDate *)selectedDate pickerName:(NSString *)pickerName;
- (void)didCancelButtonClicked:(DatePickerViewController *)controller pickerName:(NSString *)pickerName;

@end

@interface DatePickerViewController : UIViewController{
    __weak IBOutlet UIBarButtonItem *buttonDone;
    __weak IBOutlet UIBarButtonItem *buttonCancel;
    __weak IBOutlet UIDatePicker *picker;
    IBOutlet UIView *view;
    
    NSString *pickerName;
    NSDate *dispDate_;
    id<DatePickerViewControllerDelegate>delegate;
}

- (IBAction)buttonCancel:(id)sender;
- (IBAction)buttonDone:(id)sender;

@property (nonatomic, assign) id<DatePickerViewControllerDelegate> delegate;
@property (nonatomic, retain) NSString *pickerName_;
@property (nonatomic, retain) NSDate *dispDate_;

@end
