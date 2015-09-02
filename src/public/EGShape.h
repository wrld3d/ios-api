// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import "EGAnnotation.h"

/*!
 @protocol EGPrecacheOperation
 @brief Defines the basic properties for all shape-based annotation objects.
 @discussion Subclasses of EGShape are responsible for defining the geometry of the shape and providing an appropriate value for the coordinate property inherited from the EGAnnotation protocol.*/
@interface EGShape : NSObject <EGAnnotation>

/*!
 @property title
 @brief String representing the shape title.
 */
@property (nonatomic, copy) NSString *title;

/*!
 @property title
 @brief String representing the shape title.
 */
@property (nonatomic, copy) NSString *subtitle;

@end
