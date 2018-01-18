#pragma once

#import <UIKit/UIKit.h>
@import Wrld;

@class WRLDSearchModule;

@interface WRLDSearchWidgetView : UIView <UISearchBarDelegate>

- (void) setSearchModule:(WRLDSearchModule*) searchModule;

/*!
 Provide the map view to enable jumping to locations on the map.
 */
- (void) setMapView: (WRLDMapView*) mapView;

@end

