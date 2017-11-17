// Copyright eeGeo Ltd (2012-2017), All Rights Reserved

#import <Foundation/Foundation.h>

#import "WRLDSearchModule.h"
#import "SearchResultSet.h"
#import "SearchResult.h"
#import "SearchProvider.h"
#import "SuggestionProvider.h"


@implementation WRLDSearchModule
{
    NSMutableArray<id <SearchProvider> >* m_searchProviders;
    NSMutableArray<id <SuggestionProvider> >* m_suggestionProviders;
    
    NSMutableArray<SearchResultSet*>* m_searchResultSets;
    
    NSMutableArray<id <OnResultsModelUpdateDelegate> >* m_modelUpdateDelegates;
    
    bool m_showSuggestions;
}

-(instancetype) init
{
    self = [super init];
    m_searchProviders = [[NSMutableArray alloc] init];
    m_suggestionProviders = [[NSMutableArray alloc] init];
    m_modelUpdateDelegates = [[NSMutableArray alloc] init];
    m_searchResultSets = [[NSMutableArray alloc] init];
    
    m_showSuggestions = true;
    
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return m_searchResultSets.count;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger) section
{
    if(m_showSuggestions)
    {
        return [m_searchResultSets[section] getSuggestionCount];
    }
    
    return [m_searchResultSets[section] getResultCount];
}

-(UITableViewCell*) tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:@"resultCell"];
    }   
    
    SearchResult* searchResult = [self getSearchResult:(NSIndexPath *) indexPath];
    
    [cell.textLabel setText:[searchResult title]];
    return cell;        
}

-(SearchResult*) getSearchResult:(NSIndexPath *) indexPath
{
    if(m_showSuggestions)
    {
        return [m_searchResultSets[[indexPath section]] getSuggestion:[indexPath row]];
    }
    
    return [m_searchResultSets[[indexPath section]] getResult:[indexPath row]];
}

- (void) addSearchProvider: (id<SearchProvider>) provider
{
    if(m_searchProviders == nil)
    {
        m_searchProviders = [[NSMutableArray alloc] init];
    }
    
    SearchResultSet* searchResultSet = [[SearchResultSet alloc] init];
    [searchResultSet addUpdateDelegate: self];    
    [provider addOnResultsReceivedDelegate: searchResultSet];
    
    [m_searchResultSets addObject:searchResultSet];
    [m_searchProviders addObject:provider];
}

- (void) addSuggestionProvider:(id<SuggestionProvider>)suggestionProvider
{
    if(m_suggestionProviders == nil)
    {
        m_suggestionProviders = [[NSMutableArray alloc] init];
    }
    
    SearchResultSet* searchResultSet = [[SearchResultSet alloc] init];
    [searchResultSet addUpdateDelegate: self];
    [suggestionProvider addOnResultsReceivedDelegate: searchResultSet];
    [suggestionProvider addOnSuggestionsReceivedDelegate: searchResultSet];
    
    [m_searchResultSets addObject:searchResultSet];
    [m_searchProviders addObject:suggestionProvider];
    [m_suggestionProviders addObject:suggestionProvider];
}

-(void) onResultsModelUpdate
{
    
    for (id<OnResultsModelUpdateDelegate> delegate in m_modelUpdateDelegates) {
        [delegate onResultsModelUpdate];
    }
}

- (void)doSearch:(NSString*)query
{
    m_showSuggestions = false;
    for(id<SuggestionProvider> provider in m_suggestionProviders)
    {
        [provider getSearchResults: query];
    }
}

- (void)doAutoCompleteQuery:(NSString*)query
{
    m_showSuggestions = true;
    for(id<SuggestionProvider> provider in m_suggestionProviders)
    {
        [provider getSuggestions:query];
    }
}

-(void) addUpdateDelegate:(id<OnResultsModelUpdateDelegate>)delegate
{
    [m_modelUpdateDelegates addObject:delegate];
}

@end
