#import "WRLDScreenProperties.h"

WRLDScreenProperties WRLDScreenPropertiesMake(float width, float height, float pixelScale)
{
    WRLDScreenProperties screenProperties;
    screenProperties.width = width;
    screenProperties.height = height;
    screenProperties.pixelScale = pixelScale;
    return screenProperties;
}
