//
//  OptionViewController.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//
#import "AppDelegate.h"
#import "OptionViewController.h"

@interface OptionViewController (){
    AppDelegate *appDelegate;
    Methods *_method;
}

@end

@implementation OptionViewController

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
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    deleteDataButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)deleteDataButton_down:(id)sender {
    [_method deleteData];
    // TODO: データ渡すようにしたら治す必要がありまーす
    [appDelegate.editLog deleteLogData];
    [appDelegate.editData deleteData];
    [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"MainView"] animated:YES];
}


#pragma mark - Storyboardで画面遷移する前に呼ばれるあれ
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showGoalView"]) {
        //FIXME:ここでデータを渡すといいんじゃないか
    }
    if ([segue.identifier isEqualToString:@"showBudgetView"]) {
        //FIXME:ここでデータを渡すといいんじゃないか
    }
}

@end
