
#import <Foundation/Foundation.h>
#import <accelerate/Accelerate.h>
#import "WRLDSpeechHandler.h"
#import "WRLDSpeechObserver+Private.h"

@interface WRLDSpeechHandler()
@property (strong, nonatomic) IBOutlet UIView *microphoneOverlayRootView;
@property (strong, nonatomic) IBOutlet UIView *microphoneIconView;
@property (strong, nonatomic) IBOutlet UILabel *promptTextView;
@end

@implementation WRLDSpeechHandler
{
    SFSpeechRecognizer* m_speechRecognizer;
    AVAudioEngine* m_audioEngine;
    SFSpeechAudioBufferRecognitionRequest *m_recognitionRequest;
    SFSpeechRecognitionTask *m_recognitionTask;
    UIView* m_rootView;
    
    BOOL m_hasPartialResult;
    NSTimer* m_speechTimeout;
    BOOL m_wasCancelled;
    CGFloat m_inputVolume;
    CGRect m_originalIconBounds;
    CGRect m_screenFrame;
}

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _isEnabled = NO;
        _isAuthorized = NO;
        _isRecording = NO;
        _promptText = @"Search the WRLD";
        
        m_screenFrame = frame;
        
        NSBundle* bundle = [NSBundle bundleForClass:[WRLDSpeechHandler class]];
        m_rootView = [[bundle loadNibNamed:@"WRLDMicrophoneOverlay" owner:self options:nil] objectAtIndex:0];
        
        _observer = [[WRLDSpeechObserver alloc] init];
        
        [self addSubview:m_rootView];
        m_rootView.frame = m_screenFrame;
        
        self.hidden = YES;
        
        float initialRadius = self.microphoneIconView.bounds.size.height/2.0f;
        self.microphoneIconView.layer.cornerRadius = initialRadius + 5;
        self.microphoneIconView.clipsToBounds = YES;
        
        m_originalIconBounds = self.microphoneIconView.bounds;
    }
    return self;
}

-(void)layoutSubviews
{
    // TODO: Fix up full-screen view hackery
    CGPoint rootOffset = [self convertPoint:CGPointMake(0, 0) toView:nil];
    m_screenFrame.origin.x = -rootOffset.x;
    m_screenFrame.origin.y = -rootOffset.y;
    m_rootView.frame = m_screenFrame;
    
    [super layoutSubviews];
}

-(void) enableWithPrompt:(NSString*)promptText
{
    _isEnabled = YES;
    _promptText = promptText;
    [self.promptTextView setText:_promptText];
}

-(void) disable
{
    _isEnabled = NO;
}

-(IBAction)outsideBoundsClickHandler:(id)sender
{
    [self cancelRecording];
}

-(IBAction)insideBoundsClickHandler:(id)sender
{
}

-(IBAction)cancelButtonClickHandler:(id)sender
{
    [self cancelRecording];
}

-(void) endRecording
{
    [m_audioEngine stop];
    [m_recognitionRequest endAudio];
    self.hidden = YES;
}

-(void) cancelRecording
{
    m_wasCancelled = YES;
    [self endRecording];
    [_observer speechRecordingCancelled];
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if(self.hidden) {
        return NO;
    }
    return [super pointInside:point withEvent:event];
}

-(void) authorize
{
    // TODO: Locale configuration
    m_speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en-GB"]];
    m_speechRecognizer.delegate = self;
    
    _isAuthorized = NO;
    
    m_audioEngine = [[AVAudioEngine alloc] init];
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch(status) {
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    _isAuthorized = YES;
                    [_observer authorizationChanged:_isAuthorized];
                    break;
                case SFSpeechRecognizerAuthorizationStatusDenied:
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    _isAuthorized = NO;
                    [_observer authorizationChanged:_isAuthorized];
                    break;
                default:
                    break;
            }
        });
    }];
}

