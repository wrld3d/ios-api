// Copyright (c) 2015 eeGeo. All rights reserved.

#import "EGPrecacheOperationImplementation.h"
#include "MortonKey.h"
#include "VectorMath.h"
#include "LatLongAltitude.h"
#include "CubeMapCellInfo.h"
#include "Space.h"
#include "IStreamingVolume.h"
#include "PrecacheService.h"
#include "EegeoPrecacheApi.h"
#include <unordered_map>

@implementation EGPrecacheOperationImplementation
{
    Eegeo::Web::PrecacheService* m_pPrecacheService;
    Eegeo::Api::EegeoPrecacheApi* m_pPrecacheApi;
    id<EGMapDelegate> m_pDelegate;
    Eegeo::Api::TOperationId m_operationId;
    
    Eegeo::dv3 m_ecefCentre;
    double m_radius;
    
    BOOL m_cancelled;
    BOOL m_inFlight;
    BOOL m_started;
}

namespace
{
    static std::unordered_map<Eegeo::Api::TOperationId, EGPrecacheOperationImplementation*> s_inFlightOperations;
    static Eegeo::Api::TOperationId s_operationIdGenerator = 0;

    static Eegeo::Api::TOperationId GenerateNextOperationId()
    {
        Eegeo::Api::TOperationId result;
        
        do
        {
            result = s_operationIdGenerator++;
        }
        while (s_inFlightOperations.find(result) != s_inFlightOperations.end());
        
        return result;
    }

    static void OnOperationCompleted(Eegeo::Api::TOperationId operation)
    {
        auto it = s_inFlightOperations.find(operation);
        
        Eegeo_ASSERT(it != s_inFlightOperations.end());
        
        it->second->m_inFlight = NO;
        [it->second triggerDelegateCompletionCallback];
        s_inFlightOperations.erase(it);
    }

    static void OnOperationCancelled(Eegeo::Api::TOperationId operation)
    {
        const auto& it = s_inFlightOperations.find(operation);
        
        Eegeo_ASSERT(it != s_inFlightOperations.end());
        
        [it->second cancel];
        s_inFlightOperations.erase(it);
    }
}

- (id)initWithPrecacheService:(Eegeo::Web::PrecacheService&)precacheService
                          api:(Eegeo::Api::EegeoPrecacheApi&)api
                       center:(const Eegeo::dv3&)ecefCentre
                       radius:(double)radius
                     delegate:(id<EGMapDelegate>)delegate;
{
    m_pPrecacheService = &precacheService;
    m_pPrecacheApi = &api;
    m_pDelegate = delegate;
    
    m_operationId = GenerateNextOperationId();
    m_ecefCentre = ecefCentre;
    m_radius = radius;
    m_cancelled = NO;
    m_inFlight = NO;
    m_started = NO;
    
    return self;
}

- (void)start
{
    Eegeo_ASSERT(!m_cancelled);
    
    m_pPrecacheApi->BeginPrecacheOperation(m_operationId,
                                           Eegeo::Space::LatLongAltitude::FromECEF(m_ecefCentre),
                                           m_radius,
                                           OnOperationCompleted,
                                           OnOperationCancelled);
    
    s_inFlightOperations[m_operationId] = self;
    m_inFlight = YES;
    m_started = YES;
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
            m_pPrecacheApi->CancelPrecacheOperation(m_operationId);
        }
        
        m_inFlight = NO;
        
        [self triggerDelegateCompletionCallback];
    }
}

- (BOOL)cancelled
{
    return m_cancelled;
}

- (int)percentComplete
{
    if([self completed])
    {
        return 100;
    }
    
    return m_started ? static_cast<int>(m_pPrecacheService->PercentCompleted()) : 0;
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
