#import "WRLDSearchWidgetView.h"

@interface WRLDSearchWidgetView()
@property (unsafe_unretained, nonatomic) IBOutlet UIView *menuSubView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *searchBarSubView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *resultsSubView;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *suggestionsSubView;
@end

@implementation WRLDSearchWidgetView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if([self subviewContainsEvent: self.menuSubView point: point event: event])
    {
        return YES;
    }
    if([self subviewContainsEvent: self.searchBarSubView point: point event: event])
    {
        return YES;
    }
    if([self subviewContainsEvent: self.resultsSubView point: point event: event])
    {
        return YES;
    }
    if([self subviewContainsEvent: self.suggestionsSubView point: point event: event])
    {
        return YES;
    }
    
    if([self.searchBarSubView isFirstResponder]){
        [self.searchBarSubView resignFirstResponder];
    }
    
    return NO;
}

-(BOOL) subviewContainsEvent: (UIView*) view
                       point: (CGPoint)point
                        event: (UIEvent*) event
{
    if (view.userInteractionEnabled && ![view isHidden] && [view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
        return YES;
    }
    return NO;
}

@end

