//
//  DynamicObjectTests.m
//  DynamicObjectTests
//
//  Created by 崔 明辉 on 16/5/10.
//  Copyright © 2016年 UED Center. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestObject.h"

@interface TestObject (XXX)

@property (nonatomic, strong) NSString *addString;

@property (nonatomic, weak) NSObject *weakObject;

@end

@interface DynamicObjectTests : XCTestCase

@property (nonatomic, strong) TestObject *anObject;

@end

@implementation DynamicObjectTests

- (void)setUp {
    [super setUp];
    self.anObject = [[TestObject alloc] init];
    self.anObject.weakObject = self;
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGetterSetter {
    self.anObject.addString = @"Testing";
    XCTAssertEqual(self.anObject.addString, @"Testing");
}

@end
