#pragma once

/*!
 This protocol defines an interface for receiving messages when an indoor map is entered or exited.
 An object implementing this protocol must be set to the indoorMapDelegate property of a WRLDMapView to receive events.
 */
@protocol WRLDIndoorMapDelegate <NSObject>

@optional

/// A message sent when the user enters an indoor map.
- (void) didEnterIndoorMap;

/// A message sent when the user exits an indoor map.
- (void) didExitIndoorMap;

@end
