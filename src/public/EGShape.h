// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import "EGAnnotation.h"

@interface EGShape : NSObject <EGAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
