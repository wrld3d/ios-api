#import "WRLDMenuGroup.h"
#import "WRLDMenuGroup+Private.h"
#import "WRLDMenuOption.h"
#import "WRLDMenuChangedListener.h"

@implementation WRLDMenuGroup
{
    NSMutableArray* m_options;
    id<WRLDMenuChangedListener> m_listener;
}

- (instancetype)init
{
    return [self initWithTitle:nil];
}

- (instancetype)initWithTitle:(nullable NSString *)title
{
    self = [super init];
    if (self)
    {
        _title = title;
        m_options = [[NSMutableArray alloc] init];
        m_listener = nil;
    }
    
    return self;
}

- (void)setTitle:(nullable NSString *)title
{
    _title = title;
    if (m_listener != nil)
    {
        [m_listener onMenuChanged];
    }
}

- (void)addOption:(WRLDMenuOption *)option
{
    [m_options addObject:option];
}

- (void)addOption:(NSString *)text
          context:(nullable NSObject *)context
{
    [self addOption:[[WRLDMenuOption alloc] initWithText:text
                                                 context:context]];
}

#pragma mark - WRLDMenuGroup (Private)

- (NSMutableArray *)getOptions
{
    return m_options;
}

- (bool)hasTitle
{
    return _title != nil;
}

- (void)setListener:(id<WRLDMenuChangedListener>)listener
{
    m_listener = listener;
}

@end


