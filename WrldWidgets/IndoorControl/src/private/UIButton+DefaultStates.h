// Copyright eeGeo Ltd (2012-2015), All Rights Reserved

#pragma once

#import <UIKit/UIKit.h>

@interface UIButton (DefaultStates)

- (void)setDefaultStates;

- (void)setDefaultStatesWithImages:(UIImage*)normalImage
                                  :(UIImage*)highlightImage;

- (void)setDefaultStatesWithImageName:(NSString*)imageName fromBundle:(NSBundle*)bundle;

- (void)setDefaultStatesWithImageNames:(NSString*)normalImageName
                                      :(NSString*)highlightImageName
                            fromBundle:(NSBundle*)bundle;

@end
