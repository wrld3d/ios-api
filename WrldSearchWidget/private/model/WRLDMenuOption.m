#import "WRLDMenuOption.h"
#import "WRLDMenuOption+Private.h"
#import "WRLDMenuChild.h"
#import "WRLDMenuChangedListener.h"

@implementation WRLDMenuOption
{
    NSMutableArray* m_children;
    id<WRLDMenuChangedListener> m_listener;
}

- (instancetype)initWithText:(NSString *)text
                     context:(nullable NSObject *)context
{
    self = [super init];
    if (self)
    {
        _text = text;
        _context = context;
        m_children = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addChild:(WRLDMenuChild *)child
{
    [m_children addObject:child];
    if (m_listener != nil)
    {
        [m_listener onMenuChanged];
    }
}

- (void)addChild:(NSString *)text
            icon:(nullable NSString *)icon
         context:(nullable NSObject *)context
{
    [self addChild:[[WRLDMenuChild alloc] initWithText:text
                                                  icon:icon
                                               context:context]];
}

- (void)removeChild:(WRLDMenuChild *)child
{
    if ([m_children containsObject:child])
    {
        [m_children removeObject:child];
        if (m_listener != nil)
        {
            [m_listener onMenuChanged];
        }
    }
}

- (void)insertChild:(WRLDMenuChild *)child
            atIndex:(NSUInteger)index
{
    if ([m_children count] > index)
    {
        [m_children insertObject:child
                         atIndex:index];
        if (m_listener != nil)
        {
            [m_listener onMenuChanged];
        }
    }
}

- (void)removeChildAtIndex:(NSUInteger)index
{
    if ([m_children count] > index)
    {
        [m_children removeObjectAtIndex:index];
        if (m_listener != nil)
        {
            [m_listener onMenuChanged];
        }
    }
}

- (void)removeAllChildren
{
    [m_children removeAllObjects];
    if (m_listener != nil)
    {
        [m_listener onMenuChanged];
    }
}

#pragma mark - WRLDMenuOption (Private)

- (bool)hasChildren
{
    return [m_children count] > 0;
}

- (NSMutableArray *)getChildren
{
    return m_children;
}

- (void)setListener:(id<WRLDMenuChangedListener>)listener
{
    m_listener = listener;
}

@end



