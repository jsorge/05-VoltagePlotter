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

extern NSString *jmsWindowSizeChangeNotification;

@property (strong, nonatomic)WidgetTester *widgetTester;
@property (strong, nonatomic)NSArray *plotPoints; //of NSPoints

- (void)changePlotStyle:(JMSWidgetPlotViewStyle)plotStyle;

@end
