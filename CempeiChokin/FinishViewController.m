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

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate = APP_DELEGATE;
    
    _method = [Methods alloc];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Storyboardで画面遷移する前に呼ばれるあれ
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

- (IBAction)nextButton_down:(id)sender {
    [_method deleteData];
    // TODO: データ渡すようにしたら治す必要がありまーす
    [appDelegate.editLog deleteLogData];
    [appDelegate.editData deleteData];
}

- (IBAction)extendButton_down:(id)sender {
    DNSLog(@"あきらめません！");
}
@end
