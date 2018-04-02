
#pragma once

#include "WRLDSpeechHandler.h"
#include "WRLDSpeechObserver+Private.h"

@interface WRLDSpeechHandler (Private)
- (IBAction)outsideBoundsClickHandler:(id)sender;
- (IBAction)insideBoundsClickHandler:(id)sender;
- (IBAction)cancelButtonClickHandler:(id)sender;

-(void) authorize;
-(void) startRecording;
-(void) endRecording;

@end
