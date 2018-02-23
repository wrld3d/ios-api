//
//  WRLDPoiSearchCrossProviderQueryTests.m
//  WRLDSearchWidgetTests
//
//  Created by Michael O'Donnell on 12/02/2018.
//  Copyright © 2018 eeGeo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import "WRLDPoiServiceSearchProvider.h"

@interface WRLDPoiSearchCrossProviderQueryTests : XCTestCase

@end

@implementation WRLDPoiSearchCrossProviderQueryTests
{
    WRLDMapView* m_mockMapView;
    WRLDPoiService* m_mockPoiService;
    WRLDPoiServiceSearchProvider* m_searchProvider;
    
    NSString * m_cancelledRequestText;
    NSString * m_completedRequestText;
    
    WRLDPoiSearch * m_mockPoiSearchFirstRequest;
    WRLDPoiSearch * m_mockPoiSearchSecondRequest;
    int m_cancelledPoiSearchId;
    int m_completedPoiSearchId;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    m_cancelledPoiSearchId = 1;
    m_completedPoiSearchId = 2;
    
    m_cancelledRequestText = @"Cancelled";
    m_completedRequestText = @"Completed";
    
    [self createMocks];
    
    m_searchProvider = [[WRLDPoiServiceSearchProvider alloc] initWithMapViewAndPoiService:m_mockMapView poiService:m_mockPoiService];
}

- (void)createMocks {
    m_mockMapView = OCMClassMock([WRLDMapView class]);
    m_mockPoiService = OCMClassMock([WRLDPoiService class]);
    m_mockPoiSearchFirstRequest = OCMClassMock([WRLDPoiSearch class]);
    m_mockPoiSearchSecondRequest = OCMClassMock([WRLDPoiSearch class]);
    
    OCMStub([m_mockPoiSearchFirstRequest poiSearchId]).andReturn(m_cancelledPoiSearchId);
    OCMStub([m_mockPoiSearchSecondRequest poiSearchId]).andReturn(m_completedPoiSearchId);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testSuggestionsRequestCancelsInFlightSearchRequest {
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchFirstRequest);
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockPoiSearchSecondRequest);
    
    WRLDSearchRequest * firstRequest = OCMClassMock([WRLDSearchRequest class]);
    OCMStub([firstRequest hasCompleted]).andReturn(NO);
    [m_searchProvider searchFor:firstRequest];
    
    WRLDSearchRequest * secondRequest = OCMClassMock([WRLDSearchRequest class]);
    [m_searchProvider getSuggestions:secondRequest];
    
    OCMVerify([firstRequest cancel]);
}

- (void)testSearchRequestCancelsInFlightSuggestionRequest {
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockPoiSearchFirstRequest);
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchSecondRequest);
    
    WRLDSearchRequest * firstRequest = OCMClassMock([WRLDSearchRequest class]);
    OCMStub([firstRequest hasCompleted]).andReturn(NO);
    [m_searchProvider getSuggestions:firstRequest];
    
    WRLDSearchRequest * secondRequest = OCMClassMock([WRLDSearchRequest class]);
    [m_searchProvider searchFor:secondRequest];
    
    OCMVerify([firstRequest cancel]);
}

- (void)testSuggestionsRequestDoesNotCancelCompletedSearchRequest {
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchFirstRequest);
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockPoiSearchSecondRequest);
    
    WRLDSearchRequest * firstRequest = OCMClassMock([WRLDSearchRequest class]);
    OCMStub([firstRequest hasCompleted]).andReturn(YES);
    [m_searchProvider searchFor:firstRequest];
    
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchSecondRequest);
    
    WRLDSearchRequest * secondRequest = OCMClassMock([WRLDSearchRequest class]);
    [m_searchProvider getSuggestions:secondRequest];
    
    OCMReject([firstRequest cancel]);
}

- (void)testSearchRequestDoesNotCancelCompletedSuggestionRequest {
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockPoiSearchFirstRequest);
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchSecondRequest);
    
    WRLDSearchRequest * firstRequest = OCMClassMock([WRLDSearchRequest class]);
    OCMStub([firstRequest hasCompleted]).andReturn(YES);
    [m_searchProvider getSuggestions:firstRequest];
    
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchSecondRequest);
    
    WRLDSearchRequest * secondRequest = OCMClassMock([WRLDSearchRequest class]);
    [m_searchProvider searchFor:secondRequest];
    
    OCMReject([firstRequest cancel]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
