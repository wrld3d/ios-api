#import "WRLDSearchBar.h"

@implementation WRLDSearchBar
{
    CGFloat m_searchBarIconWidth;
    UIColor *m_searchBarActiveColor;
    UIColor *m_searchBarInactiveColor;
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
    m_searchBarActiveColor = [UIColor colorWithRed:0.0f/255.0f green:113.0f/255.0f blue:158.0f/255.0f alpha:1.0f];
    m_searchBarInactiveColor = [UIColor grayColor];
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
    
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 10;
    self.layer.borderColor = [m_searchBarInactiveColor CGColor];
    [self setBackgroundImage:[UIImage imageWithCGImage:(__bridge CGImageRef)([UIColor clearColor])]];
}

-(void) setActive:(BOOL) isActive
{
    if(isActive)
    {
        [UIView animateWithDuration:0.25 animations:^{
            [self setPositionAdjustment:UIOffsetMake(-m_searchBarIconWidth, 0) forSearchBarIcon:UISearchBarIconSearch];
        }];
        self.layer.borderColor = [m_searchBarActiveColor CGColor];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            [self setPositionAdjustment:UIOffsetMake(0, 0) forSearchBarIcon:UISearchBarIconSearch];
        }];
        self.layer.borderColor = [m_searchBarInactiveColor CGColor];
    }
}

@end
