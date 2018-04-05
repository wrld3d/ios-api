#pragma once

#import <UIKit/UIKit.h>
#import "WRLDMenuChangedListener.h"

@class WRLDMenuObserver;
@class WRLDSearchMenuModel;
@class WRLDSearchWidgetStyle;

NS_ASSUME_NONNULL_BEGIN

@interface WRLDSearchMenuViewController : NSObject <WRLDMenuChangedListener, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readonly) WRLDMenuObserver* observer;

- (instancetype) initWithVisibilityView:(UIView *)visibilityView
                             titleLabel:(UILabel *)titleLabel
                          separatorView:(UIView *)separatorView
                              tableView:(UITableView *)tableView
                       tableFadeTopView:(UIView *)tableFadeTop
                    tableFadeBottomView:(UIView *)tableFadeBottom
                       heightConstraint:(NSLayoutConstraint *)heightConstraint
                                  style:(WRLDSearchWidgetStyle *)style;

- (void) setModel: (WRLDSearchMenuModel *) menuModel;
- (void) removeModel;

- (void)open;

- (void)close;

- (void)collapse;

- (void)expandAt:(NSUInteger)index;

- (void)onMenuButtonClicked;

- (void)onMenuBackButtonClicked;

- (BOOL)isMenuOpen;

@end

NS_ASSUME_NONNULL_END
