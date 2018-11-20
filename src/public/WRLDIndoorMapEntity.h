#pragma once

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 * Represents infomation about an identifiable feature on an indoor map.
 * These correspond to features within a level GeoJSON in an indoor map submission via the WRLD Indoor Map REST API.
 * See [https://github.com/wrld3d/wrld-indoor-maps-api/blob/master/FORMAT.md](https://github.com/wrld3d/wrld-indoor-maps-api/blob/master/FORMAT.md)
 */
@interface WRLDIndoorMapEntity : NSObject

/// The string identifier of this indoor map entity. 
@property (nonatomic, readonly, copy) NSString* indoorMapEntityId;

/// The identifier of the indoor map floor on which this indoor map entity is positioned.
@property (nonatomic, readonly) NSInteger indoorMapFloorId;

/*!
 * The location of this indoor map entity. Although indoor map entities can represent area
 * features such as rooms or desks, this position provides a point that is in the center of the
 * feature. As such, it is suitable for use if locating a WRLDMarker for this entity, or if
 * positioning the camera to look at this entity.
 */
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end

NS_ASSUME_NONNULL_END
