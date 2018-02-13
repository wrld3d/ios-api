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
#import "WRLDSearchRequest.h"

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
    
    NSString * m_cancelledRequestText;
    NSString * m_completedRequestText;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    m_mockResultTitleStub = @"Title";
    m_mockResultSubTitleStub = @"SubTitle";
    
    m_cancelledRequestText = @"Cancelled";
    m_completedRequestText = @"Completed";
    
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

-(void)testGetSuggestionsCallsRequestCompletionDelegateOnCompletion
{
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockFirstPoiSearch);
    
    WRLDSearchRequest * mockRequest = OCMClassMock([WRLDSearchRequest class]);
    [m_searchProvider getSuggestions:mockRequest];
    
    WRLDPoiSearchResponse * mockPoiSearchResponse = [self createSuccessResponse];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:1 poiSearchResponse:mockPoiSearchResponse];
    
    OCMVerify([mockRequest didComplete:[OCMArg any] withResults:[OCMArg any]]);
}

-(void)testGetSuggestionsCallsCompletionDelegateWithSuccessOnSuccessfulCompletion
{
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockFirstPoiSearch);
    
    WRLDSearchRequest * mockRequest = OCMClassMock([WRLDSearchRequest class]);
    [m_searchProvider getSuggestions:mockRequest];
    
    WRLDPoiSearchResponse * mockPoiSearchResponse = [self createSuccessResponse];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:1 poiSearchResponse:mockPoiSearchResponse];
    
    OCMVerify([mockRequest didComplete:YES withResults:[OCMArg any]]);
}

-(void)testGetSuggestionsCallsCompletionDelegateWithAllResultsOnSuccess
{
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockFirstPoiSearch);
    
    WRLDSearchRequest * mockRequest = OCMClassMock([WRLDSearchRequest class]);
    [m_searchProvider getSuggestions:mockRequest];
    
    NSInteger numMockResults = 10;
    
    WRLDPoiSearchResponse * mockPoiSearchResponse = [self createMockPoiSearchResponseWithSuccess:YES numResults: numMockResults];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:1 poiSearchResponse:mockPoiSearchResponse];
    
    OCMVerify([mockRequest didComplete:[OCMArg any] withResults:[OCMArg checkWithBlock:^BOOL(WRLDMutableSearchResultsCollection* resultsArray){
        return [resultsArray count] == numMockResults;
    }]]);
}

-(void)testGetSuggestionsCallsCompletionDelegateWithFailOnFailureToComplete
{
    WRLDPoiSearchResponse * mockPoiSearchResponse = [self createFailedResponse];
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockFirstPoiSearch);
    WRLDSearchRequest * mockRequest = OCMClassMock([WRLDSearchRequest class]);
    [m_searchProvider getSuggestions:mockRequest];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:1 poiSearchResponse:mockPoiSearchResponse];
    
    OCMVerify([mockRequest didComplete:NO withResults:[OCMArg any]]);
}

-(void)testGetSuggestionsCallsCompletionDelegateWithEmptyResultsOnFailure
{
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockFirstPoiSearch);
    
    WRLDSearchRequest * mockRequest = OCMClassMock([WRLDSearchRequest class]);
    [m_searchProvider getSuggestions:mockRequest];
    
    NSInteger numMockResults = 10;
    
    WRLDPoiSearchResponse * mockPoiSearchResponse = [self createMockPoiSearchResponseWithSuccess: NO numResults: numMockResults];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:1 poiSearchResponse:mockPoiSearchResponse];
    
    OCMVerify([mockRequest didComplete:NO withResults:[OCMArg checkWithBlock:^BOOL(WRLDMutableSearchResultsCollection * resultsArray){
        return [resultsArray count] == 0;
    }]]);
}

-(void)testGetSuggestionsCancelsPreviousRequestIfUnfulfilled
{
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockSecondPoiSearch);
    
    WRLDSearchRequest * requestToCancel = OCMClassMock([WRLDSearchRequest class]);
    OCMStub([requestToCancel hasCompleted]).andReturn(NO);
    [m_searchProvider getSuggestions:requestToCancel];
    
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockFirstPoiSearch);
    
    WRLDSearchRequest * requestToComplete = OCMClassMock([WRLDSearchRequest class]);
    [m_searchProvider getSuggestions:requestToComplete];
    
    OCMVerify([requestToCancel cancel]);
}

-(void)testGetSuggestionsDoesNotCancelPreviousRequestIfAlreadyFulfilled
{
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockSecondPoiSearch);
    
    WRLDSearchRequest * requestToCancel = OCMClassMock([WRLDSearchRequest class]);
    OCMStub([requestToCancel hasCompleted]).andReturn(YES);
    [m_searchProvider getSuggestions:requestToCancel];
    
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg any]]).andReturn(m_mockFirstPoiSearch);
    
    WRLDSearchRequest * requestToComplete = OCMClassMock([WRLDSearchRequest class]);
    [m_searchProvider getSuggestions:requestToComplete];
    
    OCMReject([requestToCancel cancel]);
}

-(void)testCancelledRequestResponsesNotReturnedToLaterQueries
{
    WRLDSearchRequest * requestToCancel = OCMClassMock([WRLDSearchRequest class]);
    OCMStub([requestToCancel queryString]).andReturn(m_cancelledRequestText);
    WRLDSearchRequest * requestToComplete = OCMClassMock([WRLDSearchRequest class]);
    OCMStub([requestToComplete queryString]).andReturn(m_completedRequestText);
    NSInteger numCancelledRequestResults = 10;
    NSInteger numCompletedRequestResults = 20;
    
    WRLDPoiSearchResponse * mockCancelledRequestResponse = [self createMockPoiSearchResponseWithSuccess:YES numResults: numCancelledRequestResults];
    WRLDPoiSearchResponse * mockCompletedRequestResponse = [self createMockPoiSearchResponseWithSuccess:YES numResults: numCompletedRequestResults];
    
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg checkWithBlock:^BOOL(WRLDTextSearchOptions* textSearchOptions){
        return [textSearchOptions.getQuery isEqualToString:m_cancelledRequestText];
    }]]).andReturn(m_mockFirstPoiSearch);
    OCMStub([m_mockPoiService searchAutocomplete:[OCMArg checkWithBlock:^BOOL(WRLDTextSearchOptions* textSearchOptions){
        return [textSearchOptions.getQuery isEqualToString:m_completedRequestText];
    }]]).andReturn(m_mockSecondPoiSearch);
    
    [m_searchProvider getSuggestions:requestToCancel];
    [m_searchProvider getSuggestions:requestToComplete];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:1 poiSearchResponse:mockCancelledRequestResponse];
    [m_searchProvider mapView:m_mockMapView poiSearchDidComplete:2 poiSearchResponse:mockCompletedRequestResponse];
    
    OCMVerify([requestToComplete didComplete:YES withResults:[OCMArg checkWithBlock:^BOOL(WRLDMutableSearchResultsCollection* resultsArray){
        if([resultsArray count] == numCancelledRequestResults)
        {
            XCTFail();
        }
        return [resultsArray count] == numCompletedRequestResults;
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

