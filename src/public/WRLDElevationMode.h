#pragma once

/// The method of determining an altitude.
typedef NS_ENUM(NSInteger, WRLDElevationMode)
{
    /// An elevation should be relative to sea-level.
    WRLDElevationModeHeightAboveSeaLevel,
    
    /// An elevation should be relative to the ground directly below.
    WRLDElevationModeHeightAboveGround
};
