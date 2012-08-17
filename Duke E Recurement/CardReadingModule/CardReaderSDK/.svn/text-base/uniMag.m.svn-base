//
//  uniMag.m
//  IDTech
//
//  Created by Randy Palermo on 5/30/10.
//  Copyright 2010 ID_Tech. All rights reserved.
//

#import "uniMag.h"
#import "CommonCrypto/CommonDigest.h"

static BOOL needsPower = TRUE;
static BOOL readerAttached = TRUE;
static BOOL needsSwipe = FALSE;
static BOOL ValidateOnly = FALSE;
static BOOL noUniMag = FALSE;
static BOOL uniConnected = FALSE;
static BOOL swipeCancelled = FALSE;
static BOOL evaluateSwipe = FALSE;
static BOOL cancelSwipe = FALSE;


static BOOL keepPowerOn = TRUE;
static BOOL baud2400 = FALSE;
static int verifyCounter = 0;
static int loopCounter = 0;
static BOOL checkingPower = FALSE;
static BOOL checkMeter = FALSE;
static NSData *commandFile;
static NSData *tone;
static BOOL headphoneCheck = FALSE;
static BOOL verifyMe = FALSE;
static BOOL vMeter = FALSE;
static BOOL meterValid = FALSE;
static BOOL swipeValid = FALSE;
static BOOL swipeTimeout = FALSE;
static BOOL confirmConnection = TRUE;
static BOOL dialogOpen = FALSE;
static BOOL proceed = FALSE;

static int crossingPoint = 10;






@implementation uniMag


-(NSString *)audioData{
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"audioData" ofType:@"txt"];  
	NSData *myData = [NSData dataWithContentsOfFile:filePath];

	if (myData) {  
		return [NSString stringWithUTF8String:[myData bytes]];
	}else{
		return nil;
	}
	
}


- (NSString *) platform  
{  
	size_t size;  
	sysctlbyname("hw.machine", NULL, &size, NULL, 0);  
	char *machine = malloc(size);  
	sysctlbyname("hw.machine", machine, &size, NULL, 0);  
	NSString *platform = [NSString stringWithUTF8String:machine];
	
	free(machine);  
	return platform; 
	
} 


int char2hex(unichar c) {
	switch (c) {
		case '0' ... '9': return c - '0';
		case 'a' ... 'f': return c - 'a' + 10;
		case 'A' ... 'F': return c - 'A' + 10;
		default: return -1;
	}
}


- (NSData *)hexToData:(NSString*)audioData {
	//NSLog(@"Routine = %@",@"hexToData");
	unsigned stringIndex=0, resultIndex=0, max=[audioData length];
	NSMutableData* result = [NSMutableData dataWithLength:(max + 1)/2];
	unsigned char* bytes = [result mutableBytes];
	
	unsigned num_nibbles = 0;
	unsigned char byte_value = 0;
	
	for (stringIndex = 0; stringIndex < max; stringIndex++) {
		int val = char2hex([audioData characterAtIndex:stringIndex]);
		if (val < 0) continue;
		num_nibbles++;
		byte_value = byte_value * 16 + (unsigned char)val;
		if (! (num_nibbles % 2)) {
			bytes[resultIndex++] = byte_value;
			byte_value = 0;
		}
	}
	
	
	//final nibble
	if (num_nibbles % 2) {
		bytes[resultIndex++] = byte_value;
		byte_value = 0;
	}
	
	[result setLength:resultIndex];
	return result;
}


-(NSData*) getWave{
	//NSLog(@"Routine = %@",@"getWave");
	NSURL *url = [NSURL fileURLWithPath: recorderFilePath];
	NSError *err = nil;
	return [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
}



-(void) autoDetect:(BOOL)autoDetect{
	//NSLog(@"Routine = %@",@"autoDetect");
	if (autoDetect) {
		autoTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(checkforUniMag) userInfo:nil repeats:YES];
	}
	else {
		if ([autoTimer isValid])  [autoTimer invalidate];
	}
	
}



-(void) playTone{
	
	[audioPlayer stop];
	
	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc]  initWithData:tone  error:&error];
	audioPlayer.numberOfLoops = -1;
	audioPlayer.volume = 1.0;
	[audioPlayer prepareToPlay];
	[audioPlayer play];
	
}


