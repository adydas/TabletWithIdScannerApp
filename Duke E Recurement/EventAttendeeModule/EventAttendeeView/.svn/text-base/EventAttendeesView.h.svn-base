//
//  EventAttendeesView.h
//  Duke E Recurement
//
//  Created by Waqas Butt on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendeeCustomCell.h"
#import "AppDelegate.h"

@interface EventAttendeesView : UIView{

    IBOutlet AttendeeCustomCell *eventAttendeeCell;
    NSString *eventID;
    NSString *eventName;
    NSMutableArray *attendeesArray;
    
    

    int currentSelectedIndex;
    int sID;
    IBOutlet UITableView *attendeesTable;
}

@property(nonatomic,retain) IBOutlet AttendeeCustomCell *eventAttendeeCell;
@property(nonatomic,retain) NSString *eventID;
@property(nonatomic,retain) NSString *eventName;
@property(nonatomic,retain)  NSMutableArray *attendeesArray;

-(void)reloadData;
+(EventAttendeesView*) loadInstanceFromNib;

@end