-(void)completeVoiceQuery:(NSTimer*)timer
{
    if([m_audioEngine isRunning]) {
        
        NSLog(@"Time ran out so ending recording");
        [self endRecording];
    }
}

-(void)startRecording
{
    if(!self.isEnabled) {
        return;
    }
    
    if(!self.isAuthorized) {
        return;
    }
    
    if(self.isRecording) {
        return;
    }
    
    if(m_recognitionTask) {
        [m_recognitionTask cancel];
        m_recognitionTask = nil;
    }
    
    AVAudioSession* audioSession = [self initialiseAudioSession];
    if(audioSession == nil) {
        return;
    }
    
    m_recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    m_recognitionRequest.shouldReportPartialResults = YES;
    
    m_wasCancelled = NO;
    AVAudioInputNode *inputNode = m_audioEngine.inputNode;
    m_recognitionTask = [self initialiseRecognitionTask :inputNode];
    [self initialiseAudioSampling :inputNode];
    
    _isRecording = YES;
    self.hidden = NO;
    
    [m_audioEngine prepare];
    
    m_hasPartialResult = NO;
    
    [_observer speechRecordingStarted];
    
    NSError* error;
    [m_audioEngine startAndReturnError:&error];
}

- (AVAudioSession*)initialiseAudioSession
{
    NSError* error;
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    if(![audioSession setCategory:AVAudioSessionCategoryRecord error:&error]) {
        NSLog(@"%@", [error domain]);
        return nil;
    }
    if(![audioSession setMode:AVAudioSessionModeMeasurement error:&error]) {
        NSLog(@"%@", [error domain]);
        return nil;
    }
    
    if(![audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error]) {
        NSLog(@"%@", [error domain]);
        return nil;
    }
    
    return audioSession;
}

-(SFSpeechRecognitionTask*)initialiseRecognitionTask :(AVAudioInputNode*)inputNode
{
    SFSpeechRecognitionTask* recognitionTask = [m_speechRecognizer recognitionTaskWithRequest:m_recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if(error != nil || result.isFinal) {
            [m_audioEngine stop];
            self.hidden = YES;
            [inputNode removeTapOnBus:0];
            _isRecording = NO;
            if(m_speechTimeout) {
                [m_speechTimeout invalidate];
            }
            
            NSString* bestTranscription = result.bestTranscription.formattedString;
            if(!m_wasCancelled && bestTranscription && [bestTranscription length]) {
                NSLog(@"%@", bestTranscription);
                [_observer speechRecordingCompleted:bestTranscription];
            }
            else {
                NSLog(@"Coudn't transcribe input");
                [self cancelRecording];
            }
            
            m_recognitionRequest = nil;
            m_recognitionTask = nil;
        }
        if(error == nil && !result.isFinal)
        {
            m_hasPartialResult = YES;
            if(m_speechTimeout) {
                [m_speechTimeout invalidate];
            }
            m_speechTimeout = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                               target:self
                                                             selector:@selector(completeVoiceQuery:)
                                                             userInfo:nil
                                                              repeats:NO];
        }
    }];
    return recognitionTask;
}

-(void)initialiseAudioSampling :(AVAudioInputNode*)inputNode
{
    AVAudioFormat* recordingFormat = [inputNode outputFormatForBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        UInt32 inNumberFrames = buffer.frameLength;
        [m_recognitionRequest appendAudioPCMBuffer: buffer];
        Float32* samples = (Float32*)buffer.floatChannelData[0];
        
        Float32 avgActivity = 0;
        
        vDSP_meamgv((Float32*)samples, 1, &avgActivity, inNumberFrames);
        
        m_inputVolume = MAX(0, MIN(10, avgActivity * 1000));
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                [self.microphoneIconView setBounds:CGRectInset(m_originalIconBounds, -m_inputVolume, -m_inputVolume)];
            }];
        });
    }];
}

-(void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available
{
    _isAuthorized = available;
}

@end
