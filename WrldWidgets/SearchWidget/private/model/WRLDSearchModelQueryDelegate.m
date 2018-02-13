#import "WRLDSearchModelQueryDelegate.h"

@implementation WRLDSearchModelQueryDelegate
{
    NSMutableArray< id <WRLDQueryStartingDelegate> >* m_startingDelegates;
    NSMutableArray< id <WRLDQueryFinishedDelegate> >* m_finishedDelegates;
}

-(instancetype) init
{
    self = [super init];
    if (self)
    {
        m_startingDelegates = [[NSMutableArray< id <WRLDQueryStartingDelegate> > alloc] init];
        m_finishedDelegates = [[NSMutableArray< id <WRLDQueryFinishedDelegate> > alloc] init];
    }
    return self;
}

- (void) addQueryStartingDelegate: (id<WRLDQueryStartingDelegate>) queryStartingDelegate
{
    if(queryStartingDelegate){
        [m_startingDelegates addObject:queryStartingDelegate];
    }
}

- (void) removeQueryStartingDelegate: (id<WRLDQueryStartingDelegate>) queryStartingDelegate
{
    if(queryStartingDelegate){
        [m_startingDelegates removeObject:queryStartingDelegate];
    }
}

- (void) addQueryCompletedDelegate: (id<WRLDQueryFinishedDelegate>) queryFinishedDelegate
{
    if(queryFinishedDelegate){
        [m_finishedDelegates addObject:queryFinishedDelegate];
    }
}

- (void) removeQueryCompletedDelegate: (id<WRLDQueryFinishedDelegate>) queryFinishedDelegate
{
    if(queryFinishedDelegate){
        [m_finishedDelegates removeObject:queryFinishedDelegate];
    }
}

- (void) willSearchFor: (WRLDSearchQuery *)query
{
    for(id<WRLDQueryStartingDelegate> startingDelegate in m_startingDelegates)
    {
        [startingDelegate willSearchFor:query];
    }
}


- (void) didComplete: (WRLDSearchQuery *) query
{
    for(id<WRLDQueryFinishedDelegate> finishedDelegate in m_finishedDelegates)
    {
        [finishedDelegate didComplete: query];
    }
}


@end
