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
#include "WRLDSearchQuery.h"
#include "WRLDSearchRequest.h"
#include "WRLDSearchTypes.h"
#include "WRLDSearchQueryObserver.h"

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
    __block BOOL didRunBlock = NO;
    [model.searchObserver addQueryStartingEvent:^(WRLDSearchQuery * query){didRunBlock = YES;}];
    [model getSearchResultsForString:testString];
    XCTAssertTrue(didRunBlock);
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
    __block BOOL didRunBlock = NO;
    [model.searchObserver addQueryCompletedEvent:^(WRLDSearchQuery * query){didRunBlock = YES;}];
    [model getSearchResultsForString: testString];
    XCTAssertTrue(didRunBlock);
}

- (void)testSearchInvokesCompletionDelegateWhenProvidersComplete {
    
    id<WRLDSearchProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    __block WRLDSearchRequest *requestCapture = nil;
    
    OCMStub([mockProvider searchFor:[OCMArg checkWithBlock:^BOOL(WRLDSearchRequest* request){
        requestCapture = request;
        return YES;
    }]]);
    
    [model addSearchProvider:mockProvider];
    
    __block BOOL didRunBlock = NO;
    [model.searchObserver addQueryCompletedEvent:^(WRLDSearchQuery * query){didRunBlock = YES;}];
    
    [model getSearchResultsForString:testString];
    [requestCapture didComplete:YES withResults:[[WRLDSearchResultsCollection alloc]init]];
    XCTAssertTrue(didRunBlock);
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
    
    __block NSInteger numberOfCalls = 0;
    
    [model.searchObserver addQueryCompletedEvent:^(WRLDSearchQuery *query) {
        ++numberOfCalls;
    }];
    
    [model getSearchResultsForString:testString];
    [requestCapture1 didComplete:YES withResults:[[WRLDSearchResultsCollection alloc]init]];
    [requestCapture2 didComplete:YES withResults:[[WRLDSearchResultsCollection alloc]init]];
    XCTAssertEqual(numberOfCalls, 1);
}

- (void)testSearchStartingDelegateInvokedBeforeCompletionDelegateOnGetSearchResultsForStringWithNoProviders
{
    __block BOOL didRunStartBlock = NO;
    __block BOOL didRunCompletedBlock = NO;
    
    [model.searchObserver addQueryStartingEvent:^(WRLDSearchQuery *query) {
        didRunStartBlock = YES;
        XCTAssertFalse(didRunCompletedBlock);
    }];
    [model.searchObserver addQueryCompletedEvent:^(WRLDSearchQuery *query) {
        didRunCompletedBlock = YES;
        XCTAssertTrue(didRunStartBlock);
    }];
    
    [model getSearchResultsForString:testString];
    
    XCTAssertTrue(didRunStartBlock);
    XCTAssertTrue(didRunCompletedBlock);
}

- (void)testASearchQueryWithZeroProvidersIsComplete {
    WRLDSearchQuery *query = [model getSearchResultsForString:testString];
    XCTAssertEqual([query progress], Completed);
}

