#import "WRLDSearchProviderHandle.h"
#import "WRLDSearchProvider.h"

@implementation WRLDSearchProviderHandle

@synthesize identifier;
@synthesize cellHeight;

-(instancetype) initWithId: (NSInteger) uniqueId forProvider: (id<WRLDSearchProvider>) searchProvider
{
    self = [super init];
    if(self)
    {
        identifier = uniqueId;
        _provider = searchProvider;
        cellHeight = searchProvider.cellHeight;
    }
    return self;
}
@end
