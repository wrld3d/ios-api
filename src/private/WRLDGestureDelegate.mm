#include "WRLDGestureDelegate.h"
#include "AppInterface.h"
#include "ITouchController.h"


#include <algorithm>

@interface WRLDGestureDelegate() <UIGestureRecognizerDelegate>


@property (nonatomic) UIRotationGestureRecognizer *gestureRotation;
@property (nonatomic) UIPinchGestureRecognizer *gesturePinch;
@property (nonatomic) UIPanGestureRecognizer* gesturePan;
@property (nonatomic) UITapGestureRecognizer* gestureTap;
@property (nonatomic) UITapGestureRecognizer* gestureDoubleTap;
@property (nonatomic) UILongPressGestureRecognizer* gestureTouch;

@property (nonatomic) UIView* view;

@end

@implementation WRLDGestureDelegate
{
    Eegeo::ITouchController* m_pTouchController;
    float m_previousDist;
    float m_pixelScale;
    float m_screenWidth;
    float m_screenHeight;
}

-(instancetype) initWith :(Eegeo::ITouchController*)pTouchController
                 :(float)width
                 :(float)height
                 :(float)pixelScale
{
    self = [super init];
    
    m_pTouchController = pTouchController;
    m_screenWidth = width;
    m_screenHeight = height;
    m_pixelScale = pixelScale;
    
    return self;

}



-(void) bind:(UIView*)pView
{
    _view = pView;

    [_view setMultipleTouchEnabled: true];
    
    _gestureRotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRotation_Callback:)];
    _gestureRotation.delegate = self;
    _gestureRotation.cancelsTouchesInView = FALSE;
    
    _gesturePinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(gesturePinch_Callback:)];
    _gesturePinch.delegate = self;
    _gesturePinch.cancelsTouchesInView = FALSE;
    
    
    _gesturePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gesturePan_Callback:)];
    _gesturePan.delegate = self;
    _gesturePan.cancelsTouchesInView = FALSE;
    
    _gestureTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTap_Callback:)];
    _gestureTap.delegate = self;
    _gestureTap.cancelsTouchesInView = FALSE;
    
    _gestureDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureDoubleTap_Callback:)];
    _gestureDoubleTap.delegate = self;
    _gestureDoubleTap.cancelsTouchesInView = FALSE;
    _gestureDoubleTap.delaysTouchesEnded = FALSE;
    _gestureDoubleTap.numberOfTapsRequired = 2;
    
    _gestureTouch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTouch_Callback:)];
    _gestureTouch.delegate = self;
    _gestureTouch.cancelsTouchesInView = FALSE;
    _gestureTouch.minimumPressDuration = 0;

    
    
    [_view addGestureRecognizer: _gestureRotation];
    [_view addGestureRecognizer: _gesturePinch];
    [_view addGestureRecognizer: _gesturePan];
    [_view addGestureRecognizer: _gestureTap];
    [_view addGestureRecognizer: _gestureDoubleTap];
    [_view addGestureRecognizer: _gestureTouch];
}

- (void)unbind
{
    [_view removeGestureRecognizer:_gestureRotation];
    [_view removeGestureRecognizer:_gesturePinch];
    [_view removeGestureRecognizer:_gesturePan];
    [_view removeGestureRecognizer:_gestureTap];
    [_view removeGestureRecognizer:_gestureDoubleTap];
    [_view removeGestureRecognizer:_gestureTouch];
    
    _gestureRotation = nil;
    _gesturePinch = nil;
    _gesturePan = nil;
    _gestureTap = nil;
    _gestureDoubleTap = nil;
    _gestureTouch = nil;
    
   // [super dealloc];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)gestureRotation_Callback:(UIRotationGestureRecognizer*)recognizer
{
    AppInterface::RotateData data;
    
    data.rotation	= static_cast<float>(recognizer.rotation);
    data.numTouches	= static_cast<int>(recognizer.numberOfTouches);
    data.velocity = static_cast<float>(recognizer.velocity);
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        m_pTouchController->Event_TouchRotate_Start (data);
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        m_pTouchController->Event_TouchRotate (data);
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        m_pTouchController->Event_TouchRotate_End (data);
    }
}

namespace
{
    Eegeo::v2 CGPointToEegeoV2(const CGPoint& p)
    {
        return Eegeo::v2(static_cast<float>(p.x), static_cast<float>(p.y));
    }
}

