//
//  SearchResultViewFactory.h
//  ios-sdk
//
//  Created by Sam Ainsworth on 10/11/2017.
//  Copyright © 2017 eeGeo. All rights reserved.
//

#ifndef SearchResultViewFactory_h
#define SearchResultViewFactory_h

#import <UIKit/UIKit.h>

@protocol SearchResultViewFactory <NSObject>

UIView makeSearchResultView();
SearchResultViewHolder makeSearchResultViewHolder();

@end

#endif /* SearchResultViewFactory_h */
