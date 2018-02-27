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
    __block BOOL callbackInvoked = NO;
    [m_style call:^(UIColor *color) {
        callbackInvoked = YES;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style apply];
    XCTAssertTrue(callbackInvoked);
}

- (void)testStyleCallbacksNotTriggeredBeforeApply {
    __block BOOL callbackInvoked = NO;
    [m_style call:^(UIColor *color) {
        callbackInvoked = YES;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    XCTAssertFalse(callbackInvoked);
}

- (void)testStyleUpdatesReceivesCorrectColor {
    __block BOOL callbackInvoked = NO;
    [m_style call:^(UIColor *color) {
        XCTAssertEqual(color, testColor1);
        callbackInvoked = YES;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style apply];
    XCTAssertTrue(callbackInvoked);
}

- (void)testStyleUpdatesOnlyAppliedWhenColorChanges
{
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style apply];
    
    __block BOOL callbackInvoked = NO;
    [m_style call:^(UIColor *color) {
        callbackInvoked = YES;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style apply];
    XCTAssertFalse(callbackInvoked);
}

- (void)testStyleUpdatesOnlyAppliedOnceWhenColorChangesMultipleTimesBetweenApplies {
    
    __block int callbackInvokedCount = 0;
    [m_style call:^(UIColor *color) {
        ++callbackInvokedCount;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style usesColor:testColor2 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style apply];
    XCTAssertEqual(1, callbackInvokedCount);
}

- (void)testStyleUpdatesUsesCorrectColorWhenColorChangesMultipleTimesBetweenApplies {
    
    __block BOOL callbackInvoked = NO;
    [m_style call:^(UIColor *color) {
        XCTAssertEqual(color, testColor2);
        callbackInvoked = YES;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style usesColor:testColor2 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style apply];
    XCTAssertTrue(callbackInvoked);
}

- (void)testStyleUpdatesOnlyCalledForChangedStyles {
    
    __block BOOL primaryColorCallbackInvoked = NO;
    [m_style call:^(UIColor *color) {
        primaryColorCallbackInvoked = YES;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    [m_style call:^(UIColor *color) {
        XCTFail();
    } whenUpdated:WRLDSearchWidgetStyleSecondaryColor];
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style apply];
    XCTAssertTrue(primaryColorCallbackInvoked);
}

- (void)testStyleCallbackCalledForAllChangedStyles {
    
    __block BOOL primaryColorCallbackInvoked = NO;
    __block BOOL secondaryColorCallbackInvoked = NO;
    [m_style call:^(UIColor *color) {
        primaryColorCallbackInvoked = YES;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    [m_style call:^(UIColor *color) {
        secondaryColorCallbackInvoked = YES;
    } whenUpdated:WRLDSearchWidgetStyleSecondaryColor];
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style usesColor:testColor2 forStyle:WRLDSearchWidgetStyleSecondaryColor];
    [m_style apply];
    XCTAssertTrue(primaryColorCallbackInvoked);
    XCTAssertTrue(secondaryColorCallbackInvoked);
}

- (void)testStyleCallbacksForChangedStylesUseAssignedColors {

    __block BOOL primaryColorCallbackInvoked = NO;
    __block BOOL secondaryColorCallbackInvoked = NO;
    [m_style call:^(UIColor *color) {
        XCTAssertEqual(color, testColor1);
        primaryColorCallbackInvoked = YES;
    } whenUpdated:WRLDSearchWidgetStylePrimaryColor];
    [m_style call:^(UIColor *color) {
        XCTAssertEqual(color, testColor2);
        secondaryColorCallbackInvoked = YES;
    } whenUpdated:WRLDSearchWidgetStyleSecondaryColor];
    
    [m_style usesColor:testColor1 forStyle:WRLDSearchWidgetStylePrimaryColor];
    [m_style usesColor:testColor2 forStyle:WRLDSearchWidgetStyleSecondaryColor];
    [m_style apply];
    XCTAssertTrue(primaryColorCallbackInvoked);
    XCTAssertTrue(secondaryColorCallbackInvoked);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
