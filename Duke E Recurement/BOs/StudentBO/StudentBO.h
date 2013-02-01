//
//  StudentBO.h
//  Duke E Recurement
//
//  Created by Waqas Butt on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentBO : NSObject{
    NSString *studentID;
    NSString *firstName;
    NSString *lastName;
    NSString *check_in;
    NSString *email;
    NSString *sID;
    NSString *partnerKey;
}

@property(nonatomic, retain) NSString *studentID;
@property(nonatomic, retain) NSString *firstName;
@property(nonatomic, retain) NSString *lastName;
@property(nonatomic, retain) NSString *check_in;
@property(nonatomic, retain) NSString *email;
@property(nonatomic, retain) NSString *sID;
@property(nonatomic, retain) NSString *partnerKey;

@end
