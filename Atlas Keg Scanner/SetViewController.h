//
//  SetViewController.h
//  Atlas Keg Scanner
//
//  Created by Family on 5/21/15.
//  Copyright (c) 2015 Westglenn Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanSet.h"
#import "Scan.h"
#import "ScannerViewController.h"
#import "ScanEditViewController.h"
#import <MessageUI/MessageUI.h>

@interface SetViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
    //, ChildViewControllerDelegate>

@property (nonatomic, strong) ScanSet *scanSet;
@property (weak, nonatomic) IBOutlet UITextField *scanSetName;
- (void) refreshData;
@end
