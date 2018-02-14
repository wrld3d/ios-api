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
#include "WRLDQueryFinishedDelegate.h"
#include "WRLDSearchQuery.h"
#include "WRLDSearchRequest.h"
#include "WRLDSearchTypes.h"
#include "WRLDSearchModelQueryDelegate.h"

@interface WRLDSearchModelSearchTests : XCTestCase

@end

@implementation WRLDSearchModelSearchTests
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

- (void)testAddingASearchProviderReturnsASearchProviderReference {
    id mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    WRLDSearchProviderHandle * handle = [model addSearchProvider:mockProvider];
    XCTAssertNotNil(handle);
}

- (void)testRunningASearchQueryReturnsValidObject {
    WRLDSearchQuery *query = [model getSearchResultsForString:testString];
    XCTAssertNotNil(query);
}

- (void)testSearchDelegateStartingMethodInvokedOnGetSearchResultsForString
{
    id<WRLDQueryStartingDelegate> mockDelegate = OCMProtocolMock(@protocol(WRLDQueryStartingDelegate));
    [model.searchDelegate addQueryStartingDelegate:mockDelegate];
    [model getSearchResultsForString:testString];
    OCMVerify([mockDelegate willSearchFor:[OCMArg any]]);
}

- (void)testSearchQueryCompleteFlagInCorrectStateDuringProviderCompletions {
    
    id<WRLDSearchProvider> mockProvider1 = OCMProtocolMock(@protocol(WRLDSearchProvider));
    __block WRLDSearchRequest *requestCapture1 = nil;
    id<WRLDSearchProvider> mockProvider2 = OCMProtocolMock(@protocol(WRLDSearchProvider));
    __block WRLDSearchRequest *requestCapture2 = nil;
    
    OCMStub([mockProvider1 searchFor:[OCMArg checkWithBlock:^BOOL(WRLDSearchRequest* request){
        requestCapture1 = request;
        return YES;
    }]]);
    OCMStub([mockProvider2 searchFor:[OCMArg checkWithBlock:^BOOL(WRLDSearchRequest* request){
        requestCapture2 = request;
        return YES;
    }]]);
    
    [model addSearchProvider:mockProvider1];
    [model addSearchProvider:mockProvider2];
    WRLDSearchQuery *query = [model getSearchResultsForString:testString];
    XCTAssertFalse(query.hasCompleted);
    [requestCapture1 didComplete:YES withResults:[[WRLDSearchResultsCollection alloc]init]];
    XCTAssertFalse(query.hasCompleted);
    [requestCapture2 didComplete:YES withResults:[[WRLDSearchResultsCollection alloc]init]];
    XCTAssertTrue(query.hasCompleted);
}

- (void)testSearchDelegateCompletionMethodInvokedOnGetSearchForStringWithNoProviders
{
    id<WRLDQueryFinishedDelegate> mockDelegate = OCMProtocolMock(@protocol(WRLDQueryFinishedDelegate));
    [model.searchDelegate addQueryCompletedDelegate:mockDelegate];
    [model getSearchResultsForString: testString];
    OCMVerify([mockDelegate didComplete:[OCMArg any]]);
}

- (void)testSearchInvokesCompletionDelegateWhenProvidersComplete {
    
    id<WRLDSearchProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    __block WRLDSearchRequest *requestCapture = nil;
    
    OCMStub([mockProvider searchFor:[OCMArg checkWithBlock:^BOOL(WRLDSearchRequest* request){
        requestCapture = request;
        return YES;
    }]]);
    
    [model addSearchProvider:mockProvider];
    
    id<WRLDQueryFinishedDelegate> mockQueryDelegate = OCMProtocolMock(@protocol(WRLDQueryFinishedDelegate));
    [model.searchDelegate addQueryCompletedDelegate: mockQueryDelegate];
    
    [model getSearchResultsForString:testString];
    [requestCapture didComplete:YES withResults:[[WRLDSearchResultsCollection alloc]init]];
    OCMVerify([mockQueryDelegate didComplete:[OCMArg any]]);
}

