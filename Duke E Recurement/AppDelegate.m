//
//  AppDelegate.m
//  Duke E Recurement
//
//  Created by Waqas Butt on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "MainScreenVC.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize navController;

- (void)dealloc
{
    [darkView release];
    [navController release];
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[MainScreenVC alloc] initWithNibName:@"MainScreenVC" bundle:nil] autorelease];
    navController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    [self initDarkView];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)initDarkView{
    darkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    darkView.backgroundColor = [UIColor darkGrayColor];
    
    UIActivityIndicatorView *myIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	myIndicator.center = CGPointMake(500, 370);
    [myIndicator startAnimating];
	myIndicator.hidesWhenStopped = NO;
ç
    [darkView addSubview:myIndicator];
    [myIndicator release];
    
}
-(void)addDarkView{
    [self.navController.view addSubview:darkView];
    
}
-(void)removeDarkView{
    [darkView removeFromSuperview];
    
}


@end
