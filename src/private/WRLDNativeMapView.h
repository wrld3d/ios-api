#pragma once

#import "WRLDMapView.h"

#include "Types.h"
#include "EegeoApiHostDeclarations.h"
#include "EegeoApi.h"
#include "ICallback.h"
#include "IMarker.h"

class WRLDNativeMapView : private Eegeo::NonCopyable
{
public:
    WRLDNativeMapView(WRLDMapView* mapView, Eegeo::ApiHost::iOS::iOSApiRunner& apiRunner);
    
    virtual ~WRLDNativeMapView();
    
private:
    
    void OnInitialStreamingComplete();
    void OnMarkerTapped(const Eegeo::Markers::IMarker& marker);
    
    Eegeo::Api::EegeoMapApi& GetMapApi();
    
    __weak WRLDMapView* m_mapView;
    Eegeo::ApiHost::iOS::iOSApiRunner& m_apiRunner;
    
    Eegeo::Helpers::TCallback0<WRLDNativeMapView> m_initialStreamingCompleteHandler;
    
    Eegeo::Helpers::TCallback1<WRLDNativeMapView, const Eegeo::Markers::IMarker> m_markerTappedHandler;
};


