#import <Foundation/Foundation.h>
#import "WRLDSearchResultSet.h"

@implementation WRLDSearchResultSet
{
    NSMutableArray<WRLDSearchResult*>* m_results;
    NSMutableArray<WRLDSearchResult*>* m_suggestions;
    id<WRLDSearchModuleDelegate> m_searchDelegate;
    
   // NSMutableArray<id <OnResultsModelUpdateDelegate> >* m_modelUpdateDelegates;
}

- (instancetype) init
{
    [super self];
    m_results = [[NSMutableArray alloc] init];
    m_suggestions = [[NSMutableArray alloc] init];
    
 //   m_modelUpdateDelegates = [[NSMutableArray alloc] init];
    return self;
}

-(NSMutableArray<WRLDSearchResult*>*)getAllResults
{
    return m_results;
}

- (void)addResults:(NSMutableArray<WRLDSearchResult*>*)searchResults
{
    [m_results addObjectsFromArray: searchResults];
    
    if(m_searchDelegate != nil)
        [m_searchDelegate dataDidChange];
}

-(void) clearResults
{
    [m_results removeAllObjects];
}

- (NSInteger) getResultCount
{
    return m_results.count;
}

- (WRLDSearchResult*) getResult:(NSInteger) index
{
    if(index < m_results.count)
    {
        return m_results[index];
    }
    return nil;
}

- (NSInteger) getSuggestionCount
{
    return m_suggestions.count;
}

- (WRLDSearchResult*) getSuggestion:(NSInteger) index
{
    if(index < m_suggestions.count)
    {
        return m_suggestions[index];
    }
    return nil;
}

- (void) setUpdateDelegate:(id<WRLDSearchModuleDelegate>)delegate
{
    m_searchDelegate = delegate;
}

- (void)addSuggestions:(NSMutableArray<WRLDSearchResult *> *)searchResults
{
    [m_suggestions addObjectsFromArray: searchResults];
    
    //TDP Fix me
    ///for (id<OnResultsModelUpdateDelegate> delegate in m_modelUpdateDelegates)
    //{
    //    [delegate onResultsModelUpdate];
    //}
}

-(void) clearSuggestions
{
    [m_suggestions removeAllObjects];
}

@end
