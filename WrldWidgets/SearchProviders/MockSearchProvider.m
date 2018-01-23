#import <Foundation/Foundation.h>

#import "MockSearchProvider.h"
#import "WRLDSearchProviderDelegate.h"
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

- (void) search: (NSString*) query
{
    [self clearResults];
    
    NSMutableArray<WRLDSearchResult *> * searchResults = [[NSMutableArray<WRLDSearchResult *> alloc] init];
    
    NSString * tags = @"";
    
    for(int i = 0; i < 20; ++i){
        [searchResults addObject: [self createSearchResult:
                                   [NSString stringWithFormat:@"Mock Result %d", i]
                                                    latLng: CLLocationCoordinate2DMake(0, 0)
                                                  subTitle: [NSString stringWithFormat:@"Mock Result Description %d", i]
                                                      tags: tags]];
    }
    
    [self addResults:searchResults];
}

- (void) searchSuggestions: (NSString*) query
{
    [self clearResults];
}

@synthesize title;

@end


