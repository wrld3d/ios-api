#include "WRLDFadeableView.h"

@implementation WRLDFadeableView
{
    BOOL m_isAnimatingOut;
    CGFloat m_fadeDuration;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initMembers];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initMembers];
    }
    return self;
}

- (void) initMembers
{
    m_isAnimatingOut = NO;
    m_fadeDuration = 0.2f;
}

- (void) show: (BOOL) animated
{
    if(animated)
    {
        [self showWithAnimation];
    }
    else{
        [self showImmediately];
    }
}

- (void) showWithAnimation
{
    if(!self.hidden)
    {
        return;
    }
    
    [UIView animateWithDuration: m_fadeDuration animations:^{
        self.alpha = 1.0;
    }];
    self.hidden = NO;
}

- (void) showImmediately
{
    [self.layer removeAllAnimations];
    self.alpha = 1.0;
    self.hidden = NO;
    m_isAnimatingOut = false;
}

- (void) hide: (BOOL) animated
{
    if(animated)
    {
        [self hideWithAnimation];
    }
    else{
        [self hideImmediately];
    }
}

- (void) hideWithAnimation
{
    if(m_isAnimatingOut || self.hidden)
    {
        return;
    }
    
    m_isAnimatingOut = true;
    [UIView animateWithDuration: m_fadeDuration animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if(finished)
        {
            self.hidden =  YES;
            m_isAnimatingOut = false;
        }
    }];
}

- (void) hideImmediately
{
    [self.layer removeAllAnimations];
    self.alpha = 0.0;
    m_isAnimatingOut = false;
    self.hidden = YES;
}

@end
