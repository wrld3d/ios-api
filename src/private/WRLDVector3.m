#import "WRLDVector3.h"

WRLDVector3 WRLDVector3Make(float x, float y, float z)
{
    WRLDVector3 vector3;
    vector3.x = x;
    vector3.y = y;
    vector3.z = z;
    return vector3;
}
