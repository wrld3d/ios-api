#import "WRLDSearchResultSelectedObserver.h"
#import "WRLDSearchResultSelectedObserver+Private.h"

@implementation WRLDSearchResultSelectedObserver
{
    NSMutableArray<ResultSelectedEvent>* m_selectedResultEvents;
}

-(instancetype) init
{
    self = [super init];
    if (self)
    {
        m_selectedResultEvents = [[NSMutableArray<ResultSelectedEvent> alloc] init];
    }
    return self;
}

- (void) addResultSelectedEvent: (ResultSelectedEvent) event
{
    if(event){
        [m_selectedResultEvents addObject:event];
    }
}

- (void) removeResultSelectedEvent: (ResultSelectedEvent) event
{
    if(event){
        [m_selectedResultEvents removeObject:event];
    }
}

- (void) selected: (id<WRLDSearchResultModel>) selectedResult
{
    for(ResultSelectedEvent event in m_selectedResultEvents)
    {
        event(selectedResult);
    }
}

@end

