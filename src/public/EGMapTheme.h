// Copyright (c) 2015 eeGeo. All rights reserved.

#pragma once

#import <Foundation/Foundation.h>

/*!
 @enum EGMapThemeTime
 @brief Represents the statically defined collection of default times of day for the theme. These influence lighting and texture selection in the eeGeo 3D Map.
*/
typedef NS_ENUM(NSInteger, EGMapThemeTime) {
    EGMapThemeTimeDay,
    EGMapThemeTimeNight,
    EGMapThemeTimeDawn,
    EGMapThemeTimeDusk
};

/*!
 @enum EGMapThemeWeather
 @brief Represents the statically defined collection of default weather types for the theme. These influence lighting, effects, and texture selection in the eeGeo 3D Map.
 */
typedef NS_ENUM(NSInteger, EGMapThemeWeather) {
    EGMapThemeWeatherClear,
    EGMapThemeWeatherOvercast,
    EGMapThemeWeatherFoggy,
    EGMapThemeWeatherRainy,
    EGMapThemeWeatherSnow
};

/*!
 @enum EGMapThemeSeason
 @brief Represents the statically defined collection of default weather types for the theme. These influence lighting, and texture selection in the eeGeo 3D Map.
 */
typedef NS_ENUM(NSInteger, EGMapThemeSeason) {
    EGMapThemeSeasonSpring,
    EGMapThemeSeasonSummer,
    EGMapThemeSeasonAutumn,
    EGMapThemeSeasonWinter
};

/*!
 @class EGMapTheme
 @brief Responsible for controlling the visual presentation of the environment in the eeGeo 3D Map.
 */
@interface EGMapTheme : NSObject

/*!
 @method init
 @brief Initializes and returns a EGMapTheme instance with default configuration.
 @return The initialized theme, or nil if there was a problem initializing the object.
 */
- (instancetype)init;

/*!
 @method initWithSeason
 @brief Initializes and returns a EGMapTheme instance with a configuration that uses predefined theme state values.
 @param season The EGMapThemeSeason state to display.
 @param time The EGMapThemeTime state to display.
 @param weather The EGMapThemeWeather state to display.
 @return The initialized annotation view or nil if there was a problem initializing the object.
 */
- (instancetype)initWithSeason:(EGMapThemeSeason)season
                       andTime:(EGMapThemeTime)time
                    andWeather:(EGMapThemeWeather)weather;

/*!
 @method initWithSeason
 @brief Initializes and returns a EGMapTheme instance with a configuration that uses a predefined theme season value, with a dynamic state within the theme.
 @param season The EGMapThemeSeason state to display.
 @param themeStateName A string that identifies the theme state.
 @return The initialized theme, or nil if there was a problem initializing the object.
 */
- (instancetype)initWithSeason:(EGMapThemeSeason)season
             andThemeStateName:(NSString*)themeStateName;

/*!
 @method initWithThemeName
 @brief Initializes and returns a EGMapTheme instance with a configuration a dynamic theme.
 @param themeName A string that identifies the theme.
 @param themeStateName A string that identifies the theme state.
 @return The initialized theme, or nil if there was a problem initializing the object.
 */
- (instancetype)initWithThemeName:(NSString*)themeName
                andThemeStateName:(NSString*)themeStateName;

/*!
 @property themeName
 @brief The string that contains the current theme name.
 */
@property (readonly, copy) NSString* themeName;

/*!
 @property themeStateName
 @brief The string that contain the current state within the current theme.
 */
@property (readonly, copy) NSString* themeStateName;

/*!
 @property enableThemeByLocation
 @brief YES if the current theme responds to the current location of the camera in the eeGeo 3D Map, else NO.
 */
@property (readonly) BOOL enableThemeByLocation;

@end
