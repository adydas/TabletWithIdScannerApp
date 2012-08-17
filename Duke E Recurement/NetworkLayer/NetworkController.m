//
//  NetworkController.m
//  Duke E Recurement
//
//  Created by Waqas Butt on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NetworkController.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"


@implementation NetworkController

NetworkController *SharedNetworkInstance;

+(NetworkController*)SharedNetworkInstance{
	if (!SharedNetworkInstance) {
		SharedNetworkInstance = [[NetworkController alloc] init];
	}
	
	if([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) 
	{
		NSLog(@"Could not connect to server. Throw an exception from here");
		///Network Availability here///
	}
	
	return SharedNetworkInstance;
}

#pragma mark 
#pragma mark PostRequest

-(NSString*)requestServerPostWithUrl:(NSString*)requestUrl JSonString:(NSString*)jsonString withError:(NSError**)theError{
    
	NSLog(@"URL %@",requestUrl);
	NSLog(@"JsonString %@",jsonString);
	NSString *responseStr = nil;
    @try{
		
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[requestUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
		[request setTimeOutSeconds:30];
		[request setRequestMethod:@"GET"];
		[request startSynchronous];
        NSError *error = [request error];
		int statusCode = request.responseStatusCode;
		if (statusCode==200) {
			responseStr = [request responseString];
			NSLog(@"responseString From RequestServer %@",responseStr);
		}
        
		else if(statusCode==901){
			error = [NSError errorWithDomain:@"Page not found" code:404 userInfo:[NSDictionary dictionaryWithObject:@"parameter missing" forKey:@"localizedDescription"]];
			*theError = error;
		}
        
		//'no internet connection detected', please ensure you are connected to the internet
		else if(statusCode==0){
			error=[NSError errorWithDomain:@"'no internet connection detected', please ensure you are connected to the internet" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Server is not responding" forKey:@"localizedDescription"]];
			*theError = error;
			
		}
		else {
			*theError = error;
		}
	}
	@catch (NSException *e) {
		NSLog(@"Exception occured");
	}
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return responseStr;	
}


#pragma mark 
#pragma mark GetRequest

-(NSString*)requestServerGetWithUrl:(NSString*)requestUrl JSonString:(NSString*)jsonString withError:(NSError**)theError{
    
	NSLog(@"URL %@",requestUrl);
	NSLog(@"JsonString %@",jsonString);
	NSString *responseStr = nil;
    @try{
		
    
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[requestUrl stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
        
        [request addBasicAuthenticationHeaderWithUsername:@"seleniumadmin" andPassword:@"test"];
        [request applyAuthorizationHeader];
        
		[request setTimeOutSeconds:20];
		[request setRequestMethod:@"GET"];
		
		[request startSynchronous];
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSError *error = [request error];
		int statusCode = request.responseStatusCode;
		if (statusCode==200) {
			responseStr = [request responseString];
			NSLog(@"responseString From Server %@",responseStr);
		}
		
        else if(statusCode==901){
			error = [NSError errorWithDomain:@"Page not found" code:404 userInfo:[NSDictionary dictionaryWithObject:@"parameter missing" forKey:@"localizedDescription"]];
			*theError = error;
			//			return nil;
		}
        
		//'no internet connection detected', please ensure you are connected to the internet
		else if(statusCode==0){
			error=[NSError errorWithDomain:@"'no internet connection detected', please ensure you are connected to the internet" code:0 userInfo:[NSDictionary dictionaryWithObject:@"Server is not responding" forKey:@"localizedDescription"]];
			*theError = error;
		}
		else {
			*theError = error;
		}
	}
	@catch (NSException *e) {
		NSLog(@"Exception occured");
	}
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	return responseStr;	
}







@end