-(id)init
{
	//NSLog(@"Routine = %@",@"init");
    if (self = [super init])
    {
		confirmUniMag = [[UIAlertView alloc] initWithTitle:@"Device Message" 
												   message:@"Device detected in headphone. Check for Device? Headphone volume must be at maximum level to proceed."
												  delegate:self
										 cancelButtonTitle:@"Cancel"
										 otherButtonTitles:@"OK",nil];
		
		
		volumeWarning = [[UIAlertView alloc] initWithTitle:@"Device Message" 
												   message:@"Volume is not sufficient to power Device. Please increase your headphone volume until this alert disappears."
												  delegate:self
										 cancelButtonTitle:nil
										 otherButtonTitles:nil];

		ValidateOnly = FALSE;
		uniConnected = FALSE;
		noUniMag = FALSE;
		commandFile = [[NSData alloc] init];
		audioSession = [AVAudioSession sharedInstance];
		NSError *err = nil;
		[audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
		if(err){
			//NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
			//return;
		}
		[audioSession setActive:YES error:&err];
		err = nil;
		if(err){
			//NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
			//return;
		}
		
		recordSetting = [[NSMutableDictionary alloc] init];
		
		[recordSetting setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
		
		[recordSetting setValue:[NSNumber numberWithFloat:48000.0] forKey:AVSampleRateKey]; 
		
		
		
		[recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
		
		[recordSetting setValue :[NSNumber numberWithInt:8] forKey:AVLinearPCMBitDepthKey];
		[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
		[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
		
		[recordSetting setValue :[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
		[recordSetting setValue :[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVSampleRateConverterAudioQualityKey];
		
		
		// Create a new dated file
		recorderFilePath = [[NSString stringWithFormat:@"%@/audio.caf", DOCUMENTS_FOLDER] retain];
		
		 
		tone = [self hexToData:[self audioData]] ;
		
		NSError *error;
		audioPlayer = [[AVAudioPlayer alloc]  initWithData:tone error:&error];
		audioPlayer.numberOfLoops = -1;
		audioPlayer.volume = 0.0;
		[audioPlayer prepareToPlay];
		[audioPlayer play];
		audioPlayer.meteringEnabled = YES;
		
		
		NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
		
		
		NSFileManager *fm = [NSFileManager defaultManager];
		[fm removeItemAtPath:[url path] error:&err];
		if(err)
			NSLog(@"File Manager: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
		
		recorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
		if(err)
			NSLog(@"File Manager: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
		
		
		
		//prepare to record
		[recorder setDelegate:self];
		[recorder prepareToRecord];
		//***recorder.meteringEnabled = YES;

    }
	
    return self;
}


-(void) closeConnection{

	[self cancelSwipe];	
	[audioPlayer stop];
	if ([autoTimer isValid])  [autoTimer invalidate];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"uniMagDidDisconnectNotification" object:nil];
	
}


- (void) startRecording{
	
	NSLog(@"Routine = %@",@"startRecording");
	
	BOOL audioHWAvailable = audioSession.inputIsAvailable;
	if (! audioHWAvailable) {
		//NSLog(@"%@",@"Hardware Not Available");
		return;
	}
	
	//NSLog(@"%@",@"Hardware IS Available");
	recorder.meteringEnabled = TRUE;
	audioPlayer.volume = 1.0; //***
	
	if (needsSwipe) {
		
		[recorder recordForDuration:(NSTimeInterval) 20];
		verifyMe = FALSE;
		vMeter = FALSE;
		meterValid = TRUE;
		swipeValid = TRUE;
		swipeTimeout = FALSE;
		meterTimer = [NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(checkMeters) userInfo:nil repeats:YES];
		swipeTimer = [NSTimer scheduledTimerWithTimeInterval:19.0 target:self selector:@selector(swipeTimeout) userInfo:nil repeats:NO];

	}
	else 
	{
		[recorder recordForDuration:(NSTimeInterval) 4];
		vMeter = FALSE;
		meterValid = TRUE;
		meterTimer = [NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(checkMeters) userInfo:nil repeats:YES];
		verifyMe = TRUE;
		[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(stopVerify) userInfo:nil repeats:NO];

	}
	
}


-(void) waitForVolume{
	
	if ([self getVolumeLevel] < 1.0) 
	{
		
		NSRunLoop *theRL = [NSRunLoop currentRunLoop];
		
		NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.1];
		MPVolumeSettingsAlertShow();
		
		//[volumeWarning show];
		
		while ([self getVolumeLevel] < 1.0 &&  MPVolumeSettingsAlertIsVisible()  && [theRL runMode:NSDefaultRunLoopMode beforeDate:loopUntil]){
			
			
		}
		if ([self getVolumeLevel] == 1.0) {
			MPVolumeSettingsAlertHide();
			swipeCancelled = TRUE;  //so we don't get timeout error
			ValidateOnly = TRUE;
			
			[self playTone];
			[self startRecording];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"uniMagPoweringNotification" object:nil];
			
			verifyCounter = 0;
			needsSwipe = FALSE;
			headphoneCheck = TRUE;
			
			//[volumeWarning dismissWithClickedButtonIndex:0 animated:FALSE];
		}
		else 
		{
			noUniMag = TRUE;
			
			ValidateOnly = FALSE;
			needsPower = FALSE;
			needsSwipe = FALSE;
			evaluateSwipe = FALSE;
			proceed = FALSE;
			dialogOpen = FALSE;
			UIAlertView *volumeBad = [[UIAlertView alloc] initWithTitle:@"Device Message" 
																message:@"Detection cancelled. Volume not at maximum levels."
															   delegate:self
													  cancelButtonTitle:@"OK"
													  otherButtonTitles:nil];
			[volumeBad show];
			[volumeBad release];
		}
		
	}
	
}


-(void) startUniMag:(BOOL)start;{
	
	//NSLog(@"Routine = %@",@"startUniMag");
	
	if (start) {
		
		if (!uniConnected && !ValidateOnly && !noUniMag) {
			
			audioPlayer.volume = 1.0;
			swipeCancelled = TRUE;  //so we don't get timeout error
			ValidateOnly = TRUE;
			
			[self startRecording];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"uniMagPoweringNotification" object:nil];
			
			verifyCounter = 0;
			needsSwipe = FALSE;
			verifyMe = TRUE;
		}
		
	}
	else 
	{
		if (uniConnected) {
			ValidateOnly = FALSE;
			uniConnected = FALSE;
			noUniMag = FALSE;
			
			audioPlayer.volume = 1.0;
			checkMeter = FALSE;
			[[NSNotificationCenter defaultCenter] postNotificationName:@"uniMagDidReceiveDataNotification" object:nil];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"uniMagDidDisconnectNotification" object:nil];
		};
		noUniMag = FALSE;
	}
	
}



-(void)checkforUniMag{
	
	if (!checkingPower) 
	{
		//first, let's see if headhphone is plugged in
		CFStringRef newRoute;
		
		UInt32 size; size = sizeof(CFStringRef);
		OSStatus error = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &size, &newRoute);
		if (error)
		{
			NSLog(@"[Error] Not Able to Get New Audio Route (%ld).", error);
		}
		else
		{
			if (CFStringHasPrefix(newRoute, CFSTR("Head"))) 
			{
				if (!uniConnected && !ValidateOnly && !noUniMag && !headphoneCheck && !dialogOpen)
				{
					if (confirmConnection) {
						
						dialogOpen = TRUE;
						proceed = FALSE;
						NSRunLoop *theRL = [NSRunLoop currentRunLoop];
						
						NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:0.1];
						[confirmUniMag show];
						
						while (dialogOpen == TRUE && [theRL runMode:NSDefaultRunLoopMode beforeDate:loopUntil]){
							
							
						}
						
					}
					else {
						proceed = TRUE;
						dialogOpen = FALSE;
					}
					if (proceed == TRUE) {
						
						if ([self getVolumeLevel] < 1.0) {
							[self waitForVolume];
						}
						else {
							//audioPlayer.volume = 0.0;
							swipeCancelled = TRUE;  //so we don't get timeout error
							ValidateOnly = TRUE;
							
							[self playTone];
							[[NSNotificationCenter defaultCenter] postNotificationName:@"uniMagPoweringNotification" object:nil];
							
							verifyCounter = 0;
							needsSwipe = FALSE;
							headphoneCheck = TRUE;
							
							[self startRecording];
						}
						
					}
					
				}
				
			}
			else 
			{
				headphoneCheck = FALSE;
				ValidateOnly = FALSE;
				noUniMag = FALSE;
				audioPlayer.volume = 0.0;
				
				if (uniConnected) {
					
					uniConnected = FALSE;
					checkMeter = FALSE;
					
					[[NSNotificationCenter defaultCenter] postNotificationName:@"uniMagDidReceiveDataNotification" object:nil];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"uniMagDidDisconnectNotification" object:nil];
				};
				
				noUniMag = FALSE;
			}
			
		}
		
	}
	
}



- (void) stopRecording{
	
	NSLog(@"Routine = %@",@"stopRecording");
	
	verifyMe = FALSE;
	[recorder stop];
	[self checkRecording];
	
}

- (void) stopVerify{
	//NSLog(@"Routine = %@",@"stopVerify - PRE VERIFY ME");
	
	if (verifyMe == TRUE) {

		if (!uniConnected) {

			if (verifyCounter < 2) 
			{
				if (meterValid == TRUE){
					meterValid = FALSE;
					[meterTimer invalidate];
				}
				[recorder stop];
				audioPlayer.volume = 0.0;
				verifyCounter = verifyCounter + 1;
				ValidateOnly = TRUE;
				[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startRecording) userInfo:nil repeats:NO];
			}
			else 
			{
				noUniMag = TRUE;
				
				ValidateOnly = FALSE;
				needsPower = FALSE;
				needsSwipe = FALSE;
				evaluateSwipe = FALSE;
				
				if (!evaluateSwipe && !cancelSwipe)
				{
					loopCounter = loopCounter + 1;
					audioPlayer.volume = 0.0;
					checkingPower = FALSE;
					loopCounter = 0;
					checkMeter = FALSE;
					
					[[NSNotificationCenter defaultCenter] postNotificationName:@"uniMagDidReceiveDataNotification" object:nil];
					[[NSNotificationCenter defaultCenter] postNotificationName:@"uniMagTimeoutNotification" object:nil];
				}
				if (meterValid == TRUE){
					meterValid = FALSE;
					[meterTimer invalidate];
				}
				
				[recorder stop];
			}
			
		}

	}
	
}



- (void)checkMeters
{
	//NSLog(@"Routine = %@",@"checkMeters");
	if (!ValidateOnly && !needsPower && !needsSwipe) {
		NSLog(@"%@",@"Validate Only");
		//[RecordTimer invalidate];
	}
	else 
	{
		evaluateSwipe = FALSE;
		[recorder updateMeters];
		float p = [recorder peakPowerForChannel:0];
		if (p < 0.0) vMeter = TRUE;
		

		NSLog(@"checking meter %f", p );

		if (p >-2.0 && vMeter == TRUE) {
			
			if (meterValid == TRUE){
				meterValid = FALSE;
				[meterTimer invalidate];
			}
			NSLog(@"%@",@"Check Recording....");
			evaluateSwipe = TRUE;
			checkMeter = FALSE;
			if (swipeValid == TRUE) {
				swipeValid = FALSE;
				[swipeTimer invalidate];
			}
			
			[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(stopRecording) userInfo:nil repeats:NO];
		}
		
	}
	
}



-(int)addWave:(int)a{
	
	int returnValue = 0;
	
	if (a-crossingPoint<3 && a-crossingPoint>-3) 
		returnValue = 16 ;
	else if (a-(crossingPoint+10)<3 && a-(crossingPoint+10)>-3) 
		returnValue = 32 ;
	else if (a-(crossingPoint+20)<3 && a-(crossingPoint+20)>-3) 
		returnValue = 64 ;
	else if (a-(crossingPoint+30)<3 && a-(crossingPoint+30)>-3) 
		returnValue = 128 ;
	else if (a-(crossingPoint+50)<3 && a-(crossingPoint+50)>-3) 
		returnValue = 1 ;
	else if (a-(crossingPoint+60)<3 && a-(crossingPoint+60)>-3) 
		returnValue = 2 ;
	else if (a-(crossingPoint+70)<3 && a-(crossingPoint+70)>-3) 
		returnValue = 4 ;
	else if (a-(crossingPoint+80)<3 && a-(crossingPoint+80)>-3) 
		returnValue = 8 ;
	else
		returnValue = 0;


	int diff = 0;
	int rA = a % 5;
	int rCP = crossingPoint % 5;
	
	// need adjustment
	if (rA != rCP) 
	{
		// calculate difference between crossPoint
		diff = rA - rCP;
		
		if (diff >= 3) {
			diff = diff - 5;
		}else if (diff <= -3) {
			diff = diff + 5;
		}
		
		// adjust crossPoint
		if (diff < 0) {
			crossingPoint = crossingPoint - 1;
		}else{
			crossingPoint = crossingPoint + 1;
		}
	}

	return returnValue;
	
}



-(NSData*) decryptAudioData:(NSData*)audioData{
	
	//NSLog(@"Routine = %@",@"decryptAudioData");
	
	int x4 = 1;
	if (baud2400) {
		x4 = 4;
	}
	
	NSMutableData *str = [[NSMutableData alloc] initWithCapacity:0];
	size_t length = [audioData length];
	SInt8 adBytes[length];
	[audioData getBytes:adBytes length:length];
	adBytes[length - 1] = 0;
	
	int position = length - 65000; // 65000/48000 = 1.354167 second
	if (position < 0) position = 0;
		
	//************************************************************
	int baseline = 0;
	int tBaseline = 0;
	int maxSample = 0;
	int minSample = 0;
	int maxCounter = 0;
	int minCounter = 0;
	
	BOOL use3G = FALSE;
	if ([[self platform] isEqualToString:@"iPhone1,2"]) use3G = TRUE;

	
	// get average high and average low of background noise
	if (length > position+800) {
		
		for (int sample = position; sample < position+800; sample++) {

			if (adBytes[sample] > 0) {
				maxSample = maxSample + adBytes[sample];
				maxCounter = maxCounter + 1;
			}
			if (adBytes[sample] <= 0) {
				minSample = minSample + adBytes[sample];
				minCounter = minCounter + 1;
			}
		}

		maxSample = maxSample/maxCounter;
		minSample = minSample/minCounter;
		//NSLog(@"[Debug] average = %d, %d", maxSample, minSample);
	}

	if (maxSample < 10) maxSample = 10;
	if (minSample > -10) minSample = -10;
	
	if (use3G)
	{
		maxSample = maxSample + 30;
		minSample = minSample - 30;

		if (maxSample > 70) maxSample = 65;
		if (minSample < -80) minSample = -80;

	}else {

		maxSample = maxSample + 50;
		minSample = minSample - 50;

		if (maxSample > 100) maxSample = 80;
		if (minSample < -100) minSample = -80;
	}
	
	// calculate baseline according to average high and average low
	baseline = maxSample + minSample;
	
	//NSLog(@"[Debug] length = %d", length);
	//NSLog(@"[Debug] baseline of noise = %d", baseline);
	//NSLog(@"[Debug] threshold = %d, %d", maxSample, minSample);

	
	

	int myChar = 0;
	int bitFlag = 1;
	int newPosition = 0;
	BOOL isLow = FALSE;
	int byteCounter = 0;


	//************************************************************
	if (use3G) {

		int maxData = 0;
		int minData = 0;
		NSMutableArray *minArray = [[NSMutableArray alloc] init];
		NSMutableArray *maxArray = [[NSMutableArray alloc] init];
		
		while (position + 1 * x4 < length) 
		{
			
			if ( adBytes[position] > maxSample && adBytes[position+45 * x4] < minSample && adBytes[position+50 * x4] > maxSample ) {
				
				//NSLog(@"============================================================");
				//NSLog(@"[Debug] found matched byte: adBytes[%d] = %i", position, adBytes[position]);
				
				if (byteCounter % 5 == 0) 
				{
					maxData = 0;	
					minData = 0;
					maxCounter = 0;
					minCounter = 0;
					
					for (int i=position; i<position+200; i++) {
						
						if (adBytes[i] > maxSample) {
							maxCounter = maxCounter + 1;
							[maxArray addObject:[NSNumber numberWithInt:adBytes[i]]];
						}
						if (adBytes[i] < minSample) {
							minCounter = minCounter + 1;
							[minArray addObject:[NSNumber numberWithInt:adBytes[i]]];
						}
					}
					
					[maxArray sortUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"doubleValue" ascending:NO] autorelease]]];
					[minArray sortUsingDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"doubleValue" ascending:YES] autorelease]]];
					
					int endCounter = 18;
					if (maxCounter < 18) endCounter = maxCounter-2;
					for (int f = 2; f < endCounter; f++) {
						maxData = maxData + [[maxArray objectAtIndex:f] intValue];
					}
					if (endCounter-2 > 0)
						maxData = maxData/(endCounter-2);
					else
						maxData = maxSample;
					
					endCounter = 18;
					if (minCounter < 18) endCounter = minCounter-2;
					for (int f = 2; f < endCounter; f++) {
						minData = minData + [[minArray objectAtIndex:f] intValue];
					}
					if (endCounter-2 > 0)
						minData = minData/(endCounter-2);
					else 
						minData = minSample;

					
					if (maxData < 40) maxData = 40;
					if (minData > -40) minData = -40;
					tBaseline = maxData + minData;
					
					// safe guard for baseline
					if (byteCounter == 0) {
						baseline = tBaseline;
					}else{
						if (tBaseline-baseline > 2) {
							baseline = baseline + 2;
						}else if (tBaseline-baseline < -2) {
							baseline = baseline - 2;
						}else {
							baseline = tBaseline;
						}
					}
					
					// update threshold dynamically
					maxSample = maxData * 0.75;
					minSample = minData * 0.75;
					
					//NSLog(@"[Debug] updtae baseline = %d >> %d", tBaseline, baseline);
					//NSLog(@"[Debug] update threshold = %d, %d", maxSample, minSample);
					
					[maxArray removeAllObjects];
					[minArray removeAllObjects];
				}
				
				bitFlag = 1;
				isLow = FALSE;
				myChar = 0;	
				
				// reset bit range checker
				crossingPoint = 10;
				
				//lets get the crossover points for the next 95 samples
				for (int z = 0; z < 101; z++) {
					if (bitFlag == -1) {
						//if (adBytes[position + z * x4] > 0 ) {
						if (adBytes[position + z * x4] > baseline ) {
							if (isLow == TRUE) myChar = myChar + [self addWave:z];
							bitFlag = 1;
							if (z>97 && isLow == FALSE) {
								newPosition = z;
							}
						}
					}
					else  {
						//if (adBytes[position + z * x4] < 0 ) {
						if (adBytes[position + z * x4] < baseline ) {
							if (isLow == FALSE) myChar = myChar + [self addWave:z];
							bitFlag = -1;
							if (z>97 && isLow == TRUE) {
								newPosition = z;
							}
						}
					}
					
				}
				
				
				if (newPosition <= 0) {
					//NSLog(@"[Debug] skip");
					
				}else{
					
					adBytes[0] = myChar;
					[str appendBytes:adBytes length:1];
					byteCounter = byteCounter + 1;
					
					//NSLog(@"[Debug] found matched byte: adByte[%d] = %d with value %i >> %c", position, adBytes[position], myChar, myChar);
					position = position + (newPosition * x4) - (3 * x4);
				}
				
				//NSLog(@"[Debug] next position >> %d", position + x4);
			}
			
			position = position + x4; // increment by 1
		}
		
		[minArray release];
		[maxArray release];
		
		
	//************************************************************	
	}else{
		
		while (position + 1 * x4 < length) {
			
			if ( adBytes[position] < minSample && adBytes[position+45 * x4] > maxSample && adBytes[position+50 * x4] < minSample ) {
				
				bitFlag = -1;
				isLow = TRUE;
				myChar = 0;
				
				// reset bit range checker
				crossingPoint = 10;
				
				//lets get the crossover points for the next 95 samples
				for (int z = 0; z < 101; z++) {
					if (bitFlag == -1) {
						//if (adBytes[position + z * x4] > 0 ) {
						if (adBytes[position + z * x4] > baseline ) {
							if (isLow == TRUE) myChar = myChar + [self addWave:z];
							bitFlag = 1;
							if (z>97 && isLow == FALSE) {
								newPosition = z;
							}
						}
					}
					else  {
						//if (adBytes[position + z * x4] < 0 ) {
						if (adBytes[position + z * x4] < baseline ) {
							if (isLow == FALSE) myChar = myChar + [self addWave:z];
							bitFlag = -1;
							if (z>97 && isLow == TRUE) {
								newPosition = z;
							}
						}
					}
					
				}
				
				if (newPosition <= 0) {
					//NSLog(@"[Debug] skip");
				}else{
					
					adBytes[0] = myChar;
					[str appendBytes:adBytes length:1];
					byteCounter = byteCounter + 1;
					
					//NSLog(@"[Debug] found matched byte: adByte[%d] = %d with value %i >> %c", position, adBytes[position], myChar, myChar);
					position = position + (newPosition * x4) - (3 * x4);
				}
				
				//NSLog(@"[Debug] next position >> %d", position + x4);
			}
			
			position = position + x4; // increment by 1
		}
		
		
	}
	

	audioPlayer.volume = 1.0;
	
	return str;
	
}

						  

