#import "WRLDSearchBar.h"
#import "WRLDSearchWidgetStyle.h"

@interface WRLDSearchBar()
@property (weak, nonatomic) IBOutlet UIView* searchBarBackground;
@end

@implementation WRLDSearchBar
{
    UIColor *m_activeBorderColor;
    UIColor *m_inactiveBorderColor;
    CGFloat m_fontSize;
    UIFont *m_font;
    NSString* m_placeholderText;
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
    m_font = [UIFont systemFontOfSize:m_fontSize];
    m_placeholderText = @"Search the WRLD";
}

- (void) applyStyle: (WRLDSearchWidgetStyle *) style
{
    [style call:^(UIColor *color) {
        if(@available(iOS 9.0, *))
        {
            [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setBackgroundColor:color];
        }
        else
        {
            [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:color];
        }
        self.searchBarBackground.backgroundColor = color;
        self.backgroundColor = color;
    } toApply:WRLDSearchWidgetStylePrimaryColor];
    
    [style call:^(UIColor *color) {
        if(@available(iOS 9.0, *))
        {
            [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor: color];
        }
        else
        {
            [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor: color];
        }
    } toApply:WRLDSearchWidgetStyleTextPrimaryColor];
    
    [style call:^(UIColor *color) {
        NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString: self.placeholder attributes:@{NSForegroundColorAttributeName: color}];
        if(@available(iOS 9.0, *))
        {
            [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setAttributedPlaceholder:attributedString];
            [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setLeftViewMode:UITextFieldViewModeUnlessEditing];
        }
        else
        {
            [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAttributedPlaceholder:attributedString];
            [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setLeftViewMode:UITextFieldViewModeUnlessEditing];
        }
    } toApply:WRLDSearchWidgetStyleTextSecondaryColor];
    
    [style call:^(UIColor *color) {
        [self setActiveBorderColor:color];
    } toApply:WRLDSearchWidgetStyleLinkColor];
    
    [style call:^(UIColor *color) {
        [self setInactiveBorderColor:color];
    } toApply:WRLDSearchWidgetStyleSecondaryColor];
    
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
    
    [self setPositionAdjustment:UIOffsetMake(6, 0) forSearchBarIcon:UISearchBarIconClear];
    
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 10;
    UIImage * clearImage = [UIImage imageWithCGImage:(__bridge CGImageRef)([UIColor clearColor])];
    [self setBackgroundImage:clearImage];
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
        self.layer.borderColor = [m_activeBorderColor CGColor];
    }
    else
    {
        self.layer.borderColor = [m_inactiveBorderColor CGColor];
    }
}

-(void) setPlaceholder:(NSString *)placeholder
{
    m_placeholderText = placeholder;
    [super setPlaceholder:m_placeholderText];
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    [super setPlaceholder:m_placeholderText];
}

@end
