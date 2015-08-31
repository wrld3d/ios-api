// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

namespace Eegeo
{
    namespace Api
    {
        class AnimationTransition
        {
            float m_value;
            float m_transitionSeconds;
            bool m_toOne;
            
        public:
            AnimationTransition(float transitionSeconds);
            
            void ToOne();
            
            void ToZero();
            
            void Update(float deltaSeconds);
            
            float T() const;
            
            void SetT(float value);
        };
    }
}

