//
//  SearchModuleFacade.h
//  ios-sdk
//
//  Created by Sam Ainsworth on 09/11/2017.
//  Copyright © 2017 eeGeo. All rights reserved.
//

#ifndef SearchModuleFacade_h
#define SearchModuleFacade_h

@protocol SearchModuleFacade <NSObject>

-(void)setDefaultSearchResultViewFactory(SearchResultViewFactory);
-(void)addSearchProvider(SearchProvider, bool);
-(void)addConsumer(SearchResultConsumer);

@end


#endif /* SearchModuleFacade_h */
