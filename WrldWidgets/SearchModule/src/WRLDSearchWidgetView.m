#import <QuartzCore/QuartzCore.h>

#import "WRLDSearchWidgetView.h"
#import "WRLDSearchWidgetViewSubclass.h"
#import "WRLDSearchProvider.h"
#import "WRLDSearchQuery.h"
#import "SearchProviders.h"
#import "WRLDSearchResultTableViewController.h"
#import "WRLDSearchSuggestionsViewController.h"
#import "WRLDSearchResult.h"
#import "WRLDSearchResultSet.h"

@implementation WRLDSearchWidgetView
{
    SearchProviders* m_searchProviders;
    WRLDSearchResultTableViewController* m_searchResultsTableViewController;
    WRLDSearchSuggestionsViewController* m_searchSuggestionsTableViewController;
    bool m_byPassSuggestions;
    NSString* m_suggestionsText;
    CALayer *m_searchBarBorderObject;
    UIColor *m_searchBarActiveColor;
    UIImage * m_searchBarIcon;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self customInit];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self customInit];
    }
    
    return self;
}

-(void)customInit
{
    m_searchProviders = [[SearchProviders alloc] init];
    m_byPassSuggestions = false;
    m_suggestionsText = @"";
    if(@available(iOS 9.0, *))
    {
        [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setDefaultTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:16],}];
        //[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].leftView = nil;
    }
    else
    {
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:16],}];
        //[UITextField appearanceWhenContainedIn:[UISearchBar class], nil].leftView = nil;
    }
    
    NSBundle* widgetsBundle = [NSBundle bundleForClass:[WRLDSearchWidgetView class]];
    
    [widgetsBundle.self loadNibNamed:@"WRLDSearchWidgetView" owner:self options:nil];
    
    [self addSubview:self.wrldSearchWidgetRootView];
    self.wrldSearchWidgetRootView.frame = self.bounds;
    
    m_searchResultsTableViewController = [[WRLDSearchResultTableViewController alloc] init:
                                          self.wrldSearchWidgetResultsTableViewContainer :
                                          self.wrldSearchWidgetResultsTableView :
                                          m_searchProviders :
                                          ^(WRLDSearchResult* result) {
                                              [self setQueryTextWithoutSuggestions: result.title];
                                          }];
    
    [m_searchResultsTableViewController setHeightConstraint: self.resultsHeightConstraint
                                                  maxHeight: self.bounds.size.height - self.wrldSearchWidgetSearchBar.bounds.size.height];
    
    m_searchSuggestionsTableViewController = [[WRLDSearchSuggestionsViewController alloc] init :
                                              self.wrldSearchWidgetSuggestionsTableView :
                                              m_searchProviders :
                                               ^(NSString* queryText) {
                                                   [self setQueryTextWithoutSuggestions: queryText];
                                                   [self runSearch: queryText];
                                               }];
    
    
    [m_searchSuggestionsTableViewController setHeightConstraint: self.suggestionsHeightConstraint];
    
//    UIImage *imgClear = [UIImage imageNamed:@"Expander.png" inBundle: widgetsBundle compatibleWithTraitCollection:nil];
//    [_wrldSearchWidgetSearchBar setImage:imgClear forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    m_searchBarBorderObject = [self styleSearchBar];
    m_searchBarActiveColor = [UIColor colorWithRed:0.0f/255.0f green:113.0f/255.0f blue:158.0f/255.0f alpha:1.0f];
    [self setSearchBarBorderColor: [UIColor grayColor]];
}

-(CALayer *) styleSearchBar
{
    self.wrldSearchWidgetSearchBarContainerView.layer.borderWidth = 1.0;
    self.wrldSearchWidgetSearchBarContainerView.layer.cornerRadius = 10;
    [self.wrldSearchWidgetSearchBar setBackgroundImage:[UIImage imageWithCGImage:(__bridge CGImageRef)([UIColor clearColor])]];
    m_searchBarIcon = [self.wrldSearchWidgetSearchBar imageForSearchBarIcon:
                       UISearchBarIconSearch state: UIControlStateNormal];
    return self.wrldSearchWidgetSearchBarContainerView.layer;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if([self subviewContainsEvent: self.wrldSearchWidgetSearchBarContainerView point: point event: event]) return YES;
    if([self subviewContainsEvent: self.wrldSearchWidgetResultsTableViewContainer point: point event: event]) return YES;
    if([self subviewContainsEvent: self.wrldSearchWidgetSuggestionsTableView point: point event: event]) return YES;
    return NO;
}

