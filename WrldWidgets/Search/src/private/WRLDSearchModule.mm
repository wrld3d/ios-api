// Copyright eeGeo Ltd (2012-2017), All Rights Reserved

#import <Foundation/Foundation.h>
#import "WRLDSearchModule.h"

#import "SearchProvider.h"

@implementation WRLDSearchModule

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
    
    NSString* text = [NSString stringWithFormat:@"Hello WRLD Section:%d Row:%d",
     (int)[indexPath section],
     (int)[indexPath row]];
    
    [cell.textLabel setText:text];
    
    return cell;
}

- (void) addSearchProvider: (SearchProvider*) provider {
   //TODO MOD
}

@end
