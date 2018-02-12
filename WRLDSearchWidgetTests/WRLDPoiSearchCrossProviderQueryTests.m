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
#import "WRLDSearchQuery.h"

@interface WRLDPoiSearchCrossProviderQueryTests : XCTestCase

@end

@implementation WRLDPoiSearchCrossProviderQueryTests
{
    WRLDMapView* m_mockMapView;
    WRLDPoiService* m_mockPoiService;
    WRLDPoiServiceSearchProvider* m_searchProvider;
    
    NSString * m_cancelledQueryText;
    NSString * m_completedQueryText;
    
    WRLDPoiSearch * m_mockPoiSearchFirstQuery;
    WRLDPoiSearch * m_mockPoiSearchSecondQuery;
    int m_cancelledPoiSearchId;
    int m_completedPoiSearchId;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    m_cancelledPoiSearchId = 1;
    m_completedPoiSearchId = 2;
    
    m_cancelledQueryText = @"Cancelled";
    m_completedQueryText = @"Completed";
    
    [self createMocks];
    
    m_searchProvider = [[WRLDPoiServiceSearchProvider alloc] initWithMapViewAndPoiService:m_mockMapView poiService:m_mockPoiService];
}

- (void)createMocks {
    m_mockMapView = OCMClassMock([WRLDMapView class]);
    m_mockPoiService = OCMClassMock([WRLDPoiService class]);
    m_mockPoiSearchFirstQuery = OCMClassMock([WRLDPoiSearch class]);
    m_mockPoiSearchSecondQuery = OCMClassMock([WRLDPoiSearch class]);
    
    OCMStub([m_mockPoiSearchFirstQuery poiSearchId]).andReturn(m_cancelledPoiSearchId);
    OCMStub([m_mockPoiSearchSecondQuery poiSearchId]).andReturn(m_completedPoiSearchId);
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testSuggestionsQueryCancelsInFlightSearchQuery {
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchFirstQuery);
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockPoiSearchSecondQuery);
    
    WRLDSearchQuery * firstQuery = OCMClassMock([WRLDSearchQuery class]);
    OCMStub([firstQuery hasCompleted]).andReturn(NO);
    [m_searchProvider searchFor:firstQuery];
    
    WRLDSearchQuery * secondQuery = OCMClassMock([WRLDSearchQuery class]);
    [m_searchProvider getSuggestions:secondQuery];
    
    OCMVerify([firstQuery cancel]);
}

- (void)testSearchQueryCancelsInFlightSuggestionQuery {
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockPoiSearchFirstQuery);
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchSecondQuery);
    
    WRLDSearchQuery * firstQuery = OCMClassMock([WRLDSearchQuery class]);
    OCMStub([firstQuery hasCompleted]).andReturn(NO);
    [m_searchProvider getSuggestions:firstQuery];
    
    WRLDSearchQuery * secondQuery = OCMClassMock([WRLDSearchQuery class]);
    [m_searchProvider searchFor:secondQuery];
    
    OCMVerify([firstQuery cancel]);
}

- (void)testSuggestionsQueryDoesNotCancelCompletedSearchQuery {
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchFirstQuery);
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockPoiSearchSecondQuery);
    
    WRLDSearchQuery * firstQuery = OCMClassMock([WRLDSearchQuery class]);
    OCMStub([firstQuery hasCompleted]).andReturn(YES);
    [m_searchProvider searchFor:firstQuery];
    
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchSecondQuery);
    
    WRLDSearchQuery * secondQuery = OCMClassMock([WRLDSearchQuery class]);
    [m_searchProvider getSuggestions:secondQuery];
    
    OCMReject([firstQuery cancel]);
}

- (void)testSearchQueryDoesNotCancelCompletedSuggestionQuery {
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockPoiSearchFirstQuery);
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchSecondQuery);
    
    WRLDSearchQuery * firstQuery = OCMClassMock([WRLDSearchQuery class]);
    OCMStub([firstQuery hasCompleted]).andReturn(YES);
    [m_searchProvider getSuggestions:firstQuery];
    
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchSecondQuery);
    
    WRLDSearchQuery * secondQuery = OCMClassMock([WRLDSearchQuery class]);
    [m_searchProvider searchFor:secondQuery];
    
    OCMReject([firstQuery cancel]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
