#import "WRLDSpeechObserver.h"
#import "WRLDSpeechObserver+Private.h"

@implementation WRLDSpeechObserver
{
    NSMutableArray<VoiceAuthorizedEvent>* m_voiceAuthorizedEvents;
    NSMutableArray<VoiceEvent>* m_voiceStartedRecordingEvents;
    NSMutableArray<VoiceEvent>* m_voiceCancelledRecordingEvents;
    NSMutableArray<VoiceRecordedEvent>* m_voiceCompletedRecordingEvents;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        m_voiceAuthorizedEvents = [[NSMutableArray<VoiceAuthorizedEvent> alloc] init];
        m_voiceStartedRecordingEvents = [[NSMutableArray<VoiceEvent> alloc] init];
        m_voiceCancelledRecordingEvents = [[NSMutableArray<VoiceEvent> alloc] init];
        m_voiceCompletedRecordingEvents = [[NSMutableArray<VoiceRecordedEvent> alloc] init];
    }
    return self;
}

- (void)addAuthorizationChangedEvent:(VoiceAuthorizedEvent)event
{
    if(event)
    {
        [m_voiceAuthorizedEvents addObject:event];
    }
}

- (void)removeAuthorizationChangedEvent:(VoiceAuthorizedEvent)event
{
    if(event)
    {
        [m_voiceAuthorizedEvents removeObject:event];
    }
}

- (void)addVoiceRecordStartedEvent:(VoiceEvent)event
{
    if(event)
    {
        [m_voiceStartedRecordingEvents addObject:event];
    }
}
    
- (void)removeVoiceRecordStartedEvent:(VoiceEvent)event
{
    if(event)
    {
        [m_voiceStartedRecordingEvents removeObject:event];
    }
}

- (void)addVoiceRecordCancelledEvent:(VoiceEvent)event
{
    if(event)
    {
        [m_voiceCancelledRecordingEvents addObject:event];
    }
}

- (void)removeVoiceRecordCancelledEvent:(VoiceEvent)event
{
    if(event)
    {
        [m_voiceCancelledRecordingEvents removeObject:event];
    }
}

- (void)addVoiceRecordCompleteEvent:(VoiceRecordedEvent)event
{
    if(event)
    {
        [m_voiceCompletedRecordingEvents addObject:event];
    }
}

- (void)removeVoiceRecordCompleteEvent:(VoiceRecordedEvent)event
{
    if(event)
    {
        [m_voiceCompletedRecordingEvents removeObject:event];
    }
}

#pragma mark - WRLDSpeechObserver (Private)

- (void)authorizationChanged:(BOOL)authorized
{
    for( VoiceAuthorizedEvent event in m_voiceAuthorizedEvents)
    {
        event(authorized);
    }
}

- (void)speechRecordingStarted
{
    for( VoiceEvent event in m_voiceStartedRecordingEvents)
    {
        event();
    }
}

- (void)speechRecordingCancelled
{
    for(VoiceEvent event in m_voiceCancelledRecordingEvents)
    {
        event();
    }
}

- (void)speechRecordingCompleted:(NSString *)transcript
{
    for(VoiceRecordedEvent event in m_voiceCompletedRecordingEvents)
    {
        event(transcript);
    }
}

@end

