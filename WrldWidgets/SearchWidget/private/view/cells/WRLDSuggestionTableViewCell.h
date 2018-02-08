#pragma once

#import <UIKit/UIKit.h>

@interface WRLDSuggestionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
-(void) setTitleLabelText : (NSString*) fullString : (NSString*) bolded;
@end
