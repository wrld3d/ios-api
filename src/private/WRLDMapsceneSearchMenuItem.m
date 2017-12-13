#import "WRLDMapsceneSearchMenuItem.h"

@interface WRLDMapsceneSearchMenuItem()

@end

@implementation WRLDMapsceneSearchMenuItem{
    
}

-(instancetype)initMapsceneSearchMenuItem:(NSString*)name tag:(NSString*)tag iconKey:(NSString*)iconKey skipYelpSearch:(bool)skipYelpSearch
{
    self = [super init];
    
    if(self)
    {
        _name = name;
        _tag = tag;
        _iconKey = iconKey;
        _skipYelpSearch = skipYelpSearch;
        
    }
    
    return self;
    
}

@end
