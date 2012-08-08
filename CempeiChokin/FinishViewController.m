//
//  FinishViewController.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//
#import "AppDelegate.h"
#import "FinishViewController.h"

@interface FinishViewController (){
    AppDelegate *appDelegate;
    Methods *_method;
}

@end

@implementation FinishViewController

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
    appDelegate = APP_DELEGATE;
    
    _method = [Methods alloc];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //FinishNavigationbar.title = @"目標達成通知";
}

- (void)viewDidUnload
{
    //FinishNavigationbar = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Storyboardで画面遷移する前に呼ばれるあれ
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (IBAction)nextButton_down:(id)sender {
    [_method deleteData];
    // TODO: データ渡すようにしたら治す必要がありまーす
    [[[EditLog alloc] init] deleteLogData];
}

- (IBAction)extendButton_down:(id)sender {
}
@end
