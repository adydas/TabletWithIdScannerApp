//
//  AttendeeCustomCell.m
//  Duke E Recurement
//
//  Created by Waqas Butt on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AttendeeCustomCell.h"

@implementation AttendeeCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)populateData:(StudentBO*)student{
    
    studentName.text = [NSString stringWithFormat:@"%@ %@",student.firstName,student.lastName];
    studentEmail.text = student.email;
    NSLog(@"Checkin %@",student.check_in);
    isCheckedin.text = student.check_in;
//    checkinBtn.tag = student.studentID;
    if ([student.check_in isEqualToString:@"YES"]) {
        checkinBtn.enabled = NO;
    }
}


@end
