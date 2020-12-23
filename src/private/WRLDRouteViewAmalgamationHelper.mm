#import "WRLDRouteViewAmalgamationHelper.h"
#import "WRLDRouteViewHelper.h"

@implementation WRLDRouteViewAmalgamationHelper

+ (void)createPolylines:(const WRLDRoutingPolylineCreateParamsVector&)polylineCreateParams
                  width:(CGFloat)width
             miterLimit:(CGFloat)miterLimit
   outBackwardPolylines:(NSMutableArray*)out_backwardPolylines
    outForwardPolylines:(NSMutableArray*)out_forwardPolylines
{
    const auto& ranges = [WRLDRouteViewAmalgamationHelper buildAmalgamationRanges:polylineCreateParams];

    for (const auto& range : ranges)
    {
        WRLDPolyline* polyline = [WRLDRouteViewAmalgamationHelper createAmalgamatedPolylineForRange:polylineCreateParams startRange:range.first endRange:range.second width:width miterLimit:miterLimit];
        if (polyline != nil)
        {
            if (polylineCreateParams[range.first].isForwardColor())
            {
                [out_forwardPolylines addObject:polyline];
            }
            else
            {
                [out_backwardPolylines addObject:polyline];
            }
        }
    }
}

+ (WRLDStartEndRangePairVector)buildAmalgamationRanges:(const WRLDRoutingPolylineCreateParamsVector&)polylineCreateParams
{
    WRLDStartEndRangePairVector ranges;

    if (polylineCreateParams.empty())
    {
        return ranges;
    }

    int rangeStart = 0;
    for (int i = 1; i < polylineCreateParams.size(); ++i)
    {
        const auto& a = polylineCreateParams[i - 1];
        const auto& b = polylineCreateParams[i];

        if (![WRLDRouteViewAmalgamationHelper canAmalgamate:a with:b])
        {
            ranges.push_back(std::make_pair(rangeStart, i));
            rangeStart = i;
        }
    }
    ranges.push_back(std::make_pair(rangeStart, int(polylineCreateParams.size())));

    return ranges;
}

+ (bool)canAmalgamate:(const WRLDRoutingPolylineCreateParams&)a
                 with:(const WRLDRoutingPolylineCreateParams&)b
{
    if (a.isIndoor() != b.isIndoor())
    {
        return false;
    }

    if (![a.getIndoorMapId() isEqualToString:b.getIndoorMapId()])
    {
        return false;
    }

    if (a.getIndoorMapFloorId() != b.getIndoorMapFloorId())
    {
        return false;
    }

    if (a.isForwardColor() != b.isForwardColor())
    {
        return false;
    }
    return true;
}

+ (WRLDPolyline*)createAmalgamatedPolylineForRange:(const WRLDRoutingPolylineCreateParamsVector&)polylineCreateParams
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
        const auto& coordinates = params.getCoordinates();

        joinedCoordinates.insert(joinedCoordinates.end(), coordinates.begin(), coordinates.end());

        if (!params.getPerPointElevations().empty())
        {
            anyPerPointElevations = true;
        }
    }

    if (anyPerPointElevations)
    {
        for (int i = rangeStartIndex; i < rangeEndIndex; ++i)
        {
            const auto& params = polylineCreateParams[i];
            const auto& perPointElevations = params.getPerPointElevations();

            if (perPointElevations.empty())
            {
                // fill with zero
                joinedPerPointElevations.insert(joinedPerPointElevations.end(), params.getCoordinates().size(), 0.0);
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

        polyline.lineWidth = width;
        polyline.miterLimit = miterLimit;

        if (commonParams.isIndoor())
        {
            [polyline setIndoorMapId:commonParams.getIndoorMapId()];
            [polyline setIndoorFloorId:commonParams.getIndoorMapFloorId()];

            if (anyPerPointElevations)
            {
                [polyline setPerPointElevations:joinedPerPointElevations.data() count:joinedPerPointElevations.size()];
            }
        }

        return polyline;
    }

    return nil;
}

@end
