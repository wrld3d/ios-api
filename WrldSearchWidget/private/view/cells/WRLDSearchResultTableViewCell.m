#import <Foundation/Foundation.h>
#import "WRLDSearchResultTableViewCell.h"
#import "WRLDSearchResultModel.h"
#import "WRLDSearchQuery.h"
#import "WRLDSearchWidgetStyle.h"

@implementation WRLDSearchResultTableViewCell
{
    NSDictionary *m_titleLabelRegularAttrs;
    NSDictionary *m_titleLabelBoldAttrs;
    NSDictionary *m_descriptionLabelRegularAttrs;
    NSDictionary *m_descriptionLabelBoldAttrs;
    
    UIView *m_selectedBackgroundView;
}

- (void) populateWith: (id<WRLDSearchResultModel>) searchResult fromQuery: (WRLDSearchQuery *) query
{
    if(self.titleLabel)
    {
        [self applyAttributedTextTo:self.titleLabel
                               text: searchResult.title
                           boldText: query.queryString
                  regularAttributes: m_titleLabelRegularAttrs
                     boldAttributes: m_titleLabelBoldAttrs];
    }
    
    if(self.descriptionLabel)
    {
        [self applyAttributedTextTo:self.descriptionLabel
                               text: searchResult.subTitle
                           boldText: query.queryString
                  regularAttributes: m_descriptionLabelRegularAttrs
                     boldAttributes: m_descriptionLabelBoldAttrs];
    }
}

- (void) applyStyle: (WRLDSearchWidgetStyle *) style
{
    self.backgroundColor = [style colorForStyle: WRLDSearchWidgetStylePrimaryColor];
    
    if(self.titleLabel)
    {
        self.titleLabel.textColor = [style colorForStyle: WRLDSearchWidgetStyleTextPrimaryColor];
    }
    
    if(self.descriptionLabel)
    {
        self.descriptionLabel.textColor = [style colorForStyle: WRLDSearchWidgetStyleTextSecondaryColor];
    }
    
    m_selectedBackgroundView.backgroundColor = [style colorForStyle: WRLDSearchWidgetStyleResultSelectedColor];
}

- (void) applyAttributedTextTo :(UILabel*) label text:(NSString*) text boldText:(NSString*) boldText regularAttributes:(NSDictionary *) regularAttributes boldAttributes:(NSDictionary*) boldAttributes
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

- (void)awakeFromNib
{
    [super awakeFromNib];
    if(self.titleLabel)
    {
        UIFont * titleLabelFont = [self.titleLabel font];
        UIFont *titleLabelBoldFont = [UIFont fontWithDescriptor:[[titleLabelFont fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:titleLabelFont.pointSize];
        m_titleLabelRegularAttrs = @{NSFontAttributeName:titleLabelFont};
        m_titleLabelBoldAttrs = @{NSFontAttributeName:titleLabelBoldFont};
    }
    
    if(self.descriptionLabel)
    {
        UIFont * descriptionLabelFont = [self.descriptionLabel font];
        UIFont *descriptionLabelBoldFont = [UIFont fontWithDescriptor:[[descriptionLabelFont fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:descriptionLabelFont.pointSize];
        m_descriptionLabelRegularAttrs = @{NSFontAttributeName:descriptionLabelFont};
        m_descriptionLabelBoldAttrs = @{NSFontAttributeName:descriptionLabelBoldFont};
    }
    
    m_selectedBackgroundView = [[UIView alloc] init];
    [self setSelectedBackgroundView: m_selectedBackgroundView];
}

@end
