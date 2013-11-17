//
//  JMSWidgetPlotView.m
//  Voltage Plotter
//
//  Created by Jared Sorge on 11/10/13.
//  Copyright (c) 2013 jsorge. All rights reserved.
//

#import "JMSWidgetPlotView.h"
#import "WidgetTester.h"
#import "WidgetTestObservationPoint.h"

NSString *jmsWindowSizeChangeNotification = @"windowDidResize";

@interface JMSWidgetPlotView ()
@property (nonatomic)JMSWidgetPlotViewStyle plotStyle;
@property (nonatomic)double xScale;
@property (nonatomic)double yScale;
@property (strong, nonatomic)NSString *stringAtMousePointer;
@property (nonatomic)NSPoint currentMousePoint;
@property (strong, nonatomic)NSColor *lineColor;
@property (nonatomic)CGFloat lineWidth;
@property (strong, nonatomic)NSColor *backgroundColor;
@end

@implementation JMSWidgetPlotView
#pragma mark - Properties
- (double)xScale
{
    if ( ( _xScale == 0 ) && self.widgetTester) {
        _xScale = self.frame.size.width / ( self.widgetTester.timeMaximum - self.widgetTester.timeMinimum );
    }
    return _xScale;
}

- (double)yScale
{
    if ( ( _yScale == 0 ) && self.widgetTester) {
        _yScale = self.frame.size.height / ( self.widgetTester.sensorMaximum - self.widgetTester.sensorMinimum );
    }
    return _yScale;
}

#pragma mark - Initializers
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resetAxisScales:)
                                                     name:jmsWindowSizeChangeNotification
                                                   object:nil];
        NSTrackingArea *ta = [[NSTrackingArea alloc] initWithRect:NSZeroRect
                                     options: ( NSTrackingMouseEnteredAndExited
                                               | NSTrackingMouseMoved
                                               | NSTrackingActiveAlways
                                               | NSTrackingInVisibleRect )
                                       owner:self
                                    userInfo:nil];
        [self addTrackingArea:ta];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    
    [self.backgroundColor setFill];
    NSRectFill(dirtyRect);
	
    NSBezierPath *path = [NSBezierPath bezierPath];
    NSPoint firstPoint;
    firstPoint.x = 0;
    firstPoint.y = self.widgetTester.sensorMinimum * self.yScale;
    [path moveToPoint:firstPoint];
    
    for (int i = 1; i < [self.widgetTester.testData count]; i++) {
        WidgetTestObservationPoint *plotPoint = self.widgetTester.testData[i];
        NSPoint nextPoint = [self projectObservationPointToView:plotPoint];
        [path lineToPoint:nextPoint];
    }

    [path setLineWidth:self.lineWidth];
    [self.lineColor set];
    [path stroke];
    
    if (self.currentMousePoint.x != 0) {
        NSAttributedString *coordinateString = [[NSAttributedString alloc] initWithString:self.stringAtMousePointer];
        [coordinateString drawAtPoint:self.currentMousePoint];

    }
}

#pragma mark - Public API
- (void)changePlotStyle:(JMSWidgetPlotViewStyle)plotStyle
{
    switch (plotStyle) {
        case WidgetViewStyleGood:
            self.lineWidth = 1.0;
            self.lineColor = [NSColor blackColor];
            self.backgroundColor = [NSColor whiteColor];
            break;
            
        case WidgetViewStyleBad:
            self.lineWidth = 3.0;
            self.lineColor = [NSColor greenColor];
            self.backgroundColor = [NSColor orangeColor];
            break;
            
        case WidgetViewStyleUgly:
            self.lineWidth = 5.0;
            self.lineColor = [NSColor purpleColor];
            self.backgroundColor = [NSColor yellowColor];
            break;
    }
    [self setNeedsDisplay:YES];
}

#pragma mark - Helpers
- (NSPoint)projectObservationPointToView:(WidgetTestObservationPoint *)point
{
    NSPoint thePoint;
    
    thePoint.x = ( point.observationTime - self.widgetTester.timeMinimum ) * self.xScale;
    thePoint.y = ( point.voltage - self.widgetTester.sensorMinimum ) * self.yScale;
    
    return thePoint;
}

- (void)resetAxisScales:(id)sender
{
    self.xScale = 0;
    self.yScale = 0;
}

#pragma mark - Dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Tracking Area
- (void)mouseMoved:(NSEvent *)theEvent
{
    self.currentMousePoint = [self convertPoint:theEvent.locationInWindow fromView:nil];
    self.stringAtMousePointer = [NSString stringWithFormat: @"Mouse at: %@", NSStringFromPoint(self.currentMousePoint)];
    [self setNeedsDisplay:YES];
}

@end
