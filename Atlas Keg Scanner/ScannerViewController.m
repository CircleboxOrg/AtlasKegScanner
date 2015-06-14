//
//  ScannerViewController.m
//  Atlas Keg Scanner
//
//  Created by Family on 5/21/15.
//  Copyright (c) 2015 Westglenn Software. All rights reserved.
//

#import "ScannerViewController.h"
#import <UIKit/UIKit.h>

#import "Barcode.h"
#import "Scan.h"
@import AVFoundation;
#import <AudioToolbox/AudioToolbox.h>
@interface ScannerViewController ()


@property (weak, nonatomic) IBOutlet UIView *previewView;

@end

@implementation ScannerViewController {
    /* Here’s a quick rundown of the instance variables (via 'iOS 7 By Tutorials'):
     
     1. _captureSession – AVCaptureSession is the core media handling class in AVFoundation. It talks to the hardware to retrieve, process, and output video. A capture session wires together inputs and outputs, and controls the format and resolution of the output frames.
     
     2. _videoDevice – AVCaptureDevice encapsulates the physical camera on a device. Modern iPhones have both front and rear cameras, while other devices may only have a single camera.
     
     3. _videoInput – To add an AVCaptureDevice to a session, wrap it in an AVCaptureDeviceInput. A capture session can have multiple inputs and multiple outputs.
     
     4. _previewLayer – AVCaptureVideoPreviewLayer provides a mechanism for displaying the current frames flowing through a capture session; it allows you to display the camera output in your UI.
     5. _running – This holds the state of the session; either the session is running or it’s not.
     6. _metadataOutput - AVCaptureMetadataOutput provides a callback to the application when metadata is detected in a video frame. AV Foundation supports two types of metadata: machine readable codes and face detection.
     7. _backgroundQueue - Used for showing alert using a separate thread.
     */
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_videoDevice;
    AVCaptureDeviceInput *_videoInput;
    AVCaptureVideoPreviewLayer *_previewLayer;
    BOOL _running;
    AVCaptureMetadataOutput *_metadataOutput;
}
//@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setupCaptureSession];
    _previewLayer.frame = _previewView.bounds;
    [_previewView.layer addSublayer:_previewLayer];
    
    // listen for going into the background and stop the session
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillEnterForeground:)
     name:UIApplicationWillEnterForegroundNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationDidEnterBackground:)
     name:UIApplicationDidEnterBackgroundNotification
     object:nil];
    
    // set default allowed barcode types, remove types via setings menu if you don't want them to be able to be scanned
    self.allowedBarcodeTypes = [NSMutableArray new];
        NSString *reqSysVer = @"8.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
        [self.allowedBarcodeTypes addObject:@"org.iso.DataMatrix"];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startRunning];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopRunning];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - AV capture methods

- (void)setupCaptureSession {
    // 1
    if (_captureSession) return;
    //[_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    // 2
    _videoDevice = [AVCaptureDevice
                    defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!_videoDevice) {
        NSLog(@"No video camera on this device!");
        return;
    }
    // 3
    _captureSession = [[AVCaptureSession alloc] init];
    // 4
    _videoInput = [[AVCaptureDeviceInput alloc]
                   initWithDevice:_videoDevice error:nil];
    // 5
    if ([_captureSession canAddInput:_videoInput]) {
        [_captureSession addInput:_videoInput];
    }
    // 6
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc]
                     initWithSession:_captureSession];
    _previewLayer.videoGravity =
    AVLayerVideoGravityResizeAspectFill;
    
    
    // capture and process the metadata
    _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t metadataQueue = dispatch_queue_create("com.westglenn.barcode.queue", DISPATCH_QUEUE_SERIAL);
    [_metadataOutput setMetadataObjectsDelegate:self queue:metadataQueue];
    if ([_captureSession canAddOutput:_metadataOutput]) {
        [_captureSession addOutput:_metadataOutput];
    }
}

- (void)startRunning {
    if (_running) return;
    [_captureSession startRunning];
    _metadataOutput.metadataObjectTypes =
    _metadataOutput.availableMetadataObjectTypes;
    _running = YES;
}
- (void)stopRunning {
    if (!_running) return;
    [_captureSession stopRunning];
    _running = NO;
}

//  handle going foreground/background
- (void)applicationWillEnterForeground:(NSNotification*)note {
    [self startRunning];
}
- (void)applicationDidEnterBackground:(NSNotification*)note {
    [self stopRunning];
}



#pragma mark - Delegate functions

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    [metadataObjects
     enumerateObjectsUsingBlock:^(AVMetadataObject *obj,
                                  NSUInteger idx,
                                  BOOL *stop)
     {
         if ([obj isKindOfClass:
              [AVMetadataMachineReadableCodeObject class]])
         {
             // 3
             AVMetadataMachineReadableCodeObject *code =
             (AVMetadataMachineReadableCodeObject*)
             [_previewLayer transformedMetadataObjectForMetadataObject:obj];
             // 4
             Barcode * barcode = [Barcode processMetadataObject:code];
             
             for(NSString * str in self.allowedBarcodeTypes){
                 if([barcode.getBarcodeType isEqualToString:str]){
                     [self validBarcodeFound:barcode];
                     return;
                 }
             }
         }
     }];
}
- (void) validBarcodeFound:(Barcode *)barcode{
    [self stopRunning];
    
    
    Scan *s;
    s = [[Scan alloc] init];
    s.scanValue = [barcode getBarcodeData];
    
    // don't add value already in list
    BOOL found = FALSE;
    for (id val in self.scanSet.scans) {
        Scan *oldScan = (Scan *)val;
        if ([oldScan.scanValue isEqualToString:s.scanValue])
            found = TRUE;
    }
        
    if (!found) {
        [self.scanSet.scans addObject:s];
        
        AudioServicesPlaySystemSound (1007);
    } else {
        AudioServicesPlaySystemSound (1016);
    }
    // sleep for 1 second
    [NSThread sleepForTimeInterval:1.0f];
    //prepare for next scan
    [self startRunning];
    // don't exit until cancel
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)manualScanAdd:(id)sender {
    [self stopRunning];
    
    Scan *s;
    s = [[Scan alloc] init];
    s.scanValue = self.manualScanText.text;
    [self.scanSet.scans addObject:s];
    // refresh parent list data
    //[self.delegate refreshData];
    //[self.navigationController popViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cancelClick:(id)sender {
    [self stopRunning];
    
    //_audioPlayer play];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(IBAction) manualClicked
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Manual Entry" message:@"Enter code:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    
    alertTextField.placeholder = @"Enter code";
    
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        
        [self stopRunning];
        
        
        Scan *s;
        s = [[Scan alloc] init];
        s.scanValue = [[alertView textFieldAtIndex:0] text];
        
        // don't add value already in list
        BOOL found = FALSE;
        for (id val in self.scanSet.scans) {
            Scan *oldScan = (Scan *)val;
            if ([oldScan.scanValue isEqualToString:s.scanValue])
                found = TRUE;
        }
        
        if (!found) {
            [self.scanSet.scans addObject:s];
            
            AudioServicesPlaySystemSound (1007);
        } else {
            AudioServicesPlaySystemSound (1016);
        }
        //prepare for next scan
        [self startRunning];
        // don't exit until cancel
        //[self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

@end
