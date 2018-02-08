#pragma once

#include "VectorMath.h"

#import <UIKit/UIColor.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WRLDMathApiHelpers : NSObject

+ (Eegeo::v4) getEegeoColor:(UIColor*) fromUIColor;

@end

NS_ASSUME_NONNULL_END
