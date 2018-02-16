#import "WRLDSearchQueryObserver.h"
#import "WRLDSearchQueryObserver+Private.h"

@implementation WRLDSearchQueryObserver
{
    NSMutableArray< QueryEvent >* m_startingEvents;
    NSMutableArray< QueryEvent >* m_completedEvent;
}

-(instancetype) init
{
    self = [super init];
    if (self)
    {
        m_startingEvents = [[NSMutableArray< QueryEvent > alloc] init];
        m_completedEvent = [[NSMutableArray< QueryEvent > alloc] init];
    }
    return self;
}

- (void) addQueryStartingEvent: (QueryEvent) event
{
    if(event){
        [m_startingEvents addObject:event];
    }
}

- (void) removeQueryStartingEvent: (QueryEvent) event
{
    if(event){
        [m_startingEvents removeObject:event];
    }
}

- (void) addQueryCompletedEvent: (QueryEvent) event
{
    if(event){
        [m_completedEvent addObject:event];
    }
}

- (void) removeQueryCompletedEvent: (QueryEvent) event
{
    if(event){
        [m_completedEvent removeObject:event];
    }
}

- (void) willSearchFor: (WRLDSearchQuery *)query
{
    for(QueryEvent startingEvent in m_startingEvents)
    {
        startingEvent(query);
    }
}


- (void) didComplete: (WRLDSearchQuery *) query
{
    for(QueryEvent finishedEvent in m_completedEvent)
    {
        finishedEvent(query);
    }
}


@end
