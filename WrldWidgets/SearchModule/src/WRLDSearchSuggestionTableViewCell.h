#pragma once

#import <UIKit/UIKit.h>

@interface WRLDSearchSuggestionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
-(void) setTitleLabelText : (NSString*) fullString : (NSString*) bolded;
@end
