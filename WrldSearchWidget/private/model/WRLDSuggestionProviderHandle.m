#import "WRLDSuggestionProviderHandle.h"
#import "WRLDSuggestionProvider.h"
#import "WRLDSearchResultSelectedObserver.h"

@implementation WRLDSuggestionProviderHandle

@synthesize identifier;
@synthesize cellHeight;
@synthesize cellIdentifier;
@synthesize moreResultsName;
@synthesize selectionObserver;

-(instancetype) initWithId: (NSInteger) uniqueId forProvider: (id<WRLDSuggestionProvider>) provider
{
    self = [super init];
    if(self)
    {
        identifier = uniqueId;
        _provider = provider;
        cellHeight = 36;
        cellIdentifier = @"WRLDSuggestionTableViewCell";
        moreResultsName = @"Suggestions";
        selectionObserver = [[WRLDSearchResultSelectedObserver alloc] init];
    }
    return self;
}

@end

