#pragma once

#import <UIKit/UIKit.h>
#import "WRLDSearchModuleDelegate.h"
#import "WRLDSearchModule.h"

@interface WRLDSearchWidgetView : UIView <WRLDSearchModuleDelegate>

-(void)setSearchModule:(WRLDSearchModule*) searchModule;

@end
