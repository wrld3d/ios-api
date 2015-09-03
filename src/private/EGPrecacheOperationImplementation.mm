// Copyright (c) 2015 eeGeo. All rights reserved.

#import "EGPrecacheOperationImplementation.h"
#include "MortonKey.h"
#include "VectorMath.h"
#include "LatLongAltitude.h"
#include "CubeMapCellInfo.h"
#include "Space.h"
#include "IStreamingVolume.h"
#include "PrecacheService.h"
#include "PrecacheOperationScheduler.h"

namespace
{
    class SphereVolume : public Eegeo::Streaming::IStreamingVolume
    {
        Eegeo::dv3 m_ecefCentre;
        double m_sphereVolumeRadius;
        std::vector<Eegeo::Streaming::MortonKey> m_interesectedKeys;
        
    public:
        SphereVolume(double lat, double lon, double radius)
        : m_ecefCentre(Eegeo::Space::LatLong::FromDegrees(lat, lon).ToECEF())
        , m_sphereVolumeRadius(radius)
        {
            
        }
        
        bool IntersectsKey(const Eegeo::Streaming::MortonKey& key,
                           bool& canRefineIntersectedKey,
                           double& intersectedNodeDepthSortSignedDistance)
        {
            intersectedNodeDepthSortSignedDistance = 0.0;
            
            const Eegeo::Space::CubeMap::CubeMapCellInfo cellInfo(key);
            const Eegeo::dv3 keyEcef = cellInfo.GetFaceCentreECEF();
            const double distanceBetweenCellBoundingSphereAndVolumeSphere = (m_ecefCentre - keyEcef).Length();
            const double cellWidth = key.WidthInMetres();
            const double cellBoundingSphereRadius = std::sqrt((cellWidth*cellWidth) + (cellWidth*cellWidth));
            
            if(distanceBetweenCellBoundingSphereAndVolumeSphere < (m_sphereVolumeRadius + cellBoundingSphereRadius))
            {
                m_interesectedKeys.push_back(key);
                canRefineIntersectedKey = true;
                
                return true;
            }
            
            canRefineIntersectedKey = false;
            return false;
        }
    };
}


@implementation EGPrecacheOperationImplementation
{
    Eegeo::Web::PrecacheService* m_pPrecacheService;
    Eegeo::Api::PrecacheOperationScheduler* m_pPrecacheOperationScheduler;
    id<EGMapDelegate> m_pDelegate;
    
    Eegeo::dv3 m_ecefCentre;
    double m_radius;
    
    BOOL m_cancelled;
    BOOL m_inFlight;
    BOOL m_started;
}

- (id)initWithPrecacheService:(Eegeo::Web::PrecacheService&)precacheService
                    scheduler:(Eegeo::Api::PrecacheOperationScheduler&)precacheOperationScheduler
                       center:(const Eegeo::dv3&)ecefCentre
                       radius:(double)radius
                     delegate:(id<EGMapDelegate>)delegate;
{
    m_pPrecacheService = &precacheService;
    m_pPrecacheOperationScheduler = &precacheOperationScheduler;
    m_pDelegate = delegate;
    
    m_ecefCentre = ecefCentre;
    m_radius = radius;
    m_cancelled = NO;
    m_inFlight = NO;
    m_started = NO;
    
    return self;
}

- (BOOL)tryStart
{
    Eegeo_ASSERT(!m_cancelled);
    
    if(m_pPrecacheService->IsCancelling())
    {
        return NO;
    }
    
    Eegeo_ASSERT(!m_pPrecacheService->CurrentlyPrecaching());

    Eegeo::Space::LatLong ll(Eegeo::Space::LatLong::FromECEF(m_ecefCentre));
    
    SphereVolume volume(ll.GetLatitudeInDegrees(),
                        ll.GetLongitudeInDegrees(),
                        m_radius);
    
    m_pPrecacheService->Precache(volume);
    
    m_inFlight = YES;
    m_started = YES;
    
    return YES;
}

- (BOOL)inFlight
{
    return m_inFlight;
}

- (void)cancel
{
    if(!m_cancelled)
    {
        m_cancelled = YES;
        
        if(m_inFlight)
        {
            m_pPrecacheService->CancelPrecaching();
        }
        
        m_inFlight = NO;
        
        m_pPrecacheOperationScheduler->RemoveFromScheduler(*self);
        
        [self triggerDelegateCompletionCallback];
    }
}

- (BOOL)cancelled
{
    return m_cancelled;
}

- (int)percentComplete
{
    if(m_cancelled)
    {
        return 100;
    }
    
    return static_cast<int>(m_pPrecacheService->PercentCompleted());
}

- (void)update
{
    if(m_inFlight && !m_pPrecacheService->CurrentlyPrecaching())
    {
        m_inFlight = NO;
        [self triggerDelegateCompletionCallback];
    }
}

- (BOOL)completed
{
    if(m_cancelled)
    {
        return YES;
    }
    
    BOOL finished = m_started && !m_inFlight;
    
    return finished;
}

- (void)triggerDelegateCompletionCallback
{
    if(m_pDelegate && [m_pDelegate respondsToSelector:@selector(precacheOperationCompleted:)])
    {
        [m_pDelegate precacheOperationCompleted:self];
    }
}

@end
