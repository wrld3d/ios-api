// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#include "AnimationTransition.h"
#include "MathFunc.h"

namespace Eegeo
{
    namespace Api
    {
        float m_value;
        float m_transitionSeconds;
        
        
        AnimationTransition::AnimationTransition(float transitionSeconds)
        : m_value(0.f)
        , m_transitionSeconds(transitionSeconds)
        , m_toOne(true)
        {
            
        }
        
        void AnimationTransition::ToOne()
        {
            m_toOne = true;
        }
        
        void AnimationTransition::ToZero()
        {
            m_toOne = false;
        }
        
        void AnimationTransition::Update(float deltaSeconds)
        {
            float scaledDelta = deltaSeconds / m_transitionSeconds;
            m_value += (m_toOne ? scaledDelta : -scaledDelta);
            m_value = Math::Clamp01(m_value);
        }
        
        float AnimationTransition::T() const
        {
            return m_value;
        }
        
        void AnimationTransition::SetT(float value)
        {
            m_value = Math::Clamp01(value);;
        }
    }
}
