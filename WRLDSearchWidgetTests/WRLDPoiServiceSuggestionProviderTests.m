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

@interface WRLDPoiServiceSuggestionProviderTests : XCTestCase

@end

@implementation WRLDPoiServiceSuggestionProviderTests
{
    NSString *m_expectedPoiSearchServiceTitle;
    NSString *m_expectedPoiSearchCellIdentifier;
    WRLDPoiServiceSearchProvider* m_searchProvider;
    
    WRLDMapView* m_mockMapView;
    WRLDPoiService* m_mockPoiService;
    
    WRLDPoiSearch * m_mockFirstPoiSearch;
    WRLDPoiSearch * m_mockSecondPoiSearch;
    
    NSString * m_mockResultTitleStub;
    NSString * m_mockResultSubTitleStub;
    NSString * m_mockResultIconKeyStub;
    CLLocationCoordinate2D m_mockResultPosition;
    
    NSString * m_cancelledQueryText;
    NSString * m_completedQueryText;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
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
    m_mockSecondPoiSearch = OCMClassMock([WRLDPoiSearch class]);
    m_mockFirstPoiSearch = OCMClassMock([WRLDPoiSearch class]);
    
    OCMStub([m_mockFirstPoiSearch poiSearchId]).andReturn(1);
    OCMStub([m_mockSecondPoiSearch poiSearchId]).andReturn(2);
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

-(void)testGetSuggestionsCallsQueryCompletionDelegateOnCompletion
{
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockFirstPoiSearch);
    
    WRLDSearchQuery * mockQuery = OCMClassMock([WRLDSearchQuery class]);
    [m_searchProvider getSuggestions:mockQuery];
    
    WRLDPoiSearchResponse * mockPoiSearchResponse = [self createSuccessResponse];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:1 poiSearchResponse:mockPoiSearchResponse];
    
    OCMVerify([mockQuery didComplete:[OCMArg any] withResults:[OCMArg any]]);
}

-(void)testGetSuggestionsCallsCompletionDelegateWithSuccessOnSuccessfulCompletion
{
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockFirstPoiSearch);
    
    WRLDSearchQuery * mockQuery = OCMClassMock([WRLDSearchQuery class]);
    [m_searchProvider getSuggestions:mockQuery];
    
    WRLDPoiSearchResponse * mockPoiSearchResponse = [self createSuccessResponse];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:1 poiSearchResponse:mockPoiSearchResponse];
    
    OCMVerify([mockQuery didComplete:YES withResults:[OCMArg any]]);
}

-(void)testGetSuggestionsCallsCompletionDelegateWithAllResultsOnSuccess
{
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockFirstPoiSearch);
    
    WRLDSearchQuery * mockQuery = OCMClassMock([WRLDSearchQuery class]);
    [m_searchProvider getSuggestions:mockQuery];
    
    NSInteger numMockResults = 10;
    
    WRLDPoiSearchResponse * mockPoiSearchResponse = [self createMockPoiSearchResponseWithSuccess:YES numResults: numMockResults];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:1 poiSearchResponse:mockPoiSearchResponse];
    
    OCMVerify([mockQuery didComplete:[OCMArg any] withResults:[OCMArg checkWithBlock:^BOOL(WRLDMutableSearchResultsCollection* resultsArray){
        return [resultsArray count] == numMockResults;
    }]]);
}

-(void)testGetSuggestionsCallsCompletionDelegateWithFailOnFailureToComplete
{
    WRLDPoiSearchResponse * mockPoiSearchResponse = [self createFailedResponse];
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockFirstPoiSearch);
    WRLDSearchQuery * mockQuery = OCMClassMock([WRLDSearchQuery class]);
    [m_searchProvider getSuggestions:mockQuery];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:1 poiSearchResponse:mockPoiSearchResponse];
    
    OCMVerify([mockQuery didComplete:NO withResults:[OCMArg any]]);
}

-(void)testGetSuggestionsCallsCompletionDelegateWithEmptyResultsOnFailure
{
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockFirstPoiSearch);
    
    WRLDSearchQuery * mockQuery = OCMClassMock([WRLDSearchQuery class]);
    [m_searchProvider getSuggestions:mockQuery];
    
    NSInteger numMockResults = 10;
    
    WRLDPoiSearchResponse * mockPoiSearchResponse = [self createMockPoiSearchResponseWithSuccess: NO numResults: numMockResults];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:1 poiSearchResponse:mockPoiSearchResponse];
    
    OCMVerify([mockQuery didComplete:NO withResults:[OCMArg checkWithBlock:^BOOL(WRLDMutableSearchResultsCollection * resultsArray){
        return [resultsArray count] == 0;
    }]]);
}

-(void)testGetSuggestionsCancelsPreviousQueryIfUnfulfilled
{
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockSecondPoiSearch);
    
    WRLDSearchQuery * queryToCancel = OCMClassMock([WRLDSearchQuery class]);
    OCMStub([queryToCancel hasCompleted]).andReturn(NO);
    [m_searchProvider getSuggestions:queryToCancel];
    
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockFirstPoiSearch);
    
    WRLDSearchQuery * queryToComplete = OCMClassMock([WRLDSearchQuery class]);
    [m_searchProvider getSuggestions:queryToComplete];
    
    OCMVerify([queryToCancel cancel]);
}

-(void)testGetSuggestionsDoesNotCancelPreviousQueryIfAlreadyFulfilled
{
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockSecondPoiSearch);
    
    WRLDSearchQuery * queryToCancel = OCMClassMock([WRLDSearchQuery class]);
    OCMStub([queryToCancel hasCompleted]).andReturn(YES);
    [m_searchProvider getSuggestions:queryToCancel];
    
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockFirstPoiSearch);
    
    WRLDSearchQuery * queryToComplete = OCMClassMock([WRLDSearchQuery class]);
    [m_searchProvider getSuggestions:queryToComplete];
    
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
    
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg checkWithBlock:^BOOL(WRLDTextSearchOptions* textSearchOptions){
        return [textSearchOptions.getQuery isEqualToString:m_cancelledQueryText];
    }]]).andReturn(m_mockFirstPoiSearch);
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg checkWithBlock:^BOOL(WRLDTextSearchOptions* textSearchOptions){
        return [textSearchOptions.getQuery isEqualToString:m_completedQueryText];
    }]]).andReturn(m_mockSecondPoiSearch);
    
    [m_searchProvider getSuggestions:queryToCancel];
    [m_searchProvider getSuggestions:queryToComplete];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:1 poiSearchResponse:mockCancelledQueryResponse];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:2 poiSearchResponse:mockCompletedQueryResponse];
    
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

