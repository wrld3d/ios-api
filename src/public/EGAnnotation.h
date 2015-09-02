// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import <CoreLocation/CoreLocation.h>

/*!
 @protocol EGAnnotation
 @brief Provides annotation-related information for drawing on the eeGeo 3D Map.
 @discussion To use this protocol, you adopt it in any custom objects that store or represent annotation data. Each object then serves as the source of information about a single map annotation and provides critical information, such as the annotation’s location on the map.
 */
@protocol EGAnnotation <NSObject>

/*!
 @property coordinate
 @brief The WGS84 center point of the annotation.
 */
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@optional

/*!
 @property title
 @brief String representing the annotation title.
 */
@property (nonatomic, readonly, copy) NSString *title;

/*!
 @property subtitle
 @brief String representing the annotation subtitle.
 */
@property (nonatomic, readonly, copy) NSString *subtitle;

@end
