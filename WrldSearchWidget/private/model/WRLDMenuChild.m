#import "WRLDMenuChild.h"

@implementation WRLDMenuChild
{
}

- (instancetype)initWithText:(NSString *)text
                        icon:(nullable NSString *)icon
                     context:(nullable NSObject *)context
{
    self = [super init];
    if (self)
    {
        _text = text;
        _icon = icon;
        _context = context;
    }
    
    return self;
}

// TODO: onSelectCallback

@end




