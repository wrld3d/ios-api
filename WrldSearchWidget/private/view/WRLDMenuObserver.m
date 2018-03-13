#import "WRLDMenuObserver.h"
#import "WRLDMenuObserver+Private.h"

@implementation WRLDMenuObserver
{
    NSMutableArray<OptionSelectedEvent>* m_selectedOptionEvents;
    NSMutableArray<OptionExpandedEvent>* m_expandedOptionEvents;
    NSMutableArray<OptionCollapsedEvent>* m_collapsedOptionEvents;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        m_selectedOptionEvents = [[NSMutableArray<OptionSelectedEvent> alloc] init];
        m_expandedOptionEvents = [[NSMutableArray<OptionExpandedEvent> alloc] init];
        m_collapsedOptionEvents = [[NSMutableArray<OptionCollapsedEvent> alloc] init];
    }
    return self;
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
