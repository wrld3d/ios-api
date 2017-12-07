#import <Foundation/Foundation.h>

#include "WRLDMapsceneRequestResponse.h"
#include "WRLDMapscene.h"

@interface WRLDMapsceneRequestResponse(){
    
}

@end

@implementation WRLDMapsceneRequestResponse{
    WRLDMapscene* m_wrldMapscene;
    bool m_succeeded;
}

-(instancetype)initMapsceneRequestResponse :(bool)succeeded :(WRLDMapscene*)mapscene{
    
    self = [super init];
    
    if(self){
        m_succeeded = succeeded;
        m_wrldMapscene = mapscene;
    }
    
    return self;
    
}

-(WRLDMapscene*)getMapscene{
    return m_wrldMapscene;
    
}
-(bool)getSucceeded{
    return m_succeeded;
    
}

@end

