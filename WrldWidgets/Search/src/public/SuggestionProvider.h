//
//  SuggestionProvider.h
//  ios-sdk
//
//  Created by Sam Ainsworth on 10/11/2017.
//  Copyright © 2017 eeGeo. All rights reserved.
//

#ifndef SuggestionProvider_h
#define SuggestionProvider_h

#import "SearchProvider.h"

@protocol SuggestionProvider <SearchProvider>

-(void)getSuggestions(NSString);

-(void)addOnSuggestionsRecievedCallback(OnResultRecievedCallback);

-(void)setSuggestionViewFactory(SearchResultFactory);
-(SearchResultFactory)getSuggestionViewFactory();

@end

#endif /* SuggestionProvider_h */
