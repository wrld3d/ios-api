#import "WRLDQueryFinishedViewUpdateDelegate.h"
#import "WRLDSearchWidgetTableViewController.h"

@implementation WRLDQueryFinishedViewUpdateDelegate
{
    WRLDSearchWidgetTableViewController* m_queryDisplayer;
    NSMutableArray<UIView *> * m_viewsToHide;
    CGFloat m_fadeOutDuration;
}

- (instancetype) initWithDisplayer: (WRLDSearchWidgetTableViewController *) queryDisplayer
{
    self = [super init];
    if(self)
    {
        m_queryDisplayer = queryDisplayer;
        m_fadeOutDuration = 1.0f;
    }
    return self;
}

- (void) onQueryCompletionHide: (UIView *) viewToHide
{
    [m_viewsToHide addObject:viewToHide];
}

-(void) didComplete: (WRLDSearchQuery*) query
{
    [m_queryDisplayer showQuery: query];
    for(UIView * viewToHide in m_viewsToHide)
    {
        [UIView animateWithDuration: m_fadeOutDuration animations:^{
            viewToHide.alpha = 0.0;
        } completion:^(BOOL finished) {
            if(finished){
                viewToHide.hidden =  YES;
            }
        }];
    }
}

@end

