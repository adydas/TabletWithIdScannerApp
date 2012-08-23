//
//  EventAttendeesView.m
//  Duke E Recurement
//
//  Created by Waqas Butt on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventAttendeesView.h"
#import "StudentBO.h"
#import "BLController.h"
#import "AttendeeCustomCell.h"

@implementation EventAttendeesView
@synthesize eventAttendeeCell;
@synthesize eventName,eventID,attendeesArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+(EventAttendeesView*) loadInstanceFromNib { 
    EventAttendeesView *result = nil; 
    NSArray* elements = [[NSBundle mainBundle] loadNibNamed:@"EventAttendeesView" owner:self options:nil];
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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *MyIdentifier = @"CustomCell";
    AttendeeCustomCell *cell = (AttendeeCustomCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"AttendeeCustomCell" owner:self options:nil];
		cell = eventAttendeeCell;
		self.eventAttendeeCell = nil;
	} 
    
    cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"Table-View-slcted-cell.png"]] autorelease];
    
    [cell populateData:[attendeesArray objectAtIndex:indexPath.row]];
    return cell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([attendeesArray count]<=0){
        return 0;
    }
    return [attendeesArray count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    currentSelectedIndex = indexPath.row;
    
}

-(IBAction)checkedinBtnPressed:(id)sender{
    
    UIButton *tempBtn = (UIButton *)sender;
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    [delegate addDarkView];
    
    for(int i = 0; i <[self.attendeesArray count];i++){
        StudentBO *tempBO = [self.attendeesArray objectAtIndex:i];
        if(tempBO.studentID==tempBtn.tag){
            currentSelectedIndex = i;
            break;
        }
    }
    sID = tempBtn.tag;
    
    [self performSelectorInBackground:@selector(performCheckinWithStudentID) withObject:nil];
    
    
}

-(void)performCheckinWithStudentID{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSDictionary *dict = [BLController checkInStudent:[eventID intValue] withUserID:sID andEmailAddress:@""];
	[self performSelectorOnMainThread:@selector(handleCheckinResponse:) withObject:dict waitUntilDone:NO];
	[pool release];
    
}

-(void)handleCheckinResponse:(NSDictionary*) results{    
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    [delegate removeDarkView];
    
	if ([results objectForKey:FailureKey]) 
	{		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" 
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation" 
														message:[results objectForKey:SuccessKey]
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
        
        StudentBO *tempBO = [attendeesArray objectAtIndex:currentSelectedIndex];
        tempBO.check_in = @"YES";
        [attendeesArray replaceObjectAtIndex:currentSelectedIndex withObject:tempBO];
	
        [attendeesTable reloadData];
        
        
	}
    
    
}

-(void)reloadData{
    if([eventID intValue] ==-1){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:@"Please Select an Event from left menu."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
    else if([attendeesArray count]<=0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:@"There is no Student Attending this Event."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
    }
    else {
        [attendeesTable reloadData];
    }

    
}




@end
