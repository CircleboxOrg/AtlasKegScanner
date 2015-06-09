//
//  ViewController.h
//  Atlas Keg Scanner
//
//  Created by Family on 5/17/15.
//  Copyright (c) 2015 Westglenn Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>

@property(nonatomic, strong) IBOutlet UITableView *tableView;

@end