-(NSInteger) verifyCardData:(NSData*)cardData{

	
	NSString *searchString = [[NSString alloc] initWithData:cardData encoding: NSASCIIStringEncoding];
	NSString *JIS = @"[\x7F][\x20-\x7E]+[\x7F]";
	NSString *ISO_1 = @"[\x25][\x20-\x7E]+[\x3F]";
	NSString *ISO_2 = @"[\x3B][\x20-\x7E]+[\x3F]";
	
	unsigned int length = 0;
	length = [searchString length];
	
	
	// non-encrypted data format
	//**************************************************
	if( ([searchString hasPrefix:@"%"] || [searchString hasPrefix:@";"]) ){
		
		NSString *regEx = [NSString stringWithFormat:@"(%@){0,1}(%@){0,2}(%@){0,1}[\x0D]", ISO_1, ISO_2, JIS];
		
		BOOL matched = FALSE;
		NSPredicate *regPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
		matched = [regPred evaluateWithObject:searchString];
		
		if (matched) {

			return length;
		}
		
		
	// encrypted data format or JIS format
	//**************************************************
	}else{
		
		NSString *regEx = [NSString stringWithFormat:@"(%@%@%@|%@%@|%@%@|%@){1}[\x0D]", JIS,ISO_2,JIS, JIS,JIS, JIS,ISO_2, JIS];

		BOOL matched = FALSE;
		NSPredicate *regPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
		matched = [regPred evaluateWithObject:searchString];
		
		// JIS format
		if (matched)
		{
			return length;
			
		// encrypted data format
		}else{
			
			length = [cardData length];
			Byte *byteData = (Byte*) malloc(length);
			memcpy(byteData, [cardData bytes], length);
			unsigned char checkLRC;
			unsigned int checkSum;
			
			if (length > 6) {
				
				checkLRC = byteData[3];
				checkSum = byteData[3];
				
				for (int i = 4;i<length-3;i++) {
					checkLRC = checkLRC ^ byteData[i];
					checkSum = checkSum + byteData[i];
				}
				
				checkLRC = checkLRC ^ byteData[length-3];
				checkSum = checkSum%256;
				
				if (checkLRC == 0 && checkSum == byteData[length-2]) {
					
					return length;
				}
				
			}
			
			// release resource
			free(byteData);
			
		}
		
	}
	
	// release resource
	[searchString release];

	return 0;
}


