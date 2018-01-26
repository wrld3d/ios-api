#pragma once
#import <Foundation/Foundation.h>

@class WRLDSearchResult;
@class WRLDSearchResultSet;
@class SearchProviders;
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

-(instancetype) initWithQueryString: (NSString *) queryString :(SearchProviders *) providers;

-(void) setCompletionDelegate: (id<WRLDSearchQueryCompleteDelegate>) delegate;
-(void) addResults: (id<WRLDSearchProvider>) provider : (NSMutableArray<WRLDSearchResult*>*) results;
-(void) cancel;

-(WRLDSearchResultSet *) getResultSetForProviderAtIndex : (NSInteger) providerId;

@end

@protocol WRLDSearchQueryCompleteDelegate <NSObject>
-(void) updateResults;
@end


