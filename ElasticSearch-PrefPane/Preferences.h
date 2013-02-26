//
//  Preferences.h
//  ElasticSearch-PrefPane
//
//  Created by Justin D'Arcangelo on 2/18/13.
//  Copyright (c) 2013 Entropi Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Preferences : NSObject {
  NSBundle *bundle;
}

@property (nonatomic, retain) NSBundle *bundle;

+ (Preferences *)sharedPreferences;

- (id)objectForUserDefaultsKey:(NSString *)key;
- (void)setObject:(id)value forUserDefaultsKey:(NSString *)key;

@end
