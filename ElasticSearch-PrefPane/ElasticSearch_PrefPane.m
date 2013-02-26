//
//  ElasticSearch_PrefPane.m
//  ElasticSearch-PrefPane
//
//  Created by Justin D'Arcangelo on 2/17/13.
//  Copyright (c) 2013 Entropi Software. All rights reserved.
//

#import "ElasticSearch_PrefPane.h"
#import "Preferences.h"

@interface ElasticSearch_PrefPane()

@property (nonatomic, retain) FFYDaemonController *daemonController;

- (void)binaryLocationChanged:(NSNotification *)notification;
- (void)pidLocationChanged:(NSNotification *)notification;
- (void)argumentsChanged:(NSNotification *)notification;

@end

@implementation ElasticSearch_PrefPane

@synthesize daemonController;

@synthesize theSlider;
@synthesize launchPathTextField;
@synthesize pidPathTextField;
@synthesize argumentsTextField;

- (id)initWithBundle:(NSBundle *)bundle {
  if ((self = [super initWithBundle:bundle])) {
    [[Preferences sharedPreferences] setBundle:bundle];
  }
  
  return self;
}

- (void)mainViewDidLoad {
  FFYDaemonController *dC = [[FFYDaemonController alloc] init];
  self.daemonController = dC;
  [dC release];
  
  daemonController.launchPath = [[Preferences sharedPreferences] objectForUserDefaultsKey:@"launchPath"];
  daemonController.pidPath = [[Preferences sharedPreferences] objectForUserDefaultsKey:@"pidPath"];
  daemonController.startArguments = [[Preferences sharedPreferences] objectForUserDefaultsKey:@"arguments"];
  
  daemonController.daemonStartedCallback = ^(NSNumber *pid) {
    [theSlider setState:NSOnState animate:YES];
  };
  
  daemonController.daemonFailedToStartCallback = ^(NSString *reason) {
    [theSlider setState:NSOffState animate:YES];
  };
  
  daemonController.daemonStoppedCallback = ^(void) {
    [theSlider setState:NSOffState animate:YES];
  };
  
  daemonController.daemonFailedToStopCallback = ^(NSString *reason) {
    [theSlider setState:NSOnState animate:YES];
  };
  
  [theSlider setState:daemonController.isRunning ? NSOnState : NSOffState];
  [launchPathTextField setStringValue:daemonController.launchPath];
  [pidPathTextField setStringValue:daemonController.pidPath];
  [argumentsTextField setStringValue:daemonController.startArguments];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(binaryLocationChanged:)
                                               name:NSControlTextDidChangeNotification
                                             object:launchPathTextField];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(pidLocationChanged:)
                                               name:NSControlTextDidChangeNotification
                                             object:pidPathTextField];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(argumentsChanged:)
                                               name:NSControlTextDidChangeNotification
                                             object:argumentsTextField];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
  [daemonController release];
  
  [super dealloc];
}

- (IBAction)startStopDaemon:(id)sender {
  daemonController.launchPath = [[[Preferences sharedPreferences] objectForUserDefaultsKey:@"launchPath"] stringByExpandingTildeInPath];
  daemonController.pidPath = [[[Preferences sharedPreferences] objectForUserDefaultsKey:@"pidPath"] stringByExpandingTildeInPath];
  daemonController.startArguments = [[[Preferences sharedPreferences] objectForUserDefaultsKey:@"arguments"] stringByExpandingTildeInPath];
  
  if (theSlider.state == NSOffState)
    [daemonController stop];
  else
    [daemonController start];
}

- (IBAction)locateBinary:(id)sender {
  NSOpenPanel *openPanel = [NSOpenPanel openPanel];
  [openPanel setCanChooseFiles:YES];
  [openPanel setShowsHiddenFiles:YES];
  [openPanel setResolvesAliases:YES];
  
  if (![[launchPathTextField stringValue] isEqualToString:@""])
    [openPanel setDirectoryURL:[NSURL fileURLWithPath:[[launchPathTextField stringValue] stringByDeletingLastPathComponent]]];
  
  if ([openPanel runModal] == NSOKButton) {
    [launchPathTextField setStringValue:[openPanel.URL path]];
    [[Preferences sharedPreferences] setObject:[launchPathTextField stringValue] forUserDefaultsKey:@"launchPath"];
    daemonController.launchPath = [[Preferences sharedPreferences] objectForUserDefaultsKey:@"launchPath"];
  }
}

- (IBAction)locatePID:(id)sender {
  NSOpenPanel *openPanel = [NSOpenPanel openPanel];
  [openPanel setCanChooseFiles:YES];
  [openPanel setShowsHiddenFiles:YES];
  [openPanel setResolvesAliases:YES];
  
  if (![[pidPathTextField stringValue] isEqualToString:@""])
    [openPanel setDirectoryURL:[NSURL fileURLWithPath:[[pidPathTextField stringValue] stringByDeletingLastPathComponent]]];
  
  if ([openPanel runModal] == NSOKButton) {
    [pidPathTextField setStringValue:[openPanel.URL path]];
    [[Preferences sharedPreferences] setObject:[pidPathTextField stringValue] forUserDefaultsKey:@"pidPath"];
    daemonController.pidPath = [[Preferences sharedPreferences] objectForUserDefaultsKey:@"pidPath"];
  }
}

- (void)binaryLocationChanged:(NSNotification *)notification {
  [[Preferences sharedPreferences] setObject:[launchPathTextField stringValue] forUserDefaultsKey:@"launchPath"];
  daemonController.launchPath = [[Preferences sharedPreferences] objectForUserDefaultsKey:@"launchPath"];
}

- (void)pidLocationChanged:(NSNotification *)notification {
  [[Preferences sharedPreferences] setObject:[pidPathTextField stringValue] forUserDefaultsKey:@"pidPath"];
  daemonController.pidPath = [[Preferences sharedPreferences] objectForUserDefaultsKey:@"pidPath"];
}

- (void)argumentsChanged:(NSNotification *)notification {
  [[Preferences sharedPreferences] setObject:[argumentsTextField stringValue] forUserDefaultsKey:@"arguments"];
  daemonController.startArguments = [[Preferences sharedPreferences] objectForUserDefaultsKey:@"arguments"];
}

@end
