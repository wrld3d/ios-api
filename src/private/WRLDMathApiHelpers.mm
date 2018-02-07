#include "WRLDMathApiHelpers.h"

@interface WRLDMathApiHelpers ()

@end

@implementation WRLDMathApiHelpers
{

}

+ (Eegeo::v4) getEegeoColor:(UIColor*) fromUIColor
{
    CGFloat red, green, blue, alpha;
    [fromUIColor getRed:&red
                  green:&green
                   blue:&blue
                  alpha:&alpha];
    return Eegeo::v4(static_cast<float>(red), static_cast<float>(green), static_cast<float>(blue), static_cast<float>(alpha));
}

@end
