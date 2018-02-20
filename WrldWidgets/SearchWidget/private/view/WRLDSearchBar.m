#import "WRLDSearchBar.h"

@implementation WRLDSearchBar
{
    CGFloat m_searchBarIconWidth;
    UIColor *m_activeBorderColor;
    UIColor *m_inactiveBorderColor;
    CGFloat m_fontSize;
    UIFont *m_font;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self defineConstants];
        [self customiseStyle];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self defineConstants];
        [self customiseStyle];
    }
    
    return self;
}

-(void) defineConstants
{
    m_fontSize = 16;
    m_font = [UIFont  systemFontOfSize:m_fontSize];
    
    if(@available(iOS 11.0, *))
    {
        m_searchBarIconWidth = 30;
    }
    else{
        m_searchBarIconWidth = 24;
    }
}

-(void) customiseStyle
{
    if(@available(iOS 9.0, *))
    {
        [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setDefaultTextAttributes:@{NSFontAttributeName: m_font}];
    }
    else
    {
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSFontAttributeName: m_font}];
    }
    
    [self setActiveBorderColor:[UIColor blackColor]];
    [self setInactiveBorderColor:[UIColor grayColor]];
    
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 10;
    [self setBackgroundImage:[UIImage imageWithCGImage:(__bridge CGImageRef)([UIColor clearColor])]];
}

- (void) setActiveBorderColor: (UIColor *) color
{
    if(color == nil)
    {
        return;
    }
    m_activeBorderColor = color;
    if(self.isFirstResponder)
    {
        self.layer.borderColor = [m_activeBorderColor CGColor];
    }
}

- (void) setInactiveBorderColor: (UIColor *) color
{
    if(color == nil)
    {
        return;
    }
    m_inactiveBorderColor = color;
    if(!self.isFirstResponder)
    {
        self.layer.borderColor = [m_inactiveBorderColor CGColor];
    }
}

-(void) setActive:(BOOL) isActive
{
    if(isActive)
    {
        [UIView animateWithDuration:0.25 animations:^{
            [self setPositionAdjustment:UIOffsetMake(-m_searchBarIconWidth, 0) forSearchBarIcon:UISearchBarIconSearch];
        }];
        self.layer.borderColor = [m_activeBorderColor CGColor];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            [self setPositionAdjustment:UIOffsetMake(0, 0) forSearchBarIcon:UISearchBarIconSearch];
        }];
        self.layer.borderColor = [m_inactiveBorderColor CGColor];
    }
}

@end
