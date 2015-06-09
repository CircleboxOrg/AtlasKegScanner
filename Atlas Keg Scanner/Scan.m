//
//  Scan.m
//  Atlas Keg Scanner
//
//  Created by Family on 5/17/15.
//  Copyright (c) 2015 Westglenn Software. All rights reserved.
//

#import "Scan.h"

@implementation Scan

-(void) encodeWithCoder: (NSCoder *) encoder
{
    [encoder encodeObject: _scanValue];
    [encoder encodeObject: _scanDateTime];
    
}

-(id) initWithCoder: (NSCoder *) decoder
{
    _scanValue = [decoder decodeObject];
    _scanDateTime = [decoder decodeObject];
    return self;
}
@end
