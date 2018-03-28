#import "WRLDSearchWidgetObserver.h"
#import "WRLDSearchWidgetObserver+Private.h"

@implementation WRLDSearchWidgetObserver
{
    NSMutableArray<SearchbarFocusEvent>* m_searchbarGainedFocusEvents;
    NSMutableArray<SearchbarFocusEvent>* m_searchbarResignedFocusEvents;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        m_searchbarGainedFocusEvents = [[NSMutableArray<SearchbarFocusEvent> alloc] init];
        m_searchbarResignedFocusEvents = [[NSMutableArray<SearchbarFocusEvent> alloc] init];
    }
    return self;
}

- (void)addSearchbarGainedFocusEvent:(SearchbarFocusEvent)event
{
    if (event)
    {
        [m_searchbarGainedFocusEvents addObject:event];
    }
}

- (void)removeSearchbarGainedFocusEvent:(SearchbarFocusEvent)event
{
    if (event)
    {
        [m_searchbarGainedFocusEvents removeObject:event];
    }
}

- (void)addSearchbarResignedFocusEvent:(SearchbarFocusEvent)event
{
    if (event)
    {
        [m_searchbarResignedFocusEvents addObject:event];
    }
}

- (void)removeSearchbarResignedFocusEvent:(SearchbarFocusEvent)event
{
    if (event)
    {
        [m_searchbarResignedFocusEvents removeObject:event];
    }
}

#pragma mark - WRLDSearchWidgetObserver.h (Private)

- (void)searchbarGainFocus
{
    for (SearchbarFocusEvent event in m_searchbarGainedFocusEvents)
    {
        event();
    }
}

- (void)searchbarResignFocus
{
    for (SearchbarFocusEvent event in m_searchbarResignedFocusEvents)
    {
        event();
    }
}

@end

