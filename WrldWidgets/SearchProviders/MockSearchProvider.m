#import <Foundation/Foundation.h>

#import "MockSearchProvider.h"
#import "WRLDSearchQuery.h"
#import "WRLDSearchResultModel.h"
#import "WRLDBasicSearchResultModel.h"

@implementation MockSearchProvider

@synthesize title;
@synthesize cellIdentifier;

- (instancetype)init
{
    if (self = [super init])
    {
        cellIdentifier = nil;
        title = @"Mock";
    }
    
    return self;
}

- (void) searchFor: (WRLDSearchQuery*) query
{
    NSDictionary * userInfo = @{ @"Query" : query };
    [NSTimer scheduledTimerWithTimeInterval:3
                                     target:self
                                   selector:@selector(completeQuery:)
                                   userInfo:userInfo
                                    repeats:NO];
}

- (void) getSuggestions: (WRLDSearchQuery *) query
{
    NSDictionary * userInfo = @{ @"Query" : query };
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(completeQuery:)
                                   userInfo:userInfo
                                    repeats:NO];
}

- (void)completeQuery:(NSTimer*)theTimer {
    WRLDSearchQuery *query = [[theTimer userInfo] objectForKey:@"Query"];
    
    NSMutableArray<id<WRLDSearchResultModel>> * searchResults = [[NSMutableArray<id<WRLDSearchResultModel>> alloc] init];
    
    for(int i = 0; i < 20; ++i){
        [searchResults addObject: [self createSearchResult:
                                   [NSString stringWithFormat:@"Mock Result %@ %d", query.queryString, i]
                                                  subTitle: [NSString stringWithFormat:@"Mock Result Description %d", i]]];
    }
    
    [query didComplete:YES withResults: searchResults];
}

- (id<WRLDSearchResultModel>) createSearchResult: (NSString*) title subTitle: (NSString*)subTitle
{
    id<WRLDSearchResultModel> searchResult = [[WRLDBasicSearchResultModel alloc] init];
    [searchResult setTitle: title];
    [searchResult setSubTitle: subTitle];
    return searchResult;
}

@end


