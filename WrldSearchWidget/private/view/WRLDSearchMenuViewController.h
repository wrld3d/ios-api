#pragma once

#import <UIKit/UIKit.h>
#import "WRLDViewVisibilityController.h"
#import "WRLDMenuChangedListener.h"

@class WRLDSearchMenuModel;

NS_ASSUME_NONNULL_BEGIN

@interface WRLDSearchMenuViewController : NSObject <WRLDViewVisibilityController, WRLDMenuChangedListener>

- (instancetype)initWithMenuModel:(WRLDSearchMenuModel *)menuModel
                   visibilityView:(UIView *)visibilityView
                       titleLabel:(UILabel *)titleLabel;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
