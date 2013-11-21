//
//  JMSAppDelegate.m
//  Voltage Plotter
//
//  Created by Jared Sorge on 11/10/13.
//  Copyright (c) 2013 jsorge. All rights reserved.
//

#import "JMSAppDelegate.h"
#import "JMSWidgetPlotView.h"
#import "WidgetTester.h"
#import "WidgetTestObservationPoint.h"

@interface JMSAppDelegate ()
@property (weak) IBOutlet JMSWidgetPlotView *plotView;
@property (weak) IBOutlet NSSegmentedControl *styleSegmentedControl;
@end

@implementation JMSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self changePlotStyle:self.styleSegmentedControl];
}

#pragma mark - IBActions
- (IBAction)generateNewDataButton:(id)sender
{
    [self.plotView.widgetTester performTest];
    [[NSNotificationCenter defaultCenter] postNotificationName:modelDidChangeNotification object:nil];
    [self.plotView setNeedsDisplay:YES];
}

- (IBAction)copySummaryButton:(id)sender
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard declareTypes:@[NSStringPboardType] owner:nil];
    [pasteboard setString:self.plotView.widgetTester.summary forType:NSStringPboardType];
}

- (IBAction)changePlotStyle:(NSSegmentedControl *)sender
{
    switch (sender.selectedSegment) {
        case 0:
            [self.plotView changePlotStyle:WidgetViewStyleGood];
            break;
        
        case 1:
            [self.plotView changePlotStyle:WidgetViewStyleBad];
            break;
        
        case 2:
            [self.plotView changePlotStyle:WidgetViewStyleUgly];
            break;
    }
}
@end
