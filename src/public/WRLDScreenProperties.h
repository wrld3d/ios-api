#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct WRLDScreenProperties
{
    float width;
    float height;
    float pixelScale;
};
typedef struct WRLDScreenProperties WRLDScreenProperties;

#ifdef __cplusplus
extern "C" {
#endif
    WRLDScreenProperties WRLDScreenPropertiesMake(float width, float height, float pixelScale);

#ifdef __cplusplus
}
#endif

NS_ASSUME_NONNULL_END

