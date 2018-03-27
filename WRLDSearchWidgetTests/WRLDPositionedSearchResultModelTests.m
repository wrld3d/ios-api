//
//  WRLDPositionedSearchResultModel.m
//  WRLDSearchWidgetTests
//
//  Created by Michael O'Donnell on 12/02/2018.
//  Copyright © 2018 eeGeo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WRLDPositionedSearchResultModel.h"

@interface WRLDPositionedSearchResultModelTests : XCTestCase

@end

@implementation WRLDPositionedSearchResultModelTests
{
    WRLDPositionedSearchResultModel * model;
    NSString *m_testTitle;
    NSString *m_testSubTitle;
    NSString *m_testIconKey;
    CLLocationCoordinate2D m_testLatLng;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    m_testTitle = @"Test Title";
    m_testSubTitle = @"Test SubTitle";
    m_testIconKey = @"Test IconKey";
    m_testLatLng = CLLocationCoordinate2DMake(56.4620, 2.9707);
    
    model = [[WRLDPositionedSearchResultModel alloc] initWithTitle:m_testTitle
                                                          subTitle:m_testSubTitle
                                                           iconKey:m_testIconKey
                                                          latLng:m_testLatLng];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitDoesNotReturnNil
{
    XCTAssertNotNil(model);
}

- (void)testInitCorrectlyAssignsTitle
{
    XCTAssertNotNil(model.title);
    XCTAssertEqual(model.title, m_testTitle);
}

- (void)testInitCorrectlyAssignsSubTitle
{
    XCTAssertNotNil(model.subTitle);
    XCTAssertEqual(model.subTitle, m_testSubTitle);
}

- (void)testInitCorrectlyAssignsIconKey
{
    XCTAssertNotNil(model.iconKey);
    XCTAssertEqual(model.iconKey, m_testIconKey);
}

- (void)testInitCorrectlyAssignsPosition
{
    XCTAssertEqual(model.latLng.latitude, m_testLatLng.latitude);
    XCTAssertEqual(model.latLng.longitude, m_testLatLng.longitude);
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
