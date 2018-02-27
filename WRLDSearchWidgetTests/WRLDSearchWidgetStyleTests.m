//
//  WRLDSearchWidgetStyleTests.m
//  WrldSearchWidgetTests
//
//  Created by Michael O'Donnell on 26/02/2018.
//  Copyright © 2018 eeGeo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "WRLDSearchWidgetStyle.h"

@interface WRLDSearchWidgetStyleTests : XCTestCase

@end

@implementation WRLDSearchWidgetStyleTests
{
    WRLDSearchWidgetStyle* m_style;
    UIColor * testColor1;
    UIColor * testColor2;
}

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    m_style = [[WRLDSearchWidgetStyle alloc] init];
    testColor1 = [UIColor colorWithRed:0.1 green:0.3 blue:0.5 alpha:0.7];
    testColor2 = [UIColor colorWithRed:0.2 green:0.4 blue:0.6 alpha:0.8];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testStyleCallbacksTriggeredByApply {
    __block int callbackInvokedCount = 0;
    [m_style call:^(UIColor *color) {
        callbackInvokedCount++;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style apply];
    XCTAssertEqual(2, callbackInvokedCount);
}

- (void)testStyleCallbacksNotTriggeredBeforeApply {
    __block int callbackInvokedCount = 0;
    [m_style call:^(UIColor *color) {
        callbackInvokedCount++;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    XCTAssertEqual(1, callbackInvokedCount);
}

- (void)testStyleUpdateInvokedOnAssignment {
    __block int callbackInvokedCount = 0;
    [m_style call:^(UIColor *color) {
        callbackInvokedCount++;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    XCTAssertEqual(1, callbackInvokedCount);
}

- (void)testStyleUpdateInvokedOnAssignmentReceivesCorrectColor {
    
    __block int callbackInvokedCount = 0;
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style apply];
    
    [m_style call:^(UIColor *color) {
        XCTAssertEqual(color, testColor1);
        callbackInvokedCount++;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    
    XCTAssertEqual(1, callbackInvokedCount);
}

- (void)testStyleUpdateInvokedOnAssignmentDoesNotReceiveUnappliedColor {
    
    __block int callbackInvokedCount = 0;
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style apply];
    [m_style usesColor:testColor2 forStyle:WRLDSearchWidgetStylePrimaryColor];
    
    [m_style call:^(UIColor *color) {
        XCTAssertEqual(color, testColor1);
        callbackInvokedCount++;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    
    XCTAssertEqual(1, callbackInvokedCount);
}

- (void)testStyleUpdatesReceivesCorrectColor {
    __block int callbackInvokedCount = 0;
    [m_style call:^(UIColor *color) {
        if(callbackInvokedCount == 1)
        {
            XCTAssertEqual(color, testColor1);
        }
        callbackInvokedCount++;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style apply];
    XCTAssertEqual(2, callbackInvokedCount);
}

- (void)testStyleUpdatesOnlyAppliedWhenColorChanges
{
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style apply];
    
    __block int callbackInvokedCount = 0;
    [m_style call:^(UIColor *color) {
        callbackInvokedCount++;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style apply];
    
    XCTAssertEqual(1, callbackInvokedCount);
}

- (void)testStyleUpdatesOnlyAppliedOnceWhenColorChangesMultipleTimesBetweenApplies {
    
    __block int callbackInvokedCount = 0;
    [m_style call:^(UIColor *color) {
        ++callbackInvokedCount;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style usesColor:testColor2 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style apply];
    XCTAssertEqual(2, callbackInvokedCount);
}

- (void)testStyleUpdatesUsesCorrectColorWhenColorChangesMultipleTimesBetweenApplies {
    
    __block int callbackInvokedCount = 0;
    [m_style call:^(UIColor *color) {
        if(callbackInvokedCount == 1)
        {
            XCTAssertEqual(color, testColor2);
        }
        callbackInvokedCount++;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style usesColor:testColor2 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style apply];
    XCTAssertEqual(2, callbackInvokedCount);
}

- (void)testStyleUpdatesOnlyCalledForChangedStyles {
    
    __block int primaryColorCallbackInvokedCount = 0;
    __block int secondaryColorCallbackInvokedCount = 0;
    [m_style call:^(UIColor *color) {
        primaryColorCallbackInvokedCount++;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    [m_style call:^(UIColor *color) {
        if(secondaryColorCallbackInvokedCount > 0)
        {
            XCTFail();
        }
        secondaryColorCallbackInvokedCount++;
    } whenUpdated:WRLDSearchWidgetStyleSecondaryColor];
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style apply];
    XCTAssertEqual(2, primaryColorCallbackInvokedCount);
}

- (void)testStyleCallbackCalledForAllChangedStyles {
    
    __block int primaryColorCallbackInvokedCount = 0;
    __block int secondaryColorCallbackInvokedCount = 0;
    [m_style call:^(UIColor *color) {
        primaryColorCallbackInvokedCount++;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    [m_style call:^(UIColor *color) {
        secondaryColorCallbackInvokedCount++;
    } whenUpdated:WRLDSearchWidgetStyleSecondaryColor];
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style usesColor:testColor2 forStyle:WRLDSearchWidgetStyleSecondaryColor];
    [m_style apply];
    XCTAssertEqual(2, primaryColorCallbackInvokedCount);
    XCTAssertEqual(2, secondaryColorCallbackInvokedCount);
}

- (void)testStyleCallbacksForChangedStylesUseAssignedColors {

    __block int primaryColorCallbackInvokedCount = 0;
    __block int secondaryColorCallbackInvokedCount = 0;
    [m_style call:^(UIColor *color) {
        if(primaryColorCallbackInvokedCount > 0)
        {
            XCTAssertEqual(color, testColor1);
        }
        primaryColorCallbackInvokedCount++;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    [m_style call:^(UIColor *color) {
        if(secondaryColorCallbackInvokedCount > 0)
        {
            XCTAssertEqual(color, testColor2);
        }
        secondaryColorCallbackInvokedCount++;
    } whenUpdated:WRLDSearchWidgetStyleSecondaryColor];
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style usesColor:testColor2 forStyle:WRLDSearchWidgetStyleSecondaryColor];
    [m_style apply];
    XCTAssertEqual(2, primaryColorCallbackInvokedCount++);
    XCTAssertEqual(2, secondaryColorCallbackInvokedCount++);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
