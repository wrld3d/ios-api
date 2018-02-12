//
//  WRLDPoiServiceSearchProviderTests.m
//  WRLDSearchWidgetTests
//
//  Created by Michael O'Donnell on 12/02/2018.
//  Copyright © 2018 eeGeo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import "WRLDPoiServiceSearchProvider.h"
#import "WRLDSearchQuery.h"

@interface WRLDPoiServiceSearchProviderTests : XCTestCase

@end

@implementation WRLDPoiServiceSearchProviderTests
{
    NSString *m_expectedPoiSearchServiceTitle;
    NSString *m_expectedPoiSearchCellIdentifier;
    WRLDPoiServiceSearchProvider* m_searchProvider;
    
    WRLDMapView* m_mockMapView;
    WRLDPoiService* m_mockPoiService;
    WRLDPoiSearch * m_mockPoiSearchToCompletion;
    WRLDPoiSearch * m_mockPoiSearchToCancel;
    
    NSString * m_mockResultTitleStub;
    NSString * m_mockResultSubTitleStub;
    NSString * m_mockResultIconKeyStub;
    CLLocationCoordinate2D m_mockResultPosition;
    
    NSString * m_cancelledQueryText;
    NSString * m_completedQueryText;
    
    int m_cancelledPoiSearchId;
    int m_completedPoiSearchId;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    m_expectedPoiSearchServiceTitle = @"WRLD";
    m_expectedPoiSearchCellIdentifier = @"WRLDSearchResultTableViewCell";
    m_searchProvider = nil;
    
    m_cancelledPoiSearchId = 1;
    m_completedPoiSearchId = 2;
    
    m_mockResultTitleStub = @"Title";
    m_mockResultSubTitleStub = @"SubTitle";
    
    m_cancelledQueryText = @"Cancelled";
    m_completedQueryText = @"Completed";
    
    [self createMocks];
    
    m_searchProvider = [[WRLDPoiServiceSearchProvider alloc] initWithMapViewAndPoiService:m_mockMapView poiService:m_mockPoiService];
}

- (void)createMocks {
    m_mockMapView = OCMClassMock([WRLDMapView class]);
    m_mockPoiService = OCMClassMock([WRLDPoiService class]);
    m_mockPoiSearchToCancel = OCMClassMock([WRLDPoiSearch class]);
    m_mockPoiSearchToCompletion = OCMClassMock([WRLDPoiSearch class]);
    
    OCMStub([m_mockPoiSearchToCancel poiSearchId]).andReturn(m_cancelledPoiSearchId);
    OCMStub([m_mockPoiSearchToCompletion poiSearchId]).andReturn(m_completedPoiSearchId);
}

-(WRLDPoiSearchResponse *) createFailedResponse
{
    WRLDPoiSearchResponse * mockPoiSearchResponse = OCMClassMock([WRLDPoiSearchResponse class]);
    OCMStub([mockPoiSearchResponse succeeded]).andReturn(NO);
    return mockPoiSearchResponse;
}

-(WRLDPoiSearchResponse *) createSuccessResponse
{
    WRLDPoiSearchResponse * mockPoiSearchResponse = OCMClassMock([WRLDPoiSearchResponse class]);
    OCMStub([mockPoiSearchResponse succeeded]).andReturn(YES);
    return mockPoiSearchResponse;
}

