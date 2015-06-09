//
//  Barcode.h
//  Atlas Keg Scanner
//
//  Created by Family on 5/21/15.
//  Copyright (c) 2015 Westglenn Software. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

@interface Barcode : NSObject

+ (Barcode * )processMetadataObject:(AVMetadataMachineReadableCodeObject*) code;
- (NSString *) getBarcodeType;
- (NSString *) getBarcodeData;
- (void) printBarcodeData;
@end