-(BOOL) subviewContainsEvent: (UIView*) view
                       point: (CGPoint)point
                        event: (UIEvent*) event
{
    if (view.userInteractionEnabled && ![view  isHidden] && [view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
        return YES;
    }
    if([self.wrldSearchWidgetSearchBar isFirstResponder]){
        [self.wrldSearchWidgetSearchBar resignFirstResponder];
    }
    return NO;
}

-(void) setSearchBarBorderColor :(UIColor *) color
{
    m_searchBarBorderObject.borderColor = [color CGColor];
}

-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self setSearchBarBorderColor: m_searchBarActiveColor];
    
    [UIView animateWithDuration:0.25 animations:^{
        NSInteger iconWidth = 24;
        if(@available(iOS 11.0, *))
        {
            iconWidth += 6;
        }
        [searchBar setPositionAdjustment:UIOffsetMake(-iconWidth, 0) forSearchBarIcon:UISearchBarIconSearch];
    }];
}

-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self setSearchBarBorderColor: [UIColor grayColor]];
    
    [UIView animateWithDuration:0.25 animations:^{
        [searchBar setPositionAdjustment:UIOffsetMake(0, 0) forSearchBarIcon:UISearchBarIconSearch];
    }];
}

- (void)dictationRecordingDidEnd
{
    [self runSearch:[self.wrldSearchWidgetSearchBar text]];
}

-(void) addSearchProvider:(id<WRLDSearchProvider>)searchProvider
{
    [m_searchProviders addSearchProvider: searchProvider];
}

-(void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    NSString *trimmedString = [searchText stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    
    if([trimmedString isEqualToString:m_suggestionsText]){
        return;
    }
    
    m_suggestionsText = trimmedString;
    
    if(!m_byPassSuggestions)
    {
        [m_searchResultsTableViewController fadeOut];
        if([searchText length] > 0)
        {
            WRLDSearchQuery * newQuery = [[WRLDSearchQuery alloc] initWithQueryString: trimmedString : m_searchProviders];
            [m_searchSuggestionsTableViewController setCurrentQuery:newQuery];
            [m_searchProviders doSuggestions: newQuery];
        }
    }
    
    [self determineVoiceButtonVisibility];
}

-(void) setQueryTextWithoutSuggestions: (NSString *) text
{
    m_byPassSuggestions = true;
    [self.wrldSearchWidgetSearchBar setText:text];
    [self determineVoiceButtonVisibility];
    m_byPassSuggestions = false;
}

-(void) determineVoiceButtonVisibility
{
    if([[self.wrldSearchWidgetSearchBar text] length] > 0)
    {
        if(![self.wrldSearchWidgetSpeechButton isHidden]){
            [UIView animateWithDuration: 0.25 animations:^{
                [self.voiceButtonWidthConstraint setConstant:0];
            } completion:^(BOOL finished) {
                if(finished){
                    self.wrldSearchWidgetSpeechButton.hidden = YES;
                }
            }];
        }
    }
    else {
        [m_searchSuggestionsTableViewController fadeOut];
        if([self showVoiceButton] && self.voiceButtonWidthConstraint.constant < 32)
        {
            self.wrldSearchWidgetSpeechButton.hidden = NO;
            [UIView animateWithDuration: 0.25 animations:^{
                [self.voiceButtonWidthConstraint setConstant:32];
            }];
        }
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self runSearch:[searchBar text]];
}

-(void) runSearch:(NSString *) queryString
{
    m_suggestionsText = queryString;
    [m_searchSuggestionsTableViewController fadeOut];
    WRLDSearchQuery * newQuery = [[WRLDSearchQuery alloc] initWithQueryString: queryString : m_searchProviders];
    
    [m_searchResultsTableViewController setCurrentQuery:newQuery];
    [m_searchProviders doSearch: newQuery];
    [self.wrldSearchWidgetSearchBar resignFirstResponder];
    [self determineVoiceButtonVisibility];
}

-(void) registerCellForResultsTable: (NSString *) cellIdentifier : (UINib *) nib
{
    [self.wrldSearchWidgetResultsTableView registerNib:nib forCellReuseIdentifier: cellIdentifier];
}

-(IBAction)voiceButtonClicked:(id)sender
{
    //Do Nothing - not supported on iOS < 10
}

-(BOOL) showVoiceButton
{
    return NO;
}

@end

