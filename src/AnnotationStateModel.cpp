// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#include "AnnotationStateModel.h"

namespace Eegeo
{
    namespace Api
    {
        AnnotationStateModel::AnnotationStateModel(bool usePin)
        : m_selected(false)
        , m_selectionT(0.3f)
        , m_usePin(usePin)
        {
            
        }
        
        bool AnnotationStateModel::UsingPlatformPin() const
        {
            return m_usePin;
        }
        
        void AnnotationStateModel::Select(bool animateTransition)
        {
            m_selected = true;
            
            if(animateTransition)
            {
                m_selectionT.ToOne();
            }
            else
            {
                m_selectionT.SetT(1.f);
            }
        }
        
        void AnnotationStateModel::Deselect(bool animateTransition)
        {
            m_selected = false;
            
            if(animateTransition)
            {
                m_selectionT.ToZero();
            }
            else
            {
                m_selectionT.SetT(0.f);
            }
        }
        
        bool AnnotationStateModel::Selected() const
        {
            return m_selected;
        }
        
        void AnnotationStateModel::Update(float deltaSeconds)
        {
            m_selectionT.Update(deltaSeconds);
        }
        
        float AnnotationStateModel::T() const
        {
            return m_selectionT.T();
        }
    }
}

