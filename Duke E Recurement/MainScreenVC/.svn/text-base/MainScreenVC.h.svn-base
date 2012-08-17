//
//  MainScreenVC.h
//  Duke E Recurement
//
//  Created by Waqas Butt on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchStudentView.h"
#import "EventAttendeesView.h"
#import "QRCodeView.h"
#import "CheckinInputView.h"
@interface MainScreenVC : UIViewController{
    
    IBOutlet UIButton *checkinStudentBtn;
    IBOutlet UIButton *studentListBtn;
    
    IBOutlet UIButton *searchBtn;
    IBOutlet UITextField *searchTxtField;
    
    IBOutlet UIView *darkView;
    IBOutlet UIActivityIndicatorView *activityView;
    IBOutlet UITableView *eventTableView;
    NSMutableArray *eventsArray;
    
    BOOL isStudentListSelected;
    
    int currentSelectedRow;
    
    
    IBOutlet UILabel *selectedEventName;
    IBOutlet UIView *eventSelectedView;
    IBOutlet UIView *eventWelcomeView;
    IBOutlet UILabel *userName;
    IBOutlet UIImageView *logoImageView;
    
    SearchStudentView *searchStudentView;
    
    EventAttendeesView *eventAttendeeView;
    CheckinInputView *checkinInputView;
    QRCodeView *qrCode;
    
}

@property(nonatomic, retain)NSMutableArray *eventsArray;
@property(nonatomic, readwrite)int currentSelectedRow;



-(void)performSearch;

-(void)removeOverLay:(NSDictionary*) results;

-(void)getEventList;

-(void)removeDarkView:(NSDictionary*) results;
-(void) loadSchoolLogo;


@end
