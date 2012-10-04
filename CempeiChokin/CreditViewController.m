//
//  CreditViewController.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/08/08.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import "CreditViewController.h"

@interface CreditViewController ()

@end

@implementation CreditViewController

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
    versionLabel.text = [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    //クレジットをフィット
    CGSize result = [[UIScreen mainScreen] bounds].size; //ビューの大きさを取ってくる
    
    if(result.height == 568 || result.height == 548)
    {
        //iPhone5のとき
        //セルをのばす
        //licenceCell.
    }
    
}

- (void)viewDidUnload
{
    versionLabel = nil;
    licenceCell = nil;
    licenceTextView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)contactButton_down:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/CEMPEI_official"]];
}

- (IBAction)aboutButton_down:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com/Cempei"]];
}
@end
