#import <Foundation/Foundation.h>

#import "WRLDMockSearchProvider.h"
#import "WRLDSearchRequest.h"
#import "WRLDSearchResultModel.h"
#import "WRLDBasicSearchResultModel.h"

@implementation WRLDMockSearchProvider
{
    CGFloat m_searchResultsDelayInSeconds;
    CGFloat m_suggestionResultsDelayInSeconds;
}

@synthesize moreResultsName;
@synthesize cellIdentifier;
@synthesize cellHeight;

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
    moreResultsName = @"Mock";
    cellHeight = 64;
    m_searchResultsDelayInSeconds = searchDelayInSeconds;
    m_suggestionResultsDelayInSeconds = suggestionDelayInSeconds;
}

- (void) searchFor: (WRLDSearchRequest*) request
{
    if(m_suggestionResultsDelayInSeconds > 0)
    {
        NSDictionary * userInfo = @{ @"Request" : request };
        [NSTimer scheduledTimerWithTimeInterval:m_searchResultsDelayInSeconds
                                         target:self
                                       selector:@selector(completeQuery:)
                                       userInfo:userInfo
                                        repeats:NO];
    }
    else
    {
        [self fulfilRequest: request];
    }
}

- (void) getSuggestions: (WRLDSearchRequest*) request
{
    if(m_suggestionResultsDelayInSeconds > 0)
    {
        NSDictionary * userInfo = @{ @"Request" : request };
        [NSTimer scheduledTimerWithTimeInterval:m_suggestionResultsDelayInSeconds
                                         target:self
                                       selector:@selector(completeQuery:)
                                       userInfo:userInfo
                                        repeats:NO];
    }
    else
    {
        [self fulfilRequest: request];
    }
}

- (void)completeQuery:(NSTimer*)theTimer {
    WRLDSearchRequest *request = [[theTimer userInfo] objectForKey:@"Request"];
    
    [self fulfilRequest: request];
}

-(void) fulfilRequest: (WRLDSearchRequest *) searchRequest
{
    NSMutableArray<id<WRLDSearchResultModel>> * searchResults = [[NSMutableArray<id<WRLDSearchResultModel>> alloc] init];
    
    for(int i = 0; i < 20; ++i){
        [searchResults addObject: [self createSearchResult:
                                   [NSString stringWithFormat:@"Mock Result %@ %d", searchRequest.queryString, i]
                                                  subTitle: [NSString stringWithFormat:@"Mock Result Description %d", i]]];
    }
    
    [searchRequest didComplete:YES withResults: searchResults];
}

- (id<WRLDSearchResultModel>) createSearchResult: (NSString*) title subTitle: (NSString*)subTitle
{
    id<WRLDSearchResultModel> searchResult = [[WRLDBasicSearchResultModel alloc] init];
    [searchResult setTitle: title];
    [searchResult setSubTitle: subTitle];
    return searchResult;
}

@end


