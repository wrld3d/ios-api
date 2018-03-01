#include "WRLDStringApiHelpers.h"

@interface WRLDStringApiHelpers ()

@end

@implementation WRLDStringApiHelpers
{

}

+ (std::vector<std::string>) copyToStringVector:(NSArray<NSString*>*) fromNSArray
{
    std::vector<std::string> stringVector;
    stringVector.reserve([fromNSArray count]);

    for (NSString* str in fromNSArray)
    {
        const std::string nativeString = std::string([str UTF8String]);
        stringVector.emplace_back(nativeString);
    }

    return stringVector;
}

+ (NSArray<NSString*>*) copyToNSStringArray:(const std::vector<std::string>&) fromStringVector
{
    NSMutableArray<NSString*>* stringArray = [[NSMutableArray alloc] initWithCapacity:(fromStringVector.size())];
    for(auto& nativeString : fromStringVector)
    {
        [stringArray addObject:[NSString stringWithCString: nativeString.c_str() encoding:NSUTF8StringEncoding]];
    }

    return [stringArray copy];
}

@end
