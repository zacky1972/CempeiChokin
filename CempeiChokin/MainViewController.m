//
//  MainViewController.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController (){
    Methods *_method;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _method = [Methods alloc];
    
    [LogScroll setScrollEnabled:YES];
    [LogScroll setContentSize:CGSizeMake(320, 900)];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    // 初期設定画面の表示
    if([_method searchGoal] == 0){//初期設定がまだだったら，設定画面に遷移します
    [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Init"] animated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    // TODO:ここに円グラフの描画やら，値のセットが必要．その前にログを表示できるようにせなあかんですな
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView関係
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // TODO: とりあえず一個
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DNSLog(@"Cell for Row :%d",indexPath.row);
    static NSString *CellIdentifier = @"Log";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *logDate      = (UILabel *)[cell viewWithTag:1];
    UILabel *logKind      = (UILabel *)[cell viewWithTag:2];
    UITextField *logValue = (UITextField *)[cell viewWithTag:3];
    
    logDate.text = @"いつだよ！";
    logKind.text = @"出費だよ！";
    logValue.text = @"100円だよ！";
    
    return cell;
}
@end
