#import "WRLDSearchQueryAcrossMultipleProviders.h"
#import "WRLDQueryFulfiller.h"

@implementation WRLDSearchQueryAcrossMultipleProviders

-(instancetype) initWithQuery:(NSString*) queryString forProviders:(NSArray<id<WRLDQueryFulfiller>>*) providerReferences
{
    return nil;
}

-(void) addResults: (NSArray<WRLDSearchResultModel*>*) results fromProvider:(id<WRLDQueryFulfiller>) providerReference
{
    
}
                    
@end
