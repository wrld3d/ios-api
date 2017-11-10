//
//  SearchResultSet.h
//  ios-sdk
//
//  Created by Sam Ainsworth on 10/11/2017.
//  Copyright © 2017 eeGeo. All rights reserved.
//

#ifndef SearchResultSet_h
#define SearchResultSet_h

@protocol SearchResultSet <NSObject>

-(SearchResult[])sortOn(NSString propertyKey);
-(SearchResult[])getAllResults();
-(SearchResult)getResult(int);

-(int)getResultCount();

-(void)addResult(SearchResult);
-(void)removeResult(SearchResult);
-(void)removeResult(int);
-(void)clear();

-(void)addOnResultChangedHandler(OnResultChanged);

@protocol OnResultChanged{
    -(void)invoke();
}


@end

#endif /* SearchResultSet_h */
