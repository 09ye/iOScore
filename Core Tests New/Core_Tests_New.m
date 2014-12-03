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
NSThread * t;
- (void)testExample {
    // This is an example of a functional test case.
    t = [[NSThread alloc]initWithTarget:self selector:@selector(a:) object:nil];
    [t start];
    [NSThread sleepForTimeInterval:1000];
  }

- (void)a:(NSObject*)a
{
    XCTAssert(YES, @"Pass");
    [SHPrivateAPI debugguid];
    SHPostTaskM * post = [[SHPostTaskM alloc]init];
    SHEntironment.instance.loginName = @"14227";
    SHEntironment.instance.password = @"301236";
    post.URL = @"http://zambon-prod.mobilitychina.com:8091/get_config";

    [post start:^(SHTask *t) {
        XCTAssert(YES, @"Pass");
        
    } taskWillTry:^(SHTask *t) {
    } taskDidFailed:^(SHTask *t) {
        XCTAssert(NO, @"No_Pass");
        
    }];

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
