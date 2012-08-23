//
//  CheckinInputView.m
//  Duke E Recurement
//
//  Created by Waqas Butt on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CheckinInputView.h"
#import "BLController.h"
#import "StudentBO.h"
#import "SearchStudentView.h"
#import "AppDelegate.h"

@implementation CheckinInputView
@synthesize eventID,eventName;


+(CheckinInputView*) loadInstanceFromNib { 
    CheckinInputView *result = nil; 
    NSArray* elements = [[NSBundle mainBundle] loadNibNamed:@"CheckinInputView" owner:self options:nil];
    for (id anObject in elements) 
    { 
        if ([anObject isKindOfClass:[self class]]) 
        { 
            result = anObject; 
            break; 
        } 
    } 

    return result; 
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setContentSize{
    [scrollView setContentSize:CGSizeMake(673, 500)];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(IBAction)checkInBtnPressed:(id)sender{
    [self removeKeyBoard];
    NSString *studentID = [studentIDTxt text];
    NSString *studentEmail = [emailTxt text];
    NSString *fName = [fNameTxt text];
    NSString *lName = [lNameTxt text];

    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    [delegate addDarkView];

    if([studentID length]>0){
        sID = [[studentIDTxt text] intValue];
        [self performSelectorInBackground:@selector(performCheckinbyStudentID) withObject:nil];
    }
    else if([studentEmail length]>0) {
        [self performSelectorInBackground:@selector(performCheckinbyEmail) withObject:nil];
    }
    else if([fName length]>0&&[lName length]>0){
        
        [self performSelectorInBackground:@selector(performCheckinbyStudentName) withObject:nil];
    }
    else {
        AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
        [delegate removeDarkView];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" 
                                                        message:@"Please fill at least 1 required field."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self populateData];


    }
    
}

-(void)performCheckinbyStudentID{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSLog(@"student id%i",sID);
	NSDictionary *dict = [BLController checkInStudent:[eventID intValue] withUserID:sID andEmailAddress:@""];
	[self performSelectorOnMainThread:@selector(removeOverLay:) withObject:dict waitUntilDone:NO];
	[pool release];
    
}

-(void)performCheckinbyStudentName{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *fName = [fNameTxt text];
    NSString *lName = [lNameTxt text];
    
    NSLog(@"event id%@",eventID);
        
	NSDictionary *dict = [BLController getStudent:fName lastName:lName andEventID:[eventID intValue] withOption:2];
	[self performSelectorOnMainThread:@selector(handleCheckinResponseByName:) withObject:dict waitUntilDone:NO];
	[pool release];
    
}

-(void)performCheckinbyEmail{
  
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *email = [emailTxt text];
    
    
	NSDictionary *dict = [BLController checkInStudent:[eventID intValue] withUserID:0 andEmailAddress:email];
	[self performSelectorOnMainThread:@selector(removeOverLay:) withObject:dict waitUntilDone:NO];
	[pool release];
    
}


-(void)handleCheckinResponseByName:(NSDictionary*) results{

    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    [delegate removeDarkView];

    
    if ([results objectForKey:FailureKey]) 
	{		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" 
														message:@"No Student Found."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
        [self populateData];
	}
	else if ([results objectForKey:Errorkey]) {
		NSError *error=[results objectForKey:Errorkey];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
        [self populateData];
        
		
	}
	else
	{	
        NSArray *tempArray = [results objectForKey:SuccessKey];
        if([tempArray count]<=0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" 
                                                            message:@"Invalid First or Last Name."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
            [self populateData];
            
        }//end if
        else if([tempArray count]==1){
            StudentBO *tempBO = [tempArray objectAtIndex:0];
            sID = tempBO.studentID;
            [self performSelectorInBackground:@selector(performCheckinbyStudentID) withObject:nil];
        }//end else if
        else {
            
            SearchStudentView *tempView = (SearchStudentView*)[SearchStudentView loadInstanceFromNib];
            
            tempView.eventID = [eventID intValue];
            NSLog(@"tempView.eventID %d",tempView.eventID);
            tempView.studentArray = [results objectForKey:SuccessKey];
            NSLog(@"Count of Student Array :%i",[tempView.studentArray count]);
            tempView.frame = CGRectMake(0, 0, 718, 643); 
            [self addSubview:tempView];
        }//end else

	}
    
    
}



-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.tag ==1){
        [scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
    }
    else if(textField.tag ==2){
        [scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
    }
    else if(textField.tag ==3||textField.tag==4){
        [scrollView setContentOffset:CGPointMake(0 , 100) animated:YES];
    }
}




-(void)removeOverLay:(NSDictionary*) results{    

    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    [delegate removeDarkView];

    
    if ([results objectForKey:FailureKey]) 
	{		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" 
														message:@"No Student Found."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
        [self populateData];
	}
	else if ([results objectForKey:Errorkey]) {
		NSError *error=[results objectForKey:Errorkey];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
        [self populateData];
        
		
	}
	else
	{	
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation" 
														message:[results objectForKey:SuccessKey]
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		[self removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"shouldRemove"];
        [[NSUserDefaults standardUserDefaults] synchronize];

	}
    
    
}
-(void)keyboardWillShow {
    
}

-(void)keyboardWillHide {
    
    [scrollView setContentOffset:CGPointMake(0 , 0) animated:YES];
    
}



-(void)populateData{
    qrCodeBtn.Enabled = NO;
    keypadBtn.Enabled = NO;
    eventNameLbl.text= self.eventName;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


- (void)removeKeyBoard{
    
    [scrollView setContentOffset:CGPointMake(0 , 0) animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    [studentIDTxt resignFirstResponder];
    [emailTxt resignFirstResponder];
    [fNameTxt resignFirstResponder];
    [lNameTxt resignFirstResponder];
    
}


-(void)dealloc{
    [eventName release];
    [eventID release];
    eventName=eventID=nil;
    [super dealloc];
}

@end
