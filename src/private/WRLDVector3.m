#import "WRLDVector3.h"
#import "WRLDVector3+Private.h"

WRLDVector3 WRLDVector3Make(CGFloat x, CGFloat y, CGFloat z)
{
    WRLDVector3 vector3;
    vector3.x = x;
    vector3.y = y;
    vector3.z = z;
    return vector3;
}
