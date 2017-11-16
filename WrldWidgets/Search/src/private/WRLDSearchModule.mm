// Copyright eeGeo Ltd (2012-2017), All Rights Reserved

#import <Foundation/Foundation.h>

#import "WRLDSearchModule.h"


@implementation WRLDSearchModule
{
    NSMutableArray<id<SearchProvider>>* m_searchProviders;
    NSMutableArray<id<SuggestionProvider>>* m_suggestionProviders;
    
    NSMutableArray<SearchResult*>* m_currentSearchResults;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger) section
{
    return 5;
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
    
    m_searchProviders = [[NSMutableArray alloc] init];
    m_suggestionProviders = [[NSMutableArray alloc] init];
    
    if(m_currentSearchResults != nil && [m_currentSearchResults count] > 0)
    {
        if([indexPath row] < [m_currentSearchResults count])
        {
            [cell.textLabel setText:[[m_currentSearchResults objectAtIndex:[indexPath row]] title]];
        }
        else
        {
            [cell.textLabel setText:@""];
        }
    }
    else
    {
        NSString* text = [NSString stringWithFormat:@"Hello WRLD Section:%d Row:%d",
         (int)[indexPath section],
         (int)[indexPath row]];
        
        [cell.textLabel setText:text];
    }
    return cell;
        
}

- (void) addSearchProvider: (id<SearchProvider>) provider
{
    if(m_searchProviders == nil)
    {
        m_searchProviders = [[NSMutableArray alloc] init];
    }
    
    
    [provider addOnResultsRecievedCallback: self];

    [m_searchProviders addObject:provider];
}

- (void) addSuggestionProvider:(id<SuggestionProvider>)suggestionProvider
{
    if(m_suggestionProviders == nil)
    {
        m_suggestionProviders = [[NSMutableArray alloc] init];
    }
    
    
    [suggestionProvider addOnSuggestionsRecievedCallback: self];
    
    [m_suggestionProviders addObject:suggestionProvider];
    
}

- (void)onResultsRecieved:(NSMutableArray<SearchResult*>*)searchResults
{
    // add results to table view
    m_currentSearchResults = searchResults;
    
    
}

- (void)doSearch:(NSString*)query
{
    
}

- (void)doAutoCompleteQuery:(NSString*)query
{
    for(id<SuggestionProvider> provider in m_suggestionProviders)
    {
        [provider getSuggestions:query];
    }
}


@end
