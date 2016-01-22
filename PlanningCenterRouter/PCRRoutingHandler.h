//
//  PCRRoutingHandler.h
//  PlanningCenterRouter
//
//  Created by Skylar Schipper on 1/22/16.
//  Copyright © 2016 Ministry Centered Technology. All rights reserved.
//

#ifndef PlanningCenterRouter_PCRRoutingHandler_h
#define PlanningCenterRouter_PCRRoutingHandler_h

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol PCRRoutingHandler <NSObject>

/**
 *  Create a new instance of the handler class
 *
 *  @param URL    The URL to handle
 *  @param params The params from the URL by the key used for the path matcher
 *
 *  @return A new instance or nil
 */
@required
- (nullable instancetype)initWithURL:(NSURL *)URL params:(NSDictionary<NSString *, NSString *> *)params;

/**
 *  Called by the router when the routing should handle the URL passed into initialize
 *
 *  @return Success of the action
 */
@required
- (BOOL)handle;

@end

NS_ASSUME_NONNULL_END

#endif
