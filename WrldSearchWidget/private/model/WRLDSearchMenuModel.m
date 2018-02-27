#import "WRLDSearchMenuModel.h"
#import "WRLDMenuGroup.h"
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

- (void)setListener:(id<WRLDMenuChangedListener>)listener
{
    m_listener = listener;
}

- (NSMutableArray *)getGroups
{
    return m_groups;
}

- (void)addMenuGroup:(WRLDMenuGroup *)group
{
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
        [m_groups removeObject:group];
        if (m_listener != nil)
        {
            [m_listener onMenuChanged];
        }
    }
}

@end

