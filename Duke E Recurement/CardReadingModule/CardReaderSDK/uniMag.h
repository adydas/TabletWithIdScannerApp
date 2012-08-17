//
//  uniMag.h
//  IDTech
//
//  Created by Randy Palermo on 5/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#include <sys/sysctl.h>

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface uniMag : NSObject <AVAudioRecorderDelegate>  {
	
	AVAudioPlayer *audioPlayer;
	AVAudioRecorder *recorder;
	NSString *recorderFilePath;
	NSMutableDictionary *recordSetting;
	NSTimer *RecordTimer;
	AVAudioSession *audioSession;
	SystemSoundID cmd;
	NSTimer *autoTimer;
	NSTimer *meterTimer;
	NSTimer *swipeTimer;
	UILabel *powerLabel;
	
	UIAlertView *confirmUniMag;
	UIAlertView *volumeWarning;
	UIAlertView *confirmUniMagVolume;
		
}

-(id)init;
-(void) requestSwipe;
-(void) cancelSwipe;
-(void) autoDetect:(BOOL)autoDetect;
-(void) startUniMag:(BOOL)start;
-(NSData*) getWave;
-(void) checkRecording;
-(void) playTone;

-(void) promptForConnection:(BOOL)prompt;
-(float) getVolumeLevel;
-(void) closeConnection;

-(NSInteger) verifyCardData:(NSData*) cardData;


@end
