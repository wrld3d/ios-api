#import "WRLDMapFeatureType.h"

NSString* WRLDMapFeatureTypeToString(WRLDMapFeatureType featureType)
{
    NSString* featureTypeString;
    switch (featureType)
    {
        case WRLDFeatureTypeGround:
            featureTypeString = @"WRLDFeatureTypeGround";
            break;
        case WRLDFeatureTypeBuilding:
            featureTypeString = @"WRLDFeatureTypeBuilding";
            break;
        case WRLDFeatureTypeTree:
            featureTypeString = @"WRLDFeatureTypeTree";
            break;
        case WRLDFeatureTypeTransportRoad:
            featureTypeString = @"WRLDFeatureTypeTransportRoad";
            break;
        case WRLDFeatureTypeTransportRail:
            featureTypeString = @"WRLDFeatureTypeTransportRail";
            break;
        case WRLDFeatureTypeTransportTram:
            featureTypeString = @"WRLDFeatureTypeTransportTram";
            break;
        case WRLDFeatureTypeIndoorStructure:
            featureTypeString = @"WRLDFeatureTypeIndoorStructure";
            break;
        case WRLDFeatureTypeIndoorHighlight:
            featureTypeString = @"WRLDFeatureTypeIndoorHighlight";
            break;

        default:
            featureTypeString = @"WRLDFeatureTypeNone";
            break;
    }
    return featureTypeString;
}
