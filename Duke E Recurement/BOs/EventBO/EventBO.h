//
//  EventBO.h
//  Duke E Recurement
//
//  Created by Waqas Butt on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventBO : NSObject{
    NSInteger eventID;
    NSString *eventName;
    NSString *eventDescription;
    NSString *location;
    NSString *startDate;
    NSString *endDate;
    NSString *canRSVP;
    NSString *rsvpDate;
    NSString *rsvpCapacity;
    NSString *eventURL;
    
}



@property(nonatomic, readwrite) NSInteger eventID;
@property(nonatomic, retain) NSString *eventName;
@property(nonatomic, retain) NSString *eventDescription;
@property(nonatomic, retain) NSString *location;
@property(nonatomic, retain) NSString *startDate;
@property(nonatomic, retain) NSString *endDate;
@property(nonatomic, retain) NSString *canRSVP;
@property(nonatomic, retain) NSString *rsvpDate;
@property(nonatomic, retain) NSString *rsvpCapacity;
@property(nonatomic, retain) NSString *eventURL;

@end
