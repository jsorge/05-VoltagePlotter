//
//  JMSWidgetPlotView.h
//  Voltage Plotter
//
//  Created by Jared Sorge on 11/10/13.
//  Copyright (c) 2013 jsorge. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class WidgetTester;

@interface JMSWidgetPlotView : NSView

typedef NS_ENUM(NSInteger, JMSWidgetPlotViewStyle) {
    WidgetViewStyleGood,
    WidgetViewStyleBad,
    WidgetViewStyleUgly
};

@property(strong, nonatomic)WidgetTester *widgetTester;

- (void)changePlotStyle:(JMSWidgetPlotViewStyle)plotStyle;

@end
