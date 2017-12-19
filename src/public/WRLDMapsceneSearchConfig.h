#pragma once
#import <Foundation/Foundation.h>

@class WRLDMapsceneSearchMenuItem;

/**
 * The optional configuration to apply to the WRLD Searchbox Widget for a given Mapscene.
 */
@interface WRLDMapsceneSearchConfig:NSObject

/**
 * The list of custom Searches defined in the Searchbox Widget's Find menu when viewing the
 * outdoor map.
 */
@property (nonatomic, readonly) NSArray <WRLDMapsceneSearchMenuItem *>* outdoorSearchMenuItems;

/**
 * Optional flag to specify an initial search to perform when Mapscene is loaded.
 */
@property (nonatomic, readonly) bool performStartupSearch;

/**
 * Optional search term to execute if the 'performStartupSearch' option is set.
 */
@property (nonatomic, readonly) NSString* startupSearchTerm;

/**
 * Option to use the outdoorSearchMenuItems configuration even in Indoor Maps that have their
 * own set of defined Search Menu items.
 */
@property (nonatomic, readonly) bool overrideIndoorSearchMenu;

@end

