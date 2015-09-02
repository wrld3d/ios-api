// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import "EegeoMapApi.h"
#import "EGAnnotationView.h"

@protocol EegeoMapDelegate<NSObject>

- (void)eegeoMapReady:(id<EegeoMapApi>)api;

@optional

- (void)precacheOperationCompleted:(id<EGPrecacheOperation>)precacheOperation;

- (EGAnnotationView*)viewForAnnotation:(id<EGAnnotation>)annotation;

- (void)didSelectAnnotation:(id<EGAnnotation>)annotation;

- (void)didDeselectAnnotation:(id<EGAnnotation>)annotation;

- (BOOL)shouldUseEegeoPinTextureAnnotation:(id<EGAnnotation>)annotation eegeoPinTexturePageIndex:(NSInteger*)eegeoPinTexturePageIndex;

@end
