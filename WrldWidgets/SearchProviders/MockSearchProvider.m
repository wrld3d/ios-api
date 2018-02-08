#import <Foundation/Foundation.h>

#import "MockSearchProvider.h"
#import "WRLDSearchQuery.h"
#import "WRLDSearchResultModel.h"

@implementation MockSearchProvider
{
    WRLDPoiService* m_poiService;
    WRLDMapView* m_mapView;
    
    int m_poiSearchId;
}

@synthesize title;
@synthesize cellIdentifier;

- (instancetype)init
{
    if (self = [super init])
    {
        cellIdentifier = nil;
        title = @"Mock";
    }
    
    return self;
}

- (void) search: (WRLDSearchQuery*) query
{
    NSDictionary * userInfo = @{ @"Query" : query };
    [NSTimer scheduledTimerWithTimeInterval:3
                                     target:self
                                   selector:@selector(completeQuery:)
                                   userInfo:userInfo
                                    repeats:NO];
}

- (void) getSuggestions: (WRLDSearchQuery *) query
{
    NSDictionary * userInfo = @{ @"Query" : query };
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(completeQuery:)
                                   userInfo:userInfo
                                    repeats:NO];
}

- (void)completeQuery:(NSTimer*)theTimer {
    WRLDSearchQuery *query = [[theTimer userInfo] objectForKey:@"Query"];
    
    NSMutableArray<WRLDSearchResultModel *> * searchResults = [[NSMutableArray<WRLDSearchResultModel *> alloc] init];
    
    for(int i = 0; i < 20; ++i){
        [searchResults addObject: [self createSearchResult:
                                   [NSString stringWithFormat:@"Mock Result %@ %d", query.queryString, i]
                                                  subTitle: [NSString stringWithFormat:@"Mock Result Description %d", i]]];
    }
    
    [query didCompleteSuccessfully:YES withResults: searchResults];
}

- (WRLDSearchResultModel*) createSearchResult: (NSString*) title subTitle: (NSString*)subTitle
{
    WRLDSearchResultModel* searchResult = [[WRLDSearchResultModel alloc] init];
    [searchResult setTitle: title];
    [searchResult setSubTitle: subTitle];
    return searchResult;
}

@end


