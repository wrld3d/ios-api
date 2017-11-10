//
//  SearchResultProperty.h
//  ios-sdk
//
//  Created by Sam Ainsworth on 10/11/2017.
//  Copyright © 2017 eeGeo. All rights reserved.
//

#ifndef SearchResultProperty_h
#define SearchResultProperty_h

@interface SearchResultProperty : NSObject

@end

-(NSString)getKey();
-(T)getValue();
-(int)compareTo(SearchResultProperty<T>);

@end


#endif /* SearchResultProperty_h */
