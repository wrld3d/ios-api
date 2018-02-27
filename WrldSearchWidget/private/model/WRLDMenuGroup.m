#import "WRLDMenuGroup.h"
#import "WRLDMenuOption.h"

@implementation WRLDMenuGroup
{
    NSMutableArray* m_options;
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
    }
    
    return self;
}

- (NSMutableArray *)getOptions
{
    return m_options;
}

- (void)addOption:(WRLDMenuOption *)option
{
    [m_options addObject:option];
}

- (void)addOption:(NSString *)text
          context:(NSObject *)context
{
    [self addOption:[[WRLDMenuOption alloc] initWithText:text
                                                 context:context]];
}

@end


