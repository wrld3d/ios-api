// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@protocol EGPrecacheOperation<NSObject>

- (void)cancel;

- (BOOL)cancelled;

- (BOOL)completed;

- (int)percentComplete;

@end
