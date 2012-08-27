//
//  FirstHelpViewController.m
//  CempeiChokin
//
//  Created by CEMPEI on 12/08/01.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import "FirstHelpViewController.h"

@interface FirstHelpViewController ()

@end

@implementation FirstHelpViewController

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
    
    //アラートの表示
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ヘルプ"
                                                    message:@"せんちょをダウンロードして頂き，ありがとうございます．\nこのアプリはあなたの貯金をサポートするためにあります．これから，一緒に頑張っていきましょう！\nお気づきの点があれば，Twitterアカウント(@CEMPEI_official)までお知らせください．"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIAlertView関係
// アラートビューのボタンの動作
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Init"] animated:NO]; // 貯金画面へ移動する
}

@end
