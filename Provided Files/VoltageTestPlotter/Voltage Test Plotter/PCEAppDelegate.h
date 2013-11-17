//
//  PCEAppDelegate.h
//  Voltage Test Plotter
//
//  Created by CP120 on 10/29/13.
//  Copyright (c) 2013 Hal Mueller. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WidgetTester;
@class WidgetTestRunView;

@interface PCEAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (assign) IBOutlet NSSegmentedControl *stylePicker;

@property(nonatomic,retain) WidgetTester *widgetTester;
@property(retain)	IBOutlet WidgetTestRunView *testView;

- (IBAction)changeDrawingStyle:(NSSegmentedControl *)sender;
- (IBAction)performNewTest:(id)sender;
- (IBAction)summarizeToCopyBuffer:(id)sender;


@end