-(void) checkRecording{
	
	if (meterValid == TRUE){
		meterValid = FALSE;
		[meterTimer invalidate];
	}

	checkMeter = FALSE;
	checkingPower = FALSE;
	
	if (readerAttached == TRUE  && evaluateSwipe == FALSE) {
		
		readerAttached = FALSE;
		needsSwipe = FALSE;
		checkMeter = FALSE;
		
		if (!keepPowerOn) audioPlayer.volume = 0.0;					//[audioPlayer stop];
		
		NSString* da = @"Timeout - No Data Read";
		[[NSNotificationCenter defaultCenter] postNotificationName:@"uniMagDidReceiveDataNotification" object:[da dataUsingEncoding:NSUTF8StringEncoding] ];
		
	}
	else 
	{
		
		int x4 = 1;
		if (baud2400) {
			x4 = 4;
		}
		
		//[RecordTimer invalidate];

		NSURL *url = [NSURL fileURLWithPath: recorderFilePath];
		NSError *err = nil;
		
		cancelSwipe = FALSE;
		
		
		if (evaluateSwipe) {
			
			evaluateSwipe = false;
			NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
			

			// remove audio file after decode
			//**************************************************
			NSFileManager *fm = [NSFileManager defaultManager];
			[fm removeItemAtPath:[url path] error:&err];
			if(err)
				NSLog(@"File Manager: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
			//**************************************************
			
			
			NSData* returnValue = [[self decryptAudioData:audioData] retain];
			NSString* aStr = [[NSString alloc] initWithData:returnValue encoding:NSASCIIStringEncoding];
			
			// trim preamble off
			//**************************************************
			NSRange rangePowerUpStr, rangeRealData;
			rangePowerUpStr = [aStr rangeOfString:[NSString stringWithFormat:@"UUUUUUUUUUUUUUf"]];
			
			if (rangePowerUpStr.length > 0) {
				
				int position = rangePowerUpStr.location + rangePowerUpStr.length;
				
				if (ValidateOnly) {
					rangeRealData = NSMakeRange(position, [returnValue length]-(position)-1);
				}else {
					rangeRealData = NSMakeRange(position + 1, [returnValue length]-(position)-1);
				}
				
				// reset value after trimmed preamble off
				returnValue = [returnValue subdataWithRange:rangeRealData];
				
				[aStr release];
				aStr = [[NSString alloc] initWithData:returnValue encoding:NSASCIIStringEncoding];

			}

			NSLog(@"UniMag response - %@", aStr);
			//**************************************************

			
			if (ValidateOnly) {
				NSLog(@"Enter validate only");
				
				if([aStr rangeOfString:@"ID"].location != NSNotFound){
					
					ValidateOnly = FALSE;
					uniConnected = TRUE;
					verifyCounter = 3;
					
					needsPower = FALSE;
					checkMeter = FALSE;
					headphoneCheck = FALSE;
					[[NSNotificationCenter defaultCenter] postNotificationName:@"uniMagDidConnectNotification" object:nil];			
					if (!keepPowerOn) audioPlayer.volume = 0.0;
					
				}
				else 
				{
					uniConnected = FALSE;
					verifyMe = TRUE;
					
					if (!keepPowerOn) audioPlayer.volume = 0.0;
				}
				
			}
			else if (!readerAttached) { //let's check for reader attachment
				NSLog(@"Enter ! readerattached");
				
				if([aStr rangeOfString:@"ID"].location != NSNotFound){
					
					readerAttached = true;
					swipeCancelled = FALSE;
					needsSwipe = TRUE;
				
					[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startRecording) userInfo:nil repeats:NO];						
					[[NSNotificationCenter defaultCenter] postNotificationName:@"uniMagSwipeNotification" object:nil];
					
				}
			}
			else if (readerAttached && needsSwipe) {
				
				// filter bad swipes
				//**************************************************
				int verifiedLength = 0;
				verifiedLength = [self verifyCardData:returnValue];
				
				if (verifiedLength == 0){
					
					NSLog(@"[Error] Bad swipe");
					
					readerAttached = FALSE;
					needsSwipe = FALSE;
					checkMeter = FALSE;
					
					NSString* da = @"Bad Swipe, Please Swipe Again.";
					[[NSNotificationCenter defaultCenter] postNotificationName:@"uniMagDidReceiveDataNotification" object:[da dataUsingEncoding:NSUTF8StringEncoding] ];
					
				}
				else
				{
					readerAttached = FALSE;
					needsSwipe = FALSE;
					checkMeter = FALSE;
					
					[[NSNotificationCenter defaultCenter] postNotificationName:@"uniMagDidReceiveDataNotification" object:returnValue ];
					
				}
				//**************************************************
				
			}
			else 
			{
				NSLog(@"Enter else");

				[[NSNotificationCenter defaultCenter] postNotificationName:@"uniMagDidReceiveDataNotification" object:nil];
			}
			
			
			[aStr release];
			
		}
		else 
		{
			NSLog(@"nothing to do.");
		}
		
		
		if (!readerAttached) {
			if (!keepPowerOn) audioPlayer.volume = 0.0;
		}
		
	}
	
}


