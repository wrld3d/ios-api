//
//  WRLDAsyncImageLoadResponseTests.m
//  WrldSearchWidgetTests
//
//  Created by Michael O'Donnell on 22/03/2018.
//  Copyright © 2018 eeGeo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "WRLDAsyncImageLoadResponse.h"

@interface WRLDAsyncImageLoadResponseTests : XCTestCase

@end

@implementation WRLDAsyncImageLoadResponseTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testCancellationInvokesCallback {
    __block BOOL cancellationCallbackInvoked = NO;
    WRLDAsyncImageLoadResponse* response = [[WRLDAsyncImageLoadResponse alloc] initWithAssignmentCallback:
                                            ^(UIImage * image) {
                                                XCTFail();
                                            }
                                                                                 cancellationCallback:
                                            ^{
                                                cancellationCallbackInvoked = YES;
                                            }];
    [response cancel];
    XCTAssertTrue(cancellationCallbackInvoked);
}

- (void)testMultipleCancellationInvokesCallbackOnlyOnce {
    __block int cancellationCallbackInvokeCount = 0;
    WRLDAsyncImageLoadResponse* response = [[WRLDAsyncImageLoadResponse alloc] initWithAssignmentCallback:
                                            ^(UIImage * image) {
                                                XCTFail();
                                            }
                                                                                     cancellationCallback:
                                            ^{
                                                ++cancellationCallbackInvokeCount;
                                            }];
    [response cancel];
    [response cancel];
    XCTAssertEqual(1, cancellationCallbackInvokeCount);
}

- (void)testSetImageInvokesCallback {
    __block BOOL imageSetCallbackInvoked = NO;
    WRLDAsyncImageLoadResponse* response = [[WRLDAsyncImageLoadResponse alloc] initWithAssignmentCallback:
                                            ^(UIImage * image) {
                                                imageSetCallbackInvoked = YES;
                                            }
                                                                                     cancellationCallback:
                                            ^{
                                                XCTFail();
                                            }];
    [response assignImage: OCMClassMock([UIImage class])];
    XCTAssertTrue(imageSetCallbackInvoked);
}

- (void)testSetImageInvokesCallbackEachTime {
    __block int setImageCallbackInvokeCount = 0;
    WRLDAsyncImageLoadResponse* response = [[WRLDAsyncImageLoadResponse alloc] initWithAssignmentCallback:
                                            ^(UIImage * image) {
                                                setImageCallbackInvokeCount++;
                                            }
                                                                                     cancellationCallback:
                                            ^{
                                                XCTFail();
                                            }];
    [response assignImage: OCMClassMock([UIImage class])];
    [response assignImage: OCMClassMock([UIImage class])];
    XCTAssertEqual(2, setImageCallbackInvokeCount);
}

- (void)testSetImagePassesExpectedImageToCallback {
    UIImage* mockImage = OCMClassMock([UIImage class]);
    __block BOOL imageSetCallbackInvoked = NO;
    WRLDAsyncImageLoadResponse* response = [[WRLDAsyncImageLoadResponse alloc] initWithAssignmentCallback:
                                            ^(UIImage * image) {
                                                imageSetCallbackInvoked = YES;
                                                XCTAssertEqual(image, mockImage);
                                            }
                                                                                     cancellationCallback:
                                            ^{
                                                XCTFail();
                                            }];
    [response assignImage: mockImage];
    XCTAssertTrue(imageSetCallbackInvoked);
}

- (void)testSetImageDoesNotInvokeCallbackAfterCancellation {
    __block BOOL imageSetCallbackInvoked = NO;
    __block BOOL cancellationCallbackInvoked = NO;
    WRLDAsyncImageLoadResponse* response = [[WRLDAsyncImageLoadResponse alloc] initWithAssignmentCallback:
                                            ^(UIImage * image) {
                                                imageSetCallbackInvoked = YES;
                                            }
                                                                                     cancellationCallback:
                                            ^{
                                                cancellationCallbackInvoked = YES;
                                            }];
    [response cancel];
    [response assignImage: OCMClassMock([UIImage class])];
    XCTAssertTrue(cancellationCallbackInvoked);
    XCTAssertFalse(imageSetCallbackInvoked);
}

- (void)testSetImageAfterCancellationWithNoCancellationBlockDoesNotInvokeSetImageCallback {
    __block BOOL imageSetCallbackInvoked = NO;
    WRLDAsyncImageLoadResponse* response = [[WRLDAsyncImageLoadResponse alloc] initWithAssignmentCallback:
                                            ^(UIImage * image) {
                                                imageSetCallbackInvoked = YES;
                                            }];
    [response cancel];
    [response assignImage: OCMClassMock([UIImage class])];
    XCTAssertFalse(imageSetCallbackInvoked);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
