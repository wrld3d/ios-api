#import "WRLDMenuOptionSelectedObserver.h"
#import "WRLDMenuOptionSelectedObserver+Private.h"

@implementation WRLDMenuOptionSelectedObserver
{
    NSMutableArray<OptionSelectedEvent>* m_selectedOptionEvents;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        m_selectedOptionEvents = [[NSMutableArray<OptionSelectedEvent> alloc] init];
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

- (void)selected:(NSObject *)optionContext
{
    for (OptionSelectedEvent event in m_selectedOptionEvents)
    {
        event(optionContext);
    }
}

@end
