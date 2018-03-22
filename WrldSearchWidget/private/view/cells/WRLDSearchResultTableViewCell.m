#import <Foundation/Foundation.h>
#import "WRLDSearchResultTableViewCell.h"
#import "WRLDSearchResultModel.h"
#import "WRLDSearchQuery.h"
#import "WRLDSearchWidgetStyle.h"
#import "WRLDAsyncImageLoadResponse.h"
#import "WRLDUrlImageLoader.h"
#import "WRLDLabelTextHighlighter.h"

@implementation WRLDSearchResultTableViewCell
{
    UIView *m_selectedBackgroundView;
    
    WRLDAsyncImageLoadResponse * m_imageLoadResponse;
}

- (void) populateWith: (id<WRLDSearchResultModel>) searchResult fromQuery: (WRLDSearchQuery *) query
{
    [WRLDLabelTextHighlighter applyAttributedTextTo:self.titleLabel
                                               fullText: searchResult.title
                                  regularAttributes: self.titleLabelRegularAttrs
                                           boldText: query.queryString
                                     boldAttributes: self.titleLabelBoldAttrs];
    
    [WRLDLabelTextHighlighter applyAttributedTextTo:self.descriptionLabel
                                               fullText: searchResult.subTitle
                                  regularAttributes: self.descriptionLabelRegularAttrs
                                           boldText: query.queryString
                                     boldAttributes: self.descriptionLabelBoldAttrs];
    
    WRLDUrlImageLoader* urlImageLoader = [[WRLDUrlImageLoader alloc] init];
    m_imageLoadResponse = [urlImageLoader assignImageFromUrlString:searchResult.iconKey assignmentCallback:^(UIImage * image) {
        if(self.iconImageView != nil)
        {
            self.iconImageView.image = image;
            m_imageLoadResponse = nil;
        }
    } cancellationCallback:^{
        m_imageLoadResponse = nil;
    }];
}

- (void) prepareForReuse
{
    [super prepareForReuse];
    if(m_imageLoadResponse)
    {
        [m_imageLoadResponse cancel];
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

- (void)awakeFromNib
{
    [super awakeFromNib];
    if(self.titleLabel)
    {
        UIFont * titleLabelFont = [self.titleLabel font];
        UIFont *titleLabelBoldFont = [UIFont fontWithDescriptor:[[titleLabelFont fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:titleLabelFont.pointSize];
        self.titleLabelRegularAttrs = @{NSFontAttributeName:titleLabelFont};
        self.titleLabelBoldAttrs = @{NSFontAttributeName:titleLabelBoldFont};
    }
    else{
        self.titleLabelRegularAttrs = [[NSDictionary alloc] init];
        self.titleLabelBoldAttrs = [[NSDictionary alloc] init];
    }
    
    if(self.descriptionLabel)
    {
        UIFont * descriptionLabelFont = [self.descriptionLabel font];
        UIFont *descriptionLabelBoldFont = [UIFont fontWithDescriptor:[[descriptionLabelFont fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:descriptionLabelFont.pointSize];
        self.descriptionLabelRegularAttrs = @{NSFontAttributeName:descriptionLabelFont};
        self.descriptionLabelBoldAttrs = @{NSFontAttributeName:descriptionLabelBoldFont};
    }
    else{
        self.descriptionLabelRegularAttrs = [[NSDictionary alloc] init];
        self.descriptionLabelBoldAttrs = [[NSDictionary alloc] init];
    }
    
    m_selectedBackgroundView = [[UIView alloc] init];
    [self setSelectedBackgroundView: m_selectedBackgroundView];
}

@end
