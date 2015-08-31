// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#include "EegeoWorld.h"
#include "Location.h"
#include "GlobeCamera.h"
#include "VectorMath.h"

namespace Eegeo
{
    namespace Api
    {
        class CameraTransitioner
        {
        public:
            CameraTransitioner(Eegeo::Camera::GlobeCamera::GlobeCameraController& cameraController);
            
            void StartTransitionTo(Eegeo::dv3 newInterestPoint, float distanceFromInterest, bool jumpIfFarAway);
            void StartTransitionTo(Eegeo::dv3 newInterestPoint, float distanceFromInterest, float newHeading, bool jumpIfFarAway);
            void StartTransitionTo(Eegeo::dv3 newInterestPoint, float distanceFromInterest, float newHeading, float tiltDegrees, bool jumpIfFarAway);
            void StopCurrentTransition();
            void Update(float dt);
            
            const bool IsTransitioning() const
            {
                return m_isTransitioning;
            }
            
        private:
            bool ShouldJumpTo(Eegeo::dv3 newInterestPoint);
            
            Eegeo::Camera::GlobeCamera::GlobeCameraController& m_cameraController;
            Eegeo::dv3 m_startTransitionInterestPoint;
            Eegeo::dv3 m_endTransitionInterestPoint;
            float m_startInterestDistance;
            float m_endInterestDistance;
            float m_startTransitionHeading;
            float m_endTransitionHeading;
            float m_startTiltDegrees;
            float m_endTiltDegrees;
            float m_transitionTime;
            float m_transitionDuration;
            bool m_isTransitioning;
        };
    }
}
