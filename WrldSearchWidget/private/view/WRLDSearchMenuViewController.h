#pragma once

#import <UIKit/UIKit.h>
#import "WRLDViewVisibilityController.h"
#import "WRLDMenuChangedListener.h"

@class WRLDMenuObserver;
@class WRLDSearchMenuModel;
@class WRLDSearchWidgetStyle;

NS_ASSUME_NONNULL_BEGIN

@interface WRLDSearchMenuViewController : NSObject <WRLDViewVisibilityController, WRLDMenuChangedListener, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readonly) WRLDMenuObserver* observer;

- (instancetype)initWithMenuModel:(WRLDSearchMenuModel *)menuModel
                   visibilityView:(UIView *)visibilityView
                       titleLabel:(UILabel *)titleLabel
                    separatorView:(UIView *)separatorView
                        tableView:(UITableView *)tableView
                 tableFadeTopView:(UIView *)tableFadeTop
              tableFadeBottomView:(UIView *)tableFadeBottom
                 heightConstraint:(NSLayoutConstraint *)heightConstraint
                            style:(WRLDSearchWidgetStyle *)style;

- (void)show;

- (void)hide;

- (void)collapse;

- (void)expandAt:(NSUInteger)index;

- (void)onMenuButtonClicked;

- (void)onMenuBackButtonClicked;

@end

NS_ASSUME_NONNULL_END
