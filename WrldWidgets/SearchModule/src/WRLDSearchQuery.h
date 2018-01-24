#pragma once
#import <Foundation/Foundation.h>

@class WRLDSearchResult;
@protocol WRLDSearchProvider;
@protocol WRLDSearchQueryCompleteDelegate;

@interface WRLDSearchQuery : NSObject


typedef NS_ENUM(NSInteger, ProgressStatus) {
    InFlight,
    Cancelled,
    Completed
};

@property (copy, readonly) NSString* queryString;
@property (readonly) ProgressStatus* progress;

-(instancetype) initWithQueryString: (NSString *) queryString :(NSInteger) providersQueriedCount;

-(void) setCompletionDelegate: (id<WRLDSearchQueryCompleteDelegate>) delegate;
-(void) updateResults: (id<WRLDSearchProvider>) provider : (WRLDSearchResult *) results;

@end

@protocol WRLDSearchQueryCompleteDelegate
-(void) completed : (WRLDSearchQuery *) query;
@end


