#import "WRLDSearchMenuViewController.h"
#import "WRLDSearchMenuModel.h"

@implementation WRLDSearchMenuViewController
{
    WRLDSearchMenuModel* m_menuModel;
    UIView* m_visibilityView;
    UILabel* m_titleLabel;
}

- (instancetype)initWithMenuModel:(WRLDSearchMenuModel *)menuModel
                   visibilityView:(UIView *)visibilityView
                       titleLabel:(UILabel *)titleLabel
{
    self = [super init];
    if (self)
    {
        m_menuModel = menuModel;
        m_visibilityView = visibilityView;
        m_titleLabel = titleLabel;
        
        [m_menuModel setListener:self];
        
        [self updateTitleLabelText];
    }
    
    return self;
}

- (void)updateTitleLabelText
{
    m_titleLabel.text = m_menuModel.title;
}

#pragma mark - WRLDViewVisibilityController

- (void)show
{
    if (!m_visibilityView.hidden)
    {
        return;
    }
    
    m_visibilityView.hidden = NO;
}

- (void)hide
{
    if (m_visibilityView.hidden)
    {
        return;
    }
    
    m_visibilityView.hidden =  YES;
}

#pragma mark - WRLDMenuChangedListener

- (void)onMenuTitleChanged
{
    [self updateTitleLabelText];
}

- (void)onMenuChanged
{
    
}

@end

