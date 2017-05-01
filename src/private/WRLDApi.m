#import <Foundation/Foundation.h>

#import "WRLDApi.h"
#import "WRLDApi_Private.h"


@interface WRLDApi ()

@property (atomic) NSString* apiKey;

@end


@implementation WRLDApi

+ (NSString*)apiKey
{
    return [WRLDApi eegeoApiInstance].apiKey;
}

+ (void)load
{
    [WRLDApi eegeoApiInstance].apiKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"WrldApiKey"];
}

+ (instancetype)eegeoApiInstance
{

    static dispatch_once_t s_oneTimeInit;
    static WRLDApi *s_eegeoApiInstance;
    
    if ([[NSThread currentThread] isMainThread])
    {
        dispatch_once(&s_oneTimeInit, ^{
            s_eegeoApiInstance = [[self alloc] init];
        });

    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
            dispatch_once(&s_oneTimeInit, ^{
                s_eegeoApiInstance = [[self alloc] init];
            });
        });
    }
    return s_eegeoApiInstance;
}

@end
