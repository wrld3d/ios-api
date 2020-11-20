#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WRLDRoutingPolylineCreateParams.h"
#import "WRLDPolyline.h"

NS_ASSUME_NONNULL_BEGIN

typedef std::vector<WRLDRoutingPolylineCreateParams> WRLDRoutingPolylineCreateParamsVector;
typedef std::vector<std::pair<int, int>> WRLDStartEndRangePairVector;

@interface WRLDRouteViewAmalgamationHelper : NSObject

+ (NSMutableArray*) CreatePolylines:(const WRLDRoutingPolylineCreateParamsVector&)polylineCreateParams
                               width:(CGFloat)width
                          miterLimit:(CGFloat)miterLimit;

+ (bool) CanAmalgamate:(const WRLDRoutingPolylineCreateParams&)a
                  with:(const WRLDRoutingPolylineCreateParams&)b;

+ (WRLDStartEndRangePairVector) BuildAmalgamationRanges:(const WRLDRoutingPolylineCreateParamsVector&)polylineCreateParams;

+ (WRLDPolyline*) CreateAmalgamatedPolylineForRange:(const WRLDRoutingPolylineCreateParamsVector&)polylineCreateParams
                                         startRange:(const int)rangeStartIndex
                                           endRange:(const int)rangeEndIndex
                                              width:(CGFloat)width
                                         miterLimit:(CGFloat)miterLimit;
@end

NS_ASSUME_NONNULL_END
