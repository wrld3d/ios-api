#pragma once

#import <UIKit/UIKit.h>
#import "WRLDSearchModuleDelegate.h"
#import "WRLDSearchModule.h"
#import "WRLDMapView.h"

@interface WRLDSearchWidgetView : UIView <WRLDSearchModuleDelegate, UISearchBarDelegate>

- (void) setSearchModule:(WRLDSearchModule*) searchModule;

/*!
 Provide the map view to enable jumping to locations on the map.
 */
- (void) setMapView: (WRLDMapView*) mapView;

@end
