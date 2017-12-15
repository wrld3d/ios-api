#import <Foundation/Foundation.h>

#include "WRLDMapsceneRequestResponse.h"
#include "WRLDMapsceneRequestResponse+Private.h"

@interface WRLDMapsceneRequestResponse()
{
    
}

@end

@implementation WRLDMapsceneRequestResponse

-(instancetype)initWithSucceeded :(bool)succeeded :(WRLDMapscene*)mapscene
{
    
    self = [super init];
    
    if(self){
        _succeeded = succeeded;
        _mapscene = mapscene;
    }
    
    return self;
    
}

@end

