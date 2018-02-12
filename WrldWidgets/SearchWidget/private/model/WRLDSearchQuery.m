#import <Foundation/Foundation.h>
#import "WRLDSearchQuery.h"
#import "WRLDSearchResultsReadyDelegate.h"

@implementation WRLDSearchQuery
{
    id<WRLDSearchResultsReadyDelegate> m_completionDelegate;
    WRLDSearchResultsCollection* m_results;
}

-(instancetype) initWithQueryString:(NSString *)queryString
                 callingOnCompletion:(id<WRLDSearchResultsReadyDelegate>) completionDelegate
{
    self = [super init];
    if(self)
    {
        _queryString = queryString;
        m_completionDelegate = completionDelegate;
        m_results = nil;
    }
    return self;
}

-(void) cancel
{
    _progress = Cancelled;
    _hasCompleted = YES;
    _hasSucceeded = NO;
}

-(BOOL) isFinished
{
    return (self.progress == Cancelled || self.progress == Completed);
}

-(void) didComplete:(BOOL) success withResults:(WRLDSearchResultsCollection*) results
{
    _progress = Completed;
    _hasCompleted = YES;
    _hasSucceeded = success;
    m_results = results;
    [m_completionDelegate didComplete:success withResults: m_results];
}

-(WRLDSearchResultsCollection*) getResults
{
    return m_results;
}

@end
