//
//  MainScreenVC.m
//  Duke E Recurement
//
//  Created by Waqas Butt on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainScreenVC.h"
#import "BLController.h"
#import "SearchStudentView.h"
#import "EventAttendeesView.h"
#import "LoginVC.h"
#import "EventBO.h"
#import "QRCodeView.h"
#import "KeychainItemWrapper.h"

@implementation MainScreenVC

@synthesize currentSelectedRow;
@synthesize eventsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark 
#pragma mark View Controller Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    NSString *loginStatus =[[NSUserDefaults standardUserDefaults] objectForKey:@"isLoggedIn"];
    NSLog(@"LoginStatus%@",loginStatus);
    if([loginStatus isEqualToString:@"YES"]){
        
    }
    else {
        LoginVC *loginVc = [[LoginVC alloc]initWithNibName:@"LoginVC" bundle:nil];
        [self.navigationController pushViewController:loginVc animated:YES];
        [loginVc release];
        loginVc = nil;
    }
    
    [studentListBtn setImage:[UIImage imageNamed:kStudentListBtn] forState:UIControlStateNormal];
    [checkinStudentBtn setImage:[UIImage imageNamed:kCheckInStudentBtnHighlighted] forState:UIControlStateNormal];
    currentSelectedRow = -1;
    eventWelcomeView.frame = CGRectMake(306, 106, 718, 643); 
    [self.view addSubview:eventWelcomeView];
    
    [self loadSchoolLogo];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString * name = [[NSUserDefaults standardUserDefaults] objectForKey:kUserID];
    
    userName.text= [NSString stringWithFormat:@"Welcome %@",name];
    if(eventsArray ==nil || [eventsArray count]<=0){
        [self.view addSubview:darkView];
        [activityView startAnimating];
        [self performSelectorInBackground:@selector(getEventList) withObject:nil];   
    }
    eventSelectedView.hidden = NO;
    if(currentSelectedRow<0){
        eventSelectedView.hidden = YES;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark 
#pragma mark Get Event List

-(void)getEventList{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"ExperienceCSOLogin" accessGroup:nil];
    NSString *password = [keychainItem objectForKey:kSecValueData];
    NSString *username = [keychainItem objectForKey:kSecAttrAccount];
    
    
	NSDictionary *dict = [BLController getEvents:username :password];
	[self performSelectorOnMainThread:@selector(removeDarkView:) withObject:dict waitUntilDone:NO];
	[pool release];
    
}

-(void)getFutureEventList{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"ExperienceCSOLogin" accessGroup:nil];
    NSString *password = [keychainItem objectForKey:kSecValueData];
    NSString *username = [keychainItem objectForKey:kSecAttrAccount];
    
	NSDictionary *dict = [BLController getFutureEvents:username :password];
	[self performSelectorOnMainThread:@selector(removeDarkView:) withObject:dict waitUntilDone:NO];
	[pool release];
}

-(void)getPastEventList{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"ExperienceCSOLogin" accessGroup:nil];
    NSString *password = [keychainItem objectForKey:kSecValueData];
    NSString *username = [keychainItem objectForKey:kSecAttrAccount];
    
	NSDictionary *dict = [BLController getPastEvents:username :password];
	[self performSelectorOnMainThread:@selector(removeDarkView:) withObject:dict waitUntilDone:NO];
	[pool release];
}

-(void)removeDarkView:(NSDictionary*) results{
    
    [activityView stopAnimating];
	[darkView removeFromSuperview];
	if ([results objectForKey:FailureKey]) 
	{		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:@"No Record Found."
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
        eventsArray = [[NSMutableArray alloc]init];
        eventsArray = [results objectForKey:SuccessKey];
        [eventTableView reloadData];
	}
    
}

#pragma mark 
#pragma mark Rotation Controll


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        return YES;
    }
    return NO;
}


#pragma mark 
#pragma mark IBActions

