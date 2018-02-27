#pragma once

#import <UIKit/UIKit.h>

@protocol WRLDSearchResultModel;
@class WRLDSearchQuery;

@interface WRLDSearchResultTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

- (void) populateWith: (id<WRLDSearchResultModel>) searchResult fromQuery: (WRLDSearchQuery *) query;

@end
