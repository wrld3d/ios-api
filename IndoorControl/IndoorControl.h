#pragma once

#import <UIKit/UIKit.h>
#include <string>
#include <vector>

@class IndoorControl;

@interface IndoorControl : UIView<UITableViewDataSource, UITableViewDelegate>
{
    float m_width;
    float m_height;

    float m_screenWidth;
    float m_screenHeight;
    float m_pixelScale;

    float m_inactiveFloorListXPosition;
    float m_inactiveDetailPaneYPosition;

    float m_onScreenParam;
    float m_stateChangeAnimationTimeSeconds;

    float m_detailsPanelHeight;
    float m_floorDivisionHeight;
    float m_halfButtonHeight;
    float m_halfDivisionHeight;
    BOOL m_touchEnabled;
    BOOL m_draggingFloorButton;
    BOOL m_floorSelectionEnabled;
    float m_floorButtonParameter;
    float m_floorSelection;
    BOOL m_isSliderAnimPlaying;

    CGRect m_scrollRect;

    std::vector<std::string> m_tableViewFloorNames;
}

- (id) initWithCoder:(NSCoder *)aDecoder;

- (id) initWithParams:(float)width :(float)height :(float)pixelScale;

- (BOOL)consumesTouch:(UITouch *)touch;

- (void) show;

- (void) hide;

- (void) setFloorName:(const std::string*)name;

- (void) setSelectedFloor:(int)floorIndex;

- (void) updateFloors: (const std::vector<std::string>&) floorNumbers withCurrentFloor: (int) currentlySelectedFloor;

- (void) setFullyOnScreen;

- (void) setFullyOffScreen;

- (void) setOnScreenStateToIntermediateValue:(float)openState;

- (void) animateTo:(float)t;

- (void) setTouchEnabled:(BOOL)enabled;

- (void) refreshFloorViews;

- (void) playSliderShakeAnim;

- (bool) GetCanShowChangeFloorTutorialDialog;

- (UIColor*) textColorNormal;
- (UIColor*) textColorHighlighted;

@property(nonatomic, retain) UIView* pFloorPanel;
@property(nonatomic, retain) UIButton* pFloorChangeButton;
@property(nonatomic, retain) UILabel* pFloorOnButtonLabel;

@property(nonatomic, retain) UIView* pDetailsPanel;
@property(nonatomic, retain) UIImageView* pDetailsPanelBackground;
@property(nonatomic, retain) UIImageView* pDetailsPanelRight;

@property(nonatomic, retain) UIButton* pDismissButton;
@property(nonatomic, retain) UIImageView* pDismissButtonBackground;
@property(nonatomic, retain) UILabel* pFloorNameLabel;

@property(nonatomic, retain) UITableView* pFloorListView;
@property(nonatomic, retain) UIImageView* pFloorListArrowUp;
@property(nonatomic, retain) UIImageView* pFloorListArrowDown;

@property(nonatomic, retain) NSTimer* pTimer;

@end
