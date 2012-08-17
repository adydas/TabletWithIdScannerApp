//
//  BLController.h
//  Duke E Recurement
//
//  Created by Waqas Butt on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLController : NSObject{
    
}
+(NSDictionary*)userLogin:(NSString*)userEmail:(NSString*)userPassword;

+(NSDictionary*)getEvents:(NSString*)username:(NSString*)password;

+(NSDictionary*)getFutureEvents:(NSString*)username:(NSString*)password;

+(NSDictionary*)getPastEvents:(NSString*)username:(NSString*)password;

+(NSDictionary*)getEventAttendees:(NSInteger)event_id;

+(NSDictionary*)getStudent:(NSString *)fName lastName:(NSString*)lName andEventID:(NSInteger)eID withOption :(int)opt;

+(NSDictionary*)checkInStudent:(int)eventID withUserID:(int)userId andEmailAddress:(NSString*)email;

+(NSDictionary*)getStudentInformationWithQRCode:(NSString*)qrCode withEventID:(int)eID;

+(NSDictionary*)handleResponseForGetStudentInformationWithQRCodet:(NSString*)responseString;

+(NSDictionary*)handleResponseForGetEvents:(NSString*)responseString;

+(NSDictionary*)handleResponseForGetSchoolLogo:(NSString*)responseString;

+(NSDictionary*)getSchoolLogo;


@end
