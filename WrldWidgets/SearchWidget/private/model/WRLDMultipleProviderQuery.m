#import "WRLDMultipleProviderQuery.h"
#import "WRLDSearchProvider.h"
#import "WRLDSuggestionProvider.h"
#import "WRLDSearchProviderHandle.h"
#import "WRLDSuggestionProviderHandle.h"
#import "WRLDQueryPartialResponseDelegate.h"
#import "WRLDQueryPartialResponseDelegate.h"

@implementation WRLDMultipleProviderQuery
{
    id<WRLDSearchResultsReadyDelegate> m_completionDelegate;
}

-(instancetype) initWithQuery:(NSString*) queryString forSearchProviders:(WRLDSearchProviderCollection*) providerHandles callingOnCompletion:(id<WRLDSearchResultsReadyDelegate>) completionDelegate
{
    self = [super initWithQueryString:queryString callingOnCompletion:completionDelegate];
    if(self)
    {
        m_completionDelegate = completionDelegate;
        if([providerHandles count] == 0)
        {
            [self completeWithNoProviders];
        }
        else
        {
            [self dispatchIndividualQueriesToSearchProviders: providerHandles];
        }
    }
    return self;
}

-(instancetype) initWithQuery:(NSString*) queryString forSuggestionProviders:(WRLDSuggestionProviderCollection*) providerHandles callingOnCompletion:(id<WRLDSearchResultsReadyDelegate>) completionDelegate
{
    self = [super initWithQueryString:queryString callingOnCompletion:completionDelegate];
    if(self)
    {
        if([providerHandles count] == 0)
        {
            [self completeWithNoProviders];
        }
        else
        {
            [self dispatchIndividualQueriesToSuggestionProviders: providerHandles];
        }
    }
    return self;
}

-(void) completeWithNoProviders
{
    WRLDSearchResultsCollection* emptyResults = [[WRLDSearchResultsCollection alloc] init];
    [self didComplete :YES withResults: emptyResults];
}

-(void) dispatchIndividualQueriesToSearchProviders:(WRLDSearchProviderCollection *) providerHandles
{
    for(WRLDSearchProviderHandle* handle in providerHandles)
    {
        [handle.provider searchFor: [self createPartialQueryForFulfiller: handle]];
    }
}

-(void) dispatchIndividualQueriesToSuggestionProviders:(WRLDSuggestionProviderCollection *) providerHandles
{
    for(WRLDSuggestionProviderHandle* handle in providerHandles)
    {
        [handle.provider getSuggestions: [self createPartialQueryForFulfiller: handle]];
    }
}

-(WRLDSearchQuery *) createPartialQueryForFulfiller: (id<WRLDQueryFulfillerHandle>) handle
{
    WRLDQueryPartialResponseDelegate* partialResponseDelegate =
    [[WRLDQueryPartialResponseDelegate alloc] initWithFulfillerHandle: handle
                                                         forFullQuery:self];
    WRLDSearchQuery *individualProviderQuery = [[WRLDSearchQuery alloc] initWithQueryString:self.queryString
                                                                        callingOnCompletion:partialResponseDelegate];
    return individualProviderQuery;
}

-(void) addResults: (WRLDSearchResultsCollection *) results fromFulfiller:(id<WRLDQueryFulfillerHandle>) fulfillerHandle withSuccess:(BOOL) success
{
}
                    
@end
