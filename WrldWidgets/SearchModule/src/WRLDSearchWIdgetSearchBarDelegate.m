#import <Foundation/Foundation.h>
#import "WRLDSearchWidgetSearchBarDelegate.h"

@implementation WRLDSearchWidgetSearchBarDelegate

-(void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"Get Suggestions for %@", searchText);
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Get Search for %@", [searchBar text]);
}

@end
