#import "WRLDSuggestionProviderHandle.h"
#import "WRLDSuggestionProvider.h"

@implementation WRLDSuggestionProviderHandle

@synthesize identifier;
@synthesize cellHeight;
@synthesize cellIdentifier;
@synthesize moreResultsName;

-(instancetype) initWithId: (NSInteger) uniqueId forProvider: (id<WRLDSuggestionProvider>) provider
{
    self = [super init];
    if(self)
    {
        identifier = uniqueId;
        _provider = provider;
        cellHeight = 32;
        cellIdentifier = @"WRLDSuggestionTableViewCell";
        moreResultsName = @"Suggestions";
    }
    return self;
}

@end

