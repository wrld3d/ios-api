#import "WRLDSearchMenuModel.h"
#import "WRLDSearchMenuModel+Private.h"
#import "WRLDMenuGroup.h"
#import "WRLDMenuGroup+Private.h"
#import "WRLDMenuChangedListener.h"

@implementation WRLDSearchMenuModel
{
    NSMutableArray* m_groups;
    id<WRLDMenuChangedListener> m_listener;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _title = @"Menu";
        m_groups = [[NSMutableArray alloc] init];
        m_listener = nil;
    }
    
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    if (m_listener != nil)
    {
        [m_listener onMenuTitleChanged];
    }
}

- (void)addMenuGroup:(WRLDMenuGroup *)group
{
    [group setListener:m_listener];
    [m_groups addObject:group];
    if (m_listener != nil)
    {
        [m_listener onMenuChanged];
    }
}

- (void)removeMenuGroup:(WRLDMenuGroup *)group
{
    if ([m_groups containsObject:group])
    {
        [group setListener:nil];
        [m_groups removeObject:group];
        if (m_listener != nil)
        {
            [m_listener onMenuChanged];
        }
    }
}

- (void)insertMenuGroup:(WRLDMenuGroup *)group
                atIndex:(NSUInteger)index
{
    if ([m_groups count] > index)
    {
        [group setListener:m_listener];
        [m_groups insertObject:group
                       atIndex:index];
        if (m_listener != nil)
        {
            [m_listener onMenuChanged];
        }
    }
}

- (void)removeMenuGroupAtIndex:(NSUInteger)index
{
    if ([m_groups count] > index)
    {
        [[m_groups objectAtIndex:index] setListener:nil];
        [m_groups removeObjectAtIndex:index];
        if (m_listener != nil)
        {
            [m_listener onMenuChanged];
        }
    }
}

- (void) removeAllGroups
{
    for (WRLDMenuGroup* group in m_groups)
    {
        [group setListener:nil];
    }
    
    [m_groups removeAllObjects];
    if (m_listener != nil)
    {
        [m_listener onMenuChanged];
    }
}

#pragma mark - WRLDSearchMenuModel (Private)

- (NSMutableArray *)getGroups
{
    return m_groups;
}

- (void)setListener:(id<WRLDMenuChangedListener>)listener
{
    m_listener = listener;
    for (WRLDMenuGroup* group in m_groups)
    {
        [group setListener:m_listener];
    }
}

@end

