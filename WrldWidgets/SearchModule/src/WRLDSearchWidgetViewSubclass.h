#import "WRLDSearchWidgetView.h"

@interface WRLDSearchWidgetView()

@property (strong, nonatomic) IBOutlet UIView *wrldSearchWidgetRootView;
@property (strong, nonatomic) IBOutlet UIView *wrldSearchWidgetSearchBarContainerView;
@property (weak, nonatomic) IBOutlet UIButton *wrldSearchWidgetSpeechButton;
@property (weak, nonatomic) IBOutlet UIButton *wrldSearchWidgetMenuButton;
@property (unsafe_unretained, nonatomic) IBOutlet UISearchBar *wrldSearchWidgetSearchBar;
@property (weak, nonatomic) IBOutlet UIView *wrldSearchWidgetResultsTableViewContainer;
@property (weak, nonatomic) IBOutlet UITableView *wrldSearchWidgetResultsTableView;
@property (weak, nonatomic) IBOutlet UITableView *wrldSearchWidgetSuggestionsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resultsHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *suggestionsHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voiceButtonWidthConstraint;

-(IBAction)voiceButtonClicked:(id) sender;

-(void) customInit;
-(BOOL) showVoiceButton;

-(void) setQueryTextWithoutSuggestions: (NSString *) text;
-(void) runSearch:(NSString *) queryString;
@end
