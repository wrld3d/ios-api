#import "WRLDMenuOption.h"
#import "WRLDMenuChild.h"

@implementation WRLDMenuOption
{
    NSMutableArray* m_children;
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

- (bool)hasChildren
{
    return [m_children count] > 0;
}

- (NSMutableArray *)getChildren
{
    return m_children;
}

- (void)addChild:(WRLDMenuChild *)child
{
    [m_children addObject:child];
}

- (void)addChild:(NSString *)text
            icon:(NSString *)icon
         context:(NSObject *)context
{
    [self addChild:[[WRLDMenuChild alloc] initWithText:text
                                                  icon:icon
                                               context:context]];
}

// TODO: onSelectCallback, onExpandCallback, onCollapseCallback

@end



