#pragma once

#import <UIKit/UIKit.h>

@protocol WRLDSearchRequestFulfillerHandle
@property (readonly) NSInteger identifier;
@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic, readonly) NSString* cellIdentifier;
@property (nonatomic, readonly) NSString* moreResultsName;
@end

