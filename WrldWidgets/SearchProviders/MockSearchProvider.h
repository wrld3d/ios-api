#pragma once
@import Wrld;

#import "WRLDSearchProvider.h"

@interface MockSearchProvider : WRLDSearchProviderBase <WRLDSearchProvider>
- (WRLDSearchResult*) createSearchResult: (NSString*) title latLng: (CLLocationCoordinate2D) latLng subTitle: (NSString*)subTitle tags: (NSString*)tags;

@end



