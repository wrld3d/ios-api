#pragma once

#import <UIKit/UIKit.h>

@class WRLDSearchResult;

@interface WRLDSearchResultTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

-(void) populate : (WRLDSearchResult*) searchResult : (NSString*) queryString;
@end
