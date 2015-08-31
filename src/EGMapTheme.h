// Copyright (c) 2015 eeGeo. All rights reserved.

#pragma once

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, EGMapThemeTime) {
    EGMapThemeTimeDay,
    EGMapThemeTimeNight,
    EGMapThemeTimeDawn,
    EGMapThemeTimeDusk
};

typedef NS_ENUM(NSInteger, EGMapThemeWeather) {
    EGMapThemeWeatherClear,
    EGMapThemeWeatherOvercast,
    EGMapThemeWeatherFoggy,
    EGMapThemeWeatherRainy,
    EGMapThemeWeatherSnow
};

typedef NS_ENUM(NSInteger, EGMapThemeSeason) {
    EGMapThemeSeasonSpring,
    EGMapThemeSeasonSummer,
    EGMapThemeSeasonAutumn,
    EGMapThemeSeasonWinter
};

@interface EGMapTheme : NSObject
- (instancetype)init;

- (instancetype)initWithSeason:(EGMapThemeSeason)season
                       andTime:(EGMapThemeTime)time
                    andWeather:(EGMapThemeWeather)weather;

- (instancetype)initWithSeason:(EGMapThemeSeason)season andThemeStateName:(NSString*)themeStateName;

- (instancetype)initWithThemeName:(NSString*)themeName andThemeStateName:(NSString*)themeStateName;

@property (readonly, copy) NSString* themeName;
@property (readonly, copy) NSString* themeStateName;
@property (readonly) BOOL enableThemeByLocation;
@end