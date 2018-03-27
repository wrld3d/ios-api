#import <Foundation/Foundation.h>
#import "WRLDSearchQuery.h"
#import "WRLDSearchQuery+Private.h"
#import "WRLDSearchRequest.h"
#import "WRLDSearchRequest+Private.h"
#import "WRLDSearchProviderHandle.h"
#import "WRLDSuggestionProviderHandle.h"
#import "WRLDSearchProvider.h"
#import "WRLDSuggestionProvider.h"
#import "WRLDSearchQueryObserver.h"
#import "WRLDSearchQueryObserver+Private.h"

@implementation WRLDSearchQuery
{
    WRLDFulfillerResultsDictionary* m_fulfillerResultsDictionary;
    NSMutableArray<WRLDSearchRequest *>* m_requests;
    WRLDSearchQueryObserver* m_queryObserver;
}

-(instancetype) initWithQueryString:(NSString*) queryString queryObserver:(WRLDSearchQueryObserver *) queryObserver
{
    self = [super init];
    if(self)
    {
        [self assignInitialValues: queryString queryContext:nil queryObserver:queryObserver];
    }
    return self;
}

-(instancetype) initWithQueryString:(NSString*) queryString queryContext: (id<NSObject>) queryContext queryObserver:(WRLDSearchQueryObserver *) queryObserver
{
    self = [super init];
    if(self)
    {
        [self assignInitialValues: queryString queryContext:queryContext queryObserver:queryObserver];
    }
    return self;
}

- (void) assignInitialValues: (NSString *) queryString queryContext:(id<NSObject>) queryContext queryObserver:(WRLDSearchQueryObserver *) queryObserver
{
    _queryString = queryString;
    _queryContext = queryContext;
    m_queryObserver = queryObserver;
    m_requests =[[NSMutableArray<WRLDSearchRequest *> alloc ]  init];
    m_fulfillerResultsDictionary = [[WRLDFulfillerResultsDictionary alloc] init];
}

- (void) cancel
{
    if(!self.hasCompleted)
    {
        _progress = Cancelled;
        _hasCompleted = YES;
        _hasSucceeded = NO;
        [m_queryObserver cancelled:self];
    }
}

- (void) cancelRequest: (WRLDSearchRequest *) cancelledRequest;
{
    [m_requests removeObject: cancelledRequest];
    [self checkForCompletion];
}

-(void) didCompleteWithSuccess:(BOOL) success
{
    _progress = Completed;
    _hasCompleted = YES;
    _hasSucceeded = success;
    
    if(m_queryObserver)
    {
        [m_queryObserver didComplete:self];
    }
}

-(void) dispatchRequestsToSearchProviders:(WRLDSearchRequestFulfillerCollection *) providerHandles
{
    [m_queryObserver willSearchFor: self];
    if([providerHandles count] == 0)
    {
        [self didCompleteWithSuccess :YES];
        return;
    }
    for(WRLDSearchProviderHandle* handle in providerHandles)
    {
        WRLDSearchRequest *searchRequest = [self createRequestForFulfiller: handle];
        [m_requests addObject:searchRequest];
        [handle.provider searchFor: searchRequest];
    }
}

-(void) dispatchRequestsToSuggestionProviders:(WRLDSearchRequestFulfillerCollection *) providerHandles
{
    [m_queryObserver willSearchFor: self];
    if([providerHandles count] == 0)
    {
        [self didCompleteWithSuccess :YES];
        return;
    }
    
    for(WRLDSuggestionProviderHandle* handle in providerHandles)
    {
        WRLDSearchRequest *searchRequest = [self createRequestForFulfiller: handle];
        [m_requests addObject:searchRequest];
        [handle.provider getSuggestions: searchRequest];
    }
}

-(WRLDSearchRequest *) createRequestForFulfiller: (id<WRLDSearchRequestFulfillerHandle>) handle
{
    return [[WRLDSearchRequest alloc] initWithFulfillerHandle: handle
                                                     forQuery:self];
}

-(void) addResults: (WRLDSearchResultsCollection *) results fromFulfiller:(id<WRLDSearchRequestFulfillerHandle>) fulfillerHandle withSuccess:(BOOL) success
{
    if(self.progress == Cancelled)
    {
        return;
    }
    
    NSNumber *key = [[NSNumber alloc] initWithLong: fulfillerHandle.identifier];
    
    [m_fulfillerResultsDictionary setObject: results forKey: key];
    [self checkForCompletion];
}

- (void) checkForCompletion
{
    if(self.hasCompleted){
        return;
    }
    
    for(WRLDSearchRequest * request in m_requests)
    {
        if(!request.hasCompleted)
        {
            return;
        }
    }
    [self didCompleteWithSuccess:YES];
}

- (WRLDSearchResultsCollection *) getResultsForFulfiller: (NSInteger) fulfillerHandleId
{
    NSNumber *key = [[NSNumber alloc] initWithLong: fulfillerHandleId];
    return [m_fulfillerResultsDictionary objectForKey:key];
}

@end
