#import "WRLDSearchWidgetViewWithSpeechRecognition.h"
#import "WRLDSearchWidgetViewSubclass.h"

@implementation WRLDSearchWidgetViewWithSpeechRecognition
{
    SFSpeechRecognizer * m_speechRecognizer;
    BOOL m_voiceAuthorized;
    AVAudioEngine * m_audioEngine;
    SFSpeechAudioBufferRecognitionRequest *m_recognitionRequest;
    SFSpeechRecognitionTask *m_recognitionTask;
}
-(void)customInit
{
    [super customInit];
    NSLog(@"Init for WRLDSearchWidgetViewWithSpeechRecognition");
    m_speechRecognizer = [[SFSpeechRecognizer alloc] initWithLocale: [[NSLocale alloc]initWithLocaleIdentifier: @"en-GB"]];
    m_speechRecognizer.delegate = self;
    
    m_voiceAuthorized = NO;
    
    m_audioEngine = [[AVAudioEngine alloc] init];
    
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    NSLog(@"Authorized");
                    m_voiceAuthorized = YES;
                    self.wrldSearchWidgetSpeechButton.hidden = NO;
                    break;
                case SFSpeechRecognizerAuthorizationStatusDenied:
                    m_voiceAuthorized = NO;
                    break;
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    m_voiceAuthorized = NO;
                    NSLog(@"Not Determined");
                    break;
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    m_voiceAuthorized = NO;
                    break;
                default:
                    break;
            }
        });
    }];
}

-(void) voiceButtonClicked:(id)sender
{
    if ([m_audioEngine isRunning]) {
        [m_audioEngine stop];
        [m_recognitionRequest endAudio];
    } else {
        [self startRecording];
    }
}

-(void) startRecording
{
    if(!m_voiceAuthorized){
        NSLog(@"Recording Unauthorized");
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
    
    AVAudioInputNode *inputNode = m_audioEngine.inputNode;
    m_recognitionRequest.shouldReportPartialResults = true;
    
    m_recognitionTask = [m_speechRecognizer recognitionTaskWithRequest: m_recognitionRequest
                                                          resultHandler:^(SFSpeechRecognitionResult *result, NSError *error){
        
        if (error != nil || result.isFinal) {
            [m_audioEngine stop];
            [inputNode removeTapOnBus: 0];
            
            NSString* bestTranscription = result.bestTranscription.formattedString;
            if(bestTranscription && [bestTranscription length]){
                [self setQueryTextWithoutSuggestions: bestTranscription];
                [self runSearch:bestTranscription];
            }
            
            m_recognitionRequest = nil;
            m_recognitionTask = nil;
        }
    }];
    
    AVAudioFormat* recordingFormat = [inputNode outputFormatForBus: 0];
    [inputNode installTapOnBus: 0 bufferSize: 1024 format: recordingFormat block:^(AVAudioPCMBuffer *buffer, AVAudioTime *when){
        [m_recognitionRequest appendAudioPCMBuffer: buffer];
    }];
    
    [m_audioEngine prepare];
    
    [m_audioEngine startAndReturnError:&error];
}

- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer
   availabilityDidChange:(BOOL)available
{
    m_voiceAuthorized = available;
}

-(BOOL) showVoiceButton
{
    return m_voiceAuthorized;
}
@end
