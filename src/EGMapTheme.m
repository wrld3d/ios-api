#import "EGMapTheme.h"

@implementation EGMapTheme
{

}

- (NSString*)timeToString:(EGMapThemeTime)time
{
    switch(time)
    {
        case EGMapThemeTimeDay:
            return @"Day";
        case EGMapThemeTimeNight:
            return @"Night";
        case EGMapThemeTimeDawn:
            return @"Dawn";
        case EGMapThemeTimeDusk:
            return @"Dusk";
        default:
            [NSException raise:NSGenericException format:@"Unexpected time"];
    }
}

- (NSString*)weatherToString:(EGMapThemeWeather)weather
{
     switch(weather)
     {
         case EGMapThemeWeatherClear:
             return @"Default";
         case EGMapThemeWeatherOvercast:
             return @"Overcast";
         case EGMapThemeWeatherFoggy:
             return @"Foggy";
         case EGMapThemeWeatherRainy:
             return @"Rainy";
         case EGMapThemeWeatherSnow:
             return @"Snow";
         default:
             [NSException raise:NSGenericException format:@"Unexpected weather"];
     }
}

- (NSString*)seasonToString:(EGMapThemeSeason)season
{
    switch(season)
    {
        case EGMapThemeSeasonSpring:
            return @"Spring";
        case EGMapThemeSeasonSummer:
            return @"Summer";
        case EGMapThemeSeasonAutumn:
            return @"Autumn";
        case EGMapThemeSeasonWinter:
            return @"Winter";
        default:
            [NSException raise:NSGenericException format:@"Unexpected season"];
    }
}

- (instancetype)init
{
    return [self initWithSeason: EGMapThemeSeasonSummer andTime: EGMapThemeTimeDay andWeather: EGMapThemeWeatherClear];
}

- (instancetype)initWithSeason:(EGMapThemeSeason)season andTime:(EGMapThemeTime)time andWeather:(EGMapThemeWeather)weather
{
    if (self = [super init])
    {
        _themeName = [self seasonToString: season];
        NSString* themeStateName = [NSString stringWithFormat:@"%@%@", [self timeToString:time], [self weatherToString:weather]];
        _themeStateName = themeStateName;
        _enableThemeByLocation = true;
        return self;
    }

    return nil;
}

- (instancetype)initWithSeason:(EGMapThemeSeason)season andThemeStateName:(NSString*)themeStateName
{
    if (self = [super init])
    {
        _themeName = [self seasonToString: season];
        _themeStateName = themeStateName;
        _enableThemeByLocation = true;
        return self;
    }

    return nil;
}

- (instancetype)initWithThemeName:(NSString*)themeName andThemeStateName:(NSString*)themeStateName
{
    if (self = [super init])
    {
        _themeName = themeName;
        _themeStateName = themeStateName;
        _enableThemeByLocation = false;
        return self;
    }

    return nil;
}

@end