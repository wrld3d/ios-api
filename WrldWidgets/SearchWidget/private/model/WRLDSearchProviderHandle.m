#import "WRLDSearchProviderHandle.h"
#import "WRLDSearchProvider.h"
#import "WRLDSearchResultSelectedObserver.h"

@implementation WRLDSearchProviderHandle

@synthesize identifier;
@synthesize cellHeight;
@synthesize cellIdentifier;
@synthesize moreResultsName;
@synthesize selectionObserver;

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
        selectionObserver = [[WRLDSearchResultSelectedObserver alloc] init];
    }
    return self;
}
@end
