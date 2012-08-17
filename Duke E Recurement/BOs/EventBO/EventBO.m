//
//  EventBO.m
//  Duke E Recurement
//
//  Created by Waqas Butt on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventBO.h"

@implementation EventBO
@synthesize eventID,eventName,eventDescription,location,startDate,endDate,canRSVP,rsvpDate,rsvpCapacity,eventURL;


-(void)dealloc{
    [eventName release];
    eventName = nil;
    [eventDescription release];
    eventDescription = nil;
    [location release];
    location = nil;
    [startDate release];
    startDate = nil;
    [endDate release];
    endDate = nil;
    [canRSVP release];
    canRSVP = nil;
    [rsvpDate release];
    rsvpDate = nil;
    [rsvpCapacity release];
    rsvpCapacity = nil;
    [eventURL release];
    eventURL = nil;
    
    [super dealloc];
}
@end
