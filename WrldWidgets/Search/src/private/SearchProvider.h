#pragma once

#import <Foundation/Foundation.h>

@class SearchResultViewFactory;
@class OnResultsRecievedCallback;

@protocol SearchProvider <NSObject>

    @property (nonatomic, readonly, copy) NSString *title;
    - (void)getSearchResults: (NSString*) query;
    - (void) addOnResultsRecievedCallback: (OnResultsRecievedCallback*) resultsReceivedCallback;
    - (void) setResultViewFactory: (SearchResultViewFactory*) viewFactory;
    - (SearchResultViewFactory*) getResultViewFactory;

@end