-(WRLDPoiSearchResponse *) createMockPoiSearchResponseWithSuccess:(BOOL) success numResults: (NSInteger) numResults
{
    WRLDPoiSearchResponse * mockPoiSearchResponse = success ? [self createSuccessResponse] : [self createFailedResponse];
    NSMutableArray<WRLDPoiSearchResult *> * mockResults = [[NSMutableArray<WRLDPoiSearchResult *>alloc] init];
    for(int i = 0; i < numResults; ++i)
    {
        WRLDPoiSearchResult* mockResult = OCMClassMock([WRLDPoiSearchResult class]);
        OCMStub([mockResult title]).andReturn(([NSString stringWithFormat:@"%@ %d", m_mockResultTitleStub, i]));
        OCMStub([mockResult subtitle]).andReturn(([NSString stringWithFormat:@"%@ %d", m_mockResultSubTitleStub, i]));
        OCMStub([mockResult latLng]).andReturn(CLLocationCoordinate2DMake(i, i));
        [mockResults addObject: mockResult];
    }
    
    OCMStub([mockPoiSearchResponse results]).andReturn(mockResults);
    return mockPoiSearchResponse;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitDoesNotReturnNil
{
    XCTAssertNotNil(m_searchProvider);
}

- (void)testInitAssignsExpectedTitle
{
    XCTAssertNotNil(m_searchProvider.title);
    XCTAssertTrue([m_expectedPoiSearchServiceTitle isEqualToString: m_searchProvider.title]);
}

- (void)testInitAssignsExpectedCellIdentifier
{
    XCTAssertNotNil(m_searchProvider.cellIdentifier);
    XCTAssertTrue([m_expectedPoiSearchCellIdentifier isEqualToString: m_searchProvider.cellIdentifier]);
}

-(void)testSearchForCallsQueryCompletionDelegateOnCompletion
{
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchToCompletion);
    
    WRLDSearchQuery * mockQuery = OCMClassMock([WRLDSearchQuery class]);
    [m_searchProvider searchFor:mockQuery];
    
    WRLDPoiSearchResponse * mockPoiSearchResponse = [self createSuccessResponse];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:m_completedPoiSearchId poiSearchResponse:mockPoiSearchResponse];
    
    OCMVerify([mockQuery didComplete:[OCMArg any] withResults:[OCMArg any]]);
}

-(void)testSearchForCallsCompletionDelegateWithSuccessOnSuccessfulCompletion
{
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchToCompletion);
    
    WRLDSearchQuery * mockQuery = OCMClassMock([WRLDSearchQuery class]);
    [m_searchProvider searchFor:mockQuery];
    
    WRLDPoiSearchResponse * mockPoiSearchResponse = [self createSuccessResponse];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:m_completedPoiSearchId poiSearchResponse:mockPoiSearchResponse];
    
    OCMVerify([mockQuery didComplete:YES withResults:[OCMArg any]]);
}

-(void)testSearchForCallsCompletionDelegateWithAllResultsOnSuccess
{
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchToCompletion);
    
    WRLDSearchQuery * mockQuery = OCMClassMock([WRLDSearchQuery class]);
    [m_searchProvider searchFor:mockQuery];
    
    NSInteger numMockResults = 10;
    
    WRLDPoiSearchResponse * mockPoiSearchResponse = [self createMockPoiSearchResponseWithSuccess:YES numResults: numMockResults];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:m_completedPoiSearchId poiSearchResponse:mockPoiSearchResponse];
    
    OCMVerify([mockQuery didComplete:[OCMArg any] withResults:[OCMArg checkWithBlock:^BOOL(WRLDMutableSearchResultsCollection* resultsArray){
        return [resultsArray count] == numMockResults;
    }]]);
}

-(void)testSearchForCallsCompletionDelegateWithFailOnFailureToComplete
{
    WRLDPoiSearchResponse * mockPoiSearchResponse = [self createFailedResponse];
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchToCompletion);
    WRLDSearchQuery * mockQuery = OCMClassMock([WRLDSearchQuery class]);
    [m_searchProvider searchFor:mockQuery];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:m_completedPoiSearchId poiSearchResponse:mockPoiSearchResponse];
    
    OCMVerify([mockQuery didComplete:NO withResults:[OCMArg any]]);
}

