#import "WRLDSearchWidgetView.h"
#import "WRLDSearchWidgetViewController.h"

@interface WRLDSearchWidgetView()
@property (unsafe_unretained, nonatomic) IBOutlet UIView *menuSubView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *searchBarSubView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *voiceOptionSubView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *resultsSubView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *suggestionsSubView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *menuContainerSubView;
@property (unsafe_unretained, nonatomic) IBOutlet WRLDSearchWidgetViewController *owner;
@end

@implementation WRLDSearchWidgetView
{
    UITapGestureRecognizer * m_tapRecogniser;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    if(m_tapRecogniser)
    {
        [self.window removeGestureRecognizer: m_tapRecogniser];
    }
    
    m_tapRecogniser = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapInSubview:)];
    [m_tapRecogniser setCancelsTouchesInView: NO];
    [newWindow addGestureRecognizer: m_tapRecogniser];
}

- (void) tapInSubview: (UIGestureRecognizer *) gestureRecognizer
{
    BOOL tapInSubview = [self subview: self.menuSubView containsGesture: gestureRecognizer]           ||
                        [self subview: self.searchBarSubView containsGesture: gestureRecognizer]      ||
                        [self subview: self.voiceOptionSubView containsGesture: gestureRecognizer]    ||
                        [self subview: self.resultsSubView containsGesture: gestureRecognizer]        ||
                        [self subview: self.suggestionsSubView containsGesture: gestureRecognizer]    ||
                        [self subview: self.menuContainerSubView containsGesture: gestureRecognizer];
    
    if (!tapInSubview)
    {
        [self.owner resignFocus];
    }
}

- (void)dealloc
{
    [self.window removeGestureRecognizer: m_tapRecogniser];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if([self subview: self.menuSubView containsPoint: point inEvent: event])
    {
        return YES;
    }
    if([self subview: self.searchBarSubView containsPoint: point inEvent: event])
    {
        return YES;
    }
    if([self subview: self.voiceOptionSubView containsPoint: point inEvent: event])
    {
        return YES;
    }
    if([self subview: self.resultsSubView containsPoint: point inEvent: event])
    {
        return YES;
    }
    if([self subview: self.suggestionsSubView containsPoint: point inEvent: event])
    {
        return YES;
    }
    if([self subview: self.menuContainerSubView containsPoint: point inEvent: event])
    {
        return YES;
    }
    
    return NO;
}

- (BOOL) subview: (UIView*) view
   containsPoint: (CGPoint)point
         inEvent: (UIEvent*) event
{
    if (view.userInteractionEnabled && ![view isHidden] && [view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
        return YES;
    }
    return NO;
}

- (BOOL) subview: (UIView *) view
 containsGesture: (UIGestureRecognizer *) gestureRecognizer
{
    if (view.userInteractionEnabled && ![view isHidden] && CGRectContainsPoint(view.bounds, [gestureRecognizer locationInView:view]) ) {
        return YES;
    }
    return NO;
}

@end

