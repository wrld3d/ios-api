#pragma once

/*!
 Represents a mode of transport for a WRLDRoute. This is currently a placeholder,
 but more modes of transport may be added in future versions of the API.
 */
typedef NS_ENUM(NSInteger, WRLDRouteTransportationMode)
{
    /// Indicates that the route is a walking Route.
    WRLDWalking,
    /// Indicates that the route is a driving Route.
    WRLDDriving
};
