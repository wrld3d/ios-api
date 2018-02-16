#import "WRLDSearchProviderHandle.h"
#import "WRLDSearchProvider.h"

@implementation WRLDSearchProviderHandle

@synthesize identifier;
@synthesize cellHeight;
@synthesize cellIdentifier;
@synthesize moreResultsName;

-(instancetype) initWithId: (NSInteger) uniqueId forProvider: (id<WRLDSearchProvider>) searchProvider
{
    self = [super init];
    if(self)
    {
        identifier = uniqueId;
        _provider = searchProvider;
        cellHeight = searchProvider.cellHeight;
        cellIdentifier = searchProvider.cellIdentifier;
        moreResultsName = searchProvider.moreResultsName;
    }
    return self;
}
@end
