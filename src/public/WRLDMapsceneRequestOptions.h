#pragma once

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*!
 * A set of parameters for creating a Mapscene request.
 */
@interface WRLDMapsceneRequestOptions : NSObject

/*!
 * @param shortLinkUrl The full url or the short link of the Mapscene to load.
 * @param applyMapsceneOnSuccess Determins whether the mapscene should be applied once loaded.
 * @returns A WRLDMapsceneRequestOptions instance.
 */
-(instancetype)initMapsceneRequestOptions :(NSString*)shortLinkUrl applyMapsceneOnSuccess:(bool)applyMapsceneOnSuccess;

/*!
 * @returns shortLinkUrl
 */
-(NSString*)getShortLinkUrl;

/*!
 * @returns applyMapsceneOnSuccess
 */
-(bool)getApplyMapsceneOnSuccess;

@end

NS_ASSUME_NONNULL_END
