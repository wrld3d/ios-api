#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>
#import "WRLDSpeechHandler.h"
#import "WRLDSearchWidgetViewSubclass.h"

@interface WRLDSpeechHandler()
@property (strong, nonatomic) IBOutlet UIView *wrldMicrophoneOverlayRootView;
@property (strong, nonatomic) IBOutlet UIView *wrldMicrophoneIconView;
@end

@implementation WRLDSpeechHandler
{
    SFSpeechRecognizer * m_speechRecognizer;
    AVAudioEngine * m_audioEngine;
    SFSpeechAudioBufferRecognitionRequest *m_recognitionRequest;
    SFSpeechRecognitionTask *m_recognitionTask;
    BOOL m_hasPartialResult;
    NSTimer * m_speechTimeout;
    BOOL m_wasCancelled;
    WRLDSearchWidgetView * m_searchHandler;
    CGFloat m_inputVolume;
    CGRect m_originalIconBounds;
}

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        NSBundle* bundle = [NSBundle bundleForClass:[WRLDSpeechHandler class]];
        [bundle loadNibNamed:@"WRLDMicrophoneOverlay" owner:self options:nil];
        
        [self addSubview:self.wrldMicrophoneOverlayRootView];
        self.wrldMicrophoneOverlayRootView.frame = self.bounds;
        
        self.hidden = YES;
        
        float initialRadius =_wrldMicrophoneIconView.bounds.size.height / 2.0f;
        self.wrldMicrophoneIconView.layer.cornerRadius = initialRadius + 5;
        
        m_originalIconBounds = _wrldMicrophoneIconView.bounds;
    }
    return self;
}

-(void) animateMicrophoneIcon
{
}

-(void) setSearchView:(WRLDSearchWidgetView *) searchHandler
{
    m_searchHandler = searchHandler;
    [self authorize];
}

-(IBAction)outsideBoundsClickHandler:(id)sender
{
    m_wasCancelled = YES;
    [self endRecording];
}

-(IBAction)insideBoundsClickHandler:(id)sender
{
    //[self endRecording];
}

-(IBAction)cancelButtonClickHandler:(id)sender
{
    m_wasCancelled = YES;
    [self endRecording];
}

-(void) endRecording
{
    [m_audioEngine stop];
    [m_recognitionRequest endAudio];
    self.hidden = YES;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if(self.hidden){
        return NO;
    }
    return [super pointInside:point withEvent:event];
}

-(void) authorize
{
    m_speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale: [[NSLocale alloc]initWithLocaleIdentifier: @"en-GB"]];
    m_speechRecognizer.delegate = self;
    
    _isAuthorized = NO;
    
    m_audioEngine = [[AVAudioEngine alloc] init];
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    NSLog(@"Authorized");
                    _isAuthorized = YES;
                    m_searchHandler.wrldSearchWidgetSpeechButton.hidden = NO;
                    break;
                case SFSpeechRecognizerAuthorizationStatusDenied:
                    _isAuthorized = NO;
                    break;
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    _isAuthorized = NO;
                    NSLog(@"Not Determined");
                    break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    _isAuthorized = NO;
                    break;
                default:
                    break;
            }
        });
    }];
}

-(void) completeVoiceQuery:(NSTimer*) timer
{
    if ([m_audioEngine isRunning]) {
        [self endRecording];
    }
}

-(void) startRecording
{
    if(!self.isAuthorized){
        NSLog(@"Recording Unauthorized");
        return;
    }
    
    if(self.isRecording){
        NSLog(@"Already Recording");
        return;
    }
    
    if(m_recognitionTask){
        [m_recognitionTask cancel];
        m_recognitionTask = nil;
    }
    
    NSError * error;
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    if(![audioSession setCategory:AVAudioSessionCategoryRecord error:&error]){
        NSLog(@"%@", [error domain]);
        return;
    }
    if(![audioSession setMode:AVAudioSessionModeMeasurement error:&error]){
        NSLog(@"%@", [error domain]);
        return;
    }
    if(![audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error]){
        NSLog(@"%@", [error domain]);
        return;
    }
    
    m_recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
    m_wasCancelled = NO;
    
    AVAudioInputNode *inputNode = m_audioEngine.inputNode;
    m_recognitionRequest.shouldReportPartialResults = true;
    
    m_recognitionTask = [m_speechRecognizer recognitionTaskWithRequest: m_recognitionRequest
                                                         resultHandler:^(SFSpeechRecognitionResult *result, NSError *error)
    {
         if (error != nil || result.isFinal) {
             [m_audioEngine stop];
             self.hidden = YES;
             [inputNode removeTapOnBus: 0];
             _isRecording = NO;
             if(m_speechTimeout){
                 [m_speechTimeout invalidate];
             }
             
             NSString* bestTranscription = result.bestTranscription.formattedString;
             if(!m_wasCancelled && bestTranscription && [bestTranscription length]){
                 [m_searchHandler setQueryTextWithoutSuggestions: bestTranscription];
                 [m_searchHandler runSearch:bestTranscription];
             }
             else{
                 [m_searchHandler cancelVoiceSearch];
             }
             
             m_recognitionRequest = nil;
             m_recognitionTask = nil;
         }
         if(error == nil && !result.isFinal)
         {
             m_hasPartialResult = YES;
             if(m_speechTimeout){
                 [m_speechTimeout invalidate];
             }
             m_speechTimeout = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                target:self
                                                              selector:@selector(completeVoiceQuery:)
                                                              userInfo:nil
                                                               repeats:NO];
         }
     }];
    
    AVAudioFormat* recordingFormat = [inputNode outputFormatForBus: 0];
    [inputNode installTapOnBus: 0 bufferSize: 1024 format: recordingFormat block:^(AVAudioPCMBuffer *buffer, AVAudioTime *when){
        UInt32 inNumberFrames = buffer.frameLength;
        [m_recognitionRequest appendAudioPCMBuffer: buffer];
        Float32* samples = (Float32*)buffer.floatChannelData[0];
        
        Float32 avgActivity = 0;
        
        
        vDSP_meamgv((Float32*)samples, 1, &avgActivity, inNumberFrames);
        
//        Float32 level_lowpass_trig = 0.3;
//        avgActivity = (level_lowpass_trig*((avgActivity==0)?-100:20.0*log10f(avgActivity))) + ((1-level_lowpass_trig)*avgActivity) ;
        
        m_inputVolume = MAX(0, MIN(10, avgActivity * 1000));
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3
                         animations:^{
                             [self.wrldMicrophoneIconView setBounds:CGRectInset(m_originalIconBounds, -m_inputVolume, -m_inputVolume)];
                         }];
        });
        
    }];
    
    _isRecording = YES;
    self.hidden = NO;
    
    [m_audioEngine prepare];
    
    m_hasPartialResult = false;
    [m_audioEngine startAndReturnError:&error];
}

- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer
   availabilityDidChange:(BOOL)available
{
    _isAuthorized = available;
}

@end