-(void)gesturePinch_Callback:(UIPinchGestureRecognizer*)recognizer
{
    float dist;
    static bool reset = true;
    
    if (recognizer.numberOfTouches == 2)
    {
        CGPoint point0 = [recognizer locationOfTouch:0 inView:_view];
        CGPoint point1 = [recognizer locationOfTouch:1 inView:_view];
        
        Eegeo::v2 p0(CGPointToEegeoV2(point0));
        Eegeo::v2 p1(CGPointToEegeoV2(point1));
        
        Eegeo::v2 v2Dist = Eegeo::v2::Sub(p0, p1);
        
        dist = v2Dist.Length();
        
        if (reset)
        {
            m_previousDist = dist;
            reset = false;
        }
    }
    else
    {
        dist = m_previousDist;
        reset = true;
    }
    
    AppInterface::PinchData data;
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        m_previousDist = dist;
        
        data.scale	= 0.0f;
        m_pTouchController->Event_TouchPinch_Start(data);
        
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        float delta = (m_previousDist-dist);
        float majorScreenDimension = std::max(m_screenHeight, m_screenWidth);
        data.scale = delta/majorScreenDimension;
        m_pTouchController->Event_TouchPinch (data);
        m_previousDist = dist;
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        data.scale	= static_cast<float>(recognizer.scale);
        m_pTouchController->Event_TouchPinch_End (data);
    }
    
    m_previousDist = dist;
}

-(Eegeo::v2)getGestureTouchExtents:(UIGestureRecognizer*)recognizer
{
    Eegeo::v2 touchExtents = Eegeo::v2::Zero();
    if (recognizer.numberOfTouches > 1)
    {
        CGPoint extentsMax = [recognizer locationOfTouch:0 inView:_view];
        CGPoint extentsMin = extentsMax;
        for (int i = 1; i < recognizer.numberOfTouches; ++i)
        {
            CGPoint point = [recognizer locationOfTouch:i inView:_view];
            extentsMax.x = std::max(extentsMax.x, point.x);
            extentsMax.y = std::max(extentsMax.y, point.y);
            extentsMin.x = std::min(extentsMin.x, point.x);
            extentsMin.y = std::min(extentsMin.y, point.y);
        }
        
        CGPoint extents = extentsMax;
        extents.x -= extentsMin.x;
        extents.y -= extentsMin.y;
        touchExtents = CGPointToEegeoV2(extents);
    }
    return touchExtents;
}

-(void)gesturePan_Callback:(UIPanGestureRecognizer*)recognizer
{
    CGPoint position = [recognizer translationInView:_view];
    CGPoint positionAbs = [recognizer locationInView:_view];
    CGPoint velocity = [recognizer velocityInView:_view];
    
    positionAbs.x *= m_pixelScale;
    positionAbs.y *= m_pixelScale;
    position.x *= m_pixelScale;
    position.y *= m_pixelScale;
    velocity.x *= m_pixelScale;
    velocity.y *= m_pixelScale;
    
    AppInterface::PanData data;
    
    data.pointRelative = CGPointToEegeoV2(position);
    float majorScreenDimension = std::max(m_screenHeight, m_screenWidth);
    data.pointRelativeNormalized = (data.pointRelative)/majorScreenDimension;
    data.pointAbsolute = CGPointToEegeoV2(positionAbs);
    data.velocity = CGPointToEegeoV2(velocity);
    data.majorScreenDimension = majorScreenDimension;
    data.numTouches = static_cast<int>(recognizer.numberOfTouches);
    data.touchExtents = [self getGestureTouchExtents :recognizer];
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        m_pTouchController->Event_TouchPan_Start (data);
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        m_pTouchController->Event_TouchPan (data);
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        m_pTouchController->Event_TouchPan_End (data);
    }
}

-(void)gestureTap_Callback:(UITapGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint position = [recognizer locationInView:_view];
        
        position.x *= m_pixelScale;
        position.y *= m_pixelScale;
        
        AppInterface::TapData data;
        
        data.point = CGPointToEegeoV2(position);
        
        m_pTouchController->Event_TouchTap (data);
        
    }
}

-(void)gestureDoubleTap_Callback:(UITapGestureRecognizer*)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        CGPoint position = [recognizer locationInView:_view];
        
        position.x *= m_pixelScale;
        position.y *= m_pixelScale;
        
        AppInterface::TapData data;
        
        data.point = CGPointToEegeoV2(position);
        
        m_pTouchController->Event_TouchDoubleTap (data);
        
    }
}

-(void)gestureTouch_Callback:(UILongPressGestureRecognizer*)recognizer
{
    AppInterface::TouchData data;
    
    CGPoint position = [recognizer locationInView:_view];
    position.x *= m_pixelScale;
    position.y *= m_pixelScale;
    data.point = CGPointToEegeoV2(position);
    
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        m_pTouchController->Event_TouchDown(data);
    }
    else if(recognizer.state == UIGestureRecognizerStateChanged)
    {
        m_pTouchController->Event_TouchMove(data);
    }
    else if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        m_pTouchController->Event_TouchUp(data);
    }
}

@end

