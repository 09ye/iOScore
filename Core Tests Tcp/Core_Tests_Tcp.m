//
//  Core_Tests_Tcp.m
//  Core Tests Tcp
//
//  Created by WSheely on 14-5-15.
//  Copyright (c) 2014年 zywang. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Core_Tests_Tcp : XCTestCase

@end

@implementation Core_Tests_Tcp

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
    SHMsgM * msg = [[SHMsgM alloc]init];
    [msg start];
}
@end
