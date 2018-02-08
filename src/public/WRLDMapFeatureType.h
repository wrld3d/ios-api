#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 Types of feature geometry present on the map.
 */
typedef NS_ENUM(NSInteger, WRLDMapFeatureType)
{
    WRLDFeatureTypeNone,
    WRLDFeatureTypeGround,
    WRLDFeatureTypeBuilding,
    WRLDFeatureTypeTree,
    WRLDFeatureTypeTransportRoad,
    WRLDFeatureTypeTransportRail,
    WRLDFeatureTypeTransportTram,
    WRLDFeatureTypeIndoorStructure,
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