-(IBAction)studentCheckinBtnPressed:(id)sender{
    NSString *status = [[NSUserDefaults standardUserDefaults]  objectForKey:@"shouldRemove"];
    if([status isEqualToString:@"YES"]){
        [checkinInputView removeKeyBoard];
    }
    [searchTxtField resignFirstResponder];
    [studentListBtn setImage:[UIImage imageNamed:kStudentListBtn] forState:UIControlStateNormal];
    [checkinStudentBtn setImage:[UIImage imageNamed:kCheckInStudentBtnHighlighted] forState:UIControlStateNormal];
    isStudentListSelected = NO;
    [eventWelcomeView removeFromSuperview];
    
    eventWelcomeView.frame = CGRectMake(306, 106, 718, 643);
    [self.view addSubview:eventWelcomeView];
    
    if(currentSelectedRow>=0){
        eventSelectedView.hidden=NO;
        EventBO *temp = [eventsArray objectAtIndex:currentSelectedRow];
        selectedEventName.text = [NSString stringWithFormat:temp.eventName];
    }
    
}

-(IBAction)useKeyPadBtnPressed:(id)sender{
    
    [searchTxtField resignFirstResponder];
    checkinInputView = (CheckinInputView*)[CheckinInputView loadInstanceFromNib];
    checkinInputView.frame = CGRectMake(306, 106, 718, 643);
    EventBO *temp = [eventsArray objectAtIndex:currentSelectedRow];
    checkinInputView.eventID = [NSString stringWithFormat:@"%i",temp.eventID];
    NSLog(@"%@",checkinInputView.eventID);
    checkinInputView.eventName = temp.eventName;
    [checkinInputView populateData];
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"shouldRemove"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.view addSubview:checkinInputView];

    
}

-(IBAction)QRCodeBtnPressed:(id)sender{
    [searchTxtField resignFirstResponder];
    if(qrCode==nil){
        qrCode = [QRCodeView loadInstanceFromNib];
        qrCode.frame = CGRectMake(306, 106, 718, 643);
        [self.view addSubview:qrCode];
        [qrCode populateData];
    }
    
    
    EventBO *temp = [eventsArray objectAtIndex:currentSelectedRow];
    
    qrCode.eventID = [NSString stringWithFormat:@"%i",temp.eventID];
    NSLog(@"%@",qrCode.eventID);
    qrCode.eventName = temp.eventName;
    qrCode.hidden = NO;
    [self.view addSubview:qrCode];

    [qrCode populateEventName]; 

    
}

