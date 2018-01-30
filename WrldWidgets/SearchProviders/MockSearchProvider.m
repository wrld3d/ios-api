#import <Foundation/Foundation.h>

#import "MockSearchProvider.h"
#import "WRLDSearchProviderDelegate.h"
#import "WRLDSearchQuery.h"
#import "WRLDSearchResult.h"

@implementation MockSearchProvider
{
    WRLDPoiService* m_poiService;
    WRLDMapView* m_mapView;
    
    int m_poiSearchId;
    WRLDSearchResultType m_searchType;
}

- (instancetype)init
{
    if (self = [super init])
    {
        m_searchType = WRLDResult;
        cellIdentifier = @"YelpSearchResultCell";
        cellExpectedHeight = 64;
        title = @"Mock";
    }
    
    return self;
}

- (WRLDSearchResult*) createSearchResult: (NSString*) title latLng: (CLLocationCoordinate2D) latLng subTitle: (NSString*)subTitle tags: (NSString*)tags
{
    WRLDSearchResult* searchResult = [[WRLDSearchResult alloc] init];
    [searchResult setTitle: title];
    [searchResult setLatLng: latLng];
    [searchResult setSubTitle: subTitle];
    [searchResult setTags: tags];
    [searchResult setType:m_searchType];
    return searchResult;
}

- (void) search: (WRLDSearchQuery*) query
{
    NSDictionary * userInfo = @{ @"Query" : query };
    [NSTimer scheduledTimerWithTimeInterval:3
                                     target:self
                                   selector:@selector(doSearch:)
                                   userInfo:userInfo
                                    repeats:NO];
}

- (void)doSearch:(NSTimer*)theTimer {
    WRLDSearchQuery *query = [[theTimer userInfo] objectForKey:@"Query"];

    NSMutableArray<WRLDSearchResult *> * searchResults = [[NSMutableArray<WRLDSearchResult *> alloc] init];
    
    NSString * tags = @"";
    
    for(int i = 0; i < 20; ++i){
        [searchResults addObject: [self createSearchResult:
                                   [NSString stringWithFormat:@"Mock Result %@ %d", query.queryString, i]
                                                    latLng: CLLocationCoordinate2DMake(0, 0)
                                                  subTitle: [NSString stringWithFormat:@"Mock Result Description %d", i]
                                                      tags: tags]];
    }
    
    [query addResults: self :searchResults];
}

- (void) searchSuggestions: (WRLDSearchQuery *) query
{
    NSMutableArray<WRLDSearchResult *> * searchResults = [[NSMutableArray<WRLDSearchResult *> alloc] init];
    
    NSString * tags = @"";
    
    for(int i = 0; i < 20; ++i){
        [searchResults addObject: [self createSearchResult:
                                   [NSString stringWithFormat:@"Mock Suggestion %@ %d", query.queryString, i]
                                                    latLng: CLLocationCoordinate2DMake(0, 0)
                                                  subTitle: [NSString stringWithFormat:@"Mock Result Description %d", i]
                                                      tags: tags]];
    }
    
    [query addResults: self :searchResults];
}

@synthesize title;

@synthesize cellIdentifier;
@synthesize cellExpectedHeight;

@end


