#pragma once
#import <Foundation/Foundation.h>

#import "WRLDSearchTypes.h"

// This type goes out to individual providers
@protocol WRLDSearchResultModel;

@interface WRLDSearchQuery : NSObject

typedef NS_ENUM(NSInteger, ProgressStatus) {
    NotStarted,
    InFlight,
    Cancelled,
    Completed
};

@property (copy, readonly) NSString* queryString;
@property (readonly) ProgressStatus progress;
@property (readonly) BOOL hasSucceeded;
@property (readonly) BOOL hasCompleted;

-(BOOL) isFinished;
-(void) didComplete:(BOOL) success withResults:(WRLDSearchResultsCollection *) results;
-(void) cancel;
-(WRLDSearchResultsCollection *) getResults;
@end
