#import "WRLDSearchWidgetViewWithSpeechRecognition.h"
#import "WRLDSearchWidgetViewSubclass.h"
#import "WRLDSpeechHandler.h"

@implementation WRLDSearchWidgetViewWithSpeechRecognition
{
    WRLDSpeechHandler *m_speechHandler;
}

-(void)customInit
{
    [super customInit];
    CGRect fullscreen = [[UIScreen mainScreen] bounds];
    m_speechHandler = [[WRLDSpeechHandler alloc] initWithFrame:fullscreen];
    [m_speechHandler setSearchView:self];
    [self addSubview:m_speechHandler];
}

-(void) voiceButtonClicked:(id)sender
{
    if(!m_speechHandler.isRecording)
    {
        [m_speechHandler startRecording];
        [self.wrldSearchWidgetSearchBar setPlaceholder:@"Listening..."];
        [self.wrldSearchWidgetSearchBar setText:@""];
        [self.wrldSearchWidgetSearchBar setUserInteractionEnabled:NO];
    }
    else
    {
        [m_speechHandler endRecording];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if([m_speechHandler pointInside:point withEvent:event])
    {
        return YES;
    }
    return [super pointInside:point withEvent:event];
}

-(void) runSearch:(NSString *) queryString
{
    [self.wrldSearchWidgetSearchBar setUserInteractionEnabled:YES];
    [super runSearch:queryString];
}

-(void) cancelVoiceSearch
{
    [self.wrldSearchWidgetSearchBar setPlaceholder:@"Search the WRLD"];
    [self.wrldSearchWidgetSearchBar setUserInteractionEnabled:YES];
}

-(BOOL) showVoiceButton
{
    return m_speechHandler.isAuthorized;
}
@end