-(void)testSearchForCallsCompletionDelegateWithEmptyResultsOnFailure
{
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchToCompletion);
    
    WRLDSearchQuery * mockQuery = OCMClassMock([WRLDSearchQuery class]);
    [m_searchProvider searchFor:mockQuery];
    
    NSInteger numMockResults = 10;
    
    WRLDPoiSearchResponse * mockPoiSearchResponse = [self createMockPoiSearchResponseWithSuccess: NO numResults: numMockResults];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:m_completedPoiSearchId poiSearchResponse:mockPoiSearchResponse];
    
    OCMVerify([mockQuery didComplete:NO withResults:[OCMArg checkWithBlock:^BOOL(WRLDMutableSearchResultsCollection * resultsArray){
        return [resultsArray count] == 0;
    }]]);
}

-(void)testSearchForCancelsPreviousQueryIfUnfulfilled
{
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchToCancel);
    
    WRLDSearchQuery * queryToCancel = OCMClassMock([WRLDSearchQuery class]);
    OCMStub([queryToCancel hasCompleted]).andReturn(NO);
    [m_searchProvider searchFor:queryToCancel];
    
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchToCompletion);
    
    WRLDSearchQuery * queryToComplete = OCMClassMock([WRLDSearchQuery class]);
    [m_searchProvider searchFor:queryToComplete];
    
    OCMVerify([queryToCancel cancel]);
}

-(void)testSearchForDoesNotCancelPreviousQueryIfAlreadyFulfilled
{
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchToCancel);
    
    WRLDSearchQuery * queryToCancel = OCMClassMock([WRLDSearchQuery class]);
    OCMStub([queryToCancel hasCompleted]).andReturn(YES);
    [m_searchProvider searchFor:queryToCancel];
    
    OCMStub([m_mockPoiService searchText:[OCMArg any]]).andReturn(m_mockPoiSearchToCompletion);
    
    WRLDSearchQuery * queryToComplete = OCMClassMock([WRLDSearchQuery class]);
    [m_searchProvider searchFor:queryToComplete];
    
    OCMReject([queryToCancel cancel]);
}

-(void)testCancelledQueryResponsesNotReturnedToLaterQueries
{
    WRLDSearchQuery * queryToCancel = OCMClassMock([WRLDSearchQuery class]);
    OCMStub([queryToCancel queryString]).andReturn(m_cancelledQueryText);
    WRLDSearchQuery * queryToComplete = OCMClassMock([WRLDSearchQuery class]);
    OCMStub([queryToComplete queryString]).andReturn(m_completedQueryText);
    NSInteger numCancelledQueryResults = 10;
    NSInteger numCompletedQueryResults = 20;
    
    WRLDPoiSearchResponse * mockCancelledQueryResponse = [self createMockPoiSearchResponseWithSuccess:YES numResults: numCancelledQueryResults];
    WRLDPoiSearchResponse * mockCompletedQueryResponse = [self createMockPoiSearchResponseWithSuccess:YES numResults: numCompletedQueryResults];
    
    OCMStub([m_mockPoiService searchText:[OCMArg checkWithBlock:^BOOL(WRLDTextSearchOptions* textSearchOptions){
        return [textSearchOptions.getQuery isEqualToString:m_cancelledQueryText];
    }]]).andReturn(m_mockPoiSearchToCancel);
    OCMStub([m_mockPoiService searchText:[OCMArg checkWithBlock:^BOOL(WRLDTextSearchOptions* textSearchOptions){
        return [textSearchOptions.getQuery isEqualToString:m_completedQueryText];
    }]]).andReturn(m_mockPoiSearchToCompletion);
    
    [m_searchProvider searchFor:queryToCancel];
    [m_searchProvider searchFor:queryToComplete];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:m_cancelledPoiSearchId poiSearchResponse:mockCancelledQueryResponse];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:m_completedPoiSearchId poiSearchResponse:mockCompletedQueryResponse];
    
    OCMVerify([queryToComplete didComplete:YES withResults:[OCMArg checkWithBlock:^BOOL(WRLDMutableSearchResultsCollection* resultsArray){
        if([resultsArray count] == numCancelledQueryResults)
        {
            XCTFail();
        }
        return [resultsArray count] == numCompletedQueryResults;
    }]]);
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
