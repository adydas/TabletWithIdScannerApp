//
//  BLController.m
//  Duke E Recurement
//
//  Created by Waqas Butt on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BLController.h"
#import "NetworkController.h"
#import "SBJsonParser.h"
#import "StudentBO.h"
#import "EventBO.h"
#import "KeychainItemWrapper.h"

@implementation BLController

#pragma mark 
#pragma mark Login


+(NSDictionary*)userLogin:(NSString*)userEmail:(NSString*)userPassword{
    
    NSError *error = nil;
    NSString *requesturl = [NSString stringWithFormat:@"%@/api/login?j_username=%@&j_password=%@",BaseURL,userEmail,userPassword];
    NSLog(@"Base URL :%@",requesturl);
	NSString *responseStr=[[NetworkController SharedNetworkInstance] requestServerPostWithUrl:requesturl JSonString:@"" withError:&error];
	NSLog(@"Response %@",responseStr);
	if (error) {
		return [NSDictionary dictionaryWithObject:error forKey:Errorkey];
	}
	else {
        KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"ExperienceCSOLogin" accessGroup:nil];
        [keychainItem setObject:userEmail forKey:kSecAttrAccount];
        [keychainItem setObject:userPassword forKey:kSecValueData];
		return [BLController handleResponseForLogin:responseStr];
	}
}

+(NSDictionary*)handleResponseForLogin:(NSString*)responseString{
    
	@try {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseString];
		[parser release];
        NSString *result = [dict valueForKey:@"status"];
        if([result isEqualToString:@"success"]){
			[[NSUserDefaults standardUserDefaults] setValue:[dict objectForKey:@"name"] forKey:kUserID];
            [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"isLoggedIn"];
            [[NSUserDefaults standardUserDefaults]synchronize];
			NSDictionary *resultDic=[NSDictionary dictionaryWithObject:dict forKey:SuccessKey];
			return resultDic;			
		}
		else {
			NSDictionary *resultDic=[NSDictionary dictionaryWithObject:dict forKey:FailureKey];
			return resultDic;	
		}
	}
	@catch (NSException * e) {
		NSError *error=[NSError errorWithDomain:@"Invalid Data sent from server" code:0 userInfo:nil];
		return [NSDictionary dictionaryWithObject:error forKey:FailureKey];
	}
    return nil; 
}

#pragma mark 
#pragma mark GetEvents


+(NSDictionary*)getEvents:(NSString*)username:(NSString*)password{
    
	NSError *error = nil;
    
    NSString *requesturl = [NSString stringWithFormat:@"%@/ws/events?mode=tdy",BaseURL];
    NSLog(@"Base URL :%@",requesturl);
    
	NSString *jsonString = [NSString stringWithString:@""];
    
    NSLog(@"JSON String : %@",jsonString);
    
	NSString *responseStr=[[NetworkController SharedNetworkInstance] requestServerGetWithUrl:requesturl JSonString:jsonString withError:&error];
	NSLog(@"Response %@",responseStr);
	if (error) {
		return [NSDictionary dictionaryWithObject:error forKey:Errorkey];
	}
	else {
		return [BLController handleResponseForGetEvents:responseStr];
	}
}

+(NSDictionary*)handleResponseForGetEvents:(NSString*)responseString{
    
	@try {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseString];
		[parser release];
		NSMutableArray *eventsArray = [[NSMutableArray alloc]init];
        NSString *result = [dict valueForKey:@"status"];
        if([result isEqualToString:@"success"]){
			NSArray *tempArray = (NSArray*)[dict objectForKey:@"events"];
			for (NSDictionary *event in tempArray)
			{	
                
                EventBO *tempBo = [[EventBO alloc]init];
                tempBo.eventID= [[event objectForKey:@"id"] integerValue];
                tempBo.eventName= [event objectForKey:@"name"];
                tempBo.eventDescription= [event objectForKey:@"description"];
                tempBo.location= [event objectForKey:@"location"];
                tempBo.startDate= [event objectForKey:@"start_date"];
                tempBo.endDate= [event objectForKey:@"end_date"];
                tempBo.canRSVP= [event objectForKey:@"can_rsvp"];
                tempBo.rsvpDate= [event objectForKey:@"rsvp_date"];
                tempBo.rsvpCapacity= [event objectForKey:@"rsvp_capacity"];
                tempBo.eventURL = [event objectForKey:@"event_url"];
                
                [eventsArray addObject:tempBo];
                
                [tempBo release];
                tempBo = nil;
                
            }
            NSLog(@"Count of Events ---------> %i", [eventsArray count]);
			return [NSDictionary dictionaryWithObject:eventsArray forKey:SuccessKey];
		}
		else {
			NSDictionary *resultDic=[NSDictionary dictionaryWithObject:dict forKey:FailureKey];
			return resultDic;	
		}
	}
	@catch (NSException * e) {
		NSError *error=[NSError errorWithDomain:@"Invalid Data sent from server" code:0 userInfo:nil];
		return [NSDictionary dictionaryWithObject:error forKey:Errorkey];
	}
    return nil; 
}

