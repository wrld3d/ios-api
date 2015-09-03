// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#import <GLKit/GLKit.h>
#include "EGMapView.h"
#include "EegeoMapApiImplementation.h"
#include "AppLocationDelegate.h"
#include "AppRunner.h"

// Cached instance of AppRunner and GL context.
AppRunner* g_pAppRunner = NULL;
EAGLContext* g_pContext = NULL;

@implementation EGMapView
{
    CADisplayLink* m_pDisplayLink;
    AppRunner* m_pAppRunner;
    CFTimeInterval m_previousTimestamp;
    bool m_informedDelegateEegeoApiAvailable;
    EegeoMapApiImplementation* m_pEegeoMapApi;
    bool m_teardownHappened;
    bool m_useCachedResources;
}

- (id)initWithCoder:(NSCoder*)coder
{
    if(self = [super initWithCoder:coder])
    {
        [self initView :YES];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self initView :YES];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame :(BOOL)useCachedResources
{
    if(self = [super initWithFrame:frame])
    {
        [self initView :useCachedResources];
    }
    
    return self;
}

-(void) removeFromSuperview
{
    [m_pDisplayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    AppHost& appHost(m_pAppRunner->GetAppHost());
    appHost.UnbindApi();
    
    [m_pEegeoMapApi teardown];
    m_pEegeoMapApi = nil;
    
    m_pAppRunner->UnbindInputProvider();
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"handleResume" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"handlePause" object:nil];
    
    [super removeFromSuperview];
    
    if(!m_useCachedResources)
    {
        delete m_pAppRunner;
        m_pAppRunner = NULL;
    }
    
    self.context = nil;
    m_teardownHappened = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)initView :(BOOL)useCachedResources
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    self.eegeoMapDelegate = nil;
    m_pEegeoMapApi = nil;
    m_teardownHappened = NO;
    m_pDisplayLink = nil;
    m_useCachedResources = useCachedResources;
    
    [self createDisplayLink];
    
    id<UIGestureRecognizerDelegate> gestureRecognizer = self;
    
    std::string apiKey = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"eeGeoMapsApiKey"] UTF8String];
   
    if(m_useCachedResources)
    {
        if(g_pAppRunner == NULL)
        {
            g_pAppRunner = new AppRunner(apiKey);
            g_pContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        }
        
        m_pAppRunner = g_pAppRunner;
        self.context = g_pContext;
    }
    else
    {
        m_pAppRunner = new AppRunner(apiKey);
        self.context = [[[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2] autorelease];
    }
    
    m_pAppRunner->TryBindDisplay(*self, gestureRecognizer);
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(onPause)
                                                 name: @"handlePause"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(onResume)
                                                 name: @"handleResume"
                                               object: nil];
    
    m_previousTimestamp = CFAbsoluteTimeGetCurrent();
}

- (void) layoutSubviews
{
    m_pAppRunner->NotifyViewLayoutChanged(*self);
    
    if(m_pEegeoMapApi != nil)
    {
        const Eegeo::Rendering::ScreenProperties& sp = m_pAppRunner->GetAppHost().App().GetScreenPropertiesProvider().GetScreenProperties();
        
        [m_pEegeoMapApi updateScreenProperties:sp];
    }
}

- (void)onPause
{
    m_pAppRunner->Pause();
}

- (void)onResume
{
    m_pAppRunner->Resume();
}

- (void) drawFrame:(CADisplayLink*)sender
{
    [self display];
}

-(void)drawRect:(CGRect)rect
{
    const CFTimeInterval timeNow = CFAbsoluteTimeGetCurrent();
    const CFTimeInterval timePassedSincePreviousFrame = timeNow - m_previousTimestamp;
    
    const float dt(static_cast<float>(timePassedSincePreviousFrame));

    m_pAppRunner->Update(dt);
    
    if(m_pEegeoMapApi != nil)
    {
        [m_pEegeoMapApi update :dt];
    }

    m_pAppRunner->Draw(dt);
    
    const GLenum discards[]  = {GL_DEPTH_ATTACHMENT, GL_STENCIL_ATTACHMENT};
    Eegeo_GL(glDiscardFramebufferEXT(GL_READ_FRAMEBUFFER_APPLE, 2, discards));
    
    m_previousTimestamp = timeNow;
    
    if(!m_informedDelegateEegeoApiAvailable
       && self.eegeoMapDelegate != nil
       && m_pAppRunner->IsAppHostAvailable())
    {
        AppHost& appHost(m_pAppRunner->GetAppHost());
        Eegeo::EegeoWorld& world(appHost.World());
        
        if(!world.Initialising())
        {
            m_pEegeoMapApi = [[EegeoMapApiImplementation alloc] initWithWorld:world
                                                                          app:m_pAppRunner->GetAppHost().App()
                                                                     delegate:self.eegeoMapDelegate
                                                                         view:self];
            
            appHost.BindApi(*m_pEegeoMapApi);
            
            [self.eegeoMapDelegate eegeoMapReady:m_pEegeoMapApi];
            m_informedDelegateEegeoApiAvailable = true;
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)createDisplayLink
{
    Eegeo_ASSERT(m_pDisplayLink == nil);
    m_pDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawFrame:)];
    [m_pDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [m_pDisplayLink setFrameInterval:2];
}

-(void)applicationDidEnterBackground:(NSNotification*)note
{
    [m_pDisplayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    m_pDisplayLink = nil;
}

-(void)applicationWillEnterForeground:(NSNotification*)note
{
    if(m_pDisplayLink == nil)
    {
        [self createDisplayLink];
    }
}

@end
