// Copyright (c) 2015 eeGeo. All rights reserved.

#import "EGAnnotationView.h"
#import "SMCalloutView.h"

@implementation EGAnnotationView
{
    SMCalloutView* m_pSelectionCalloutView;
    
    BOOL m_calloutOnDisplay;
    BOOL m_annotationObserversSubscribed;
}

- (instancetype)initWithCoder:(NSCoder *)inCoder;
{
    if (self = [super initWithCoder:inCoder])
    {
        [self initWithAnnotation:nil];
        return self;
    }
    
    return nil;
}

- (instancetype)initWithAnnotation:(NSObject<EGAnnotation>*)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super init])
    {
        [self initWithAnnotation:annotation];
        return self;
    }
    
    return nil;
}

- (void)initWithAnnotation:(NSObject<EGAnnotation>*)annotation
{
    self.centerOffset = CGPointZero;
    self.calloutOffset = CGPointZero;
    self.canShowCallout = YES;
    self.selected = NO;
    self.enabled = YES;
    
    m_annotationObserversSubscribed = NO;
    m_calloutOnDisplay = NO;
    
    [self addObserver:self
           forKeyPath:@"annotation"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
    
    [self addObserver:self
           forKeyPath:@"calloutOffset"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
    
    [self addObserver:self
           forKeyPath:@"canShowCallout"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
    
    [self addObserver:self
           forKeyPath:@"selected"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
    
    [self addObserver:self
           forKeyPath:@"leftCalloutAccessoryView"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
    
    [self addObserver:self
           forKeyPath:@"rightCalloutAccessoryView"
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
    
    self.annotation = annotation;
    
    m_pSelectionCalloutView = [[SMCalloutView platformCalloutView] retain];
    
    [self setAnnotationViewLabelsFromAnnotation];
    
    self.calloutOffset = CGPointMake(0.f, -32.f);
}

- (void)dealloc
{
    self.annotation = nil;
    
    [self removeObserver:self forKeyPath:@"rightCalloutAccessoryView"];
    [self removeObserver:self forKeyPath:@"leftCalloutAccessoryView"];
    [self removeObserver:self forKeyPath:@"selected"];
    [self removeObserver:self forKeyPath:@"canShowCallout"];
    [self removeObserver:self forKeyPath:@"calloutOffset"];
    [self removeObserver:self forKeyPath:@"annotation"];
    
    if(m_calloutOnDisplay)
    {
        [m_pSelectionCalloutView dismissCalloutAnimated:NO];
    }
    
    [m_pSelectionCalloutView release];
    
    [super dealloc];
}

- (void)subscribeAnnotationObservers :(NSObject<EGAnnotation>*)annotationToSubscribe
{
    if(!m_annotationObserversSubscribed && annotationToSubscribe != nil && ![[NSNull null] isEqual:annotationToSubscribe])
    {
        [annotationToSubscribe addObserver:self
                                forKeyPath:@"title"
                                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                   context:nil];
        
        [annotationToSubscribe addObserver:self
                                forKeyPath:@"subtitle"
                                   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                   context:nil];
        
        m_annotationObserversSubscribed = YES;
    }
}

- (void)unsubscribeAnnotationObservers :(NSObject<EGAnnotation>*)annotationToUnsubscribe
{
    if(m_annotationObserversSubscribed && annotationToUnsubscribe != nil && ![[NSNull null] isEqual:annotationToUnsubscribe])
    {
        [annotationToUnsubscribe removeObserver:self forKeyPath:@"title"];
        [annotationToUnsubscribe removeObserver:self forKeyPath:@"subtitle"];

        m_annotationObserversSubscribed = NO;
    }
}

- (void)prepareForReuse
{
    // Nothing to do.
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    self->_selected = selected;
    
    if(self->_selected != m_calloutOnDisplay)
    {
        [self toggleCallout:self.selected animated:animated];
    }
}

- (void)toggleCallout:(BOOL)showCallout animated:(BOOL)animated
{
    BOOL shouldDisplayCallout = showCallout &&  self.canShowCallout;
    
    if(shouldDisplayCallout)
    {
        [m_pSelectionCalloutView presentCalloutFromRect:CGRectZero
                                                 inView:self
                                      constrainedToView:[self superview]
                                               animated:animated];
        
        [[self superview] bringSubviewToFront:self];
    }
    else
    {
        if(m_calloutOnDisplay)
        {
            [m_pSelectionCalloutView dismissCalloutAnimated:animated];
        }
    }
    
    m_calloutOnDisplay = shouldDisplayCallout;
}

-(void) updateCalloutFrame
{
    m_pSelectionCalloutView.calloutOffset = self.calloutOffset;
}

- (void)handleCalloutOffsetChanged
{
    [self updateCalloutFrame];
}

- (void)handleCanShowCalloutChanged
{
    if(self.selected != m_calloutOnDisplay)
    {
        [self toggleCallout:self.canShowCallout animated:YES];
    }
}

- (void)handleSelectedChanged
{
    if(self.selected != m_calloutOnDisplay)
    {
        [self toggleCallout:self.canShowCallout animated:YES];
    }
}

- (void)handleLeftCalloutAccessoryViewChanged
{
    [m_pSelectionCalloutView setLeftAccessoryView:self.leftCalloutAccessoryView];
}

- (void)handleRightCalloutAccessoryViewChanged
{
    [m_pSelectionCalloutView setRightAccessoryView:self.rightCalloutAccessoryView];
}

- (void)setAnnotationViewLabelsFromAnnotation
{
    [m_pSelectionCalloutView setTitle: [self.annotation title]];
    [m_pSelectionCalloutView setSubtitle: [self.annotation subtitle]];
}

- (void)handleAnnotationTextChanged
{
    [self setAnnotationViewLabelsFromAnnotation];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if(object == self)
    {
        if ([keyPath isEqual:@"annotation"])
        {
            [self unsubscribeAnnotationObservers:change[NSKeyValueChangeOldKey]];
            [self subscribeAnnotationObservers:change[NSKeyValueChangeNewKey]];
            [self setAnnotationViewLabelsFromAnnotation];
        }
        
        if ([keyPath isEqual:@"calloutOffset"])
        {
            [self handleCalloutOffsetChanged];
        }
        
        if ([keyPath isEqual:@"canShowCallout"])
        {
            [self handleCanShowCalloutChanged];
        }
        
        if ([keyPath isEqual:@"selected"])
        {
            [self handleSelectedChanged];
        }
        
        if ([keyPath isEqual:@"leftCalloutAccessoryView"])
        {
            [self handleLeftCalloutAccessoryViewChanged];
        }
        
        if ([keyPath isEqual:@"rightCalloutAccessoryView"])
        {
            [self handleRightCalloutAccessoryViewChanged];
        }
    }
    else if(object == [self annotation])
    {
        if ([keyPath isEqual:@"title"])
        {
            [self handleAnnotationTextChanged];
        }
        
        if ([keyPath isEqual:@"subtitle"])
        {
            [self handleAnnotationTextChanged];
        }
    }
}

@end
