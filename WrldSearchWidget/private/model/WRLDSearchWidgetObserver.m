#import "WRLDSearchWidgetObserver.h"
#import "WRLDSearchWidgetObserver+Private.h"

@implementation WRLDSearchWidgetObserver
{
    NSMutableArray<FocusEvent>* m_searchGainedFocusEvents;
    NSMutableArray<FocusEvent>* m_searchResignedFocusEvents;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        m_searchGainedFocusEvents = [[NSMutableArray<FocusEvent> alloc] init];
        m_searchResignedFocusEvents = [[NSMutableArray<FocusEvent> alloc] init];
    }
    return self;
}

- (void)addGainedFocusEvent:(FocusEvent)event
{
    if (event)
    {
        [m_searchGainedFocusEvents addObject:event];
    }
}

- (void)removeGainedFocusEvent:(FocusEvent)event
{
    if (event)
    {
        [m_searchGainedFocusEvents removeObject:event];
    }
}

- (void)addResignedFocusEvent:(FocusEvent)event
{
    if (event)
    {
        [m_searchResignedFocusEvents addObject:event];
    }
}

- (void)removeResignedFocusEvent:(FocusEvent)event
{
    if (event)
    {
        [m_searchResignedFocusEvents removeObject:event];
    }
}

#pragma mark - WRLDSearchWidgetObserver.h (Private)

- (void)gainFocus
{
    for (FocusEvent event in m_searchGainedFocusEvents)
    {
        event();
    }
}

- (void)resignFocus
{
    for (FocusEvent event in m_searchResignedFocusEvents)
    {
        event();
    }
}

@end

