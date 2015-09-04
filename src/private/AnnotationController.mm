// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#include "AnnotationController.h"
#include "CameraHelpers.h"
#include "EcefTangentBasis.h"
#include "PinsModule.h"
#include "ITextureFileLoader.h"
#include "RegularTexturePageLayout.h"
#include "CameraTransitioner.h"
#include "PrecacheOperationScheduler.h"
#include "AnnotationController.h"
#include "TerrainHeightProvider.h"
#include "LatLongAltitude.h"
#include "EGImageHelpers.h"

namespace Eegeo
{
    namespace Api
    {
        AnnotationController::AnnotationController(Eegeo::Modules::Core::RenderingModule& renderingModule,
                                                   Eegeo::Modules::Map::Layers::TerrainModelModule& terrainModelModule,
                                                   Eegeo::Modules::Map::MapModule& mapModule,
                                                   const Eegeo::Rendering::ScreenProperties& initialScreenProperties,
                                                   Eegeo::Helpers::ITextureFileLoader& textureFileLoader,
                                                   Eegeo::Resources::Terrain::Heights::TerrainHeightProvider& terrainHeightProvider,
                                                   UIView* pView,
                                                   id<EGMapDelegate> pDelegate)
        : m_terrainHeightProvider(terrainHeightProvider)
        , m_selectedAnnotation(nil)
        , m_pMapView(pView)
        , m_pDelegate(pDelegate)
        , m_nextPinId(0)
        {
            NSString* fullTextureName = Eegeo::Api::ImageHelpers::GetImageNameForDevice(@"pins_example/PinIconTexturePage", @".png");
            textureFileLoader.LoadTexture(m_pinIconsTexture, [fullTextureName UTF8String], true);
            Eegeo_ASSERT(m_pinIconsTexture.textureId != 0);
            
            int numberOfTilesAlongEachAxisOfTexturePage = 4;
            m_pPinIconsTexturePageLayout = Eegeo_NEW(Eegeo::Rendering::RegularTexturePageLayout)(numberOfTilesAlongEachAxisOfTexturePage);
            
            int spriteWidthInMetres = 32;
            int spriteHeightInMetres = 32;
            
            m_pPinsModule = Eegeo_NEW(Eegeo::Pins::PinsModule)(m_pinIconsTexture.textureId,
                                                               *m_pPinIconsTexturePageLayout,
                                                               renderingModule.GetGlBufferPool(),
                                                               renderingModule.GetShaderIdGenerator(),
                                                               renderingModule.GetMaterialIdGenerator(),
                                                               renderingModule.GetVertexBindingPool(),
                                                               renderingModule.GetVertexLayoutPool(),
                                                               renderingModule.GetRenderableFilters(),
                                                               terrainModelModule.GetTerrainHeightProvider(),
                                                               spriteWidthInMetres,
                                                               spriteHeightInMetres,
                                                               Eegeo::Rendering::LayerIds::AfterAll,
                                                               mapModule.GetEnvironmentFlatteningService(),
                                                               initialScreenProperties,
                                                               false);
        }
        
        AnnotationController::~AnnotationController()
        {
            Eegeo_DELETE(m_pPinsModule);
            Eegeo_DELETE(m_pPinIconsTexturePageLayout);
            glDeleteTextures(1, &m_pinIconsTexture.textureId);
        }
        
        void AnnotationController::UpdateScreenProperties(const Eegeo::Rendering::ScreenProperties& screenProperties)
        {
            m_pPinsModule->UpdateScreenProperties(screenProperties);
        }
        
        id<EGAnnotation> AnnotationController::SelectedAnnotation() const
        {
            return m_selectedAnnotation;
        }
        
