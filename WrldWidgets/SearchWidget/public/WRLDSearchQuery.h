#pragma once
#import <Foundation/Foundation.h>

// This type goes out to individual providers
@class WRLDSearchResultModel;

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
-(void) didCompleteSuccessfully:(BOOL) success withResults:(NSArray<WRLDSearchResultModel*>*) results;
-(void) cancel;
-(NSArray<WRLDSearchResultModel*>*) getResults;
@end
