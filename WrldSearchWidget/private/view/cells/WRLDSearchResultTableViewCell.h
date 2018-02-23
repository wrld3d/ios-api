#pragma once

#import <UIKit/UIKit.h>

@protocol WRLDSearchResultModel;

@interface WRLDSearchResultTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

-(void) populateWith: (id<WRLDSearchResultModel>) searchResult highlighting : (NSString*) queryString;

@end
