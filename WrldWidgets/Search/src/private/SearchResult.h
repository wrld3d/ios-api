//
//  SearchResult.h
//  ios-sdk
//
//  Created by Sam Ainsworth on 10/11/2017.
//  Copyright © 2017 eeGeo. All rights reserved.
//

#ifndef SearchResult_h
#define SearchResult_h

@protocol SearchResult <NSObject>

-(NSString)getTitle();
-(SearchResultProperty)getSearchProperty(NSString);

@end

#endif /* SearchResult_h */
