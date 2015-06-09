//
//  ScannerViewController.h
//  Atlas Keg Scanner
//
//  Created by Family on 5/21/15.
//  Copyright (c) 2015 Westglenn Software. All rights reserved.
//

@import AVFoundation;
/*
@protocol ChildViewControllerDelegate <NSObject>
- (void)refreshData;
@end
*/
#import <UIKit/UIKit.h>
#import "ScanSet.h"
#import "SetViewController.h"




@interface ScannerViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
@property (strong, nonatomic) NSMutableArray * allowedBarcodeTypes;
@property (nonatomic, strong) ScanSet *scanSet;
//@property (assign) id <ChildViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *manualScanText;

@end
