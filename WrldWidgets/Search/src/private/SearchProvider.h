
#ifndef SearchProvider_h
#define SearchProvider_h

#import <Foundation/Foundation.h>

@protocol SearchProvider <NSObject>

-(NSString)getTitle();
-(void)getSearchResults(NSString);

-(void)addOnResultsRecievedCallback(OnResultRecievedCallback);
-(void)setResultViewFactory(SearchResultFactory);
-(SearchResultFactory)getResultViewFactory();

@end

#endif /* SearchProvider_h */
