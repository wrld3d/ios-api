#pragma once

/// Represents the current streaming status of indoor map entities for an indoor map.
typedef NS_ENUM(NSInteger, WRLDIndoorMapEntityLoadState)
{
    /// The indoor map is not loaded.
    WRLDIndoorMapEntityLoadStateNone,
    
    /// Some map tiles for the indoor map are loaded.
    WRLDIndoorMapEntityLoadStatePartial,

    /// All map tiles for the indoor map are loaded.
    WRLDIndoorMapEntityLoadStateComplete
};