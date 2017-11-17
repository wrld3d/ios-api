
#import <UIKit/UIKit.h>
#import "OnResultsModelUpdateDelegate.h"
#import "WRLDSearchModule.h"

@interface WRLDSearchWidgetView : UIView <OnResultsModelUpdateDelegate>

-(void)setSearchModule:(WRLDSearchModule*) searchModule;

@end
