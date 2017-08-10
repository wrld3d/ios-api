#pragma once

NS_ASSUME_NONNULL_BEGIN

/*!
 The 'WRLDOverlay' protocol provides a marker interface for geographic map
 content to be added to a map view. Overlays are data objects that define
 geographic information associated with a point or region on the map, allowing
 a visual representation to be displayed on a map view when the point or region
 comes into view. Several concrete classes adopt this protocol to define
 primitive shapes, such as polygons and polylines. An overlay object is added
 to a WRLDMapView by calling its addOverlay(_:) method.
 */
@protocol WRLDOverlay

@end

NS_ASSUME_NONNULL_END
