//
//  FirstHelpViewController.m
//  CempeiChokin
//
//  Created by 中野 麻美 on 12/08/01.
//  Copyright (c) 2012年 Nakano Asami. All rights reserved.
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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    DoneButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)DoneButton_down:(id)sender {
    
    [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"Init"] animated:NO];
}
@end
