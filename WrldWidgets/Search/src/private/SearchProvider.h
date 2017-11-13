
#ifndef SearchProvider_h
#define SearchProvider_h

#import <Foundation/Foundation.h>

@class SearchResultFactory;
@class OnResultRecievedCallback;

@protocol SearchProvider <NSObject>

    @property (readonly) NSString *title;
    - (void)getSearchResults: (NSString*) query;
    - (void) addOnResultsRecievedCallback: (OnResultRecievedCallback*) resultReceivedCallback;
    - (void) setResultViewFactory: (SearchResultFactory*) viewFactory;
    - (SearchResultFactory*) getResultViewFactor;

@end

#endif /* SearchProvider_h */
