//
//  ElasticSearch_PrefPane.h
//  ElasticSearch-PrefPane
//
//  Created by Justin D'Arcangelo on 2/17/13.
//  Copyright (c) 2013 Entropi Software. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>
#import "FFYDaemonController.h"
#import "MBSliderButton.h"

@class FFYDaemonController;
@class MBSliderButton;

@interface ElasticSearch_PrefPane : NSPreferencePane {
  MBSliderButton *theSlider;
  NSTextField *launchPathTextField;
  NSTextField *pidPathTextField;
  NSTextField *argumentsTextField;
@private
  FFYDaemonController *daemonController;
}

@property (nonatomic, assign) IBOutlet MBSliderButton	*theSlider;
@property (nonatomic, assign) IBOutlet NSTextField *launchPathTextField;
@property (nonatomic, assign) IBOutlet NSTextField *pidPathTextField;
@property (nonatomic, assign) IBOutlet NSTextField *argumentsTextField;

- (void)mainViewDidLoad;

- (IBAction)startStopDaemon:(id)sender;
- (IBAction)locateBinary:(id)sender;
- (IBAction)locatePID:(id)sender;

@end
