#import <Foundation/Foundation.h>

#import "WRLDPointOnPathResult.h"


@implementation WRLDPointOnPathResult

- (instancetype)initWithResultPoint:(CLLocationCoordinate2D)resultPoint
                         inputPoint:(CLLocationCoordinate2D)inputPoint
             distanceFromInputPoint:(double)distanceFromInputPoint
                  fractionAlongPath:(double)fractionAlongPath
      indexOfPathSegmentStartVertex:(int)indexOfPathSegmentStartVertex
        indexOfPathSegmentEndVertex:(int)indexOfPathSegmentEndVertex
{
    if (self = [super init])
    {
        _resultPoint = resultPoint;
        _inputPoint = inputPoint;
        _distanceFromInputPoint = distanceFromInputPoint;
        _fractionAlongPath = fractionAlongPath;
        _indexOfPathSegmentStartVertex = indexOfPathSegmentStartVertex;
        _indexOfPathSegmentEndVertex = indexOfPathSegmentEndVertex;
    }
    
    return self;
}

@end
