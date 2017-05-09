#pragma once

@protocol WRLDIndoorMapDelegate <NSObject>

@optional

- (void) didEnterIndoorMap;
- (void) didExitIndoorMap;

@end
