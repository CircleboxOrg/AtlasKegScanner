//
//  ScanEditControllerViewController.h
//  Atlas Keg Scanner
//
//  Created by Family on 5/25/15.
//  Copyright (c) 2015 Westglenn Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Scan.h"
@interface ScanEditViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *scanEdit;
@property (nonatomic, strong) Scan *scan;
@end
