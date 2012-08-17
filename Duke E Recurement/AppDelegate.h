//
//  AppDelegate.h
//  Duke E Recurement
//
//  Created by Waqas Butt on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainScreenVC;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UIView *darkView;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainScreenVC *viewController;
@property (strong,nonatomic) UINavigationController *navController;

-(void)initDarkView;
-(void)addDarkView;
-(void)removeDarkView;

@end
