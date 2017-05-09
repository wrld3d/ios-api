// Copyright eeGeo Ltd (2012-2015), All Rights Reserved

#include "ImageHelpers.h"

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
    
    NSString* GetImageNameForDevice(const NSString* name)
    {
        return [NSString stringWithFormat:@"%@%@", name, GetImageScaleSuffix()];
    }
}

namespace ExampleApp
{
    namespace Helpers
    {
        namespace ImageHelpers
        {
            UIImage* LoadImage(const NSString* name, NSBundle* bundle, bool permitFallbackToNonNativeResolution)
            {
                // Uncomment to validate image asset exists at native resolution; this is useful when debugging to detect
                // if iOS is silently falling back to an inappropriate image.
                const bool validateImageExists = true;
                
                if(validateImageExists && !permitFallbackToNonNativeResolution)
                {
                    UIImage* pImg = [UIImage imageNamed: ::GetImageNameForDevice(name) inBundle:bundle compatibleWithTraitCollection:nil];
                    if (pImg == nil)
                    {
                        NSLog(@"Missing image asset %s for current device resolution.\n", [name UTF8String]);
                    }
//                    Eegeo_ASSERT(pImg != nil, "Missing image asset %s for current device resolution.\n", [name UTF8String]);
                }
                
                return [UIImage imageNamed: [NSString stringWithFormat:@"%@", name] inBundle:bundle compatibleWithTraitCollection:nil];
            }
            
            UIImage* ImageFromColor(UIColor* color)
            {
                CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
                UIGraphicsBeginImageContext(rect.size);
                CGContextRef context = UIGraphicsGetCurrentContext();
                
                CGContextSetFillColorWithColor(context, [color CGColor]);
                CGContextFillRect(context, rect);
                
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                return image;
            }
        }
    }
}
