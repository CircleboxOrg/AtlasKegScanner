//
//  ScanEditControllerViewController.m
//  Atlas Keg Scanner
//
//  Created by Family on 5/25/15.
//  Copyright (c) 2015 Westglenn Software. All rights reserved.
//

#import "ScanEditViewController.h"

@interface ScanEditViewController ()

@end

@implementation ScanEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    self.scanEdit.text = self.scan.scanValue;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)updateClick:(id)sender {
    self.scan.scanValue = self.scanEdit.text;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
