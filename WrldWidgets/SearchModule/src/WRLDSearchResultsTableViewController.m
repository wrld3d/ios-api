#import <Foundation/Foundation.h>

#import "WRLDSearchResultsTableViewController.h"

@implementation WRLDSearchResultsTableViewController
{
    
}

-(instancetype) init
{
    self = [super init];
    
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger) section
{
    return 0;
}

-(UITableViewCell*) tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self adjustHeightOfTableview];
}

- (void)adjustHeightOfTableview
{
    CGFloat height = self.tableView.contentSize.height;
    CGFloat maxHeight = self.tableView.superview.frame.size.height - self.tableView.frame.origin.y;
    
    if (height > maxHeight)
        height = maxHeight;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.tableView.frame;
        frame.size.height = height;
        self.tableView.frame = frame;
    }];
}

- (void)dataDidChange
{
    
}

@end

