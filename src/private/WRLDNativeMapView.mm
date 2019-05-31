#import "WRLDNativeMapView.h"
#import "WRLDMapView+Private.h"

#include "EegeoMapApi.h"
#include "EegeoMarkersApi.h"
#include "EegeoIndoorsApi.h"
#include "EegeoApiHostModule.h"
#include "EegeoPoiApi.h"
#include "EegeoMapsceneApi.h"
#include "EegeoRoutingApi.h"
#include "EegeoPrecacheApi.h"
#include "iOSApiRunner.h"



WRLDNativeMapView::WRLDNativeMapView(WRLDMapView* mapView, Eegeo::ApiHost::iOS::iOSApiRunner& apiRunner)
: m_mapView(mapView)
, m_apiRunner(apiRunner)
, m_cameraHandler(this, &WRLDNativeMapView::OnCameraChange)
, m_initialStreamingCompleteHandler(this, &WRLDNativeMapView::OnInitialStreamingComplete)
, m_markerTappedHandler(this, &WRLDNativeMapView::OnMarkerTapped)
, m_positionersProjectionChangedHandler(this, &WRLDNativeMapView::OnPositionerProjectionChanged)
, m_enteredIndoorMapHandler(this, &WRLDNativeMapView::OnEnteredIndoorMap)
, m_exitedIndoorMapHandler(this, &WRLDNativeMapView::OnExitedIndoorMap)
, m_enterIndoorMapFailedHandler(this, &WRLDNativeMapView::OnEnterIndoorMapFailed)
, m_indoorEntryMarkerAddedHandler(this, &WRLDNativeMapView::OnIndoorEntryMarkerAdded)
, m_indoorEntryMarkerRemovedHandler(this, &WRLDNativeMapView::OnIndoorEntryMarkerRemoved)
, m_poiSearchCompletedHandler(this, &WRLDNativeMapView::OnPoiSearchCompleted)
, m_mapsceneCompletedHandler(this, &WRLDNativeMapView::OnMapsceneLoadCompleted)
, m_routingQueryCompletedHandler(this, &WRLDNativeMapView::OnRoutingQueryCompleted)
, m_buildingInformationReceivedHandler(this, &WRLDNativeMapView::OnBuildingInformationReceived)
, m_indoorEntityPickedHandler(this, &WRLDNativeMapView::OnIndoorEntityPicked)
, m_precacheCompletedHandler(this, &WRLDNativeMapView::OnPrecacheOperationCompleted)
, m_precacheCancelledHandler(this, &WRLDNativeMapView::OnPrecacheOperationCancelled)
, m_indoorMapEntityInformationChangedHandler(this, &WRLDNativeMapView::OnIndoorMapEntityInformationChanged)
{
    Eegeo::Api::EegeoMapApi& mapApi = GetMapApi();
    
    mapApi.GetCameraApi().RegisterEventCallback(m_cameraHandler);
    mapApi.RegisterInitialStreamingCompleteCallback(m_initialStreamingCompleteHandler);
    mapApi.GetMarkersApi().RegisterMarkerPickedCallback(m_markerTappedHandler);
    mapApi.GetPositionerApi().RegisterProjectionChangedCallback(m_positionersProjectionChangedHandler);
    mapApi.GetIndoorsApi().RegisterIndoorMapEnteredCallback(m_enteredIndoorMapHandler);
    mapApi.GetIndoorsApi().RegisterIndoorMapExitedCallback(m_exitedIndoorMapHandler);
    mapApi.GetIndoorsApi().RegisterIndoorMapEnterFailedCallback(m_enterIndoorMapFailedHandler);
    mapApi.GetIndoorsApi().RegisterIndoorMapEntryMarkerAddedCallback(m_indoorEntryMarkerAddedHandler);
    mapApi.GetIndoorsApi().RegisterIndoorMapEntryMarkerRemovedCallback(m_indoorEntryMarkerRemovedHandler);
    mapApi.GetPoiApi().RegisterSearchCompletedCallback(m_poiSearchCompletedHandler);
    mapApi.GetMapsceneApi().RegisterMapsceneRequestCompletedCallback(m_mapsceneCompletedHandler);
    mapApi.GetRoutingApi().RegisterQueryCompletedCallback(m_routingQueryCompletedHandler);
    mapApi.GetBuildingsApi().RegisterBuildingInformationReceivedCallback(m_buildingInformationReceivedHandler);
    mapApi.GetIndoorEntityApi().RegisterIndoorEntityPickedCallback(m_indoorEntityPickedHandler);
    mapApi.GetPrecacheApi().RegisterPrecacheOperationCompletedCallback(m_precacheCompletedHandler);
    mapApi.GetPrecacheApi().RegisterPrecacheOperationCancelledCallback(m_precacheCancelledHandler);
    mapApi.GetIndoorEntityInformationApi().RegisterIndoorMapInformationChangedCallback(m_indoorMapEntityInformationChangedHandler);
}

