#pragma once

@class WRLDPositioner;
/*!
 This protocol defines an interface for receiving messages when a Positioner has changed screen-space position.
 */
@protocol WRLDPositionerDelegate <NSObject>

@optional

/// Called when a WRLDPositioner object has changed.
- (void) onPositionerChanged: (WRLDPositioner*)positioner;

@end

