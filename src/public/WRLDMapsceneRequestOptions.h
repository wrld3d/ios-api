#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface WRLDMapsceneRequestOptions : NSObject

 */
-(instancetype)initMapsceneRequestOptions :(NSString*)shortLinkUrl :(bool)applyMapsceneOnSuccess;

 */
-(NSString*)getShortLinkUrl;

 */
-(bool)getApplyMapsceneOnSuccess;

@end

NS_ASSUME_NONNULL_END
