#import "WRLDApi.h"

@interface WRLDApi (Private)

+ (instancetype)eegeoApiInstance;

@property (atomic) NSString *WrldApiKey;

@end
