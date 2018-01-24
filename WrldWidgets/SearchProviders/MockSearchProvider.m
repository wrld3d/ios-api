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
        cellExpectedHeight = 80;
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
    NSMutableArray<WRLDSearchResult *> * searchResults = [[NSMutableArray<WRLDSearchResult *> alloc] init];
    
    NSString * tags = @"";
    
    for(int i = 0; i < 20; ++i){
        [searchResults addObject: [self createSearchResult:
                                   [NSString stringWithFormat:@"Mock Result %d", i]
                                                    latLng: CLLocationCoordinate2DMake(0, 0)
                                                  subTitle: [NSString stringWithFormat:@"Mock Result Description %d", i]
                                                      tags: tags]];
    }
    
    [query addResults: self :searchResults];
}

- (void) searchSuggestions: (NSString*) query
{
}

@synthesize title;

@synthesize cellIdentifier;
@synthesize cellExpectedHeight;

@end


