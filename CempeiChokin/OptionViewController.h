//
//  OptionViewController.h
//  CempeiChokin
//
//  Created by CEMPEI on 12/07/25.
//  Copyright (c) 2012年 CEMPEI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Methods.h"

@interface OptionViewController : UITableViewController{
    
    __weak IBOutlet UIButton *deleteDataButton;
}
- (IBAction)deleteDataButton_down:(id)sender;

@end
