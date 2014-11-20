//
//  Core_Tests_New.m
//  Core Tests New
//
//  Created by sheely.paean.Nightshade on 10/30/14.
//  Copyright (c) 2014 zywang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Core-Prefix.pch"
@interface Core_Tests_New : XCTestCase

@end

@implementation Core_Tests_New

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
    XCTAssert(YES, @"Pass");
    NSData * date = [[NSData alloc]init];
    [SHBase64 encode:date];

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
