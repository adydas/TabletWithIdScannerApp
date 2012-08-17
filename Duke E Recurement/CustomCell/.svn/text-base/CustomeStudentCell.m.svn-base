//
//  CustomeStudentCell.m
//  Duke E Recurement
//
//  Created by Waqas Butt on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomeStudentCell.h"

@implementation CustomeStudentCell
@synthesize studentName,email,checkedIn,checkedInlabel;


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

-(void)dealloc {
    [studentName release];
    [email release];
    [checkedIn release];
    [checkedInlabel release];
    checkedInlabel = nil;
    studentName = nil;
    email = nil;
    checkedIn = nil;
    [super dealloc];
}

@end
