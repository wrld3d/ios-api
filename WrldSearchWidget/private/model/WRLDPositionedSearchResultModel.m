#import <Foundation/Foundation.h>
#import "WRLDPositionedSearchResultModel.h"

@implementation WRLDPositionedSearchResultModel

-(instancetype) initWithTitle:(NSString*) title subTitle:(NSString *)subTitle iconKey:(NSString *) iconKey latLng:(CLLocationCoordinate2D) latLng
{
    self = [super init];
    if(self)
    {
        self.title = title;
        self.subTitle = subTitle;
        self.iconKey = iconKey;
        self.latLng = latLng;
    }
    return self;
}

@end

