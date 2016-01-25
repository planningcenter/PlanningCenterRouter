/*!
 * PCRRouter.m
 * PlanningCenterRouter
 *
 * Copyright (c) 2016 Ministry Centered Technology
 *
 * Created by Skylar Schipper on 1/22/16
 */

@import Darwin.POSIX.pthread;

#import "PCRRouter.h"
#import "PCRRoutingHandler.h"
#import "PCRInstalledHandler.h"

@interface PCRRouter () {
    pthread_mutex_t _lock;
}

@property (nonatomic, strong) NSMutableArray *handlers;

@end

@implementation PCRRouter

// MARK: - Singleton
+ (instancetype)globalRouter {
    static PCRRouter *router;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        router = [[self alloc] init];
    });
    return router;
}

// MARK: - Object Lifecycle
- (instancetype)init {
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);

        _handlers = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_lock);
}

// MARK: - Install handler
- (void)installHandlerForPath:(NSString *)path handler:(Class<PCRRoutingHandler>)handler {
    pthread_mutex_lock(&_lock);
    [self.handlers addObject:[[PCRInstalledHandler alloc] initWithPath:path handler:handler]];
    pthread_mutex_unlock(&_lock);
}


- (BOOL)handleURL:(NSURL *)URL {
    id<PCRRoutingHandler> handler = [self handlerForURL:URL];
    if (!handler) {
#if defined(DEBUG) && DEBUG
        NSLog(@"[URL Handler] Failed to find handler matching %@",[URL absoluteString]);
#endif
        return NO;
    }
    return [handler handle];
}

- (nullable id<PCRRoutingHandler>)handlerForURL:(NSURL *)URL {
    pthread_mutex_lock(&_lock);

    id<PCRRoutingHandler> foundHandler = nil;

    for (PCRInstalledHandler *handler in self.handlers) {
        NSDictionary *params = [handler URLMatchesPath:URL];
        if (params) {
            foundHandler = [[(Class)handler.handler alloc] initWithURL:URL params:params];
            break;
        }
    }

    pthread_mutex_unlock(&_lock);
    return foundHandler;
}

@end
