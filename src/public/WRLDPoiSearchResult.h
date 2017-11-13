#pragma once

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 The data for a single POI, returned by a POI search.
 */
@interface WRLDPoiSearchResult : NSObject

/// A unique ID for this POI.
@property (nonatomic) int id;

/// The title text for this POI.
@property (nonatomic) NSString* title;

/// The subtitle text for this POI.
@property (nonatomic) NSString* subtitle;

/// A tag, or a space-separated list of tags, for this POI.
@property (nonatomic) NSString* tags;

/// The geographic location of this POI.
@property (nonatomic) CLLocationCoordinate2D latLng;

/// The distance from the ground, in meters, of this POI.
@property (nonatomic) double heightOffset;

/// Whether this POI is indoors or not.
@property (nonatomic) BOOL indoor;

/// The ID of the indoor map this POI is inside. If the POI is outdoors, this is an empty string.
@property (nonatomic) NSString* indoorMapId;

/// The floor number that this POI is on. If the POI is outdoors, this defaults to 0.
@property (nonatomic) int indoorMapFloorId;

/// Arbitrary JSON user data. This can be empty, or can be any JSON data this POI has associated.
@property (nonatomic) NSString* userData;

@end

NS_ASSUME_NONNULL_END
