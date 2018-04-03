#import "WRLDSearchWidgetObserver.h"
#import "WRLDSearchWidgetObserver+Private.h"

@implementation WRLDSearchWidgetObserver
{
    NSMutableArray<SearchbarFocusEvent>* m_searchbarGainedFocusEvents;
    NSMutableArray<SearchbarFocusEvent>* m_searchbarResignedFocusEvents;
    NSMutableArray<Event>* m_searchWidgetGainedFocusEvents;
    NSMutableArray<Event>* m_searchWidgetResignedFocusEvents;
    NSMutableArray<Event>* m_searchResultsReceivedEvents;
    NSMutableArray<Event>* m_searchResultsClearedEvents;
    NSMutableArray<Event>* m_searchResultsShowingEvents;
    NSMutableArray<Event>* m_searchResultsHiddenEvents;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        m_searchbarGainedFocusEvents = [[NSMutableArray<SearchbarFocusEvent> alloc] init];
        m_searchbarResignedFocusEvents = [[NSMutableArray<SearchbarFocusEvent> alloc] init];
        m_searchWidgetGainedFocusEvents = [[NSMutableArray<Event> alloc] init];
        m_searchWidgetResignedFocusEvents = [[NSMutableArray<Event> alloc] init];
        m_searchResultsReceivedEvents = [[NSMutableArray<Event> alloc] init];
        m_searchResultsClearedEvents = [[NSMutableArray<Event> alloc] init];
        m_searchResultsShowingEvents = [[NSMutableArray<Event> alloc] init];
        m_searchResultsHiddenEvents = [[NSMutableArray<Event> alloc] init];
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

- (void)addSearchWidgetGainedFocusEvent:(SearchbarFocusEvent)event
{
    if (event)
    {
        [m_searchWidgetGainedFocusEvents addObject:event];
    }
}

- (void)removeSearchWidgetGainedFocusEvent:(SearchbarFocusEvent)event
{
    if (event)
    {
        [m_searchWidgetGainedFocusEvents removeObject:event];
    }
}

- (void)addSearchWidgetResignedFocusEvent:(SearchbarFocusEvent)event
{
    if (event)
    {
        [m_searchWidgetResignedFocusEvents addObject:event];
    }
}

- (void)removeSearchWidgetResignedFocusEvent:(SearchbarFocusEvent)event
{
    if (event)
    {
        [m_searchWidgetResignedFocusEvents removeObject:event];
    }
}

- (void)addSearchResultsReceivedEvent:(Event)event
{
    if (event)
    {
        [m_searchResultsReceivedEvents addObject:event];
    }
}

- (void)removeSearchResultsReceivedEvent:(Event)event
{
    if (event)
    {
        [m_searchResultsReceivedEvents removeObject:event];
    }
}

- (void)addSearchResultsClearedEvent:(Event)event
{
    if (event)
    {
        [m_searchResultsClearedEvents addObject:event];
    }
}

- (void)removeSearchResultsClearedEvent:(Event)event
{
    if (event)
    {
        [m_searchResultsClearedEvents removeObject:event];
    }
}

- (void)addSearchResultsShowingEvent:(Event)event
{
    if (event)
    {
        [m_searchResultsShowingEvents addObject:event];
    }
}

- (void)removeSearchResultsShowingEvent:(Event)event
{
    if (event)
    {
        [m_searchResultsShowingEvents removeObject:event];
    }
}

- (void)addSearchResultsHiddenEvent:(Event)event
{
    if (event)
    {
        [m_searchResultsHiddenEvents addObject:event];
    }
}

- (void)removeSearchResultsHiddenEvent:(Event)event
{
    if (event)
    {
        [m_searchResultsHiddenEvents removeObject:event];
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

- (void)searchWidgetGainFocus
{
    for (Event event in m_searchWidgetGainedFocusEvents)
    {
        event();
    }
}

- (void)searchWidgetResignFocus
{
    for (Event event in m_searchWidgetResignedFocusEvents)
    {
        event();
    }
}

- (void)receiveSearchResults
{
    for (Event event in m_searchResultsReceivedEvents)
    {
        event();
    }
}

- (void)clearSearchResults
{
    for (Event event in m_searchResultsClearedEvents)
    {
        event();
    }
}

- (void)showSearchResults
{
    for (Event event in m_searchResultsShowingEvents)
    {
        event();
    }
}

- (void)hideSearchResults
{
    for (Event event in m_searchResultsHiddenEvents)
    {
        event();
    }
}

@end