- (void)testSearchOnlyInvokesQueryCompletionDelegateWhenAllProvidersComplete {
    
    id<WRLDSearchProvider> mockProvider1 = OCMProtocolMock(@protocol(WRLDSearchProvider));
    __block WRLDSearchRequest *requestCapture1 = nil;
    id<WRLDSearchProvider> mockProvider2 = OCMProtocolMock(@protocol(WRLDSearchProvider));
    __block WRLDSearchRequest *requestCapture2 = nil;
    
    OCMStub([mockProvider1 searchFor:[OCMArg checkWithBlock:^BOOL(WRLDSearchRequest* request){
        requestCapture1 = request;
        return YES;
    }]]);
    OCMStub([mockProvider2 searchFor:[OCMArg checkWithBlock:^BOOL(WRLDSearchRequest* request){
        requestCapture2 = request;
        return YES;
    }]]);
    
    [model addSearchProvider:mockProvider1];
    [model addSearchProvider:mockProvider2];
    
    id<WRLDQueryFinishedDelegate> mockFinishedDelegate = OCMProtocolMock(@protocol(WRLDQueryFinishedDelegate));
    [model.searchDelegate addQueryCompletedDelegate: mockFinishedDelegate];
    
    __block NSInteger numberOfCalls = 0;
    OCMStub([mockFinishedDelegate didComplete:[OCMArg any]]).andDo(^(NSInvocation *invocation)
                                                                                         { ++numberOfCalls; });
    
    [model getSearchResultsForString:testString];
    [requestCapture1 didComplete:YES withResults:[[WRLDSearchResultsCollection alloc]init]];
    [requestCapture2 didComplete:YES withResults:[[WRLDSearchResultsCollection alloc]init]];
    XCTAssertEqual(numberOfCalls, 1);
}

- (void)testSearchStartingDelegateInvokedBeforeCompletionDelegateOnGetSearchResultsForStringWithNoProviders
{
    id<WRLDQueryStartingDelegate> mockStartDelegate = OCMProtocolMock(@protocol(WRLDQueryStartingDelegate));
    id<WRLDQueryFinishedDelegate> mockFinishDelegate = OCMProtocolMock(@protocol(WRLDQueryFinishedDelegate));
    
    __block BOOL didComplete = NO;
    OCMStub([mockStartDelegate willSearchFor:[OCMArg any]]).andDo(^(NSInvocation *invocation)
                                                                  { XCTAssertFalse(didComplete); });
    
    OCMStub([mockFinishDelegate didComplete:[OCMArg any]]).andDo(^(NSInvocation *invocation)
                                                                 { didComplete = YES; });
    
    [model.searchDelegate addQueryStartingDelegate:mockStartDelegate];
    [model.searchDelegate addQueryCompletedDelegate:mockFinishDelegate];
    [model getSearchResultsForString:testString];
    OCMVerify([mockStartDelegate willSearchFor:[OCMArg any]]);
    OCMVerify([mockFinishDelegate didComplete:[OCMArg any]]);
}

- (void)testASearchQueryWithZeroProvidersIsComplete {
    WRLDSearchQuery *query = [model getSearchResultsForString:testString];
    XCTAssertEqual([query progress], Completed);
}

- (void)testAnIncompleteSearchQueryReturnsNilResults {
    id<WRLDSearchProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    WRLDSearchProviderHandle * providerHandle = [model addSearchProvider:mockProvider];
    WRLDSearchQuery *query = [model getSearchResultsForString:testString];
    XCTAssertNil([query getResultsForFulfiller: providerHandle]);
}

- (void)testSearchProviderHandleNotNil {
    id<WRLDSearchProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    WRLDSearchProviderHandle* handle = [model addSearchProvider:mockProvider];
    XCTAssertNotNil(handle.provider);
}

- (void)testRunningASearchQueryDispatchesToOnlyRegisteredSearchProvider {
    id<WRLDSearchProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    [model addSearchProvider:mockProvider];
    [model getSearchResultsForString:testString];
    OCMVerify([mockProvider searchFor:[OCMArg any]]);
}

- (void)testRunningASearchQueryDispatchesToAllRegisteredSearchProviders {
    id<WRLDSearchProvider> mockProvider1 = OCMProtocolMock(@protocol(WRLDSearchProvider));
    id<WRLDSearchProvider> mockProvider2 = OCMProtocolMock(@protocol(WRLDSearchProvider));
    [model addSearchProvider:mockProvider1];
    [model addSearchProvider:mockProvider2];
    [model getSearchResultsForString:testString];
    OCMVerify([mockProvider1 searchFor:[OCMArg any]]);
    OCMVerify([mockProvider2 searchFor:[OCMArg any]]);
}

- (void)testQueryDispatchedToSearchProvidersMatchesRunQuery {
    id<WRLDSearchProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    [model addSearchProvider:mockProvider];
    WRLDSearchQuery *query = [model getSearchResultsForString:testString];
    OCMVerify([mockProvider searchFor:[OCMArg checkWithBlock:^BOOL(WRLDSearchQuery * providerQuery){
        return providerQuery.queryString == query.queryString;
    }]]);
}

- (void)testRunningASearchQueryDoesNotDispatchToRemovedSearchProviders {
    id<WRLDSearchProvider> mockProvider1 = OCMProtocolMock(@protocol(WRLDSearchProvider));
    id<WRLDSearchProvider> mockProvider2 = OCMProtocolMock(@protocol(WRLDSearchProvider));
    [model addSearchProvider:mockProvider1];
    WRLDSearchProviderHandle * mockProvider2Handle = [model addSearchProvider:mockProvider2];
    [model removeSearchProvider:mockProvider2Handle];
    [model getSearchResultsForString:testString];
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
