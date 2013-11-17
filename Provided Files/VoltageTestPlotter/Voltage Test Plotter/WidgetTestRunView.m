//
//  WidgetTestRunView.m
//  Widget Test Plotter
//
//  Created by CP120 on 10/31/12.
//  Copyright (c) 2012 Hal Mueller. All rights reserved.
//

#import "WidgetTestRunView.h"
#import "WidgetTester.h"
#import "WidgetTestObservationPoint.h"
#import "KeyStrings.h"

@implementation WidgetTestRunView

const NSUInteger maxDrawingStyle = 2;

- (id)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	NSRect bounds = [self bounds];
	MyLog(@"drawRect: bounds %@", NSStringFromRect(bounds));
	MyLog(@"%zu points, voltage range %f to %f, time range %f to %f", self.widgetTester.testData.count, self.widgetTester.sensorMinimum, self.widgetTester.sensorMaximum, self.widgetTester.timeMinimum, self.widgetTester.timeMaximum);
	NSBezierPath *pointsPath = [NSBezierPath bezierPath];

	NSUInteger drawingStyleNumber = [[NSUserDefaults standardUserDefaults] integerForKey:drawingStyleKey];
	
	switch (drawingStyleNumber) {
		case 0:
			break;
		case 1:
			break;
		case 2:
			break;
	}
}


@end
