/*!
 * PCRInstalledHandler.h
 * PlanningCenterRouter
 *
 * Copyright (c) 2016 Ministry Centered Technology
 *
 * Created by Skylar Schipper on 1/22/16
 */

#ifndef PlanningCenterRouter_PCRInstalledHandler_h
#define PlanningCenterRouter_PCRInstalledHandler_h

@import Foundation;

@protocol PCRRoutingHandler;

NS_ASSUME_NONNULL_BEGIN

@interface PCRInstalledHandler : NSObject

// Passing in a null host bypasses the host check and allows for wildcard path handlers!
- (instancetype)initWithHost:(nullable NSString *)host andPath:(NSString *)path handler:(Class<PCRRoutingHandler>)handler NS_DESIGNATED_INITIALIZER;

@property (nonatomic, copy, readonly) NSString *path;

@property (nonatomic, copy, readonly, nullable) NSString *host;

@property (nonatomic, readonly) Class<PCRRoutingHandler> handler;

- (nullable NSDictionary<NSString *, NSString *> *)URLMatchesHostAndPath:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END

#endif
