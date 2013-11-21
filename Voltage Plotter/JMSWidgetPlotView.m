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
@property (strong, nonatomic)NSString *stringAtMousePointer;
@property (nonatomic)NSPoint currentMousePoint;
@property (strong, nonatomic)NSColor *lineColor;
@property (nonatomic)CGFloat lineWidth;
@property (strong, nonatomic)NSColor *backgroundColor;
@property (strong, nonatomic)NSColor *fillColor;
@property (nonatomic)double xRange;
@property (nonatomic)double yRange;
@end

NSString *modelDidChangeNotification = @"modelDidChange";

@implementation JMSWidgetPlotView
#pragma mark - Initializers
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resetAxisRanges)
                                                     name:modelDidChangeNotification
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

#pragma mark - Properties
- (double)xRange
{
    if (_xRange == 0) {
        _xRange = self.widgetTester.timeMaximum - self.widgetTester.timeMinimum;
    }
    return _xRange;
}

- (double)yRange
{
    if (_yRange == 0) {
        _yRange = self.widgetTester.sensorMaximum - self.widgetTester.sensorMinimum;
    }
    return _yRange;
}

- (WidgetTester *)widgetTester
{
    if (!_widgetTester) {
        _widgetTester = [[WidgetTester alloc] init];
        [_widgetTester performTest];
    }
    return _widgetTester;
}

#pragma mark - drawRect
- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];

    NSBezierPath *path = [NSBezierPath bezierPath];
    path.lineCapStyle = NSRoundLineCapStyle;
    NSPoint firstPoint;
    firstPoint.x = 0;
    firstPoint.y = 0;
    [path moveToPoint:firstPoint];
    
    for (WidgetTestObservationPoint *plotPoint in self.widgetTester.testData) {
        NSPoint nextPoint;
        nextPoint.x = ((plotPoint.observationTime - self.widgetTester.timeMinimum) * self.bounds.size.width) / self.xRange;
        nextPoint.y = ((plotPoint.voltage - self.widgetTester.sensorMinimum) * self.bounds.size.height) / self.yRange;
        [path lineToPoint:nextPoint];
    }
    
    NSPoint lastPoint;
    lastPoint.x = self.bounds.size.width;
    lastPoint.y = 0;
    [path lineToPoint:lastPoint];
    [path closePath];
    
    NSColor *backgroundColor;
    NSColor *fillColor;
    NSColor *lineColor;
    
    switch (self.plotStyle) {
        case WidgetViewStyleGood:
            path.lineWidth = 2.0;
            lineColor = [NSColor blackColor];
            backgroundColor = [NSColor whiteColor];
            fillColor = [NSColor whiteColor];
            [path setLineDash:0 count:0 phase:0];
            break;
            
        case WidgetViewStyleBad:
            path.lineWidth = 4.0;
            lineColor = [NSColor purpleColor];
            backgroundColor = [NSColor yellowColor];
            fillColor = [self invertColor:lineColor];
            [path setLineDash:0 count:0 phase:0];
            break;
            
        case WidgetViewStyleUgly:
            path.lineWidth = 3.0;
            lineColor = [self randomColor];
            backgroundColor = [NSColor orangeColor];
            fillColor = [self invertColor:lineColor];
            
            CGFloat dashes[4];
            dashes[0] = 2.0;
            dashes[1] = 8.0;
            dashes[2] = 6.0;
            dashes[3] = 8.0;
            [path setLineDash:dashes count:4 phase:0.0];
            break;
    }
    
    [backgroundColor setFill];
    NSRectFill(dirtyRect);

    [lineColor set];
    [path stroke];
    
    [fillColor set];
    [path fill];

    if (self.currentMousePoint.x != 0) {
        NSDictionary *attributes;
        
        NSUInteger modifierFlags = [NSEvent modifierFlags];
        switch (modifierFlags) {
            case NSShiftKeyMask:
                attributes = @{NSFontAttributeName: [NSFont fontWithName:@"Futura" size:14.0],
                               NSForegroundColorAttributeName: [NSColor whiteColor],
                               NSBackgroundColorAttributeName: [NSColor blackColor] };
                break;
                
            default:
                attributes = @{NSFontAttributeName: [NSFont fontWithName:@"Futura" size:14.0],
                                             NSForegroundColorAttributeName: [NSColor blackColor],
                                             NSBackgroundColorAttributeName: [NSColor grayColor] };
        }
        NSAttributedString *coordinateString = [[NSAttributedString alloc] initWithString:self.stringAtMousePointer attributes:attributes];
        [coordinateString drawAtPoint:self.currentMousePoint];

    }
}

#pragma mark - Public API
- (void)changePlotStyle:(JMSWidgetPlotViewStyle)plotStyle
{
    [self setPlotStyle:plotStyle];
    [self setNeedsDisplay:YES];
}

#pragma mark - Helpers
- (NSPoint)projectViewPointToObservationPoint:(NSPoint)point
{
    NSPoint dataPoint;
    
    dataPoint.x = (point.x * self.xRange / self.bounds.size.width) + self.widgetTester.timeMinimum;
    dataPoint.y = (point.y * self.yRange / self.bounds.size.height) + self.widgetTester.sensorMinimum;
    
    return dataPoint;
}

- (NSColor *)randomColor
{
    float rand_max = RAND_MAX;
    float red = rand() / rand_max;
    float green = rand() / rand_max;
    float blue = rand() / rand_max;
    return [NSColor colorWithCalibratedRed:red
                                     green:green
                                      blue:blue
                                     alpha:1.0];
}

- (NSColor *)invertColor:(NSColor *)originalColor
{
    return [NSColor colorWithCalibratedRed:(1.0 - [originalColor redComponent])
                                     green:(1.0 - [originalColor greenComponent])
                                      blue:(1.0 - [originalColor blueComponent])
                                     alpha:[originalColor alphaComponent]];
}

- (void)resetAxisRanges
{
    self.xRange = 0;
    self.yRange = 0;
}

#pragma mark - Tracking Area
- (void)mouseMoved:(NSEvent *)theEvent
{
    self.currentMousePoint = [self convertPoint:theEvent.locationInWindow fromView:nil];
    
    NSPoint dataPoint = [self projectViewPointToObservationPoint:self.currentMousePoint];
    
    self.stringAtMousePointer = [NSString stringWithFormat: @"Mouse: (%0.2f, %0.2f), Data: (%0.2f, %0.2f)", self.currentMousePoint.x, self.currentMousePoint.y, dataPoint.x, dataPoint.y];
    [self setNeedsDisplay:YES];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    self.stringAtMousePointer = @"";
    [self setNeedsDisplay:YES];
}

#pragma mark - Dealloc
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
