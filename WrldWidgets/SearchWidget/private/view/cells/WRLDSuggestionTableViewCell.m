#import <Foundation/Foundation.h>
#import "WRLDSuggestionTableViewCell.h"

@implementation WRLDSuggestionTableViewCell
{
    NSDictionary *m_labelRegularAttrs;
    NSDictionary *m_labelBoldAttrs;
}

-(void) setTitleLabelText : (NSString*) fullString : (NSString*) bolded
{
    const NSRange boldRange = [[fullString lowercaseString] rangeOfString:[bolded lowercaseString]];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:fullString attributes:m_labelRegularAttrs];
    [attributedText setAttributes:m_labelBoldAttrs range:boldRange];
    
    [self.titleLabel setAttributedText: attributedText];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    UIFont * labelFont = [self.titleLabel font];
    UIFont *boldLabelFont = [UIFont fontWithDescriptor:[[labelFont fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:labelFont.pointSize];
    m_labelRegularAttrs = @{NSFontAttributeName:labelFont};
    m_labelBoldAttrs = @{NSFontAttributeName:boldLabelFont};
}

@end
