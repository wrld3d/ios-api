// Copyright eeGeo Ltd (2012-2015), All Rights Reserved

#include "EGImageHelpers.h"

namespace
{
    NSString* GetImageScaleSuffix()
    {
        // This is not strictly neccessary for images loaded with [UIImage imageNamed:], but is done
        // so we have a consistent way to get the right texture name for non UIKit textures like the
        // 3D pins, GPS marker, POI marker, etc.
        
        int scale = 1;
        UIScreen* screen = [UIScreen mainScreen];
        if ([screen respondsToSelector: @selector(scale)])
        {
            scale = static_cast<int>(screen.scale);
        }
        
        if(scale == 2)
        {
            return @"@2x";
        }
        else if(scale == 3)
        {
            return @"@3x";
        }
        
        return @"";
    }
}

namespace Eegeo
{
    namespace Api
    {
        namespace ImageHelpers
        {
            NSString* GetImageNameForDevice(NSString* name, NSString* ext)
            {
                return [NSString stringWithFormat:@"%@%@%@", name, GetImageScaleSuffix(), ext];
            }
        }
    }
}