- (void)testAnIncompleteSearchQueryReturnsNilResults {
    id<WRLDSearchProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    WRLDSearchProviderHandle * providerHandle = [model addSearchProvider:mockProvider];
    WRLDSearchQuery *query = [model getSearchResultsForString:testString];
    XCTAssertNil([query getResultsForFulfiller: providerHandle.identifier]);
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

- (void)testCancelledSearchesDoNotCompleteWhenRequestCompletes {
    id<WRLDSearchProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    [model addSearchProvider:mockProvider];
    
    __block WRLDSearchRequest *requestCapture = nil;
    
    OCMStub([mockProvider searchFor:[OCMArg checkWithBlock:^BOOL(WRLDSearchRequest* request){
        requestCapture = request;
        return YES;
    }]]);
    
    [model.searchObserver addQueryCompletedEvent:^(WRLDSearchQuery *query) {
        XCTFail();
    }];
    
    WRLDSearchQuery *query = [model getSearchResultsForString:testString];
    [query cancel];
    [requestCapture didComplete:YES withResults:[[WRLDSearchResultsCollection alloc]init]];
}

- (void)testCancelledSearchesDoNotCompleteWhenRequestCancelled {
    id<WRLDSearchProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    [model addSearchProvider:mockProvider];
    
    __block WRLDSearchRequest *requestCapture = nil;
    
    OCMStub([mockProvider searchFor:[OCMArg checkWithBlock:^BOOL(WRLDSearchRequest* request){
        requestCapture = request;
        return YES;
    }]]);
    
    [model.searchObserver addQueryCompletedEvent:^(WRLDSearchQuery *query) {
        XCTFail();
    }];
    
    WRLDSearchQuery *query = [model getSearchResultsForString:testString];
    [query cancel];
    [requestCapture cancel];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testSearchCancelledMethodInvokedOnCancelledQuery
{
    id<WRLDSearchProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    [model addSearchProvider:mockProvider];
    
    __block WRLDSearchRequest *requestCapture = nil;
    
    OCMStub([mockProvider searchFor:[OCMArg checkWithBlock:^BOOL(WRLDSearchRequest* request){
        requestCapture = request;
        return YES;
    }]]);
    
    __block BOOL didRunCancelBlock = NO;
    [model.searchObserver addQueryCancelledEvent:^(WRLDSearchQuery *query) {
        didRunCancelBlock = YES;
    }];
    
    WRLDSearchQuery *query = [model getSearchResultsForString:testString];
    [query cancel];
    XCTAssertTrue(didRunCancelBlock);
}

- (void)testSearchCancelledMethodReceivesCancelledQuery
{
    id<WRLDSearchProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    [model addSearchProvider:mockProvider];
    
    __block WRLDSearchRequest *requestCapture = nil;
    
    OCMStub([mockProvider searchFor:[OCMArg checkWithBlock:^BOOL(WRLDSearchRequest* request){
        requestCapture = request;
        return YES;
    }]]);
    
    __block WRLDSearchQuery *capturedCancelledQuery;
    [model.searchObserver addQueryCancelledEvent:^(WRLDSearchQuery *query) {
        capturedCancelledQuery = query;
    }];
    __block BOOL didRunCompletedBlock = NO;
    [model.searchObserver addQueryCompletedEvent:^(WRLDSearchQuery *query) {
        didRunCompletedBlock = YES;
    }];
    
    WRLDSearchQuery *query = [model getSearchResultsForString:testString];
    [query cancel];
    
    XCTAssertFalse(didRunCompletedBlock);
    XCTAssertNotNil(capturedCancelledQuery);
    XCTAssertEqual(capturedCancelledQuery, query);
}


- (void)testSearchCancelledMethodNotInvokedOnCompletedQueryWithoutCancelling
{
    id<WRLDSearchProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    [model addSearchProvider:mockProvider];
    
    __block WRLDSearchRequest *requestCapture = nil;
    
    __block BOOL didCaptureRequest = NO;
    OCMStub([mockProvider searchFor:[OCMArg checkWithBlock:^BOOL(WRLDSearchRequest* request){
        requestCapture = request;
        didCaptureRequest = YES;
        return YES;
    }]]);
    
    __block BOOL didRunCancelBlock = NO;
    [model.searchObserver addQueryCancelledEvent:^(WRLDSearchQuery *query) {
        didRunCancelBlock = YES;
    }];
    __block BOOL didRunCompletedBlock = NO;
    [model.searchObserver addQueryCompletedEvent:^(WRLDSearchQuery *query) {
        didRunCompletedBlock = YES;
    }];
    
    [model getSearchResultsForString:testString];
    [requestCapture didComplete:YES withResults:[[WRLDSearchResultsCollection alloc]init]];
    
    XCTAssertTrue(didRunCompletedBlock);
    XCTAssertFalse(didRunCancelBlock);
}

- (void)testSearchCancelledMethodNotInvokedWhenCancelCalledOnCompletedQuery
{
    id<WRLDSearchProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    [model addSearchProvider:mockProvider];
    
    __block WRLDSearchRequest *requestCapture = nil;
    
    OCMStub([mockProvider searchFor:[OCMArg checkWithBlock:^BOOL(WRLDSearchRequest* request){
        requestCapture = request;
        return YES;
    }]]);
    
    __block BOOL didRunCancelBlock = NO;
    [model.searchObserver addQueryCancelledEvent:^(WRLDSearchQuery *query) {
        didRunCancelBlock = YES;
    }];
    __block BOOL didRunCompletedBlock = NO;
    [model.searchObserver addQueryCompletedEvent:^(WRLDSearchQuery *query) {
        didRunCompletedBlock = YES;
    }];
    
    WRLDSearchQuery *query = [model getSearchResultsForString:testString];
    [requestCapture didComplete:YES withResults:[[WRLDSearchResultsCollection alloc]init]];
    [query cancel];
    XCTAssertTrue(didRunCompletedBlock);
    XCTAssertFalse(didRunCancelBlock);
}

- (void) testSearchQueryWithNoContextProvidedHasNilContext
{
    WRLDSearchQuery *query = [model getSearchResultsForString:testString];
    XCTAssertNil(query.queryContext);
}

- (void) testSearchWithContextQueryContainsContext
{
    id<NSObject> mockContext = OCMProtocolMock(@protocol(NSObject));
    WRLDSearchQuery *query = [model getSearchResultsForString:testString withContext:mockContext];
    
    XCTAssertNotNil(query.queryContext);
    XCTAssertEqual(mockContext, query.queryContext);
}

- (void) testRequestContextMatchesQueryContextWhenContextExists
{
    id<WRLDSearchProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    [model addSearchProvider:mockProvider];
    
    __block WRLDSearchRequest *requestCapture = nil;
    
    OCMStub([mockProvider searchFor:[OCMArg checkWithBlock:^BOOL(WRLDSearchRequest* request){
        requestCapture = request;
        return YES;
    }]]);
    
    id<NSObject> mockContext = OCMProtocolMock(@protocol(NSObject));
    [model getSearchResultsForString:testString withContext:mockContext];
    
    XCTAssertEqual(mockContext, requestCapture.queryContext);
}

- (void) testRequestContextIsNilWhenNoContextExists
{
    id<WRLDSearchProvider> mockProvider = OCMProtocolMock(@protocol(WRLDSearchProvider));
    [model addSearchProvider:mockProvider];
    
    __block WRLDSearchRequest *requestCapture = nil;
    
    OCMStub([mockProvider searchFor:[OCMArg checkWithBlock:^BOOL(WRLDSearchRequest* request){
        requestCapture = request;
        return YES;
    }]]);
    
    [model getSearchResultsForString:testString];
    
    XCTAssertNil(requestCapture.queryContext);
}

@end
