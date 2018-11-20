#pragma once

#import "WRLDIndoorMapEntity.h"
#import "EegeoIndoorEntityInformationApi.h"

NS_ASSUME_NONNULL_BEGIN

@class WRLDIndoorMapEntity;

@interface WRLDIndoorMapEntity (Private)

- (instancetype) initWithIndoorMapEntityId:(NSString*)indoorMapEntityId
                          indoorMapFloorId:(NSInteger)indoorMapFloorId
                                coordinate:(CLLocationCoordinate2D)coordinate;

+ (WRLDIndoorMapEntity*) createWRLDIndoorMapEntity:(const std::string&) indoorMapEntityId
                               indoorMapFloorId:(int)indoorMapFloorId
                                     coordinate:(const Eegeo::Space::LatLong&)coordinate;
@end

NS_ASSUME_NONNULL_END
