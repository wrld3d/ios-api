#pragma once

#include "EegeoMapApi.h"
#include "PoiSearchResults.h"
#include "RoutingQueryResponse.h"
#include "PositioningTypes.h"
#include "MapsceneRequestResponse.h"
#include "EegeoIndoorEntityApi.h"
#include "EegeoIndoorEntityInformationApi.h"
#include "EegeoIndoorsApi.h"

NS_ASSUME_NONNULL_BEGIN

@interface WRLDMapView (Private)
    
- (void)notifyMapViewRegionWillChange;
    
- (void)notifyMapViewRegionIsChanging;
    
- (void)notifyMapViewRegionDidChange;

- (void)notifyInitialStreamingCompleted;

- (void)notifyTouchTapped:(CGPoint)point;

- (void)notifyMarkerTapped:(int)markerId;

- (void)notifyPositionerProjectionChanged;

- (void)notifyEnteredIndoorMap;

- (void)notifyExitedIndoorMap;

- (void)notifyEnterIndoorMapFailed:(const std::string&)interiorId;

- (void)notifyIndoorEntryMarkerAdded:(const Eegeo::Api::IndoorMapEntryMarkerMessage&)message;

- (void)notifyIndoorEntryMarkerRemoved:(const Eegeo::Api::IndoorMapEntryMarkerMessage&)message;

- (void)notifyPoiSearchCompleted:(const Eegeo::PoiSearch::PoiSearchResults&)result;

- (void)notifyMapsceneCompleted:(const Eegeo::Mapscenes::MapsceneRequestResponse&)result;

- (void)notifyRoutingQueryCompleted:(const Eegeo::Routes::Webservice::RoutingQueryResponse&)result;

- (void)notifyBuildingInformationReceived:(int)buildingHighlightId;

- (void)notifyIndoorEntityTapped:(const Eegeo::Api::IndoorEntityPickedMessage&)indoorEntityPickedMessage;

- (void)notifyPrecacheOperationCompleted:(int)operationId;

- (void)notifyPrecacheOperationCancelled:(int)operationId;

- (void)notifyIndoorMapEntityInformationChanged:(const Eegeo::Api::IndoorMapEntityInformationMessage&)message;

- (Eegeo::Api::EegeoMapApi&)getMapApi;

const Eegeo::Positioning::ElevationMode::Type ToPositioningElevationMode(WRLDElevationMode elevationMode);

@end

NS_ASSUME_NONNULL_END