-(void) swipeTimeout{
	
	if (evaluateSwipe == FALSE && needsSwipe == TRUE) {
		swipeTimeout = TRUE;
		[[NSNotificationCenter defaultCenter] postNotificationName:@"uniMagTimeoutSwipe" object:nil];

		// recover from swipe timeout
		//**************************************************
		if (meterValid == TRUE){
			meterValid = FALSE;
			[meterTimer invalidate];
		}

		checkMeter = FALSE;
		if (swipeValid == TRUE) {
			swipeValid = FALSE;
			[swipeTimer invalidate];
		}
		//**************************************************
	}
}


-(void) requestSwipe{
	
	//NSLog(@"Routine = %@",@"requestSwipe");
	
	if (uniConnected) {
		
		if (audioPlayer.volume == 1.0) {
			
			readerAttached = TRUE;
			swipeCancelled = FALSE;
			needsSwipe = TRUE;
			
			[NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(startRecording) userInfo:nil repeats:NO];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"uniMagSwipeNotification" object:nil];
			
		}else{
			
			ValidateOnly = FALSE;
			readerAttached = FALSE;
			[self startRecording];
			
			if (!keepPowerOn) [[NSNotificationCenter defaultCenter] postNotificationName:@"uniMagPoweringNotification" object:nil];
		}
	}
}



