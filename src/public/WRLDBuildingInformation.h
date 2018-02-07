#pragma once

#import <Foundation/Foundation.h>

#import "WRLDBuildingDimensions.h"
#import "WRLDBuildingContour.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 Information about a building on the map, obtained by adding a WRLDBuildingHighlight object and
 to the map.
 */
@interface WRLDBuildingInformation : NSObject

/*!
 A unique identifier for the building. The BuildingId for a building on the map is not
 necessarily maintained between versions of the map or Api.
 */
@property (nonatomic, readonly, copy) NSString* buildingId;

/*!
 Summary information about the dimensions of the building.
 */
@property (nonatomic, readonly, copy) WRLDBuildingDimensions* buildingDimensions;

/*!
 An array of WRLDBuildingContour objects, representing the geometry of the building.
 */
@property (nonatomic, readonly, copy) NSArray<WRLDBuildingContour*>* contours;

@end

NS_ASSUME_NONNULL_END
