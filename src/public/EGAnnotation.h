// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import <CoreLocation/CoreLocation.h>

@protocol EGAnnotation <NSObject>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@optional

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

@end
