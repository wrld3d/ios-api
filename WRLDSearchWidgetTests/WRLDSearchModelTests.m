//
//  WRLDSearchModelTests.m
//  WRLDSearchModelTests
//
//  Created by Michael O'Donnell on 08/02/2018.
//  Copyright © 2018 eeGeo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#include "WRLDSearchModel.h"
#include "WRLDSearchProvider.h"
#include "WRLDSearchProviderReference.h"
#include "WRLDSuggestionProvider.h"
#include "WRLDSuggestionProviderReference.h"

@interface WRLDSearchModelTests : XCTestCase

@end

@implementation WRLDSearchModelTests
{
    WRLDSearchModel *model;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    model = [[WRLDSearchModel alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testInitReturnsASearchModel {
    XCTAssertNotNil(model);
}

- (void)testAddingASearchProvidersReturnsASearchProviderReference {
    id<WRLDSearchProvider> mockProvider = mockProtocol(@protocol(WRLDSearchProvider));
    //NSObject <WRLDSearchProvider> *mockProvider = mockObjectAndProtocol([NSObject class], @protocol(WRLDSearchProvider));
    WRLDSearchProviderReference * reference = [model addSearchProvider:mockProvider];
    XCTAssertNotNil(reference);
}

- (void)testAddingASuggestionProvidersReturnsASuggestionProviderReference {
    id<WRLDSuggestionProvider> mockProvider = mockProtocol(@protocol(WRLDSuggestionProvider));
    //NSObject <WRLDSearchProvider> *mockProvider = mockObjectAndProtocol([NSObject class], @protocol(WRLDSearchProvider));
    WRLDSuggestionProviderReference * reference = [model addSuggestionProvider:mockProvider];
    XCTAssertNotNil(reference);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
