//
//  AppDelegate.m
//  Atlas Keg Scanner
//
//  Created by Family on 5/17/15.
//  Copyright (c) 2015 Westglenn Software. All rights reserved.
//

#import "AppDelegate.h"

#import "ScanSet.h"
@interface AppDelegate ()

@end

@implementation AppDelegate {
    NSMutableArray *_scanSets;
}

- (NSMutableArray *)scanSets {
    if (!_scanSets){
        _scanSets = [[NSMutableArray alloc] init];
        // go ahead and put 1 member in it
        ScanSet *ss;
        ss = [[ScanSet alloc] init];
        ss.scanSetName = @"Set 1";
        [_scanSets addObject:ss];
    }
    return _scanSets;
}

- (void)setScanSets:(NSMutableArray *)arr {
    _scanSets = arr;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self restoreData];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self saveData];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveData];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self restoreData];
    
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self restoreData];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveData];
}

- (void)saveData {
    //only save if scanSets is not nil
    //check backing variable, not property - checking property initializes if nil
    if (_scanSets != nil)
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSData* myData = [NSKeyedArchiver archivedDataWithRootObject:[self scanSets]];
        [defaults setObject:myData forKey:@"scanSetsArray"];
        [defaults synchronize];
    }
}

- (void)restoreData {
    // only restore if scanSets is nil
    //check backing variable, not property - checking property initializes if nil
    if (_scanSets == nil)
    {
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSData* myData = [defaults objectForKey:@"scanSetsArray"];
        //_scanSets = [NSKeyedUnarchiver unarchiveObjectWithData:myData];
        // only update if myData is not nil
        if (myData != nil)
        {
            self.scanSets = [NSKeyedUnarchiver unarchiveObjectWithData:myData];
        }
    }
}


@end
