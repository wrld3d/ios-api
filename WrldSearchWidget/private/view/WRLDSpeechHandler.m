
#import <Foundation/Foundation.h>
#import <accelerate/Accelerate.h>
#import "WRLDSpeechHandler.h"
#import "WRLDSpeechObserver+Private.h"

@interface WRLDSpeechHandler()
@property (strong, nonatomic) IBOutlet UIView *microphoneOverlayRootView;
@property (strong, nonatomic) IBOutlet UIView *microphoneIconView;
@property (strong, nonatomic) IBOutlet UIView *microphoneContainerView;
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
    CGFloat m_baseIconCornerRadius;
    CGRect m_originalIconContainerBounds;
}

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _isAuthorized = NO;
        _isRecording = NO;
        _promptText = @"Search the WRLD";
        
        NSBundle* bundle = [NSBundle bundleForClass:[WRLDSpeechHandler class]];
        m_rootView = [[bundle loadNibNamed:@"WRLDMicrophoneOverlay" owner:self options:nil] objectAtIndex:0];
        [self addSubview:m_rootView];
        
        _observer = [[WRLDSpeechObserver alloc] init];
        
        self.frame = frame;
        self.hidden = YES;
        self.alpha = 0.0f;
        
        float initialRadius = self.microphoneIconView.bounds.size.height/2.0f;
        self.microphoneIconView.layer.cornerRadius = initialRadius;
        self.microphoneIconView.clipsToBounds = YES;
        
        float initialContainerRadius = self.microphoneContainerView.bounds.size.height/2.0f;
        self.microphoneContainerView.layer.cornerRadius = initialContainerRadius;
        self.microphoneContainerView.clipsToBounds = YES;
        
        m_baseIconCornerRadius = initialContainerRadius;
        m_originalIconContainerBounds = self.microphoneContainerView.bounds;
    }
    return self;
}

-(void) setPrompt:(NSString*)promptText
{
    _promptText = promptText;
    [self.promptTextView setText:_promptText];
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
    [self hide];
}

-(void) cancelRecording
{
    m_wasCancelled = YES;
    [self endRecording];
    [_observer speechRecordingCancelled];
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if(self.hidden || self.alpha == 0.0) {
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
        
        [self endRecording];
    }
}

-(void)startRecording
{
    if(!self.isAuthorized) {
        [self authorize];
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
    [self show];
    
    [m_audioEngine prepare];
    
    m_hasPartialResult = NO;
    
    [_observer speechRecordingStarted];
    
    NSError* error;
    [m_audioEngine startAndReturnError:&error];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    m_rootView.frame = self.frame;
}

- (AVAudioSession*)initialiseAudioSession
{
    NSError* error;
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    if(![audioSession setCategory:AVAudioSessionCategoryRecord error:&error]) {
        NSLog(@"Audio session category failure: %@", [error domain]);
        return nil;
    }
    if(![audioSession setMode:AVAudioSessionModeMeasurement error:&error]) {
        NSLog(@"Audio session measurement failure: %@", [error domain]);
        return nil;
    }
    
    if(![audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error]) {
        NSLog(@"Audio session option failure: %@", [error domain]);
        return nil;
    }
    
    return audioSession;
}

-(SFSpeechRecognitionTask*)initialiseRecognitionTask :(AVAudioInputNode*)inputNode
{
    SFSpeechRecognitionTask* recognitionTask = [m_speechRecognizer recognitionTaskWithRequest:m_recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        if(error != nil || result.isFinal) {
            [m_audioEngine stop];
            [self hide];
            [inputNode removeTapOnBus:0];
            _isRecording = NO;
            if(m_speechTimeout) {
                [m_speechTimeout invalidate];
            }
            
            NSString* bestTranscription = result.bestTranscription.formattedString;
            if(!m_wasCancelled && bestTranscription && [bestTranscription length]) {
                [_observer speechRecordingCompleted:bestTranscription];
            }
            else {
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
                float animateScale = 1.0;
                [self.microphoneContainerView setBounds:CGRectInset(m_originalIconContainerBounds, -m_inputVolume*animateScale, -m_inputVolume*animateScale)];
                [self.microphoneContainerView.layer setCornerRadius:m_baseIconCornerRadius + m_inputVolume*animateScale];
            }];
        });
    }];
}

-(void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available
{
    _isAuthorized = available;
    [_observer authorizationChanged:_isAuthorized];
}

-(void) show
{
    [self setHidden:NO];
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1.0;
    }];
}

-(void) hide
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self setHidden:YES];
    }];
}

@end
