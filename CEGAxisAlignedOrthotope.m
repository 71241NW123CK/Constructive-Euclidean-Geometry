//
//  CEGAxisAlignedOrthotope.m
//  Constructive Euclidean Geometry
//
//  Created by Ryan Tsukamoto on 4/17/12.
//  Copyright (c) 2012 Miso Media. All rights reserved.
//

#import "CEGAxisAlignedOrthotope.h"
#import "Generics.h"

@interface CEG1DRange()

@property	(nonatomic, readwrite)	int	index;
@property	(nonatomic, readwrite)	float	minValue;
@property	(nonatomic, readwrite)	float	maxValue;

@end

@implementation CEG1DRange

@synthesize index = _index;
@synthesize minValue = _minValue;
@synthesize maxValue = _maxValue;

+(CEG1DRange*)ceg1dRangeWithIndex:(int)index minValue:(float)minValue maxValue:(float)maxValue{return [[CEG1DRange alloc] initWithIndex:index minValue:minValue maxValue:maxValue];}

-(id)initWithIndex:(int)index minValue:(float)minValue maxValue:(float)maxValue
{
	if(self = [super init])
	{
		self.index = index;
		self.minValue = minValue;
		self.maxValue = maxValue;
	}
	return self;
}

-(bool)exteriorContainsPoint:(id<EGPoint>)point
{
	if(self.index < [point dimension])
	{
		float component = [[point componentAtIndex:self.index] floatValue];
		return component < self.minValue || self.maxValue < component;
	}
	return false;
}

-(bool)interiorContainsPoint:(id<EGPoint>)point
{
	if(self.index < [point dimension])
	{
		float component = [[point componentAtIndex:self.index] floatValue];
		return self.minValue < component && component < self.maxValue;
	}
	return true;
}

@end

@interface CEGAxisAlignedOrthotope()

@property	(nonatomic, readwrite, strong)	NSArray*	pairsOfMinsAndMaxes;

@end

@implementation CEGAxisAlignedOrthotope

@synthesize pairsOfMinsAndMaxes = _pairsOfMinsAndMaxes;

-(id)initWithPairsOfMinsAndMaxes:(NSArray*)pairsOfMinsAndMaxes
{
	int __block idx = 0;
	NSArray* objects =
	map
	(
		^id(id pairOfMinsAndMaxes)
		{
			return
			[CEG1DRange
				ceg1dRangeWithIndex:idx++
				minValue:[(NSNumber*)[(NSArray*)pairOfMinsAndMaxes objectAtIndex:0] floatValue]
				maxValue:[(NSNumber*)[(NSArray*)pairOfMinsAndMaxes objectAtIndex:1] floatValue]
			];
		},
		pairsOfMinsAndMaxes
	);
	if(self = [super initWithObjects:objects])
	{
		self.pairsOfMinsAndMaxes = pairsOfMinsAndMaxes;
	}
	return self;
}

@end
