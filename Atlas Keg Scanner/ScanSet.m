//
//  ScanSet.m
//  Atlas Keg Scanner
//
//  Created by Family on 5/17/15.
//  Copyright (c) 2015 Westglenn Software. All rights reserved.
//

#import "ScanSet.h"

@implementation ScanSet

- (id) init {
    self = [super init];
    if (self)
    {
        self.scans = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void) encodeWithCoder: (NSCoder *) encoder
{
    [encoder encodeObject: _scanSetName];
    NSData* myData = [NSKeyedArchiver archivedDataWithRootObject:_scans];
    [encoder encodeObject: myData];
}

-(id) initWithCoder: (NSCoder *) decoder
{
    _scanSetName = [decoder decodeObject];
    NSData* myData = [decoder decodeObject];
    _scans = [NSKeyedUnarchiver unarchiveObjectWithData:myData];
    return self;
}
@end
