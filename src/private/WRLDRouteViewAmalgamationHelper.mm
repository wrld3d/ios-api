#import "WRLDRouteViewAmalgamationHelper.h"
#import "WRLDRouteViewHelper.h"

@implementation WRLDRouteViewAmalgamationHelper

+ (NSMutableArray *) CreatePolylines:(const WRLDRoutingPolylineCreateParamsVector&)polylineCreateParams
                               width:(CGFloat)width
                          miterLimit:(CGFloat)miterLimit
{
    const auto& ranges = [WRLDRouteViewAmalgamationHelper BuildAmalgamationRanges:polylineCreateParams];
    
    NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:ranges.size()];
    
    for (const auto& range : ranges)
    {
        WRLDPolyline *polyline = [WRLDRouteViewAmalgamationHelper CreateAmalgamatedPolylineForRange:polylineCreateParams startRange:range.first endRange:range.second width:width miterLimit:miterLimit];
        if(polyline != nil)
        {
            [result addObject:polyline];
        }
    }
    
    return result;
}

+ (WRLDStartEndRangePairVector) BuildAmalgamationRanges:(const WRLDRoutingPolylineCreateParamsVector&)polylineCreateParams
{
    WRLDStartEndRangePairVector ranges;

    if (polylineCreateParams.empty())
    {
        return ranges;
    }

    int rangeStart = 0;
    for (int i = 1; i < polylineCreateParams.size(); ++i)
    {
        const auto &a = polylineCreateParams[i - 1];
        const auto &b = polylineCreateParams[i];

        if (![WRLDRouteViewAmalgamationHelper CanAmalgamate:a with:b])
        {
            ranges.push_back(std::make_pair(rangeStart, i));
            rangeStart = i;
        }
    }
    ranges.push_back(std::make_pair(rangeStart, int(polylineCreateParams.size())));

    return ranges;
}

+ (bool) CanAmalgamate:(const WRLDRoutingPolylineCreateParams&)a
                  with:(const WRLDRoutingPolylineCreateParams&)b
{
    if (a.IsIndoor() != b.IsIndoor())
    {
        return false;
    }

    if (![a.GetIndoorMapId() isEqualToString:b.GetIndoorMapId()])
    {
        return false;
    }

    if (a.GetIndoorMapFloorId() != b.GetIndoorMapFloorId())
    {
        return false;
    }

    if (![a.GetColor() isEqual:b.GetColor()])
    {
        return false;
    }
    return true;
}

+ (WRLDPolyline *) CreateAmalgamatedPolylineForRange:(const WRLDRoutingPolylineCreateParamsVector&)polylineCreateParams
                                          startRange:(const int)rangeStartIndex
                                            endRange:(const int)rangeEndIndex
                                               width:(CGFloat)width
                                          miterLimit:(CGFloat)miterLimit
{
    Eegeo_ASSERT(rangeStartIndex < rangeEndIndex);
    Eegeo_ASSERT(rangeStartIndex >= 0);
    Eegeo_ASSERT(rangeEndIndex <= polylineCreateParams.size());

    std::vector<CLLocationCoordinate2D> joinedCoordinates;
    std::vector<CGFloat> joinedPerPointElevations;
    
    bool anyPerPointElevations = false;

    for (int i = rangeStartIndex; i < rangeEndIndex; ++i)
    {
        const auto& params = polylineCreateParams[i];
        const auto& coordinates = params.GetCoordinates();

        joinedCoordinates.insert(joinedCoordinates.end(), coordinates.begin(), coordinates.end());

        if (!params.GetPerPointElevations().empty())
        {
            anyPerPointElevations = true;
        }
    }

    if (anyPerPointElevations)
    {
        for (int i = rangeStartIndex; i < rangeEndIndex; ++i)
        {
            const auto& params = polylineCreateParams[i];
            const auto& perPointElevations = params.GetPerPointElevations();

            if (perPointElevations.empty())
            {
                // fill with zero
                joinedPerPointElevations.insert(joinedPerPointElevations.end(), params.GetCoordinates().size(), 0.0);
            }
            else
            {
                joinedPerPointElevations.insert(joinedPerPointElevations.end(), perPointElevations.begin(), perPointElevations.end());
            }
        }
        
        [WRLDRouteViewHelper removeCoincidentPointsWithElevations:joinedCoordinates perPointElevation:joinedPerPointElevations];
    }
    else
    {
        [WRLDRouteViewHelper removeCoincidentPoints:joinedCoordinates];
    }

    if (joinedCoordinates.size() > 1)
    {
        const auto& commonParams = polylineCreateParams[rangeStartIndex];
        
        WRLDPolyline* polyline = [WRLDPolyline polylineWithCoordinates:joinedCoordinates.data() count:joinedCoordinates.size()];
        
        polyline.color = commonParams.GetColor();
        polyline.lineWidth = width;
        polyline.miterLimit = miterLimit;
        
        if(commonParams.IsIndoor())
        {
            [polyline setIndoorMapId:commonParams.GetIndoorMapId()];
            [polyline setIndoorFloorId:commonParams.GetIndoorMapFloorId()];
            
            if(anyPerPointElevations) {
                [polyline setPerPointElevations:joinedPerPointElevations.data() count:joinedPerPointElevations.size()];
            }
        }
        
        return polyline;
    }

    return nil;
}


@end
