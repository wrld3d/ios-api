#import <Foundation/Foundation.h>
#import "WRLDSearchResultTableViewCell.h"
#import "WRLDSearchResult.h"

@implementation WRLDSearchResultTableViewCell
{
    NSDictionary *m_titleLabelRegularAttrs;
    NSDictionary *m_titleLabelBoldAttrs;
    NSDictionary *m_descriptionLabelRegularAttrs;
    NSDictionary *m_descriptionLabelBoldAttrs;
}

-(void) populate : (WRLDSearchResult*) searchResult : (NSString*) queryString
{
    [self applyAttributedTextTo:self.titleLabel
                            text:searchResult.title
                            boldText:queryString
                            regularAttributes:m_titleLabelRegularAttrs
                            boldAttributes:m_titleLabelBoldAttrs];
    
    [self applyAttributedTextTo:self.descriptionLabel
                           text:searchResult.subTitle
                       boldText:queryString
              regularAttributes:m_descriptionLabelRegularAttrs
                 boldAttributes:m_descriptionLabelBoldAttrs];
}

-(void) applyAttributedTextTo :(UILabel*) label text:(NSString*) text boldText:(NSString*) boldText regularAttributes:(NSDictionary *) regularAttributes boldAttributes:(NSDictionary*) boldAttributes
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:regularAttributes];
    NSRange remainingString = NSMakeRange(0, [text length]);
    NSRange boldRange = [text rangeOfString:boldText options:NSCaseInsensitiveSearch range:remainingString];
    
    while(boldRange.location != NSNotFound)
    {
        [attributedText setAttributes:boldAttributes range:boldRange];
        NSInteger endOfBoldText = boldRange.location + boldRange.length;
        remainingString = NSMakeRange(endOfBoldText, [text length] - endOfBoldText);
        boldRange = [text rangeOfString:boldText options:NSCaseInsensitiveSearch range:remainingString];
    }
    
    [label setAttributedText: attributedText];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    UIFont * titleLabelFont = [self.titleLabel font];
    UIFont *titleLabelBoldFont = [UIFont fontWithDescriptor:[[titleLabelFont fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:titleLabelFont.pointSize];
    m_titleLabelRegularAttrs = @{NSFontAttributeName:titleLabelFont};
    m_titleLabelBoldAttrs = @{NSFontAttributeName:titleLabelBoldFont};
    
    UIFont * descriptionLabelFont = [self.descriptionLabel font];
    UIFont *descriptionLabelBoldFont = [UIFont fontWithDescriptor:[[descriptionLabelFont fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:descriptionLabelFont.pointSize];
    m_descriptionLabelRegularAttrs = @{NSFontAttributeName:descriptionLabelFont};
    m_descriptionLabelBoldAttrs = @{NSFontAttributeName:descriptionLabelBoldFont};
}
@end
