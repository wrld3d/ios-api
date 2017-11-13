// Copyright eeGeo Ltd (2012-2017), All Rights Reserved

#import <Foundation/Foundation.h>
#import "WRLDSearchModule.h"

#import "SearchProvider.h"

@implementation WRLDSearchModule

- (instancetype)initWithFrame:(CGRect)frame
{
    NSLog(@"WRLDSearchModule::initWithFrame");
    if(self = [super initWithFrame:frame])
    {
        [self initView];
    }
    
    return self;
}

- (void) initView
{
    NSLog(@"WRLDSearchModule::initView");
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *rootView = [[[NSBundle mainBundle] loadNibNamed:@"Results" owner:self options:nil] objectAtIndex:0];
    [self addSubview:rootView];
}

- (void) addSearchProvider: (SearchProvider*) provider {
   //TODO MOD
}

@end
