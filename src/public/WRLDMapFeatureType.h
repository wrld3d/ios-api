#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 Types of feature geometry present on the map.
 */
typedef NS_ENUM(NSInteger, WRLDMapFeatureType)
{
    /// No geometry feature.
    WRLDFeatureTypeNone,

    /// The feature geometry is the ground.
    WRLDFeatureTypeGround,

    /// The feature geometry are buildings.
    WRLDFeatureTypeBuilding,

    /// The feature geometry are trees.
    WRLDFeatureTypeTree,

    /// The feature geometry is road transport.
    WRLDFeatureTypeTransportRoad,

    /// The feature geometry is rail transport.
    WRLDFeatureTypeTransportRail,

    /// The feature geometry is tram transport.
    WRLDFeatureTypeTransportTram,

    /// The feature geometry is indoor map structures.
    WRLDFeatureTypeIndoorStructure,

    /// The feature geometry is indoor map highlights.
    WRLDFeatureTypeIndoorHighlight
};

#ifdef __cplusplus
extern "C" {
#endif
    NSString* WRLDMapFeatureTypeToString(WRLDMapFeatureType featureType);

#ifdef __cplusplus
}
#endif

NS_ASSUME_NONNULL_END