+(NSDictionary*)getFutureEvents:(NSString*)username:(NSString*)password
{
    NSError *error = nil;
    
    NSString *requesturl = [NSString stringWithFormat:@"%@/ws/events",BaseURL];
    NSLog(@"Base URL :%@",requesturl);
    
	NSString *jsonString = [NSString stringWithString:@""];
    
    NSLog(@"JSON String : %@",jsonString);
    
	NSString *responseStr=[[NetworkController SharedNetworkInstance] requestServerGetWithUrl:requesturl JSonString:jsonString withError:&error];
	NSLog(@"Response %@",responseStr);
	if (error) {
		return [NSDictionary dictionaryWithObject:error forKey:Errorkey];
	}
	else {
		return [BLController handleResponseForGetEvents:responseStr];
	}

}

+(NSDictionary*)getPastEvents:(NSString*)username:(NSString*)password
{
    NSError *error = nil;
    
    NSString *requesturl = [NSString stringWithFormat:@"%@/ws/events?mode=pst",BaseURL];
    NSLog(@"Base URL :%@",requesturl);
    
	NSString *jsonString = [NSString stringWithString:@""];
    
    NSLog(@"JSON String : %@",jsonString);
    
	NSString *responseStr=[[NetworkController SharedNetworkInstance] requestServerGetWithUrl:requesturl JSonString:jsonString withError:&error];
	NSLog(@"Response %@",responseStr);
	if (error) {
		return [NSDictionary dictionaryWithObject:error forKey:Errorkey];
	}
	else {
		return [BLController handleResponseForGetEvents:responseStr];
	}
}



#pragma mark 
#pragma mark GetEventsAttendees

+(NSDictionary*)getEventAttendees:(NSInteger)event_id{
    
	NSError *error = nil;
   
	NSString *requesturl = [NSString stringWithFormat:@"%@/ws/event/0/attendees?eventId=%i",BaseURL,event_id];
    NSLog(@"Base URL :%@",requesturl);
    
	NSString *jsonString = [NSString stringWithString:@""];
    
	NSString *responseStr=[[NetworkController SharedNetworkInstance] requestServerGetWithUrl:requesturl JSonString:jsonString withError:&error];
	NSLog(@"Response %@",responseStr);
	if (error) {
		return [NSDictionary dictionaryWithObject:error forKey:Errorkey];
	}
	else {
		return [BLController handleResponseForGetEventAttendees:responseStr];
	}
}

+(NSDictionary*)handleResponseForGetEventAttendees:(NSString*)responseString{
    
	@try {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseString];
		[parser release];
		NSMutableArray *attendeesArray = [[NSMutableArray alloc]init];
        NSString *result = [dict valueForKey:@"status"];
        if([result isEqualToString:@"success"]){
			NSArray *tempArray = (NSArray*)[dict objectForKey:@"attendees"];
			for (NSDictionary *event in tempArray)
			{	
                
                StudentBO *tempBo = [[StudentBO alloc]init];
                tempBo.studentID= [[event objectForKey:@"id"] integerValue];
                tempBo.firstName= [event objectForKey:@"first_name"];
                tempBo.lastName= [event objectForKey:@"last_name"];
                tempBo.check_in= [event objectForKey:@"check_in"];
                tempBo.email= [event objectForKey:@"email"];
                
                [attendeesArray addObject:tempBo];
                
                [tempBo release];
                tempBo = nil;
                
            }
            NSLog(@"Attendees of Events ---------> %i", [attendeesArray count]);
			return [NSDictionary dictionaryWithObject:attendeesArray forKey:SuccessKey];
		}
		else {
			NSDictionary *resultDic=[NSDictionary dictionaryWithObject:dict forKey:FailureKey];
			return resultDic;	
		}
	}
	@catch (NSException * e) {
		NSError *error=[NSError errorWithDomain:@"Invalid Data sent from server" code:0 userInfo:nil];
		return [NSDictionary dictionaryWithObject:error forKey:Errorkey];
	}
    return nil; 
}

#pragma mark 
#pragma mark searchStudent

