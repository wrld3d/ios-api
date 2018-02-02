#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

struct WRLDVector3
{
    float x;
    float y;
    float z;
};
typedef struct WRLDVector3 WRLDVector3;

#ifdef __cplusplus
extern "C" {
#endif
WRLDVector3 WRLDVector3Make(float x, float y, float z);

#ifdef __cplusplus
}
#endif

NS_ASSUME_NONNULL_END
