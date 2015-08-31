// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import "EGPrecacheOperationImplementation.h"
#include "Types.h"
#include <deque>

namespace Eegeo
{
    namespace Api
    {
        class PrecacheOperationScheduler : Eegeo::NonCopyable
        {
            std::deque<EGPrecacheOperationImplementation*> m_precacheOperations;
            
        public:
            ~PrecacheOperationScheduler();
            
            void EnqueuePrecacheOperation(EGPrecacheOperationImplementation& precacheOperation);
            
            void RemoveFromScheduler(EGPrecacheOperationImplementation& precacheOperation);
            
            void Update();
        };
    }
}

            