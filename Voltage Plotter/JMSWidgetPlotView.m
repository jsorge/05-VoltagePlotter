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

@interface JMSWidgetPlotView ()
@property (nonatomic)JMSWidgetPlotViewStyle plotStyle;
@property (nonatomic)double xScale;
@property (nonatomic)double yScale;
@end

@implementation JMSWidgetPlotView

#pragma mark - Properties
- (double)xScale
{
    if (!_xScale && self.widgetTester) {
        _xScale = self.bounds.size.width / self.widgetTester.timeMaximum;
    }
    return _xScale;
}

- (double)yScale
{
    if (!_yScale && self.widgetTester) {
        _yScale = self.bounds.size.height / self.widgetTester.sensorMaximum;
    }
    return _yScale;
}

#pragma mark - Initializers
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
    
    [[NSColor orangeColor] setFill];
    NSRectFill(dirtyRect);
	
    NSBezierPath *path = [NSBezierPath bezierPath];
    NSPoint firstPoint;
    firstPoint.x = self.widgetTester.timeMinimum * self.xScale;
    firstPoint.y = self.widgetTester.sensorMinimum * self.yScale;
    [path moveToPoint:firstPoint];
    
    for (int i = 1; i < [self.widgetTester.testData count]; i++) {
        WidgetTestObservationPoint *plotPoint = self.widgetTester.testData[i];
        NSPoint nextPoint = [self projectObservationPointToView:plotPoint];
        [path lineToPoint:nextPoint];
    }
    
    [path setLineWidth:3.0];
    [[NSColor blackColor] set];
    [path stroke];
}

#pragma mark - Public API
- (void)changePlotStyle:(JMSWidgetPlotViewStyle)plotStyle
{
    self.plotStyle = plotStyle;
    [self setNeedsDisplay:YES];
}

#pragma mark - Helpers
- (NSPoint)projectObservationPointToView:(WidgetTestObservationPoint *)point
{
    NSPoint thePoint;
    
    thePoint.x = point.observationTime * self.xScale;
    thePoint.y = point.voltage * self.yScale;
    
    return thePoint;
}

@end
