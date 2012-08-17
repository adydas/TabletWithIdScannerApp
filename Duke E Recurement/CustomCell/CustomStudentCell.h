//
//  CustomStudentCell.h
//  Duke E Recurement
//
//  Created by Waqas Butt on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentBO.h"

@interface CustomStudentCell : UITableViewCell{
    IBOutlet UILabel *studentName;
    IBOutlet UILabel *studentID;
    IBOutlet UILabel *isCheckedin;
    
    IBOutlet UIButton *checkinBtn;
}

-(void)populateData:(StudentBO*)student;

@end