-(void) cancelSwipe{

	//NSLog(@"Routine = %@",@"cancelSwipe");

	cancelSwipe = TRUE;
	if (meterValid == TRUE){
		meterValid = FALSE;
		[meterTimer invalidate];
	}
	if (swipeValid == TRUE) {
		swipeValid = FALSE;
		[swipeTimer invalidate];
	}
	verifyMe = FALSE;
	[recorder stop];
	
}



-(void) promptForConnection:(BOOL)prompt{
	confirmConnection = prompt;
}



-(float) getVolumeLevel{

	MPVolumeView *slide = [MPVolumeView new];
	UISlider *volumeViewSlider;
	
	for (UIView *view in [slide subviews]){
		if ([[[view class] description] isEqualToString:@"MPVolumeSlider"]) {
			volumeViewSlider = (UISlider *) view;
		}
	}
	float val = [volumeViewSlider value];

	
	//[slide release];
	
	return val;
	
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	
	if (alertView == confirmUniMag )
	{
		if (buttonIndex == 1) {
			proceed = TRUE;
			dialogOpen = FALSE;
		}
		else 
		{
			noUniMag = TRUE;
			
			ValidateOnly = FALSE;
			needsPower = FALSE;
			needsSwipe = FALSE;
			evaluateSwipe = FALSE;
			proceed = FALSE;
			dialogOpen = FALSE;
			
		}
	}
	
	
	if (alertView == volumeWarning){
		
		NSLog(@"[Debug] alertView");
		//audioPlayer.volume = 0.0;
		swipeCancelled = TRUE;  //so we don't get timeout error
		ValidateOnly = TRUE;
		
		[self playTone];
		[self startRecording];
		[[NSNotificationCenter defaultCenter] postNotificationName:@"uniMagPoweringNotification" object:nil];
		
		verifyCounter = 0;
		needsSwipe = FALSE;
		headphoneCheck = TRUE;
	}
	
}



@end
