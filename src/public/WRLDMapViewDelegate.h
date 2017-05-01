#import <UIKit/UIKit.h>

@class WRLDMapView;

//! define optional methods which can be implemented in order to receive update messages from the map

@protocol WRLDMapViewDelegate <NSObject>

@optional

- (void)mapApiCreated:(WRLDMapView *)mapView;

@end
