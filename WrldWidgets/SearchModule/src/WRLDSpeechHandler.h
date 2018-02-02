#pragma once

#import <UIKit/UIKit.h>
#import <Speech/Speech.h>

@class WRLDSearchWidgetView;

@interface WRLDSpeechHandler : UIView <SFSpeechRecognizerDelegate>
- (IBAction)outsideBoundsClickHandler:(id)sender;
- (IBAction)insideBoundsClickHandler:(id)sender;
- (IBAction)cancelButtonClickHandler:(id)sender;

-(void) authorize;
-(void) startRecording;
-(void) endRecording;
-(void) setSearchView:(WRLDSearchWidgetView *) searchHandler;
@property (readonly) BOOL isRecording;

@property (readonly) BOOL isAuthorized;
@end