WRLDNativeMapView::~WRLDNativeMapView()
{
    Eegeo::Api::EegeoMapApi& mapApi = GetMapApi();

    mapApi.GetIndoorEntityInformationApi().UnregisterIndoorMapInformationChangedCallback(m_indoorMapEntityInformationChangedHandler);
    mapApi.GetPrecacheApi().UnregisterPrecacheOperationCancelledCallback(m_precacheCancelledHandler);
    mapApi.GetPrecacheApi().UnregisterPrecacheOperationCompletedCallback(m_precacheCompletedHandler);
    mapApi.GetIndoorEntityApi().UnregisterIndoorEntityPickedCallback(m_indoorEntityPickedHandler);
    mapApi.GetBuildingsApi().UnregisterBuildingInformationReceivedCallback(m_buildingInformationReceivedHandler);
    mapApi.GetRoutingApi().UnregisterQueryCompletedCallback(m_routingQueryCompletedHandler);
    mapApi.GetPoiApi().UnregisterSearchCompletedCallback(m_poiSearchCompletedHandler);
    mapApi.GetIndoorsApi().UnregisterIndoorMapEntryMarkerRemovedCallback(m_indoorEntryMarkerRemovedHandler);
    mapApi.GetIndoorsApi().UnregisterIndoorMapEntryMarkerAddedCallback(m_indoorEntryMarkerAddedHandler);
    mapApi.GetIndoorsApi().UnregisterIndoorMapEnterFailedCallback(m_enterIndoorMapFailedHandler);
    mapApi.GetIndoorsApi().UnregisterIndoorMapExitedCallback(m_exitedIndoorMapHandler);
    mapApi.GetIndoorsApi().UnregisterIndoorMapEnteredCallback(m_enteredIndoorMapHandler);
    mapApi.GetPositionerApi().UnregisterProjectionChangedCallback(m_positionersProjectionChangedHandler);
    mapApi.GetMarkersApi().UnregisterMarkerPickedCallback(m_markerTappedHandler);
    mapApi.UnregisterInitialStreamingCompleteCallback(m_initialStreamingCompleteHandler);
    mapApi.GetCameraApi().UnregisterEventCallback(m_cameraHandler);
}

void WRLDNativeMapView::OnCameraChange(const Eegeo::Api::CameraEventType& type)
{
    switch (type)
    {
        case Eegeo::Api::CameraEventType::MoveStart:
        {
            [m_mapView notifyMapViewRegionWillChange];
            break;
        }
        
        case Eegeo::Api::CameraEventType::Move:
        {
            [m_mapView notifyMapViewRegionIsChanging];
            break;
        }
        
        case Eegeo::Api::CameraEventType::MoveEnd:
        {
            [m_mapView notifyMapViewRegionDidChange];
            break;
        }
        
        default:
            break;
    }
}

void WRLDNativeMapView::OnInitialStreamingComplete()
{
    [m_mapView notifyInitialStreamingCompleted];
}

void WRLDNativeMapView::OnMarkerTapped(const Eegeo::Markers::IMarker& marker)
{
    [m_mapView notifyMarkerTapped:marker.GetId()];
}

void WRLDNativeMapView::OnPositionerProjectionChanged()
{
    [m_mapView notifyPositionerProjectionChanged];
}

void WRLDNativeMapView::OnEnteredIndoorMap()
{
    [m_mapView notifyEnteredIndoorMap];
}

void WRLDNativeMapView::OnExitedIndoorMap()
{
    [m_mapView notifyExitedIndoorMap];
}

void WRLDNativeMapView::OnEnterIndoorMapFailed(const std::string& interiorId)
{
    [m_mapView notifyEnterIndoorMapFailed:interiorId];
}

void WRLDNativeMapView::OnIndoorEntryMarkerAdded(const Eegeo::Api::IndoorMapEntryMarkerMessage& indoorMapEntryMarkerMessage)
{
    [m_mapView notifyIndoorEntryMarkerAdded:indoorMapEntryMarkerMessage];
}

void WRLDNativeMapView::OnIndoorEntryMarkerRemoved(const Eegeo::Api::IndoorMapEntryMarkerMessage& indoorMapEntryMarkerMessage)
{
    [m_mapView notifyIndoorEntryMarkerRemoved:indoorMapEntryMarkerMessage];
}

void WRLDNativeMapView::OnPoiSearchCompleted(const Eegeo::PoiSearch::PoiSearchResults& poiSearchResults)
{
    [m_mapView notifyPoiSearchCompleted:poiSearchResults];
}

void WRLDNativeMapView::OnMapsceneLoadCompleted(const Eegeo::Mapscenes::MapsceneRequestResponse& mapsceneResponse)
{
    [m_mapView notifyMapsceneCompleted:mapsceneResponse];
}

void WRLDNativeMapView::OnRoutingQueryCompleted(const Eegeo::Routes::Webservice::RoutingQueryResponse& routingQueryResponse)
{
    [m_mapView notifyRoutingQueryCompleted:routingQueryResponse];
}

void WRLDNativeMapView::OnBuildingInformationReceived(const Eegeo::BuildingHighlights::BuildingHighlightId& buildingHighlightId)
{
    [m_mapView notifyBuildingInformationReceived:buildingHighlightId];
}

void WRLDNativeMapView::OnIndoorEntityPicked(const Eegeo::Api::IndoorEntityPickedMessage& indoorEntityPickedMessage)
{
    [m_mapView notifyIndoorEntityTapped:indoorEntityPickedMessage];
}

void WRLDNativeMapView::OnPrecacheOperationCompleted(const Eegeo::Api::EegeoPrecacheApi::TPrecacheOperationIdType& operationId)
{
    [m_mapView notifyPrecacheOperationCompleted:operationId];
}

void WRLDNativeMapView::OnPrecacheOperationCancelled(const Eegeo::Api::EegeoPrecacheApi::TPrecacheOperationIdType& operationId)
{
    [m_mapView notifyPrecacheOperationCancelled:operationId];
}

void WRLDNativeMapView::OnIndoorMapEntityInformationChanged(const Eegeo::Api::IndoorMapEntityInformationMessage& message)
{
    [m_mapView notifyIndoorMapEntityInformationChanged:message];
}

Eegeo::Api::EegeoMapApi& WRLDNativeMapView::GetMapApi()
{
    return m_apiRunner.GetEegeoApiHostModule()->GetEegeoMapApi();
}

