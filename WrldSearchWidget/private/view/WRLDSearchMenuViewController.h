#pragma once

#import <UIKit/UIKit.h>
#import "WRLDViewVisibilityController.h"
#import "WRLDMenuChangedListener.h"

@class WRLDSearchMenuModel;
@class WRLDSearchWidgetStyle;

NS_ASSUME_NONNULL_BEGIN

@interface WRLDSearchMenuViewController : NSObject <WRLDViewVisibilityController, WRLDMenuChangedListener, UITableViewDataSource, UITableViewDelegate>

- (instancetype)initWithMenuModel:(WRLDSearchMenuModel *)menuModel
                   visibilityView:(UIView *)visibilityView
                       titleLabel:(UILabel *)titleLabel
                        tableView:(UITableView *)tableView
                 heightConstraint:(NSLayoutConstraint *)heightConstraint
                            style:(WRLDSearchWidgetStyle *)style;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
