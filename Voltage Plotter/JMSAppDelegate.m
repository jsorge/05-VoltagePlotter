//
//  JMSAppDelegate.m
//  Voltage Plotter
//
//  Created by Jared Sorge on 11/10/13.
//  Copyright (c) 2013 jsorge. All rights reserved.
//

#import "JMSAppDelegate.h"
#import "WidgetTester.h"
#import "WidgetTestObservationPoint.h"
#import "JMSWidgetPlotView.h"

@interface JMSAppDelegate ()
@property (weak) IBOutlet JMSWidgetPlotView *plotView;
@property (weak) IBOutlet NSSegmentedControl *styleSegmentedControl;
@end

@implementation JMSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.widgetTester performTest];
    self.plotView.widgetTester = self.widgetTester;
    
    [self changePlotStyle:self.styleSegmentedControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowDidResize:)
                                                 name:NSWindowDidResizeNotification
                                               object:nil];
}

#pragma mark - Properties
- (WidgetTester *)widgetTester
{
    if (!_widgetTester) {
        _widgetTester = [[WidgetTester alloc] init];
    }
    return _widgetTester;
}

#pragma mark - IBActions
- (IBAction)generateNewDataButton:(id)sender
{
    [self.widgetTester performTest];
    [self.plotView setNeedsDisplay:YES];
}

- (IBAction)copySummaryButton:(id)sender
{
    NSString *summary = [self.widgetTester summary];
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard declareTypes:@[NSStringPboardType] owner:nil];
    [pasteboard setString:summary forType:NSStringPboardType];
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

#pragma mark - NSWindowDelegate
- (void)windowDidResize:(NSNotification *)notification
{
    [self.plotView setNeedsDisplay:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:jmsWindowSizeChangeNotification object:nil];
}

#pragma mark - Dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
