#import <Foundation/Foundation.h>

#import "WRLDSearchWidgetViewController.h"
#import "WRLDSearchWidgetSearchBarDelegate.h"

@implementation WRLDSearchWidgetViewController
{
    WRLDSearchWidgetSearchBarDelegate *m_wrldSearchWidgetSearchBarDelegate;
}

-(instancetype) init
{
    self = [super init];
    
    m_wrldSearchWidgetSearchBarDelegate = [WRLDSearchWidgetSearchBarDelegate alloc];
    
    return self;
}

-(void) assignSearchBarDelegate:(UISearchBar *)searchBar
{
    searchBar.delegate = m_wrldSearchWidgetSearchBarDelegate;
}

@end

