#import <Foundation/Foundation.h>

#import "WRLDMapsceneRequestResponse.h"
#import "WRLDMapsceneRequestResponse+Private.h"

@interface WRLDMapsceneRequestResponse()
{
    
}

@end

@implementation WRLDMapsceneRequestResponse
{
    
}

-(nullable instancetype)initWithSucceeded :(bool)succeeded mapscene:(nullable WRLDMapscene*)mapscene
{
    
    self = [super init];
    
    if(self){
        _succeeded = succeeded;
        _mapscene = mapscene;
    }
    
    return self;
    
}

@end

