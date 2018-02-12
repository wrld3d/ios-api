#import <Foundation/Foundation.h>

#import "WRLDMockSearchProvider.h"
#import "WRLDSearchQuery.h"
#import "WRLDSearchResultModel.h"
#import "WRLDBasicSearchResultModel.h"

@implementation WRLDMockSearchProvider
{
    CGFloat m_searchResultsDelayInSeconds;
    CGFloat m_suggestionResultsDelayInSeconds;
}

@synthesize title;
@synthesize cellIdentifier;

- (instancetype)init
{
    if (self = [super init])
    {
        [self setupValues:2.0 suggestionDelayInSeconds:0.1];
    }
    
    return self;
}

- (instancetype)initWithSearchDelayInSeconds:(CGFloat) searchDelayInSeconds suggestionDelayInSeconds:(CGFloat) suggestionDelayInSeconds
{
    if (self = [super init])
    {
        [self setupValues:searchDelayInSeconds suggestionDelayInSeconds:suggestionDelayInSeconds];
    }
    
    return self;
}

- (void) setupValues:(CGFloat) searchDelayInSeconds suggestionDelayInSeconds:(CGFloat) suggestionDelayInSeconds
{
    cellIdentifier = nil;
    title = @"Mock";
    m_searchResultsDelayInSeconds = searchDelayInSeconds;
    m_suggestionResultsDelayInSeconds = suggestionDelayInSeconds;
}

- (void) searchFor: (WRLDSearchQuery*) query
{
    if(m_suggestionResultsDelayInSeconds > 0)
    {
        NSDictionary * userInfo = @{ @"Query" : query };
        [NSTimer scheduledTimerWithTimeInterval:m_searchResultsDelayInSeconds
                                         target:self
                                       selector:@selector(completeQuery:)
                                       userInfo:userInfo
                                        repeats:NO];
    }
    else
    {
        [self fulfilQuery: query];
    }
}

- (void) getSuggestions: (WRLDSearchQuery *) query
{
    if(m_suggestionResultsDelayInSeconds > 0)
    {
        NSDictionary * userInfo = @{ @"Query" : query };
        [NSTimer scheduledTimerWithTimeInterval:m_suggestionResultsDelayInSeconds
                                         target:self
                                       selector:@selector(completeQuery:)
                                       userInfo:userInfo
                                        repeats:NO];
    }
    else
    {
        [self fulfilQuery: query];
    }
}

- (void)completeQuery:(NSTimer*)theTimer {
    WRLDSearchQuery *query = [[theTimer userInfo] objectForKey:@"Query"];
    
    [self fulfilQuery: query];
}

-(void) fulfilQuery: (WRLDSearchQuery *) query
{
    NSMutableArray<id<WRLDSearchResultModel>> * searchResults = [[NSMutableArray<id<WRLDSearchResultModel>> alloc] init];
    
    for(int i = 0; i < 20; ++i){
        [searchResults addObject: [self createSearchResult:
                                   [NSString stringWithFormat:@"Mock Result %@ %d", query.queryString, i]
                                                  subTitle: [NSString stringWithFormat:@"Mock Result Description %d", i]]];
    }
    
    [query didComplete:YES withResults: searchResults];
}

- (id<WRLDSearchResultModel>) createSearchResult: (NSString*) title subTitle: (NSString*)subTitle
{
    id<WRLDSearchResultModel> searchResult = [[WRLDBasicSearchResultModel alloc] init];
    [searchResult setTitle: title];
    [searchResult setSubTitle: subTitle];
    return searchResult;
}

@end