+(NSDictionary*)getStudent:(NSString *)fName lastName:(NSString*)lName andEventID:(NSInteger)eID withOption :(int)opt {
    
	NSError *error = nil;
	NSString *requesturl = [NSString stringWithFormat:@"%@/ws/stu/find?fname=%@&eid=%i",BaseURL,fName,eID];
    
    if(opt==1){
        requesturl = [NSString stringWithFormat:@"%@/ws/stu/find?lname=%@&eid=%i",BaseURL,lName,eID];
    }
    else if(opt==2){
        requesturl = [NSString stringWithFormat:@"%@/ws/stu/find?fname=%@&lname=%@&eid=%i",BaseURL,fName,lName,eID];
    }
    
    NSLog(@"Base URL :%@",requesturl);
    
	NSString *jsonString = [NSString stringWithString:@""];
    
	NSString *responseStr=[[NetworkController SharedNetworkInstance] requestServerGetWithUrl:requesturl JSonString:jsonString withError:&error];
	NSLog(@"Response %@",responseStr);
    
	if (error) {
		return [NSDictionary dictionaryWithObject:error forKey:Errorkey];
	}
	else {
		return [BLController handleResponseForGetStudents:responseStr];
	}
}

+(NSDictionary*)handleResponseForGetStudents:(NSString*)responseString{
    
	@try {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseString];
		[parser release];
		NSMutableArray *studentArray = [[NSMutableArray alloc]init];
        NSString *result = [dict valueForKey:@"status"];
        if([result isEqualToString:@"success"]){
			NSArray *tempArray = (NSArray*)[dict objectForKey:@"students"];
			for (NSDictionary *event in tempArray)
			{	

                StudentBO *tempBo = [[StudentBO alloc]init];
                tempBo.studentID= [[event objectForKey:@"id"] integerValue];
                tempBo.firstName= [event objectForKey:@"first_name"];
                tempBo.lastName= [event objectForKey:@"last_name"];
                tempBo.check_in= [event objectForKey:@"check_in"];
                tempBo.email= [event objectForKey:@"email"];
                tempBo.sID = [event objectForKey:@"student_id"];
                tempBo.partnerKey = [event objectForKey:@"partner_key"];
                
                [studentArray addObject:tempBo];
                
                [tempBo release];
                tempBo = nil;
                
            }
            NSLog(@"Attendees of Events ---------> %i", [studentArray count]);
			return [NSDictionary dictionaryWithObject:studentArray forKey:SuccessKey];
		}
		else {
			NSDictionary *resultDic=[NSDictionary dictionaryWithObject:dict forKey:FailureKey];
			return resultDic;	
		}

	}
	@catch (NSException * e) {
		NSError *error=[NSError errorWithDomain:@"Invalid Data sent from server" code:0 userInfo:nil];
		return [NSDictionary dictionaryWithObject:error forKey:Errorkey];
	}
    return nil; 
}

#pragma mark 
#pragma mark Checkin

+(NSDictionary*)checkInStudent:(int)eventID withUserID:(int)userId andEmailAddress:(NSString*)email{
    
    /*
        if user id = 0;
            mean we want to checkin using email
        else
            we want to checkin using fname and last name
     */
    
	NSError *error = nil;
    
    NSString *requesturl = [NSString stringWithFormat:@"%@/ws/stu/checkin/%i?sid=%i",BaseURL,eventID,userId];
 
    if(userId==0){
        requesturl = [NSString stringWithFormat:@"%@/ws/stu/checkin/%i?email=%@",BaseURL,eventID,email];
    }//end if
	
    NSLog(@"Base URL :%@",requesturl);
    
	NSString *jsonString = [NSString stringWithString:@""];
    
	NSString *responseStr=[[NetworkController SharedNetworkInstance] requestServerGetWithUrl:requesturl JSonString:jsonString withError:&error];
	NSLog(@"Response %@",responseStr);
	if (error) {
		return [NSDictionary dictionaryWithObject:error forKey:Errorkey];
	}
	else {
		return [BLController handleResponseForCheckInStudent:responseStr];
	}
}

+(NSDictionary*)handleResponseForCheckInStudent:(NSString*)responseString{
    
	@try {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseString];
		[parser release];
        NSString *result = [dict valueForKey:@"status"];
        if([result isEqualToString:@"success"]){
            NSDictionary *resultDic=[NSDictionary dictionaryWithObject:[dict objectForKey:@"message"] forKey:SuccessKey];
			return resultDic;	
        }
		else {
            NSDictionary *resultDic=[NSDictionary dictionaryWithObject:[dict objectForKey:@"message"] forKey:FailureKey];
			return resultDic;	
		}
	}
	@catch (NSException * e) {
		NSError *error=[NSError errorWithDomain:@"Invalid Data sent from server" code:0 userInfo:nil];
		return [NSDictionary dictionaryWithObject:error forKey:Errorkey];
	}
    return nil; 
}

#pragma mark 
#pragma mark Checkin

