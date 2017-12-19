#include "WRLDMapsceneServiceHelpers.h"

#import "WRLDMapsceneRequestResponse+Private.h"
#import "WRLDMapscene+Private.h"
#import "WRLDMapsceneStartLocation+Private.h"
#import "WRLDMapsceneDataSources+Private.h"
#import "WRLDMapsceneSearchConfig+Private.h"
#import "WRLDMapsceneSearchMenuItem+Private.h"

@interface WRLDMapsceneServiceHelpers ()

@end

@implementation WRLDMapsceneServiceHelpers
{

}

+ (WRLDMapsceneRequestResponse*)createWRLDMapsceneRequestResponse:(const Eegeo::Mapscenes::MapsceneRequestResponse&)withResponse
{
    if(withResponse.Success())
    {
        const Eegeo::Mapscenes::Mapscene& responseMapscene = withResponse.GetMapscene();
        
        WRLDMapscene* wrldMapscene = [self createWRLDMapscene:responseMapscene];
        
        WRLDMapsceneRequestResponse* mapsceneResponse = [[WRLDMapsceneRequestResponse alloc] initWithSucceeded:withResponse.Success() mapscene:wrldMapscene];
        
        return mapsceneResponse;
    }
    else
    {
        WRLDMapsceneRequestResponse* mapsceneResponse = [[WRLDMapsceneRequestResponse alloc] initWithSucceeded:withResponse.Success() mapscene:nil];
        
        return mapsceneResponse;
    }
}

+ (WRLDMapscene*) createWRLDMapscene:(const Eegeo::Mapscenes::Mapscene &)withMapscene
{
    WRLDMapsceneStartLocation* mapsceneStartLocation = [self createWRLDMapsceneStartLocation:withMapscene.startLocation];
    
    WRLDMapsceneDataSources* mapsceneDataSources = [self createWRLDMapsceneDataSources:withMapscene.dataSources];
    
    WRLDMapsceneSearchConfig* mapsceneSearchConfig = [self createWRLDMapsceneSearchConfig:withMapscene.searchConfig];
    
    WRLDMapscene* wrldMapscene = [[WRLDMapscene alloc]
                                  initWithName:[NSString stringWithCString: withMapscene.name.c_str() encoding:NSUTF8StringEncoding]
                                  shortLink:[NSString stringWithCString: withMapscene.shortlink.c_str() encoding:NSUTF8StringEncoding]
                                  apiKey:[NSString stringWithCString: withMapscene.apiKey.c_str() encoding:NSUTF8StringEncoding]
                                  startLocation:mapsceneStartLocation
                                  dataSources:mapsceneDataSources
                                  searchConfig:mapsceneSearchConfig];
    
    return wrldMapscene;
}

+ (WRLDMapsceneDataSources*)createWRLDMapsceneDataSources:(const Eegeo::Mapscenes::MapsceneDataSources&)withDataSources
{
    WRLDMapsceneDataSources* wrldMapsceneDataSources = [[WRLDMapsceneDataSources alloc]
                                                        initWithCovarageTreeManifestUrl:[NSString stringWithCString:withDataSources.coverageTreeManifestUrl.c_str() encoding:NSUTF8StringEncoding]
                                                        themeManifestUrl:[NSString stringWithCString: withDataSources.themeManifestUrl.c_str() encoding:NSUTF8StringEncoding]];
    return wrldMapsceneDataSources;
}

+ (WRLDMapsceneStartLocation*)createWRLDMapsceneStartLocation:(const Eegeo::Mapscenes::MapsceneStartLocation&)withStartLocation
{
    WRLDMapsceneStartLocation* mapsceneStartLocation = [[WRLDMapsceneStartLocation alloc]
                                                        initWithCoordinate:CLLocationCoordinate2DMake(withStartLocation.startLocation.GetLatitudeInDegrees(),   withStartLocation.startLocation.GetLongitudeInDegrees())
                                                        distance:withStartLocation.startLocationDistanceToInterest
                                                        interiorFloorIndex:withStartLocation.startLocationInteriorFloorIndex
                                                        interiorId:@(withStartLocation.startLocationInteriorId.Value().c_str())
                                                        heading:withStartLocation.startLocationHeading
                                                        tryStartAtGpsLocation:withStartLocation.tryStartAtGpsLocation];
    
    return mapsceneStartLocation;
}

+ (WRLDMapsceneSearchConfig*)createWRLDMapsceneSearchConfig:(const Eegeo::Mapscenes::MapsceneSearchConfig&)withSearchConfig
{
    NSMutableArray <WRLDMapsceneSearchMenuItem *>* wrldMapsceneSearchMenuItems = [[NSMutableArray<WRLDMapsceneSearchMenuItem *> alloc] initWithCapacity:(withSearchConfig.outdoorSearchMenuItems.size())];;
    for(auto& searchMenuItem : withSearchConfig.outdoorSearchMenuItems)
    {
        [wrldMapsceneSearchMenuItems addObject:[self createWRLDMapsceneSearchMenuItem:searchMenuItem]];
    }
    
    WRLDMapsceneSearchConfig* mapsceneSearchConfig = [[WRLDMapsceneSearchConfig alloc]
                                                      initWithOutdoorSeachMenuItems:wrldMapsceneSearchMenuItems
                                                      performStartupSearch:withSearchConfig.performStartUpSearch
                                                      startupSearchTerm:[NSString stringWithCString: withSearchConfig.startUpSearchTerm.c_str() encoding:NSUTF8StringEncoding]
                                                      overrideIndoorSearchMenu:withSearchConfig.overrideIndoorSearchMenu];
    
    return mapsceneSearchConfig;
}

+ (WRLDMapsceneSearchMenuItem*)createWRLDMapsceneSearchMenuItem:(const Eegeo::Mapscenes::MapsceneSearchMenuItem&)withSearchMenuItem
{
    return [[WRLDMapsceneSearchMenuItem alloc]
            initWithName:[NSString stringWithCString: withSearchMenuItem.name.c_str() encoding:NSUTF8StringEncoding]
            tag:[NSString stringWithCString: withSearchMenuItem.tag.c_str() encoding:NSUTF8StringEncoding]
            iconKey:[NSString stringWithCString: withSearchMenuItem.iconKey.c_str() encoding:NSUTF8StringEncoding]
            skipYelpSearch:withSearchMenuItem.skipYelpSearch];
}

@end
