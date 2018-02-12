//
//  WRLDSearchModelTests.m
//  WRLDSearchModelTests
//
//  Created by Michael O'Donnell on 08/02/2018.
//  Copyright © 2018 eeGeo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#include "WRLDSearchModel.h"
#include "WRLDSearchProvider.h"
#include "WRLDSearchProviderHandle.h"
#include "WRLDSuggestionProvider.h"
#include "WRLDSuggestionProviderHandle.h"
#include "WRLDSearchResultsReadyDelegate.h"
#include "WRLDSearchQuery.h"

@interface WRLDSearchModelTests : XCTestCase

@end

@implementation WRLDSearchModelTests
{
    WRLDSearchModel *model;
    NSString* testString;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    model = [[WRLDSearchModel alloc] init];
    testString = @"TestString";
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
    id mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    WRLDSearchProviderHandle * handle = [model addSearchProvider:mockProvider];
    XCTAssertNotNil(handle);
}

- (void)testAddingASuggestionProvidersReturnsASuggestionProviderReference {
    id mockProvider = OCMProtocolMock(@protocol(WRLDSuggestionProvider));
    WRLDSuggestionProviderHandle * reference = [model addSuggestionProvider:mockProvider];
    XCTAssertNotNil(reference);
}

- (void)testRunningASearchQueryReturnsValidObject {
    id mockResponseDelegate = OCMProtocolMock(@protocol(WRLDSearchResultsReadyDelegate));
    WRLDSearchQuery *query = [model getSearchResultsForString:testString withResultsDelegate:mockResponseDelegate];
    XCTAssertNotNil(query);
}

- (void)testRunningASearchQueryWithZeroProvidersInvokesCompletionDelegateWithSuccess {
    id mockResponseDelegate = OCMProtocolMock(@protocol(WRLDSearchResultsReadyDelegate));
    [model getSearchResultsForString:testString withResultsDelegate:mockResponseDelegate];
    OCMVerify([mockResponseDelegate didComplete:YES withResults:[OCMArg any]]);
}

- (void)testRunningASearchQueryWithZeroProvidersInvokesCompletionDelegateWithZeroResults {
    id mockResponseDelegate = OCMProtocolMock(@protocol(WRLDSearchResultsReadyDelegate));
    [model getSearchResultsForString:testString withResultsDelegate:mockResponseDelegate];
    OCMVerify([mockResponseDelegate didComplete:[OCMArg any] withResults:[OCMArg checkWithBlock:^BOOL(id value){
        WRLDSearchResultsCollection* results = value;
        XCTAssertNotNil(results);
        return results.count == 0;
    }]]);
}

- (void)testASearchQueryWithZeroProvidersIsComplete {
    id<WRLDSearchResultsReadyDelegate> mockResponseDelegate = OCMProtocolMock(@protocol(WRLDSearchResultsReadyDelegate));
    WRLDSearchQuery *query = [model getSearchResultsForString:testString withResultsDelegate:mockResponseDelegate];
    XCTAssertEqual([query progress], Completed);
}

- (void)testAnIncompleteSearchQueryReturnsNilResults {
    id<WRLDSearchProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    id<WRLDSearchResultsReadyDelegate> mockResponseDelegate = OCMProtocolMock(@protocol(WRLDSearchResultsReadyDelegate));
    [model addSearchProvider:mockProvider];
    WRLDSearchQuery *query = [model getSearchResultsForString:testString withResultsDelegate:mockResponseDelegate];
    XCTAssertNil([query getResults]);
}

- (void)testSearchProviderHandleNotNil {
    id<WRLDSearchProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    WRLDSearchProviderHandle* handle = [model addSearchProvider:mockProvider];
    XCTAssertNotNil(handle.provider);
}

- (void)testRunningASearchQueryDispatchesToOnlyRegisteredSearchProvider {
    id<WRLDSearchProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    id<WRLDSearchResultsReadyDelegate> mockResponseDelegate = OCMProtocolMock(@protocol(WRLDSearchResultsReadyDelegate));
    [model addSearchProvider:mockProvider];
    [model getSearchResultsForString:testString withResultsDelegate:mockResponseDelegate];
    OCMVerify([mockProvider searchFor:[OCMArg any]]);
}

- (void)testRunningASearchQueryDispatchesToAllRegisteredSearchProviders {
    id<WRLDSearchProvider> mockProvider1 = OCMProtocolMock(@protocol(WRLDSearchProvider));
    id<WRLDSearchProvider> mockProvider2 = OCMProtocolMock(@protocol(WRLDSearchProvider));
    [model addSearchProvider:mockProvider1];
    [model addSearchProvider:mockProvider2];
    id<WRLDSearchResultsReadyDelegate> mockResponseDelegate = OCMProtocolMock(@protocol(WRLDSearchResultsReadyDelegate));
    [model getSearchResultsForString:testString withResultsDelegate:mockResponseDelegate];
    OCMVerify([mockProvider1 searchFor:[OCMArg any]]);
    OCMVerify([mockProvider2 searchFor:[OCMArg any]]);
}

- (void)testQueryDispatchedToSearchProvidersMatchesRunQuery {
    id<WRLDSearchProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    id<WRLDSearchResultsReadyDelegate> mockResponseDelegate = OCMProtocolMock(@protocol(WRLDSearchResultsReadyDelegate));
    [model addSearchProvider:mockProvider];
    WRLDSearchQuery *query = [model getSearchResultsForString:testString withResultsDelegate:mockResponseDelegate];
    OCMVerify([mockProvider searchFor:[OCMArg checkWithBlock:^BOOL(WRLDSearchQuery * providerQuery){
        return providerQuery.queryString == query.queryString;
    }]]);
}

- (void)testRunningASearchQueryDoesNotDispatchesToRemovedSearchProviders {
    id<WRLDSearchProvider> mockProvider1 = OCMProtocolMock(@protocol(WRLDSearchProvider));
    id<WRLDSearchProvider> mockProvider2 = OCMProtocolMock(@protocol(WRLDSearchProvider));
    [model addSearchProvider:mockProvider1];
    WRLDSearchProviderHandle * mockProvider2Handle = [model addSearchProvider:mockProvider2];
    [model removeSearchProvider:mockProvider2Handle];
    id<WRLDSearchResultsReadyDelegate> mockResponseDelegate = OCMProtocolMock(@protocol(WRLDSearchResultsReadyDelegate));
    [model getSearchResultsForString:testString withResultsDelegate:mockResponseDelegate];
    OCMVerify([mockProvider1 searchFor:[OCMArg any]]);
    OCMReject([mockProvider2 searchFor:[OCMArg any]]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