        void AnnotationController::InsertAnnotation(id<EGAnnotation> annotation)
        {
            [annotation retain];
            
            TViewMapIt viewIt(m_viewMap.find(annotation));
            Eegeo_ASSERT(viewIt == m_viewMap.end());
            
            EGAnnotationView* pView = nil;
            
            if(m_pDelegate && [m_pDelegate respondsToSelector:@selector(viewForAnnotation:)])
            {
                pView = [m_pDelegate viewForAnnotation:annotation];
            }
            
            if(pView == nil)
            {
                pView = [[[EGAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"DefaultAnnotationView"] autorelease];
            }
            
            [pView retain];
            [m_pMapView insertSubview:pView atIndex:0];
            
            // 
            
            std::pair<TViewMapIt, bool> viewResult = m_viewMap.insert(std::make_pair(annotation, pView));
            Eegeo_ASSERT(viewResult.second);
            
            BOOL usePlatformPin = YES;
            NSInteger pinTexture = 0;
            
            if(m_pDelegate && [m_pDelegate respondsToSelector:@selector(shouldUseEegeoPinTextureAnnotation:eegeoPinTexturePageIndex:)])
            {
                usePlatformPin = [m_pDelegate shouldUseEegeoPinTextureAnnotation:annotation eegeoPinTexturePageIndex:&pinTexture];
            }
            
            if(usePlatformPin)
            {
                Eegeo::Pins::PinRepository& pinRepository = m_pPinsModule->GetRepository();
                Eegeo::Pins::TPinId pinId = m_nextPinId++;
                Eegeo::Space::LatLong pinLocation = Eegeo::Space::LatLong::FromDegrees(annotation.coordinate.latitude,
                                                                                       annotation.coordinate.longitude);
                
                const float heightAboveTerrainInMetres = 0.f;
                
                Eegeo::Pins::Pin* pPin = Eegeo_NEW(Eegeo::Pins::Pin)(pinId,
                                                                     pinLocation,
                                                                     heightAboveTerrainInMetres,
                                                                     static_cast<int>(pinTexture),
                                                                     annotation);
                pinRepository.AddPin(*pPin);
            }
            
            TModelMapIt modelIt(m_modelMap.find(annotation));
            Eegeo_ASSERT(modelIt == m_modelMap.end());
            std::pair<TModelMapIt, bool> modelResult = m_modelMap.insert(std::make_pair(annotation, AnnotationStateModel(usePlatformPin)));
            Eegeo_ASSERT(modelResult.second);
        }
        
        void AnnotationController::RemoveAnnotation(id<EGAnnotation> annotation)
        {
            if(m_selectedAnnotation == annotation)
            {
                DeselectAnnotation(m_selectedAnnotation, false);
            }
            
            TModelMapIt modelIt(m_modelMap.find(annotation));
            Eegeo_ASSERT(modelIt != m_modelMap.end());
            
            if(modelIt->second.UsingPlatformPin())
            {
                Eegeo::Pins::PinRepository& pinRepository = m_pPinsModule->GetRepository();
                
                for(size_t i = 0; i < pinRepository.GetNumOfPins(); ++ i)
                {
                    Eegeo::Pins::Pin& pin = *pinRepository.GetPinAtIndex(static_cast<int>(i));
                    
                    if(pin.GetUserData() == annotation)
                    {
                        pinRepository.RemovePin(pin);
                        Eegeo_DELETE &pin;
                        break;
                    }
                }
            }
            
            m_modelMap.erase(modelIt);
            
            TViewMapIt viewIt(m_viewMap.find(annotation));
            Eegeo_ASSERT(viewIt != m_viewMap.end());
            EGAnnotationView* pView = viewIt->second;
            [pView removeFromSuperview];
            [pView release];
            m_viewMap.erase(viewIt);
            
            [annotation release];
        }
        
        void AnnotationController::SelectAnnotation(id<EGAnnotation> annotation, bool animateTransition)
        {
            if(m_selectedAnnotation == annotation)
            {
                return;
            }
            
            if(m_selectedAnnotation != nil)
            {
                DeselectAnnotation(m_selectedAnnotation, false);
            }
            
            TModelMapIt modelIt(m_modelMap.find(annotation));
            Eegeo_ASSERT(modelIt != m_modelMap.end());
            AnnotationStateModel& state = modelIt->second;
            state.Select(animateTransition);
            m_selectedAnnotation = annotation;
            
            TViewMapIt viewIt(m_viewMap.find(annotation));
            Eegeo_ASSERT(viewIt != m_viewMap.end());
            EGAnnotationView* pView = viewIt->second;
            Eegeo_ASSERT(pView != nil);
            Eegeo_ASSERT(![pView isSelected]);
            
            if(m_pDelegate && [m_pDelegate respondsToSelector:@selector(didSelectAnnotation:)])
            {
                 [m_pDelegate didSelectAnnotation:annotation];
            }
            
            [pView setSelected:YES animated:animateTransition];
        }
        
        void AnnotationController::DeselectAnnotation(id<EGAnnotation> annotation, bool animateTransition)
        {
            Eegeo_ASSERT(annotation == m_selectedAnnotation);
            
            TModelMapIt it(m_modelMap.find(annotation));
            Eegeo_ASSERT(it != m_modelMap.end());
            AnnotationStateModel& state = it->second;
            state.Deselect(animateTransition);
            m_selectedAnnotation = nil;
            
            TViewMapIt viewIt(m_viewMap.find(annotation));
            Eegeo_ASSERT(viewIt != m_viewMap.end());
            EGAnnotationView* pView = viewIt->second;
            Eegeo_ASSERT(pView != nil);
            Eegeo_ASSERT([pView isSelected]);
            [pView setSelected:NO animated:animateTransition];
            
            if(m_pDelegate && [m_pDelegate respondsToSelector:@selector(didDeselectAnnotation:)])
            {
                [m_pDelegate didDeselectAnnotation:annotation];
            }
        }
        
        EGAnnotationView* AnnotationController::ViewForAnnotation(id<EGAnnotation> annotation)
        {
            TViewMapIt viewIt(m_viewMap.find(annotation));
            Eegeo_ASSERT(viewIt != m_viewMap.end());
            EGAnnotationView* pView = viewIt->second;
            Eegeo_ASSERT(pView != nil);
            return pView;
        }
        
        void AnnotationController::Update(float deltaSeconds,
                                          const Eegeo::Camera::RenderCamera& renderCamera)
        {
            for(TModelMapIt modelIt = m_modelMap.begin();
                modelIt != m_modelMap.end();
                ++ modelIt)
            {
                id<EGAnnotation> annotation = modelIt->first;
                AnnotationStateModel& state = modelIt->second;
                state.Update(deltaSeconds);
                
                UpdateAnnotationViewForAnnotation(annotation, renderCamera);
            }
            
            // TODO -- animate pins for default annotations based on AnnotationStateModel::T
            
            m_pPinsModule->Update(deltaSeconds, renderCamera);
        }
        
        void AnnotationController::UpdateAnnotationViewForAnnotation(id<EGAnnotation> annotation,
                                                                     const Eegeo::Camera::RenderCamera& renderCamera)
        {
            CLLocationCoordinate2D coord = [annotation coordinate];
            Eegeo::dv3 ecefPositionSeaLevel = Eegeo::Space::LatLong::FromDegrees(coord.latitude,  coord.longitude).ToECEF();
            float terrainHeight;
            
            if(m_terrainHeightProvider.TryGetHeight(ecefPositionSeaLevel , 0, terrainHeight))
            {
                TViewMapIt viewIt(m_viewMap.find(annotation));
                Eegeo_ASSERT(viewIt != m_viewMap.end());
                EGAnnotationView* pView = viewIt->second;
                
                Eegeo::dv3 ecefPosition = ecefPositionSeaLevel + (ecefPositionSeaLevel.Norm() * terrainHeight);
                
                Eegeo::v3 cameraLocal = (ecefPosition - renderCamera.GetEcefLocation()).ToSingle();
                Eegeo::v3 cameraSurfaceNormal = cameraLocal.Norm();
                
                Eegeo::v3 upNormal = ecefPosition.Norm().ToSingle();
                float dp = Eegeo::v3::Dot(cameraSurfaceNormal, upNormal);
                
                if(dp > 0.0f)
                {
                    pView.hidden = YES;
                    return;
                }
                else
                {
                    pView.hidden = NO;
                }
                
                Eegeo::v3 screenPos;
                renderCamera.Project(cameraLocal, screenPos);
                
                screenPos /= static_cast<float>([UIScreen mainScreen].scale);
                
                float newX = (screenPos.GetX() + pView.centerOffset.x);
                float newY = (screenPos.GetY() + pView.centerOffset.y);

                if([pView class] == [EGAnnotationView class])
                {
                    newX = roundf(newX);
                    newY = roundf(newY);
                }

                CGRect frame = pView.frame;
                frame.origin.x = newX;
                frame.origin.y = newY;
                pView.frame = frame;
            }
        }
        
        void AnnotationController::HandleTap(const Eegeo::v2& screenPoint)
        {
            Eegeo::Pins::PinController& pinController = m_pPinsModule->GetController();
            std::vector<Eegeo::Pins::Pin*> intersectingPinsClosestToCameraFirst;
            
            if(pinController.TryGetPinsIntersectingScreenPoint(screenPoint, intersectingPinsClosestToCameraFirst))
            {
                if(!intersectingPinsClosestToCameraFirst.empty())
                {
                    Eegeo::Pins::Pin& pin = *intersectingPinsClosestToCameraFirst.front();
                    id<EGAnnotation> annotationData = static_cast<id<EGAnnotation> >(pin.GetUserData());
                    SelectAnnotation(annotationData, true);
                    return;
                }
            }
            
            Eegeo::v2 scaledScreenPos = screenPoint / static_cast<float>([UIScreen mainScreen].scale);
            
            for(TModelMapIt modelIt = m_modelMap.begin();
                modelIt != m_modelMap.end();
                ++ modelIt)
            {
                id<EGAnnotation> annotation = modelIt->first;
                TViewMapIt viewIt(m_viewMap.find(annotation));
                Eegeo_ASSERT(viewIt != m_viewMap.end());
                EGAnnotationView* pView = viewIt->second;
                
                if(AnnotationViewContainsPoint(pView, scaledScreenPos))
                {
                    SelectAnnotation(annotation, true);
                    return;
                }
            }
            
            if(m_selectedAnnotation != nil)
            {
                DeselectAnnotation(m_selectedAnnotation, YES);
            }
        }
        
        bool AnnotationController::AnnotationViewContainsPoint(UIView* pView, const Eegeo::v2& screenPoint)
        {
            CGPoint locationInView = [pView convertPoint:CGPointMake(screenPoint.GetX(), screenPoint.GetY()) fromView:[pView superview]];
            CGRect viewBounds = pView.bounds;
           
            if(CGRectContainsPoint(viewBounds, locationInView))
            {
                return true;
            }
            
            for (UIView *subview in pView.subviews)
            {
                if(AnnotationViewContainsPoint(subview, screenPoint))
                {
                    return true;
                }
            }
            
            return false;
        }
    }
}

