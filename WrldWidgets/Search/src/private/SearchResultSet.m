#import <Foundation/Foundation.h>
#import "SearchResultSet.h"
#import "OnResultsModelUpdateDelegate.h"

@implementation SearchResultSet
{
    NSMutableArray<SearchResult*>* m_results;
    NSMutableArray<SearchResult*>* m_suggestions;
    NSMutableArray<id <OnResultsModelUpdateDelegate> >* m_modelUpdateDelegates;
}

- (instancetype) init
{
    [super self];
    m_results = [[NSMutableArray alloc] init];
    m_suggestions = [[NSMutableArray alloc] init];
    
    m_modelUpdateDelegates = [[NSMutableArray alloc] init];
    return self;
}

-(NSMutableArray<SearchResult*>*)getAllResults
{
    return m_results;
}

- (void)addResults:(NSMutableArray<SearchResult*>*)searchResults
{
    [m_results addObjectsFromArray: searchResults];
    
    for (id<OnResultsModelUpdateDelegate> delegate in m_modelUpdateDelegates) {
        [delegate onResultsModelUpdate];
    }
}

-(void) clearResults
{
    [m_results removeAllObjects];
}

- (NSInteger) getResultCount
{
    return m_results.count;
}

- (SearchResult*) getResult:(NSInteger) index
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

- (SearchResult*) getSuggestion:(NSInteger) index
{
    if(index < m_suggestions.count)
    {
        return m_suggestions[index];
    }
    return nil;
}

-(void) addUpdateDelegate:(id<OnResultsModelUpdateDelegate>)delegate
{
    [m_modelUpdateDelegates addObject:delegate];
}

- (void)addSuggestions:(NSMutableArray<SearchResult *> *)searchResults
{
    [m_suggestions addObjectsFromArray: searchResults];
    
    for (id<OnResultsModelUpdateDelegate> delegate in m_modelUpdateDelegates) {
        [delegate onResultsModelUpdate];
    }
}

-(void) clearSuggestions
{
    [m_suggestions removeAllObjects];
}

@end
