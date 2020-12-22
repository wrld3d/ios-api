#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WRLDRoutingPolylineCreateParams.h"
#import "WRLDPolyline.h"

NS_ASSUME_NONNULL_BEGIN

typedef std::vector<WRLDRoutingPolylineCreateParams> WRLDRoutingPolylineCreateParamsVector;
typedef std::vector<std::pair<int, int>> WRLDStartEndRangePairVector;

@interface WRLDRouteViewAmalgamationHelper : NSObject

+ (void)createPolylines:(const WRLDRoutingPolylineCreateParamsVector&)polylineCreateParams
                  width:(CGFloat)width
             miterLimit:(CGFloat)miterLimit
   outBackwardPolylines:(NSMutableArray*)out_backwardPolylines
    outForwardPolylines:(NSMutableArray*)out_forwardPolylines;

+ (bool)canAmalgamate:(const WRLDRoutingPolylineCreateParams&)a
                 with:(const WRLDRoutingPolylineCreateParams&)b;

+ (WRLDStartEndRangePairVector)buildAmalgamationRanges:(const WRLDRoutingPolylineCreateParamsVector&)polylineCreateParams;

+ (WRLDPolyline*)createAmalgamatedPolylineForRange:(const WRLDRoutingPolylineCreateParamsVector&)polylineCreateParams
                                        startRange:(const int)rangeStartIndex
                                          endRange:(const int)rangeEndIndex
                                             width:(CGFloat)width
                                        miterLimit:(CGFloat)miterLimit;
@end

NS_ASSUME_NONNULL_END
