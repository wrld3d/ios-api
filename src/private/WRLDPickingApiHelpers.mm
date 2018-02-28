#include "WRLDPickingApiHelpers.h"

#import "WRLDPickResult+Private.h"
#import "WRLDVector3+Private.h"

@interface WRLDPickingApiHelpers ()

@end

@implementation WRLDPickingApiHelpers
{

}

+ (WRLDMapFeatureType) ToWRLDMapFeatureType:(Eegeo::Api::PickResultMapFeature::Type)type
{
    WRLDMapFeatureType featureType;

    switch (type)
    {
        case Eegeo::Api::PickResultMapFeature::Ground:
            featureType = WRLDFeatureTypeGround;
            break;
        case Eegeo::Api::PickResultMapFeature::Building:
            featureType = WRLDFeatureTypeBuilding;
            break;
        case Eegeo::Api::PickResultMapFeature::Tree:
            featureType = WRLDFeatureTypeTree;
            break;
        case Eegeo::Api::PickResultMapFeature::TransportRoad:
            featureType = WRLDFeatureTypeTransportRoad;
            break;
        case Eegeo::Api::PickResultMapFeature::TransportRail:
            featureType = WRLDFeatureTypeTransportRail;
            break;
        case Eegeo::Api::PickResultMapFeature::TransportTram:
            featureType = WRLDFeatureTypeTransportTram;
            break;
        case Eegeo::Api::PickResultMapFeature::IndoorStructure:
            featureType = WRLDFeatureTypeIndoorStructure;
            break;
        case Eegeo::Api::PickResultMapFeature::IndoorHighlight:
            featureType = WRLDFeatureTypeIndoorHighlight;
            break;

        default:
            featureType = WRLDFeatureTypeNone;
            break;
    }

    return featureType;
}

+ (WRLDPickResult *)createWRLDPickResult:(const Eegeo::Api::PickResult &)withPickResult
{
    const Eegeo::Space::LatLongAltitude& latLongAlt = withPickResult.IntersectionPoint();
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latLongAlt.GetLatitudeInDegrees(), latLongAlt.GetLongitudeInDegrees());
    const Eegeo::v3& surfaceNormal = withPickResult.IntersectionSurfaceNormal();

    WRLDPickResult* pickResult = [[WRLDPickResult alloc] initWithFeatureFound:(Boolean)withPickResult.Found()
                                                               mapFeatureType:[WRLDPickingApiHelpers ToWRLDMapFeatureType:withPickResult.MapFeatureType()]
                                                            intersectionPoint:WRLDCoordinateWithAltitudeMake(coordinate, latLongAlt.GetAltitude())
                                                    intersectionSurfaceNormal:WRLDVector3Make(surfaceNormal.GetX(),
                                                                                              surfaceNormal.GetY(),
                                                                                              surfaceNormal.GetZ())];

    return pickResult;
}

@end
