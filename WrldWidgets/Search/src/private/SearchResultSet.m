#import <Foundation/Foundation.h>
#import "SearchResultSet.h"

@implementation SearchResultSet
{
    NSMutableArray<SearchResult*>* m_results;
}

- (void)addResult: (SearchResult*) searchResult
{
    if (m_results == nil)
    {
        m_results = [[NSMutableArray alloc] init];
    }
    
    [m_results addObject: searchResult];
}

-(NSMutableArray<SearchResult*>*)getAllResults
{
    return m_results;
}

@end
