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
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Apply" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    ValueTextField.inputAccessoryView = numberToolbar;
    
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

- (IBAction)NameTextField_end:(id)sender {
    [ValueTextField becomeFirstResponder];  //ValueTextFieldに移動
}

- (IBAction)ValueTextField_end:(id)sender {
    [PeriodTextField becomeFirstResponder];  //PeriodTextFieldに移動したい
}

- (IBAction)PeriodTextField_end:(id)sender {
    //ここでドラムを隠す
}



-(void)cancelNumberPad{
    [ValueTextField resignFirstResponder];
    ValueTextField.text = @"";
}

-(void)doneWithNumberPad{
    //NSString *numberFromTheKeyboard = ValueTextField.text;
    [ValueTextField resignFirstResponder];
}


@end
