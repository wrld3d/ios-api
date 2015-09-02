// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#include "AnimationTransition.h"

namespace Eegeo
{
    namespace Api
    {
        class AnnotationStateModel
        {
            bool m_selected;
            AnimationTransition m_selectionT;
            bool m_usePin;
            
        public:
            AnnotationStateModel(bool usePin);
            
            bool UsingPlatformPin() const;
            
            void Select(bool animateTransition);
            
            void Deselect(bool animateTransition);
            
            bool Selected() const;
            
            void Update(float deltaSeconds);
            
            float T() const;
        };
    }
}

