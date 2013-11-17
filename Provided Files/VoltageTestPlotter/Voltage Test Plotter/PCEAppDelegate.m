//
//  PCEAppDelegate.m
//  Voltage Test Plotter
//
//  Created by CP120 on 10/29/13.
//  Copyright (c) 2013 Hal Mueller. All rights reserved.
//

#import "PCEAppDelegate.h"
#import "KeyStrings.h"
#import "WidgetTester.h"
#import "WidgetTestRunView.h"

@implementation PCEAppDelegate

NSString *drawingStyleKey = @"drawingStyle";

+ (void)initialize
{
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	[defaultValues setObject:[NSNumber numberWithInt:0] forKey:drawingStyleKey];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    LogMethod();
    [self.stylePicker setSelectedSegment:[[NSUserDefaults standardUserDefaults] integerForKey:drawingStyleKey]];
    
    self.widgetTester = [[WidgetTester alloc] init];
    [self.widgetTester performTest];
    self.testView.widgetTester = self.widgetTester;
    [self.testView setNeedsDisplay:YES];
}



- (IBAction)changeDrawingStyle:(NSSegmentedControl *)sender
{
    LogMethod();
    [[NSUserDefaults standardUserDefaults] setInteger:sender.selectedSegment
                                               forKey:drawingStyleKey];
    [self.testView setNeedsDisplay:YES];
}

- (IBAction)performNewTest:(id)sender
{
    LogMethod();
    [self.widgetTester performTest];
    [self.testView setNeedsDisplay:YES];
}

- (IBAction)summarizeToCopyBuffer:(id)sender
{
}
@end
