//
//  Preferences.m
//  ElasticSearch-PrefPane
//
//  Created by Justin D'Arcangelo on 2/18/13.
//  Copyright (c) 2013 Entropi Software. All rights reserved.
//

#import "Preferences.h"

@implementation Preferences

@synthesize bundle;

#pragma mark - Singleton

static Preferences *sharedPreferences = nil;

+ (Preferences *)sharedPreferences {
	@synchronized(self) {
    if (!sharedPreferences)
      [[self alloc] init];
    
    return sharedPreferences;
  }
  
	return sharedPreferences;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
    if (!sharedPreferences) {
      sharedPreferences = [super allocWithZone:zone];
			return sharedPreferences;
		}
	}
  
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (NSUInteger)retainCount {
	return NSUIntegerMax;
}

- (oneway void)release {}

- (id)autorelease {
	return self;
}

#pragma mark - Read/Write User defaults

- (id)objectForUserDefaultsKey:(NSString *)key {
	CFPropertyListRef obj = CFPreferencesCopyAppValue((CFStringRef)key, (CFStringRef)[bundle bundleIdentifier]);
	return [(id)CFMakeCollectable(obj) autorelease];
}

- (void)setObject:(id)value forUserDefaultsKey:(NSString *)key {
  CFPreferencesSetValue((CFStringRef)key, value, (CFStringRef)[bundle bundleIdentifier], kCFPreferencesCurrentUser,  kCFPreferencesAnyHost);
  CFPreferencesSynchronize((CFStringRef)[bundle bundleIdentifier], kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
}

#pragma mark - Custom Setters and Getters

- (void)setBundle:(NSBundle *)aBundle {
  if (bundle != aBundle) {
    [bundle release];
    bundle = [aBundle retain];
    
    if (bundle) {
      if (![self objectForUserDefaultsKey:@"launchPath"])
        [self setObject:@"/usr/local/bin/elasticsearch" forUserDefaultsKey:@"launchPath"];
      if (![self objectForUserDefaultsKey:@"pidPath"])
        [self setObject:@"/usr/local/var/run/elasticsearch.pid" forUserDefaultsKey:@"pidPath"];
      if (![self objectForUserDefaultsKey:@"arguments"])
        [self setObject:@"-f -D es.config=/usr/local/opt/elasticsearch/config/elasticsearch.yml" forUserDefaultsKey:@"arguments"];
    }
  }
}

#pragma mark - Memory management

- (void)dealloc {
  [bundle release];
  
  [super dealloc];
}

@end
