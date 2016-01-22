/*!
 * PCRRouter.h
 * PlanningCenterRouter
 *
 * Copyright (c) 2016 Ministry Centered Technology
 *
 * Created by Skylar Schipper on 1/22/16
 */

#ifndef PlanningCenterRouter_PCRRouter_h
#define PlanningCenterRouter_PCRRouter_h

@import Foundation;

@protocol PCRRoutingHandler;

NS_ASSUME_NONNULL_BEGIN

/**
 *  Handle URLs in the app.
 *
 *  Routes are matched in the order they are added.
 */
@interface PCRRouter : NSObject

/**
 *  Shared Router Instance
 */
+ (instancetype)globalRouter;

/**
 *  Install a hander for a URL
 *
 *  If you want AppPersonOpenHandler to handle `app://localhost/people/1`
 *
 *  `[[PCRRouter globalRouter] installHandlerForPath:@"/people/:personID" handler:[AppPersonOpenHandler class]]`
 *
 *  @param path    The Path to match
 *  @param handler The Handler class for this path
 */
- (void)installHandlerForPath:(NSString *)path handler:(Class<PCRRoutingHandler>)handler;

/**
 *  Create a new handler instance for the URL.
 *
 *  @param URL The URL to handle
 *
 *  @return A handler installed to handle the URL.
 */
- (nullable id<PCRRoutingHandler>)handlerForURL:(NSURL *)URL;

/**
 *  Handle a URL
 *
 *  @param URL The URL to handle
 *
 *  @return Handled status.
 */
- (BOOL)handleURL:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END

#endif
