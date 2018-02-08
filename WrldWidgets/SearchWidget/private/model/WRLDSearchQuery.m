#import <Foundation/Foundation.h>
#import "WRLDSearchQuery.h"
#import "WRLDSearchResultsReadyDelegate.h"

@implementation WRLDSearchQuery
{
    id<WRLDSearchResultsReadyDelegate> m_completionDelegate;
    NSArray<WRLDSearchResultModel *>* m_results;
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

-(void) didCompleteSuccessfully:(BOOL) success withResults:(NSMutableArray<WRLDSearchResultModel*>*) results
{
    _progress = Completed;
    _hasCompleted = YES;
    _hasSucceeded = success;
    m_results = results;
}

-(NSArray<WRLDSearchResultModel *>*) getResults
{
    return m_results;
}

@end
