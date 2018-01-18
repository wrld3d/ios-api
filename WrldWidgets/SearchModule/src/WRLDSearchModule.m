#import <Foundation/Foundation.h>

#import "WRLDSearchModule.h"

@implementation WRLDSearchModule
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

- (void)dataDidChange
{
    
}

@end

