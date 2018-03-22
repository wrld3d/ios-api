#import "WRLDAsyncImageLoadResponse.h"

#pragma mark - WRLDImageViewAssigner

@implementation WRLDAsyncImageLoadResponse
{
    BOOL m_wasCancelled;
    AssignmentCallback m_assignmentCallback;
    CancelAssignmentCallback m_cancelAssignmentCallback;
}

- (instancetype) initWithAssignmentCallback:(AssignmentCallback) assignImageCallback;
{
    if(self = [super init])
    {
        m_wasCancelled = NO;
        m_assignmentCallback = assignImageCallback;
        m_cancelAssignmentCallback = nil;
    }
    return self;
}

- (instancetype) initWithAssignmentCallback:(AssignmentCallback) assignImageCallback cancellationCallback: (CancelAssignmentCallback) cancelAssignmentCallback;
{
    if(self = [super init])
    {
        m_wasCancelled = NO;
        m_assignmentCallback = assignImageCallback;
        m_cancelAssignmentCallback = cancelAssignmentCallback;
    }
    return self;
}

- (void) assignImage:(UIImage *)image
{
    if(!m_wasCancelled)
    {
        m_assignmentCallback(image);
    }
}

- (void) cancel
{
    if(!m_wasCancelled){
        m_wasCancelled = YES;
        if(m_cancelAssignmentCallback != nil)
        {
            m_cancelAssignmentCallback();
        }
    }
}
@end
