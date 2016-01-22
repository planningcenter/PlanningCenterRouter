/*!
 * PCRInstalledHandler.m
 * PlanningCenterRouter
 *
 * Copyright (c) 2016 Ministry Centered Technology
 *
 * Created by Skylar Schipper on 1/22/16
 */

#import "PCRInstalledHandler.h"

@interface PCRInstalledHandler ()

@end

@implementation PCRInstalledHandler

- (instancetype)init {
    NSAssert(NO, @"%@ isn't implemented",NSStringFromSelector(_cmd));
    return [self initWithPath:@"" handler:(Class<PCRRoutingHandler>)[NSObject class]];
}

- (instancetype)initWithPath:(NSString *)path handler:(Class<PCRRoutingHandler>)handler {
    self = [super init];
    if (self) {
        _path = [path copy];
        _handler = handler;
    }
    return self;
}

- (nullable NSDictionary<NSString *, NSString *> *)URLMatchesPath:(NSURL *)URL {
    NSArray<NSString *> *components = [[URL path] pathComponents];
    NSArray<NSString *> *matches = [self.path pathComponents];

    if (components.count < matches.count) {
        return nil;
    }

    NSEnumerator *URLEnum = [components objectEnumerator];
    NSEnumerator *matchEnum = [matches objectEnumerator];

    NSString *component = [URLEnum nextObject];
    NSString *matchComponent = [matchEnum nextObject];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    while (component && matchComponent) {
        if ([matchComponent hasPrefix:@":"]) {
            NSString *key = [matchComponent substringFromIndex:1];
            NSString *value = [component copy];
            [params setValue:value forKey:key];
        } else if (![component isEqualToString:matchComponent]) {
            return nil;
        }
        matchComponent = [matchEnum nextObject];
        component = [URLEnum nextObject];
    }

    return [params copy];
}

@end
