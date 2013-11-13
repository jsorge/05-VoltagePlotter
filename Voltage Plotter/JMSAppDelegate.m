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
@end

@implementation JMSAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.widgetTester performTest];
    self.plotView.widgetTester = self.widgetTester;
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
    switch ([sender integerValue]) {
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
