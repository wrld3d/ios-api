#import "WRLDSearchWidgetStyle.h"

#pragma mark - Style Applier

typedef NSMutableArray<ApplyColorEvent> ColorUpdateEventCollection;

@interface WRLDSearchWidgetStyleApplier : NSObject
- (void) apply;
@property (nonatomic, readonly) UIColor * color;
- (void) setColor: (UIColor *) color;
- (void) setColorFromInt: (NSInteger) colorHex;
- (void) addApplication: (ApplyColorEvent) event;
@end

@implementation WRLDSearchWidgetStyleApplier
{
    BOOL m_needsApplied;
    ColorUpdateEventCollection * m_updateEvents;
    UIColor * m_colorToApply;
}

- (instancetype) init
{
    self = [super init];
    if(self)
    {
        m_updateEvents = [[ColorUpdateEventCollection alloc] init];
        m_needsApplied = NO;
    }
    return self;
}

- (void) apply
{
    if(m_needsApplied)
    {
        _color = m_colorToApply;
        for(ApplyColorEvent event in m_updateEvents){
            event(self.color);
        }
        m_needsApplied = NO;
    }
}

- (void) setColor: (UIColor *) newColor
{
    m_needsApplied = newColor != self.color;
    m_colorToApply = newColor;
}

- (void) setColorFromInt: (NSInteger) colorHex
{
    CGFloat r = ((colorHex & 0XFF0000) >> 16) / 255.0f;
    CGFloat g = ((colorHex & 0X00FF00) >> 8) / 255.0f;
    CGFloat b = ((colorHex & 0X0000FF) >> 0) / 255.0f;
    CGFloat a = 1;
    UIColor * color = [UIColor colorWithRed:r green: g blue: b alpha: a];
    [self setColor:color];
}

- (void) addApplication: (ApplyColorEvent) event
{
    [m_updateEvents addObject: event];
    event(self.color);
}

@end

#pragma mark - Style Collection
typedef NSMutableArray<WRLDSearchWidgetStyleApplier *> StyleCollection;

@implementation WRLDSearchWidgetStyle
{
    StyleCollection* m_styleAppliers;
    NSMutableArray<UIColor *> * m_defaultColorsForStyles;
}

- (instancetype) init
{
    self = [super init];
    
    if(self)
    {
        m_styleAppliers = [[StyleCollection alloc] init];
        for(NSInteger i = 0; i < WrldSearchWidgetNumberOfStyles; ++i)
        {
            [m_styleAppliers addObject:[[WRLDSearchWidgetStyleApplier alloc] init]];
        }
        
        [self assignDefaultColors];
        [self apply];
    }
    
    return self;
}

- (void) assignDefaultColors
{
    [[m_styleAppliers objectAtIndex: WRLDSearchWidgetStylePrimaryColor]                 setColorFromInt: 0xFFFFFF];
    [[m_styleAppliers objectAtIndex: WRLDSearchWidgetStyleSecondaryColor]               setColorFromInt: 0xF0F0F0];
    [[m_styleAppliers objectAtIndex: WRLDSearchWidgetStyleSearchBarColor]               setColorFromInt: 0xFFFFFF];
    [[m_styleAppliers objectAtIndex: WRLDSearchWidgetStyleResultBackgroundColor]        setColorFromInt: 0xFFFFFF];
    [[m_styleAppliers objectAtIndex: WRLDSearchWidgetStyleResultSelectedColor]          setColorFromInt: 0xD0DDEF];
    [[m_styleAppliers objectAtIndex: WRLDSearchWidgetStyleTextPrimaryColor]             setColorFromInt: 0x202020];
    [[m_styleAppliers objectAtIndex: WRLDSearchWidgetStyleTextSecondaryColor]           setColorFromInt: 0x606060];
    [[m_styleAppliers objectAtIndex: WRLDSearchWidgetStyleLinkColor]                    setColorFromInt: 0x0071bc];
    [[m_styleAppliers objectAtIndex: WRLDSearchWidgetStyleWarningColor]                 setColorFromInt: 0xD1021A];
    [[m_styleAppliers objectAtIndex: WRLDSearchWidgetStyleDividerColor]            setColorFromInt: 0xB9C9E0];
    [[m_styleAppliers objectAtIndex: WRLDSearchWidgetStyleMenuGroupExpandedColor]       setColorFromInt: 0x1256B0];
    [[m_styleAppliers objectAtIndex: WRLDSearchWidgetStyleMenuGroupCollapsedColor]      setColorFromInt: 0xF0F0F0];
    [[m_styleAppliers objectAtIndex: WRLDSearchWidgetStyleMenuGroupTextExpandedColor]   setColorFromInt: 0xFFFFFF];
    [[m_styleAppliers objectAtIndex: WRLDSearchWidgetStyleMenuGroupTextCollapsedColor]  setColorFromInt: 0x1256B0];
    [[m_styleAppliers objectAtIndex: WRLDSearchWidgetStyleMenuIconColor]                setColorFromInt: 0x0071BC];
}

- (void) call:(ApplyColorEvent)event toApply:(WRLDSearchWidgetStyleType) style
{
    [[m_styleAppliers objectAtIndex: style] addApplication: event];
}

- (void) usesColor:(UIColor *)color forStyle:(WRLDSearchWidgetStyleType) style
{
    [[m_styleAppliers objectAtIndex: style] setColor: color];
}

- (UIColor *) colorForStyle:(WRLDSearchWidgetStyleType) style
{
    return [m_styleAppliers objectAtIndex: style].color;
}

- (void) apply
{
    for(WRLDSearchWidgetStyleApplier *styleApplier in m_styleAppliers)
    {
        [styleApplier apply];
    }
}

@end
