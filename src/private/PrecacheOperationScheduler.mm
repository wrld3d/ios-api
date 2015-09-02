// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#import "PrecacheOperationScheduler.h"

namespace Eegeo
{
    namespace Api
    {
        PrecacheOperationScheduler::~PrecacheOperationScheduler()
        {
            
        }
        
        void PrecacheOperationScheduler::Update()
        {
            if(!m_precacheOperations.empty())
            {
                EGPrecacheOperationImplementation* pPrecacheOperation = m_precacheOperations.front();
                
                if(![pPrecacheOperation inFlight])
                {
                    if(![pPrecacheOperation tryStart])
                    {
                        return;
                    }
                }
                
                [pPrecacheOperation update];
                
                if([pPrecacheOperation completed])
                {
                    m_precacheOperations.pop_front();
                    [pPrecacheOperation release];
                }
            }
        }
        
        void PrecacheOperationScheduler::RemoveFromScheduler(EGPrecacheOperationImplementation& precacheOperation)
        {
            Eegeo_ASSERT(!m_precacheOperations.empty());
            
            EGPrecacheOperationImplementation* pPrecacheOperation = &precacheOperation;
            
            for(std::deque<EGPrecacheOperationImplementation*>::iterator it = m_precacheOperations.begin();
                it != m_precacheOperations.end();
                ++it)
            {
                if(*it == pPrecacheOperation)
                {
                    [pPrecacheOperation release];
                    m_precacheOperations.erase(it);
                    return;
                }
            }
            
            Eegeo_ASSERT(false, "Precache operation not found in scheduler.\n");
        }
        
        void PrecacheOperationScheduler::EnqueuePrecacheOperation(EGPrecacheOperationImplementation& precacheOperation)
        {
            EGPrecacheOperationImplementation* pPrecacheOperation = &precacheOperation;
            [pPrecacheOperation retain];
            m_precacheOperations.push_back(pPrecacheOperation);
        }
    }
}

