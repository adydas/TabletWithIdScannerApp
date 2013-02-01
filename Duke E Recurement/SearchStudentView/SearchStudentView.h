//
//  SearchStudentView.h
//  Duke E Recurement
//
//  Created by Waqas Butt on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomStudentCell.h"


@interface SearchStudentView : UIView{
    NSMutableArray *studentArray;

    IBOutlet CustomStudentCell *CheckInCell;
    int eventID;
    
    
    
    
    IBOutlet UITableView *studentTable;
    
    int currentSelectedIndex;
    NSString *sID;
}

+(SearchStudentView*)loadInstanceFromNib;

@property(nonatomic,retain) NSMutableArray *studentArray;
@property(nonatomic,retain) IBOutlet UITableViewCell *CheckInCell;
@property(nonatomic, readwrite)int eventID;

-(IBAction)checkedinBtnPressed:(id)sender;

-(void)performCheckinWithStudentID;

-(void)handleCheckinResponse:(NSDictionary*) results;
@end
