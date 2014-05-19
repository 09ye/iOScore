//
//  Core_Tests.m
//  Core Tests
//
//  Created by WSheely on 14-5-16.
//  Copyright (c) 2014年 zywang. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Core_Tests : XCTestCase

@end

@implementation Core_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    NSThread* thread =   [[NSThread alloc]initWithTarget:self selector:@selector(thread:) object:nil];
    [thread start];
    [NSThread sleepForTimeInterval:100005];
    
}
- (void)thread:(NSObject*)sender
{
    while (true) {
        SHMsgM * msg = [[SHMsgM alloc]init];
        [msg start];
        [NSThread sleepForTimeInterval:5];

    }
}

@end