+(NSDictionary*)getStudentInformationWithQRCode:(NSString*)qrCode withEventID:(int)eID{
    
	NSError *error = nil;
    NSString *trimmedString = [qrCode stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"Scanned Code:%@", trimmedString);
    
    NSString *requesturl = [NSString stringWithFormat:@"%@/ws/stu/cardCode/%i?code=;?%@",BaseURL,eID,trimmedString];
	
    NSLog(@"Base URL :%@",requesturl);
    
	NSString *jsonString = [NSString stringWithString:@""];
    
	NSString *responseStr=[[NetworkController SharedNetworkInstance] requestServerGetWithUrl:requesturl JSonString:jsonString withError:&error];
	NSLog(@"Response %@",responseStr);
	if (error) {
		return [NSDictionary dictionaryWithObject:error forKey:Errorkey];
	}
	else {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *dict = [parser objectWithString:responseStr];
        
        NSDictionary *statusDic=[NSDictionary dictionaryWithObject:[dict objectForKey:@"status"] forKey:FailureKey];
        NSString *fail = [statusDic objectForKey:@"Failure"];
        if ([fail isEqualToString:@"failure"]){
            return [NSDictionary dictionaryWithObject:[dict objectForKey:@"message"] forKey:FailureKey];
        }
        
        NSDictionary *resultDic=[NSDictionary dictionaryWithObject:[dict objectForKey:@"message"] forKey:SuccessKey];
        return resultDic;	
        
        //Replaced function below with the lines above
        //return [BLController handleResponseForGetStudentInformationWithQRCodet:responseStr];
	}
}

+(NSDictionary*)handleResponseForGetStudentInformationWithQRCodet:(NSString*)responseString{
    
	@try {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseString];
		[parser release];
		NSMutableArray *studentArray = [[NSMutableArray alloc]init];
        NSString *result = [dict valueForKey:@"status"];
        if([result isEqualToString:@"success"]){
			NSArray *tempArray = (NSArray*)[dict objectForKey:@"students"];
			for (NSDictionary *student in tempArray)
			{	
                
                StudentBO *tempBo = [[StudentBO alloc]init];
                tempBo.studentID= [[student objectForKey:@"id"] integerValue];
                tempBo.firstName= [student objectForKey:@"first_name"];
                tempBo.lastName= [student objectForKey:@"last_name"];
                tempBo.check_in= [student objectForKey:@"check_in"];
                tempBo.email= [student objectForKey:@"email"];
                tempBo.sID = [student objectForKey:@"student_id"];
                tempBo.partnerKey = [student objectForKey:@"partner_key"];
                tempBo.check_in = [student objectForKey:@"check_in"];
                
                [studentArray addObject:tempBo];
                
                [tempBo release];
                tempBo = nil;
                
            }
            NSLog(@"Student Count ---------> %i", [studentArray count]);
			return [NSDictionary dictionaryWithObject:studentArray forKey:SuccessKey];
		}
		else {
            
            NSString *message = [dict objectForKey:@"message"];
            if (message != nil) {
                return [NSDictionary dictionaryWithObject:message forKey:FailureKey];
            }
            
			NSDictionary *resultDic=[NSDictionary dictionaryWithObject:dict forKey:FailureKey];
			return resultDic;	
		}
        
	}
	@catch (NSException * e) {
		NSError *error=[NSError errorWithDomain:@"Invalid Data sent from server" code:0 userInfo:nil];
		return [NSDictionary dictionaryWithObject:error forKey:Errorkey];
	}
    return nil; 

}

#pragma mark 
#pragma mark getSchoolLogo
+(NSDictionary*)getSchoolLogo/*:(NSString*)userEmail:(NSString*)userPassword*/
{
    NSError *error = nil;
    
    NSString *requesturl = [NSString stringWithFormat:@"%@/ws/school/logo",BaseURL];
    NSLog(@"Base URL :%@",requesturl);
    
	NSString *jsonString = [NSString stringWithString:@""];
    
    NSLog(@"JSON String : %@",jsonString);
    
	NSString *responseStr=[[NetworkController SharedNetworkInstance] requestServerGetWithUrl:requesturl JSonString:jsonString withError:&error];
	NSLog(@"Response %@",responseStr);
	if (error) {
		return [NSDictionary dictionaryWithObject:error forKey:Errorkey];
	}
	else {
		return [BLController handleResponseForGetSchoolLogo:responseStr];
	}

}
+(NSDictionary*)handleResponseForGetSchoolLogo:(NSString*)responseString
{
    @try {
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSDictionary *dict = [parser objectWithString:responseString];
		[parser release];
        NSString *logo = [dict objectForKey:@"logo"];
        if (logo != nil) {
            return [NSDictionary dictionaryWithObject:logo forKey:SuccessKey];
        }

		else {
			NSDictionary *resultDic=[NSDictionary dictionaryWithObject:dict forKey:FailureKey];
			return resultDic;	
		}
        
	}
	@catch (NSException * e) {
		NSError *error=[NSError errorWithDomain:@"Invalid Data sent from server" code:0 userInfo:nil];
		return [NSDictionary dictionaryWithObject:error forKey:Errorkey];
	}
    return nil; 
}


@end
