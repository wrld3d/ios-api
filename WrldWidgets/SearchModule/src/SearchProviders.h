#pragma once

#import <UIKit/UIKit.h>
@class WRLDSearchResultSet;
@class WRLDSearchQuery;

@protocol WRLDSearchProvider;

@interface SearchProviders : NSObject
-(void) addSearchProvider :(id<WRLDSearchProvider>) searchProvider;
-(NSString *) getCellIdentifierForSetAtIndex:(NSInteger) index;
-(CGFloat) getCellExpectedHeightForSetAtIndex:(NSInteger) index;

-(NSInteger) count;
-(NSInteger) getIndexOfProvider: (id<WRLDSearchProvider>) provider;

-(void) doSearch :(WRLDSearchQuery*) query;
-(void) doSuggestions :(WRLDSearchQuery*) query;

@end
