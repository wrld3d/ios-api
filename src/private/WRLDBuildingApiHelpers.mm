#include "WRLDBuildingApiHelpers.h"

#import "WRLDBuildingHighlightOptions+Private.h"
#import "WRLDBuildingDimensions+Private.h"
#import "WRLDBuildingInformation+Private.h"
#import "WRLDBuildingContour+Private.h"
#import "WRLDMathApiHelpers.h"

@interface WRLDBuildingApiHelpers ()

@end

@implementation WRLDBuildingApiHelpers
{

}

std::vector<CLLocationCoordinate2D> CreateWRLDBuildingContourPoints (const std::vector<Eegeo::Space::LatLong>& withPoints)
{
    std::vector<CLLocationCoordinate2D> locationPoints;
    locationPoints.reserve(withPoints.size());

    for (int i=0; i<withPoints.size(); i++)
    {
        const Eegeo::Space::LatLong& pointLatLong = withPoints[i];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(pointLatLong.GetLatitudeInDegrees(), pointLatLong.GetLongitudeInDegrees());

        locationPoints.emplace_back(coordinate);
    }

    return locationPoints;
}

+ (const Eegeo::BuildingHighlights::BuildingHighlightSelectionMode::Type) ToBuildingHighlightSelectionMode:(WRLDBuildingHighlightSelectionMode)selectionMode
{
    return (selectionMode == WRLDBuildingHighlightSelectionMode::WRLDBuildingHighlightSelectAtLocation)
    ? Eegeo::BuildingHighlights::BuildingHighlightSelectionMode::Type::SelectAtLocation
    : Eegeo::BuildingHighlights::BuildingHighlightSelectionMode::Type::SelectAtScreenPoint;
}

+ (Eegeo::BuildingHighlights::BuildingHighlightCreateParams)createBuildingHighlightCreateParams:(WRLDBuildingHighlightOptions*) buildingHighlightOptions
{
    CLLocationCoordinate2D selectionLocation = buildingHighlightOptions.selectionLocation;
    Eegeo::Space::LatLong latLng = Eegeo::Space::LatLong::FromDegrees(selectionLocation.latitude, selectionLocation.longitude);

    CGPoint selectionScreenPoint = buildingHighlightOptions.selectionScreenPoint;

    Eegeo::BuildingHighlights::BuildingHighlightSelectionMode::Type type = [WRLDBuildingApiHelpers ToBuildingHighlightSelectionMode:buildingHighlightOptions.selectionMode];

    Eegeo::BuildingHighlights::BuildingHighlightCreateParams highlightCreateParams
    {
        type,
        {latLng.GetLatitude(), latLng.GetLongitude()},
        {static_cast<float>(selectionScreenPoint.x),static_cast<float>(selectionScreenPoint.y)},
        [WRLDMathApiHelpers getEegeoColor:buildingHighlightOptions.color],
        static_cast<bool>(buildingHighlightOptions.shouldCreateView)
    };

    return highlightCreateParams;
}

+ (WRLDBuildingDimensions*) createWRLDBuildingDimensions:(const Eegeo::BuildingHighlights::BuildingDimensions&) withBuildingDimensions
{
    WRLDBuildingDimensions* buildingDimensions = [[WRLDBuildingDimensions alloc] initWithBaseAltitude:withBuildingDimensions.GetBaseAltitude()
                                                                                          topAltitude:withBuildingDimensions.GetTopAltitude()
                                                                                             centroid:CLLocationCoordinate2DMake(withBuildingDimensions.GetCentroid().GetLatitudeInDegrees(),
                                                                                                                                 withBuildingDimensions.GetCentroid().GetLongitudeInDegrees())];
    return buildingDimensions;
}

+ (NSArray<WRLDBuildingContour*>*) createWRLDBuildingContours:(const std::vector<Eegeo::BuildingHighlights::BuildingContour>&) withBuildingContours
{
    NSMutableArray* buildingContours = [[NSMutableArray alloc] initWithCapacity:withBuildingContours.size()];

    for(auto& nativeBuildingContour : withBuildingContours)
    {
        WRLDBuildingContour* buildingContour = [[WRLDBuildingContour alloc] initWithBottomAltitude:nativeBuildingContour.GetBottomAltitude()
                                                                                       topAltitude:nativeBuildingContour.GetTopAltitude()
                                                                                            points:CreateWRLDBuildingContourPoints(nativeBuildingContour.GetPoints())];
        [buildingContours addObject:buildingContour];
    }

    return [buildingContours copy];
}

+ (WRLDBuildingInformation*) createWRLDBuildingInformation:(const Eegeo::BuildingHighlights::BuildingInformation&) withBuildingInformation
{
    WRLDBuildingInformation* buildingInformation = [[WRLDBuildingInformation alloc] initWithBuildingId:[NSString stringWithCString: withBuildingInformation.GetBuildingId().c_str() encoding:NSUTF8StringEncoding]
                                                                                    buildingDimensions:[WRLDBuildingApiHelpers createWRLDBuildingDimensions:withBuildingInformation.GetBuildingDimensions()]
                                                                                              contours:[WRLDBuildingApiHelpers createWRLDBuildingContours:withBuildingInformation.GetBuildingContours()]];

    return buildingInformation;
}

@end
