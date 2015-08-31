// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "EGAnnotation.h"
#import "EGMapTheme.h"
#import "EGPointAnnotation.h"
#import "EGPolygon.h"
#import "EGCoordinateBounds.h"
#import "EGPrecacheOperation.h"
#import "EGAnnotationView.h"

@protocol EegeoMapApi<NSObject>

- (id<EGPolygon>)polygonWithCoordinates:(CLLocationCoordinate2D *)coords
                                 count:(NSUInteger)count;

- (void)addPolygon:(id<EGPolygon>)polygon;

- (void)removePolygon:(id <EGPolygon>)polygon;

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
             distanceMetres:(float)distanceMetres
         orientationDegrees:(float)orientationDegrees
                   animated:(BOOL)animated;

- (void)addAnnotation:(id<EGAnnotation>)annotation;

@property(nonatomic, copy) NSArray *selectedAnnotations;

- (void)selectAnnotation:(id<EGAnnotation>)annotation animated:(BOOL)animated;

- (void)deselectAnnotation:(id<EGAnnotation>)annotation animated:(BOOL)animated;

- (void)removeAnnotation:(id<EGAnnotation>)annotation;

- (EGAnnotationView*)viewForAnnotation:(id<EGAnnotation>)annotation;

- (void)setVisibleCoordinateBounds:(EGCoordinateBounds)bounds;

- (void)setVisibleCoordinateBounds:(EGCoordinateBounds)bounds animated:(BOOL)animated;

- (id<EGPrecacheOperation>)precacheMapDataInCoordinateBounds:(EGCoordinateBounds)bounds;

- (void)setMapTheme:(EGMapTheme*)mapTheme;

- (void)setEnvironmentFlatten:(BOOL)flatten;

@end
