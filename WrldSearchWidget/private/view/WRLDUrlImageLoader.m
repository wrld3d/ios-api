#import "WRLDUrlImageLoader.h"
#import "WRLDAsyncImageLoadResponse.h"

#pragma mark - WRLDUrlImageLoader
@implementation WRLDUrlImageLoader

- (WRLDAsyncImageLoadResponse *) assignImageFromUrlString:(NSString*) urlString
                                       assignmentCallback: (AssignmentCallback) assignCallback
                                     cancellationCallback: (CancelAssignmentCallback) cancelCallback
{
    if(!urlString)
    {
        WRLDAsyncImageLoadResponse * loadResponse = [[WRLDAsyncImageLoadResponse alloc] initWithAssignmentCallback:assignCallback
                                                                                              cancellationCallback:cancelCallback];
        [loadResponse cancel];
        return loadResponse;
    }
        
    NSURL* url = [NSURL URLWithString: urlString];
    return [self assignImageFromUrl:url assignmentCallback:assignCallback cancellationCallback:cancelCallback];
}

- (WRLDAsyncImageLoadResponse *) assignImageFromUrl: (NSURL*) url
                                 assignmentCallback: (AssignmentCallback) assignCallback
                               cancellationCallback: (CancelAssignmentCallback) cancelCallback
{
    WRLDAsyncImageLoadResponse * loadResponse = [[WRLDAsyncImageLoadResponse alloc] initWithAssignmentCallback:assignCallback
                                                                                          cancellationCallback:cancelCallback];
    
    if(!url)
    {
        [loadResponse cancel];
        return loadResponse;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* imageData = [NSData dataWithContentsOfURL: url];
        if (imageData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage * image = [UIImage imageWithData: imageData];
                if (image) {
                    [loadResponse assignImage: image];
                }
                else{
                    [loadResponse cancel];
                }
            });
        }
        else{
            [loadResponse cancel];
        }
    });
    
    return loadResponse;
}

@end
