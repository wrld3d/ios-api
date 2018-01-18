#pragma once

#import <UIKit/UIKit.h>

@interface WRLDSearchModule : UIViewController
- (id<UITableViewDataSource>) getResultsTableViewDataSource;
- (id<UITableViewDelegate>) getResultsTableViewDelegate;
@end

