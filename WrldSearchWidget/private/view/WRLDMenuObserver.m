#import "WRLDMenuObserver.h"
#import "WRLDMenuObserver+Private.h"

@implementation WRLDMenuObserver
{
    NSMutableArray<OpenedEvent>* m_openedEvents;
    NSMutableArray<ClosedEvent>* m_closedEvents;
    NSMutableArray<OptionSelectedEvent>* m_selectedOptionEvents;
    NSMutableArray<OptionExpandedEvent>* m_expandedOptionEvents;
    NSMutableArray<OptionCollapsedEvent>* m_collapsedOptionEvents;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        m_openedEvents = [[NSMutableArray<OpenedEvent> alloc] init];
        m_closedEvents = [[NSMutableArray<ClosedEvent> alloc] init];
        m_selectedOptionEvents = [[NSMutableArray<OptionSelectedEvent> alloc] init];
        m_expandedOptionEvents = [[NSMutableArray<OptionExpandedEvent> alloc] init];
        m_collapsedOptionEvents = [[NSMutableArray<OptionCollapsedEvent> alloc] init];
    }
    return self;
}



- (void)addOpenedEvent:(OpenedEvent)event
{
    if (event)
    {
        [m_openedEvents addObject:event];
    }
}

- (void)removeOpenedEvent:(OpenedEvent)event
{
    if (event)
    {
        [m_openedEvents removeObject:event];
    }
}

- (void)addClosedEvent:(ClosedEvent)event
{
    if (event)
    {
        [m_closedEvents addObject:event];
    }
}

- (void)removeClosedEvent:(ClosedEvent)event
{
    if (event)
    {
        [m_closedEvents removeObject:event];
    }
}

- (void)addOptionSelectedEvent:(OptionSelectedEvent)event
{
    if (event)
    {
        [m_selectedOptionEvents addObject:event];
    }
}

- (void)removeOptionSelectedEvent:(OptionSelectedEvent)event
{
    if (event)
    {
        [m_selectedOptionEvents removeObject:event];
    }
}

- (void)addOptionExpandedEvent:(OptionExpandedEvent)event
{
    if (event)
    {
        [m_expandedOptionEvents addObject:event];
    }
}

- (void)removeOptionExpandedEvent:(OptionExpandedEvent)event
{
    if (event)
    {
        [m_expandedOptionEvents removeObject:event];
    }
}

- (void)addOptionCollapsedEvent:(OptionCollapsedEvent)event
{
    if (event)
    {
        [m_collapsedOptionEvents addObject:event];
    }
}

- (void)removeOptionCollapsedEvent:(OptionCollapsedEvent)event
{
    if (event)
    {
        [m_collapsedOptionEvents removeObject:event];
    }
}

#pragma mark - WRLDMenuObserver (Private)

- (void)opened:(BOOL)fromInteraction
{
    for (OpenedEvent event in m_openedEvents)
    {
        event(fromInteraction);
    }
}

- (void)closed:(BOOL)fromInteraction
{
    for (ClosedEvent event in m_closedEvents)
    {
        event(fromInteraction);
    }
}

- (void)selected:(NSObject *)optionContext
{
    for (OptionSelectedEvent event in m_selectedOptionEvents)
    {
        event(optionContext);
    }
}

- (void)expanded:(NSObject *)optionContext
 fromInteraction:(BOOL)fromInteraction
{
    for (OptionExpandedEvent event in m_expandedOptionEvents)
    {
        event(optionContext, fromInteraction);
    }
}

- (void)collapsed:(NSObject *)optionContext
  fromInteraction:(BOOL)fromInteraction
{
    for (OptionCollapsedEvent event in m_collapsedOptionEvents)
    {
        event(optionContext, fromInteraction);
    }
}

@end
