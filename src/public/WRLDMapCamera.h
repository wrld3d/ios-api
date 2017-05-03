#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WRLDMapCamera : NSObject <NSSecureCoding, NSCopying>

/*!
 */
@property (nonatomic) CLLocationCoordinate2D centerCoordinate;

/*!
 */
@property (nonatomic) CLLocationDirection heading;

/*!
 */
@property (nonatomic) CGFloat pitch;

/*!
 */
@property (nonatomic) CLLocationDistance distance;

+ (instancetype)camera;

+ (instancetype)cameraLookingAtCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                              fromEyeCoordinate:(CLLocationCoordinate2D)eyeCoordinate
                                    eyeAltitude:(CLLocationDistance)eyeAltitude;

+ (instancetype)cameraLookingAtCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                   fromDistance:(CLLocationDistance)distance
                                          pitch:(CGFloat)pitch
                                        heading:(CLLocationDirection)heading;


@end

NS_ASSUME_NONNULL_END
