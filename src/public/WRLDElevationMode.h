#pragma once

/// Indicates how an elevation property of WRLDOverlay is interpreted.
typedef NS_ENUM(NSInteger, WRLDElevationMode)
{
    /// The elevation property is interpreted as an absolute altitude above mean sea level, in meters.
    WRLDElevationModeHeightAboveSeaLevel,
    
    /// The elevation property is interpreted as a height relative to the map's terrain, in meters.
    WRLDElevationModeHeightAboveGround
};
