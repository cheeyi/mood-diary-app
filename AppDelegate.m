//
//  AppDelegate.m
//  Diary
//
//  Created by Chee Yi Ong on 6/20/15.
//  Copyright (c) 2015 Chee Yi Ong. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupAppearance];
    return YES;
}

- (void) setupAppearance { // Get appearance proxy and set bar tint, tint color and title text attributes
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    navigationBarAppearance.barTintColor = [UIColor colorWithRed:29.0/255.0 green:47.0/255.0 blue:66.0/255.0 alpha:1.0];
    navigationBarAppearance.tintColor = [UIColor whiteColor];
    navigationBarAppearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
}

@end
