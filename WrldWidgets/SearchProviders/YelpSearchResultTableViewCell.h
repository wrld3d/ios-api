#pragma once

#import <UIKit/UIKit.h>
#import "WRLDSearchResultTableViewCell.h"

@interface YelpSearchResultTableViewCell : WRLDSearchResultTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIImageView *rating;
@end