-(IBAction)logoutBtnPressed:(id)sender{
    if(isStudentListSelected == YES){
        [eventAttendeeView removeFromSuperview]; 
    }
    NSString *status = [[NSUserDefaults standardUserDefaults]  objectForKey:@"shouldRemove"];
    if([status isEqualToString:@"YES"]){
        [checkinInputView removeKeyBoard];
        [checkinInputView removeFromSuperview];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"shouldRemove"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [searchTxtField resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] setValue:@"NO" forKey:@"isLoggedIn"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSString *loginStatus =[[NSUserDefaults standardUserDefaults] objectForKey:@"isLoggedIn"];
    
    
    NSLog(@"LoginStatus%@",loginStatus);
    if([loginStatus isEqualToString:@"NO"]){
         isStudentListSelected = NO;
        searchTxtField.text = @"";
        currentSelectedRow = -1;
        [eventsArray removeAllObjects];
        [eventTableView reloadData];
        LoginVC *loginVc = [[LoginVC alloc]initWithNibName:@"LoginVC" bundle:nil];
        [self.navigationController pushViewController:loginVc animated:YES];
        [loginVc release];
        loginVc = nil;
    }
        
}

-(IBAction)studentListBtnPressed:(id)sender{
    NSString *status = [[NSUserDefaults standardUserDefaults]  objectForKey:@"shouldRemove"];
    if([status isEqualToString:@"YES"]){
        [checkinInputView removeKeyBoard];
    }
    [searchTxtField resignFirstResponder];
    isStudentListSelected = YES;
    [studentListBtn setImage:[UIImage imageNamed:kStudentListBtnHighlighted] forState:UIControlStateNormal];
    [checkinStudentBtn setImage:[UIImage imageNamed:kCheckInStudentBtn] forState:UIControlStateNormal];
    if(currentSelectedRow>=0){
        [self.view addSubview:darkView];
        [activityView startAnimating];
        [self performSelectorInBackground:@selector(getEventAttendees) withObject:nil];
    }
    else {
        
        eventAttendeeView = (EventAttendeesView*)[EventAttendeesView loadInstanceFromNib];
        eventAttendeeView.frame = CGRectMake(306, 106, 718, 643);

        eventAttendeeView.eventID = [NSString stringWithFormat:@"%i",-1];
        [self.view addSubview:eventAttendeeView];
                
    }
    
}

-(IBAction)searchBtnPressed:(id)sender{
    [searchTxtField resignFirstResponder];
    NSString *search = searchTxtField.text;
    if(search==nil||[search isEqualToString:@""]){
    }
    else {
        [self.view addSubview:darkView];
        [activityView startAnimating];
        [self performSelectorInBackground:@selector(performSearch) withObject:nil];
    }
}

-(IBAction)todayEventsButtonPressed:(id)sender
{
    [self.view addSubview:darkView];
    [activityView startAnimating];
    [self performSelectorInBackground:@selector(getEventList) withObject:nil];  

}

-(IBAction)futureEventsButtonPressed:(id)sender
{
    [self.view addSubview:darkView];
    [activityView startAnimating];
    [self performSelectorInBackground:@selector(getFutureEventList) withObject:nil];  
}

-(IBAction)pastEventsButtonPressed:(id)sender  
{
    [self.view addSubview:darkView];
    [activityView startAnimating];
    [self performSelectorInBackground:@selector(getPastEventList) withObject:nil]; 
}

#pragma mark 
#pragma mark TableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellId = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellId];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
    }
    if([eventsArray count]>0){
        EventBO *temp = [eventsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:temp.eventName];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.highlightedTextColor = [UIColor greenColor];
    cell.backgroundView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"Cell-bg.png"]] autorelease];
    cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"Cell-bg.png"]] autorelease];

    
    UIImageView *disclosureImage = [[UIImageView alloc] initWithImage:nil];
    [disclosureImage setHighlightedImage:[UIImage imageNamed:@"green-arrow.png"]];
    disclosureImage.frame = CGRectMake(290.0, 24.0, 11.0,15.0);
    [cell.contentView addSubview:disclosureImage];
    [disclosureImage release];
    
    return cell;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rowCount = [eventsArray count];
    if(rowCount>100){
        return  100; 
    }
    return rowCount;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [searchTxtField resignFirstResponder];
    NSString *status = [[NSUserDefaults standardUserDefaults]  objectForKey:@"shouldRemove"];
    if([status isEqualToString:@"YES"]){
        [checkinInputView removeKeyBoard];
    }
    
    if(isStudentListSelected==NO){
        self.currentSelectedRow = indexPath.row;
        if(indexPath.row>=0){
            eventSelectedView.hidden = NO;
        }
        if([eventsArray count]>0){
            EventBO *temp = [eventsArray objectAtIndex:indexPath.row];
            selectedEventName.text = [NSString stringWithFormat:temp.eventName];
            
            [eventWelcomeView removeFromSuperview];
            
            eventWelcomeView.frame = CGRectMake(306, 106, 718, 643); 
            [self.view addSubview:eventWelcomeView];

        }
    }
    else {
        
        if(self.currentSelectedRow!=indexPath.row){
            self.currentSelectedRow = indexPath.row;
            [self.view addSubview:darkView];
            [activityView startAnimating];
            [self performSelectorInBackground:@selector(getEventAttendees) withObject:nil];
        }
    }
    
    
    
}


#pragma mark 
#pragma mark Search Module


-(void)performSearch{
    /*
     if option = 0 search by first name
     if option = 1 search by last name
     if option = 2 search by first name and last name 
     */
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSString *searchText = searchTxtField.text;
    
    int eventID = 123;
    
    if(currentSelectedRow>=0){
        EventBO *temp = [eventsArray objectAtIndex:currentSelectedRow];
        eventID = temp.eventID;
    }
    
	NSDictionary *dict = [BLController getStudent:searchText lastName:@"" andEventID:eventID withOption:0];
	[self performSelectorOnMainThread:@selector(removeOverLay:) withObject:dict waitUntilDone:NO];
	[pool release];
    
}

