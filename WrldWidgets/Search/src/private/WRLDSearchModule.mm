#import <Foundation/Foundation.h>

#import "WRLDSearchModule.h"
#import "WRLDSearchResultView.h"
#import "WRLDSearchResultSet.h"
#import "WRLDSearchResult.h"
#import "WRLDSearchProvider.h"

@implementation WRLDSearchModule
{
    NSMutableArray<id <WRLDSearchProvider> >* m_searchProviders;
    NSMutableArray<WRLDSearchResultSet*>* m_searchResultSets;
    NSMutableArray<id <WRLDSearchModuleDelegate> >* m_updateDelegates;
}

-(instancetype) init
{
    self = [super init];
    
    m_searchProviders = [[NSMutableArray alloc] init];
    m_updateDelegates = [[NSMutableArray alloc] init];
    m_searchResultSets = [[NSMutableArray alloc] init];

    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return m_searchResultSets.count;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger) section
{
    return [m_searchResultSets[section] getResultCount];
}

-(UITableViewCell*) tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRLDSearchResultView* cell = [tableView dequeueReusableCellWithIdentifier:@"genericResultCell"];
    
    if(cell == nil)
    {
        NSBundle* widgetsBundle = [NSBundle bundleForClass:[WRLDSearchResultView class]];
        
        [tableView registerNib:[UINib nibWithNibName:@"WRLDGenericSearchResultView" bundle:widgetsBundle] forCellReuseIdentifier:@"genericResultCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"genericResultCell" forIndexPath:indexPath];
    }   

    WRLDSearchResult* searchResult = [self getSearchResult:(NSIndexPath *) indexPath];
    
    [cell.titleLabel setText:[searchResult title]];
    [cell.descriptionLabel setText:[searchResult subTitle]];

    // todo - Fetch icon from URL using iconkey as lookup
  //[cell.iconImage setImage:]; 

    return cell;        
}

-(WRLDSearchResult*) getSearchResult:(NSIndexPath *) indexPath
{
    return [m_searchResultSets[[indexPath section]] getResult:[indexPath row]];
}

- (void) addSearchProvider: (id<WRLDSearchProvider>) provider
{
    WRLDSearchResultSet* searchResultSet = [[WRLDSearchResultSet alloc] init];
    [searchResultSet setUpdateDelegate:self];
    [provider setSearchProviderDelegate: searchResultSet];
    
    [m_searchResultSets addObject:searchResultSet];
    [m_searchProviders addObject:provider];
}

-(void) onResultsModelUpdate
{
    for (id<WRLDSearchModuleDelegate> delegate in m_updateDelegates)
    {
        [delegate dataDidChange];
    }
}

- (void)search:(NSString*)query
{
    for(id<WRLDSearchProvider> provider in m_searchProviders)
    {
        [provider search: query];
    }
}

- (void)searchSuggestions:(NSString*)query
{
    for(id<WRLDSearchProvider> provider in m_searchProviders)
    {
        [provider searchSuggestions:query];
    }
}

-(void) addSearchModuleDelegate:(id<WRLDSearchModuleDelegate>)searchModuleDelegate
{
    [m_updateDelegates addObject:searchModuleDelegate];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRLDSearchResult* searchResult = [self getSearchResult: indexPath];    
    for (id<WRLDSearchModuleDelegate> delegate in m_updateDelegates)
    {
        [delegate didSelectResult: searchResult];
    }
}

- (void)dataDidChange
{
    for(id<WRLDSearchModuleDelegate> delegate in m_updateDelegates)
    {
        [delegate dataDidChange];
    }
}

- (void)didSelectResult:(WRLDSearchResult *)searchResult
{

}

@end
