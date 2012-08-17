//
//  LoginVC.m
//  Duke E Recurement
//
//  Created by Waqas Butt on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginVC.h"
#import "BLController.h"
#import "MainScreenVC.h"

@implementation LoginVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        return YES;
    }
    return NO;
}

-(void)performLogin{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *user = username.text;
    NSString *pass = password.text;
	NSDictionary *dict = [BLController userLogin:user :pass];
	[self performSelectorOnMainThread:@selector(removeOverLay:) withObject:dict waitUntilDone:NO];
	[pool release];
    
}

-(void)removeOverLay:(NSDictionary*) results{    
    
    [activityView stopAnimating];
	[darkView removeFromSuperview];
	if ([results objectForKey:FailureKey]) 
	{		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:@"Invalid Username or Password."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else if ([results objectForKey:Errorkey]) {
		NSError *error=[results objectForKey:Errorkey];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];     
		
	}
	else
	{	
        [self.navigationController popViewControllerAnimated:YES];
	}
    
    
}



-(IBAction)loginBtnPressed:(id)sender{
    NSString *user = username.text;
    NSString *pass = password.text;
    
    if(user==nil||[user isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:@"Username cannot be empty."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
    
    else if(pass==nil||[pass isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:@"Password cannot be empty."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
    else {
        [self.view addSubview:darkView];
        [activityView startAnimating];
        [self performSelectorInBackground:@selector(performLogin) withObject:nil];
    }
    
}

-(IBAction)forgotPasswordBtnPressed:(id)sender{
    
}

@end