-(void)removeOverLay:(NSDictionary*) results{    
    
    [activityView stopAnimating];
	[darkView removeFromSuperview];
	if ([results objectForKey:FailureKey]) 
	{		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:@"No Student Found."
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
        
        [searchStudentView removeFromSuperview];
        searchStudentView = (SearchStudentView*)[SearchStudentView loadInstanceFromNib];
        
        searchStudentView.eventID = -1;
        if(currentSelectedRow>=0){
            EventBO *tempBO = [eventsArray objectAtIndex:currentSelectedRow];
            searchStudentView.eventID = tempBO.eventID;
        }
        searchStudentView.studentArray = [results objectForKey:SuccessKey];
        NSLog(@"Count of Student Array :%i",[searchStudentView.studentArray count]);
        searchStudentView.frame = CGRectMake(306, 106, 718, 643);
        [self.view addSubview:searchStudentView];
		
	}
    
    
}


#pragma mark 
#pragma mark Event Attendees


-(void)getEventAttendees{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int eventID = 0;
    if([eventsArray count]>0&&currentSelectedRow>=0){
        EventBO *temp = [eventsArray objectAtIndex:currentSelectedRow];
        eventID = temp.eventID;
    }
    NSLog(@"EventID %i",eventID);
	NSDictionary *dict = [BLController getEventAttendees:eventID];
	[self performSelectorOnMainThread:@selector(handleGetEventAttendeesResponse:) withObject:dict waitUntilDone:NO];
	[pool release];
    
}

-(void)handleGetEventAttendeesResponse:(NSDictionary*) results{    
    
    [activityView stopAnimating];
	[darkView removeFromSuperview];
	if ([results objectForKey:FailureKey]) 
	{		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" 
														message:@"No Attendees Found."
                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
        
        [eventAttendeeView removeFromSuperview];
        eventAttendeeView = (EventAttendeesView*)[EventAttendeesView loadInstanceFromNib];
        eventAttendeeView.frame = CGRectMake(306, 106, 718, 643);
        eventAttendeeView.eventID = [NSString stringWithFormat:@"%i",-1];
        NSLog(@"%@",eventAttendeeView.eventID);
        [self.view addSubview:eventAttendeeView];
        [eventAttendeeView reloadData];
	}
	else if ([results objectForKey:Errorkey]) {
        
		NSError *error=[results objectForKey:Errorkey];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" 
														message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
        

        [eventAttendeeView removeFromSuperview];
        eventAttendeeView = (EventAttendeesView*)[EventAttendeesView loadInstanceFromNib];
        eventAttendeeView.frame = CGRectMake(306, 106, 718, 643);
        eventAttendeeView.eventID = [NSString stringWithFormat:@"%i",-1];
        NSLog(@"%@",eventAttendeeView.eventID);
        [self.view addSubview:eventAttendeeView];
        [eventAttendeeView reloadData];
		
	}
	else
	{	

        [eventAttendeeView removeFromSuperview];
        eventAttendeeView = (EventAttendeesView*)[EventAttendeesView loadInstanceFromNib];
        eventAttendeeView.frame = CGRectMake(306, 106, 718, 643);
        EventBO *temp = [eventsArray objectAtIndex:currentSelectedRow];
        NSLog(@"TEmp.eventId %i",temp.eventID);
        eventAttendeeView.eventID = [NSString stringWithFormat:@"%i",temp.eventID];
        eventAttendeeView.attendeesArray = [results objectForKey:SuccessKey];
        [self.view addSubview:eventAttendeeView];
        [eventAttendeeView reloadData];
	}
}

#pragma mark 
#pragma mark loadSchoolLogo
-(void) loadSchoolLogo
{
    NSDictionary *responseDict = [BLController getSchoolLogo];
    NSString *path =[responseDict valueForKey:SuccessKey];
    NSLog(@"Logo Image path is: %@",path);
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    logoImageView.image = img;

}


#pragma mark 
#pragma mark dealloc

-(void)dealloc{
    [eventsArray release];
    eventsArray = nil;
    [super dealloc];
    
}
@end
