
#pragma once

#import <UIKit/UIKit.h>
#import <Speech/Speech.h>

#include "WRLDSpeechObserver+Private.h"

@interface WRLDSpeechHandler : UIView <SFSpeechRecognizerDelegate>
- (IBAction)outsideBoundsClickHandler:(id)sender;
- (IBAction)insideBoundsClickHandler:(id)sender;
- (IBAction)cancelButtonClickHandler:(id)sender;


-(void) authorize;
-(void) startRecording;
-(void) endRecording;

-(void) enableWithPrompt:(NSString*)promptText;
-(void) disable;

@property (readonly) BOOL isRecording;
@property (readonly) BOOL isAuthorized;
@property (readonly) BOOL isEnabled;
@property (readonly) NSString* promptText;

@property (nonatomic, readonly) WRLDSpeechObserver * observer;
@end
