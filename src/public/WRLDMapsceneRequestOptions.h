#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * A set of parameters for creating a Mapscene request.
 */
@interface WRLDMapsceneRequestOptions : NSObject

/**
 * @param shortLinkUrl The full url or the short link of the Mapscene to load.
 * @param applyMapsceneOnSuccess .
 * @returns Its self.
 */
-(instancetype)initMapsceneRequestOptions :(NSString*)shortLinkUrl :(bool)applyMapsceneOnSuccess;

/**
 * @returns shortLinkUrl
 */
-(NSString*)getShortLinkUrl;

/**
 * @returns applyMapsceneOnSuccess
 */
-(bool)getApplyMapsceneOnSuccess;

@end

NS_ASSUME_NONNULL_END
