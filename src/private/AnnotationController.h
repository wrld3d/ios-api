// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import "EGAnnotation.h"
#import "EGAnnotationView.h"

#include <map>
#include "AnnotationStateModel.h"
#include "Types.h"
#include "EGMapDelegate.h"
#include "TerrainHeightProvider.h"
#include "Rendering.h"
#include "Pins.h"
#include "GLHelpers.h"
#include "Modules.h"
#include "ITextureFileLoader.h"
#include "RenderCamera.h"

@class EGAnnotationControllerSelectionObserver;

namespace Eegeo
{
    namespace Api
    {
        class AnnotationController : Eegeo::NonCopyable
        {
            typedef std::map<id<EGAnnotation>, AnnotationStateModel> TModelMap;
            typedef TModelMap::iterator TModelMapIt;
            
            typedef std::map<id<EGAnnotation>, EGAnnotationView*> TViewMap;
            typedef TViewMap::iterator TViewMapIt;
            
            Eegeo::Resources::Terrain::Heights::TerrainHeightProvider& m_terrainHeightProvider;
            Eegeo::Rendering::ITexturePageLayout* m_pPinIconsTexturePageLayout;
            Eegeo::Helpers::GLHelpers::TextureInfo m_pinIconsTexture;
            Eegeo::Pins::PinsModule* m_pPinsModule;
            UIView* m_pMapView;
            id<EGMapDelegate> m_pDelegate;
                    
            TModelMap m_modelMap;
            TViewMap m_viewMap;
            id<EGAnnotation> m_selectedAnnotation;
            Eegeo::Pins::TPinId m_nextPinId;
            
            void UpdateAnnotationViewForAnnotation(id<EGAnnotation> selectedAnnotation,
                                                   const Eegeo::Camera::RenderCamera& renderCamera);
            
            bool AnnotationViewContainsPoint(UIView* pView, const Eegeo::v2& screenPoint);
            
        public:
            AnnotationController(Eegeo::Modules::Core::RenderingModule& renderingModule,
                                 Eegeo::Modules::Map::Layers::TerrainModelModule& terrainModelModule,
                                 Eegeo::Modules::Map::MapModule& mapModule,
                                 const Eegeo::Rendering::ScreenProperties& initialScreenProperties,
                                 Eegeo::Helpers::ITextureFileLoader& textureFileLoader,
                                 Eegeo::Resources::Terrain::Heights::TerrainHeightProvider& terrainHeightProvider,
                                 UIView* view,
                                 id<EGMapDelegate> pDelegate);
            
            ~AnnotationController();
            
            id<EGAnnotation> SelectedAnnotation() const;
            
            void InsertAnnotation(id<EGAnnotation> annotation);
            
            void RemoveAnnotation(id<EGAnnotation> annotation);
            
            void SelectAnnotation(id<EGAnnotation> annotation, bool animateTransition);
            
            void DeselectAnnotation(id<EGAnnotation> annotation, bool animateTransition);
            
            EGAnnotationView* ViewForAnnotation(id<EGAnnotation> annotation);
            
            void Update(float deltaSeconds,
                        const Eegeo::Camera::RenderCamera& renderCamera);
            
            void UpdateScreenProperties(const Eegeo::Rendering::ScreenProperties& screenProperties);
            
            void HandleTap(const Eegeo::v2& screenPoint);
        };
    }
}

