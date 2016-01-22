//
//  PlanningCenterRouterTests.m
//  PlanningCenterRouterTests
//
//  Created by Skylar Schipper on 1/22/16.
//  Copyright © 2016 Ministry Centered Technology. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <PlanningCenterRouter/PlanningCenterRouter.h>

@interface PlanningCenterRouterTests : XCTestCase

@property (nonatomic, strong) PCRRouter *router;

@end

@interface TestURLHandler : NSObject <PCRRoutingHandler>

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSDictionary *params;

@end

@interface TestInvalidURLHandler : TestURLHandler

@end

@implementation PlanningCenterRouterTests

- (void)setUp {
    [super setUp];

    self.router = [[PCRRouter alloc] init];
}

- (void)testSimplePath {
    [self.router installHandlerForPath:@"/plans/:planID/items" handler:[TestInvalidURLHandler class]];
    [self.router installHandlerForPath:@"/plans/:planID" handler:[TestURLHandler class]];

    TestURLHandler *handler = [self.router handlerForURL:[NSURL URLWithString:@"services://pco/plans/123"]];

    XCTAssertFalse([handler isKindOfClass:[TestInvalidURLHandler class]]);
    XCTAssertNotNil(handler);
    XCTAssertEqualObjects(handler.params[@"planID"], @"123");
}

@end




// MARK: - URL Handler

@implementation TestURLHandler

- (instancetype)initWithURL:(NSURL *)URL params:(NSDictionary<NSString *,NSString *> *)params {
    self = [super init];
    if (self) {
        _URL = URL;
        _params = params;
    }
    return self;
}

- (BOOL)handle {
    return NO;
}

@end

@implementation TestInvalidURLHandler

@end
