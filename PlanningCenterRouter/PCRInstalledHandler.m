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
    return [self initWithHost:@"" andPath:@"" handler:(Class<PCRRoutingHandler>)[NSObject class]];
}

- (instancetype)initWithHost:(nullable NSString *)host andPath:(NSString *)path handler:(Class<PCRRoutingHandler>)handler {
    self = [super init];
    if (self) {
        _path = [path copy];
        _host = [host copy];
        _handler = handler;
    }
    return self;
}

- (nullable NSDictionary<NSString *, NSString *> *)URLMatchesHostAndPath:(NSURL *)URL {
    NSArray<NSString *> *components = [[URL path] pathComponents];
    if (components.count == 0) {
        // If the URL comes in with no path
        components = @[@"/"];
    }
    NSArray<NSString *> *matches = [self.path pathComponents];

    if (components.count < matches.count) {
        return nil;
    }
    
    if (self.host && ![[URL host] isEqualToString:self.host]) {
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

    NSURLComponents *URLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    for (NSURLQueryItem *item in URLComponents.queryItems) {
        if (![params objectForKey:item.name] && item.value) {
            [params setObject:item.value forKey:item.name];
        }
    }

    return [params copy];
}

@end
