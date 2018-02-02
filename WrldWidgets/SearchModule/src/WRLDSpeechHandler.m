#import <Foundation/Foundation.h>
#import "WRLDSpeechHandler.h"
#import "WRLDSearchWidgetViewSubclass.h"

@interface WRLDSpeechHandler()
@property (strong, nonatomic) IBOutlet UIView *wrldMicrophoneOverlayRootView;
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
    }
    return self;
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
    [self endRecording];
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
        [m_recognitionRequest appendAudioPCMBuffer: buffer];
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

