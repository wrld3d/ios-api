
#import "WRLDPoiSearch.h"
#import "WRLDPoiSearch+Private.h"

@interface WRLDPoiSearch ()

@end

@implementation WRLDPoiSearch
{
    Eegeo::Api::EegeoPoiApi* m_poiApi;
    int m_searchId;
}

- (instancetype)initWithIdAndApi:(int)searchId poiApi:(Eegeo::Api::EegeoPoiApi&)poiApi
{
    if (self = [super init])
    {
        m_poiApi = &poiApi;
        m_searchId = searchId;
    }
    
    return self;
}

- (void)cancel
{
    m_poiApi->CancelSearch(m_searchId);
}

@end
