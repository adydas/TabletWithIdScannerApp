//
//  SearchStudentView.m
//  Duke E Recurement
//
//  Created by Waqas Butt on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchStudentView.h"
#import "StudentBO.h"
#import "BLController.h"
#import "MainScreenVC.h"
#import "CustomStudentCell.h"
#import "AppDelegate.h"

@implementation SearchStudentView

@synthesize CheckInCell;
@synthesize eventID;

@synthesize studentArray;


+(SearchStudentView*) loadInstanceFromNib { 
    SearchStudentView *result = nil; 
    NSArray* elements = [[NSBundle mainBundle] loadNibNamed:@"SearchStudentView" owner:self options:nil];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *MyIdentifier = @"SearchCustomCell";
    CustomStudentCell *cell = (CustomStudentCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"CustomStudentCell" owner:self options:nil];
		cell = CheckInCell;
		self.CheckInCell = nil;
	} 
    
    cell.selectedBackgroundView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed:@"Table-View-slcted-cell.png"]] autorelease];
    
    [cell populateData:[studentArray objectAtIndex:indexPath.row]];
    
   
    
    return cell;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.studentArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    currentSelectedIndex = indexPath.row;
    NSLog(@"currentSelectedIndex%i",currentSelectedIndex);
    
}

-(IBAction)checkedinBtnPressed:(id)sender{
    
    UIButton *tempBtn = (UIButton *)sender;
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    [delegate addDarkView];
    
    for(int i = 0; i <[self.studentArray count];i++){
        StudentBO *tempBO = [self.studentArray objectAtIndex:i];
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
	NSDictionary *dict = [BLController checkInStudent:eventID withUserID:sID andEmailAddress:@""];
	[self performSelectorOnMainThread:@selector(handleCheckinResponse:) withObject:dict waitUntilDone:NO];
	[pool release];
    
}

-(void)handleCheckinResponse:(NSDictionary*) results{    
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    [delegate removeDarkView];
    
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
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation" 
														message:[results objectForKey:SuccessKey]
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
        
        StudentBO *tempBO = [self.studentArray objectAtIndex:currentSelectedIndex];
        tempBO.check_in = @"YES";
        [self.studentArray replaceObjectAtIndex:currentSelectedIndex withObject:tempBO];
        
        [studentTable reloadData];
		
	}
    
    
}




@end
