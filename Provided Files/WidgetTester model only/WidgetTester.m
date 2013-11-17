//
//  WidgetTester.m
//  WidgetTestPlotter
//
//  Created by CP120 on 11/8/11.
//  Copyright (c) 2011 Hal Mueller. All rights reserved.
//

#import "WidgetTester.h"
#import "WidgetTestObservationPoint.h"

@implementation WidgetTester

#pragma mark -
#pragma mark properties

#pragma mark -
#pragma mark initializers / destructors

// init
- (id)init
{
    if (self = [super init]) {
    }
    return self;
}


#pragma mark -
#pragma mark data simulation

- (void)performTest
{
	NSUInteger i;
	double timeIncrement = 0.3;
	double startingTime = 10.0 + (random()/(double)RAND_MAX) * 20.;
	double sensorValueMean = 13.2;
	int sensorValueRange = 8;
	
    NSUInteger sampleSize = 50 + ((int)random() % 20);

	self.sensorMinimum = sensorValueMean + sensorValueRange;
	self.sensorMaximum = sensorValueMean - sensorValueRange;
    
	[self willChangeValueForKey:@"testData"];
    self.testData = [NSMutableArray arrayWithCapacity:sampleSize];
    double observationTime = startingTime;
	for (i = 0; i < sampleSize; i++) {
        observationTime += timeIncrement + random()/(double)RAND_MAX*.5;
        WidgetTestObservationPoint *point = [WidgetTestObservationPoint pointWithVoltage:sensorValueMean - sensorValueRange/2. + ((double)random()/(double)RAND_MAX * sensorValueRange)
                                                                                    time:observationTime];;
		self.sensorMinimum = MIN(point.voltage, self.sensorMinimum);
		self.sensorMaximum = MAX(point.voltage, self.sensorMaximum);
		[self.testData addObject:point];
	}
	[self didChangeValueForKey:@"testData"];
    //	MyLog(@"%@", self.testData);
//	MyLog(@"sensor range %f to %f", self.sensorMinimum, self.sensorMaximum);
}

- (WidgetTestObservationPoint *)startingPoint
{
	return [self.testData objectAtIndex:0];
}

- (WidgetTestObservationPoint *)endingPoint
{
	return [self.testData lastObject];
	}

- (double)timeMinimum
{
	return self.startingPoint.observationTime;
}
- (double)timeMaximum 
{
	return self.endingPoint.observationTime;	
}

- (NSString *)summary {
    return [NSString stringWithFormat:@"%ld points. Voltage range %f to %f, time range %f to %f",
            self.testData.count, self.sensorMinimum, self.sensorMaximum,
            self.timeMinimum, self.timeMaximum];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@ %@>", self.className, self.summary];
}
@end
