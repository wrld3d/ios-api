#pragma once
@import Wrld;

#import "WRLDSearchProvider.h"

@interface MockSearchProvider : NSObject <WRLDSearchProvider>
- (WRLDSearchResult*) createSearchResult: (NSString*) title latLng: (CLLocationCoordinate2D) latLng subTitle: (NSString*)subTitle tags: (NSString*)tags;

@end



