#pragma once

#import "WRLDMapView.h"

#include "Types.h"
#include "EegeoApiHostDeclarations.h"
#include "EegeoApi.h"
#include "ICallback.h"

class WRLDNativeMapView : private Eegeo::NonCopyable
{
public:
    WRLDNativeMapView(WRLDMapView* mapView, Eegeo::ApiHost::iOS::iOSApiRunner& apiRunner);
    
    virtual ~WRLDNativeMapView();
    
private:
    
    void OnInitialStreamingComplete();
    
    Eegeo::Api::EegeoMapApi& GetMapApi();
    
    __weak WRLDMapView* m_mapView;
    Eegeo::ApiHost::iOS::iOSApiRunner& m_apiRunner;
    
    Eegeo::Helpers::TCallback0<WRLDNativeMapView> m_initialStreamingCompleteHandler;
    
    
};


