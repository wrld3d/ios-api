#pragma once

#import <Foundation/Foundation.h>

/**
 * The data for a custom search menu option.  Used to define custom search terms for Mapscenes.
 */
@interface WRLDMapsceneSearchMenuItem:NSObject

/**
 * The unique display name of this search option.
 */
@property (nonatomic, readonly) NSString* name;

/**
 * The WRLD Search Tag to query as part of this search option.
 */
@property (nonatomic, readonly) NSString* tag;

/**
 * The Icon key that specifies what icon to display for this search option.
 */
@property (nonatomic, readonly) NSString* iconKey;

/**
 * (Example App Only) Optional configuration for the search to skip external search services.
 */
@property (nonatomic, readonly) bool skipYelpSearch;

@end


