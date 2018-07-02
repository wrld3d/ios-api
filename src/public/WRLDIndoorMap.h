#pragma once

#import <Foundation/Foundation.h>


/// An object containing information about a floor of an indoor map.
@interface WRLDIndoorMapFloor: NSObject

/// A short string identifier for a floor, unique within its indoor map. For example, "G".
@property (readonly) NSString* floorId;

/// The human-readable name of the floor. For example, "Ground Floor".
@property (readonly) NSString* name;

/// The index of this floor relative to the bottom floor of its indoor map.
@property (readonly) NSInteger floorIndex;

/// The floor number of this floor. For example, 1.
@property (readonly) NSInteger floorNumber;

@end


/// An object containing information about an indoor map.
@interface WRLDIndoorMap: NSObject

/// A string representing a unique ID for this indoor map
@property (readonly) NSString* indoorId;

/// The human-readable name of this indoor map.
@property (readonly) NSString* name;

/// An array of WRLDIndoorMapFloor objects, corresponding to the floors of this indoor map.
@property (readonly) NSArray<WRLDIndoorMapFloor*>* floors;

/// Optional additional JSON data associated with this indoor map.
@property (readonly) NSString* userData;

@end
