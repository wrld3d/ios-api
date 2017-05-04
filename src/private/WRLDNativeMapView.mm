#import <Foundation/Foundation.h>

#import "WRLDNativeMapView.h"
#import "WRLDMapView+Private.h"
#include "EegeoMapApi.h"
#include "EegeoApiHostModule.h"
#include "iOSApiRunner.h"



WRLDNativeMapView::WRLDNativeMapView(WRLDMapView* mapView, Eegeo::ApiHost::iOS::iOSApiRunner& apiRunner)
: m_mapView(mapView)
, m_apiRunner(apiRunner)
, m_initialStreamingCompleteHandler(this, &WRLDNativeMapView::OnInitialStreamingComplete)
{
    Eegeo::Api::EegeoMapApi& mapApi = GetMapApi();
    
    mapApi.RegisterInitialStreamingCompleteCallback(m_initialStreamingCompleteHandler);
}

WRLDNativeMapView::~WRLDNativeMapView()
{
    Eegeo::Api::EegeoMapApi& mapApi = GetMapApi();
    
    mapApi.UnregisterInitialStreamingCompleteCallback(m_initialStreamingCompleteHandler);
}


void WRLDNativeMapView::OnInitialStreamingComplete()
{
    [m_mapView notifyInitialStreamingCompleted];
}

Eegeo::Api::EegeoMapApi& WRLDNativeMapView::GetMapApi()
{
    return m_apiRunner.GetEegeoApiHostModule()->GetEegeoMapApi();
}

