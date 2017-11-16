// Copyright eeGeo Ltd (2012-2017), All Rights Reserved

#import <Foundation/Foundation.h>
#import "DefaultSearchProvider.h"

#import "SearchProvider.h"

@implementation DefaultSearchProvider

NSString* _title;

@synthesize title = _title;

- (void)addOnResultsRecievedCallback:(OnResultsRecievedCallback *)resultReceivedCallback {
    //TODO
}

- (SearchResultViewFactory *)getResultViewFactory {
    //TODO
    return nil;
}

- (void)getSearchResults:(NSString *)query {
    //TODO
}

- (void)setResultViewFactory:(SearchResultViewFactory *)viewFactory {
    //TODO
}

@end
