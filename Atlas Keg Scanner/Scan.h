//
//  Scan.h
//  Atlas Keg Scanner
//
//  Created by Family on 5/17/15.
//  Copyright (c) 2015 Westglenn Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Scan : NSObject<NSCoding>
@property NSString *scanValue;
@property NSDate *scanDateTime;
@end
