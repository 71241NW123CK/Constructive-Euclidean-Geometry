//
//  PolygonTetrisCEGObject.m
//  Constructive Euclidean Geometry
//
//  Created by Ryan Tsukamoto on 4/18/12.
//  Copyright (c) 2012 Miso Media. All rights reserved.
//

#import "PolygonTetrisCEGObject.h"
#import "Generics.h"

@interface LineSegment2D()

@property	(nonatomic, readwrite)	CGPoint	vertex0;
@property	(nonatomic, readwrite)	CGPoint	vertex1;

-(float)slope;
-(void)moveUpByFloat:(float)value;

@end

@implementation LineSegment2D

@synthesize vertex0 = _vertex0;
@synthesize vertex1 = _vertex1;

+(LineSegment2D*)lineSegment2DWithVertex0:(CGPoint)vertex0 vertex1:(CGPoint)vertex1{return [[LineSegment2D alloc] initWithVertex0:vertex0 vertex1:vertex1];}

-(id)initWithVertex0:(CGPoint)vertex0 vertex1:(CGPoint)vertex1
{
	if(self = [super init])
	{
		self.vertex0 = vertex0;
		self.vertex1 = vertex1;
	}
	return self;
}

-(float)distanceBelowVertex:(CGPoint)vertex{return vertex.y - (self.vertex0.y + [self slope] * (vertex.x - self.vertex0.x));}

-(float)slope{return (self.vertex1.y - self.vertex0.y) / (self.vertex1.x - self.vertex0.x);}

-(void)moveUpByFloat:(float)value
{
	self.vertex0 = CGPointMake(self.vertex0.x, self.vertex0.y + value);
	self.vertex1 = CGPointMake(self.vertex1.x, self.vertex1.y + value);
}

@end

@interface LineSegmentPartialFloatEndomorphism()

@property	(nonatomic, readwrite, strong)	LineSegment2D*	lineSegment2D;
@property	(nonatomic, readwrite)	float	domainMinimum;
@property	(nonatomic, readwrite)	float	floatValueAtDomainMinimum;
@property	(nonatomic, readwrite)	float	domainMaximum;
@property	(nonatomic, readwrite)	float	floatValueAtDomainMaximum;

+(CGPoint)pointOfIntersectionBetweenLineSegmentPFE0:(LineSegmentPartialFloatEndomorphism*)lineSegmentPFE0 andLineSegmentPFE1:(LineSegmentPartialFloatEndomorphism*)lineSegmentPFE1;

+(float)solutionForSystemWithLineSegmentPFE0:(LineSegmentPartialFloatEndomorphism*)lineSegmentPFE0 andLineSegmentPFE1:(LineSegmentPartialFloatEndomorphism*)lineSegmentPFE1;

-(void)moveUpByFloat:(float)value;

-(float)slope;

-(NSString*)stringValue;

@end

@implementation LineSegmentPartialFloatEndomorphism

@synthesize	lineSegment2D = _lineSegment2D;
@synthesize domainMinimum = _domainMinimum;
@synthesize floatValueAtDomainMinimum = _floatValueAtDomainMinimum;
@synthesize domainMaximum = _domainMaximum;
@synthesize floatValueAtDomainMaximum = _floatValueAtDomainMaximum;

+(LineSegmentPartialFloatEndomorphism*)lineSegmentPFEWithLineSegment2D:(LineSegment2D*)lineSegment2D{return [[LineSegmentPartialFloatEndomorphism alloc] initWithLineSegment2D:lineSegment2D];}

+(CGPoint)pointOfIntersectionBetweenLineSegmentPFE0:(LineSegmentPartialFloatEndomorphism*)lineSegmentPFE0 andLineSegmentPFE1:(LineSegmentPartialFloatEndomorphism*)lineSegmentPFE1
{
	float domainOverlapMinimum = MAX(lineSegmentPFE0.domainMinimum, lineSegmentPFE1.domainMinimum);
	float domainOverlapMaximum = MIN(lineSegmentPFE0.domainMaximum, lineSegmentPFE1.domainMaximum);
	if(domainOverlapMaximum < domainOverlapMinimum)	return CGPointMake(nanf(""), nanf(""));
	if(domainOverlapMaximum == domainOverlapMinimum)
	{
		if([lineSegmentPFE0 floatValueForFloatInput:domainOverlapMinimum] == [lineSegmentPFE1 floatValueForFloatInput:domainOverlapMinimum])	return CGPointMake(domainOverlapMinimum, [lineSegmentPFE0 floatValueForFloatInput:domainOverlapMinimum]);
		return CGPointMake(domainOverlapMinimum, nanf(""));
	}
	if([lineSegmentPFE0 floatValueForFloatInput:domainOverlapMaximum] == [lineSegmentPFE1 floatValueForFloatInput:domainOverlapMaximum])	return CGPointMake(domainOverlapMaximum, [lineSegmentPFE0 floatValueForFloatInput:domainOverlapMaximum]);
	if([lineSegmentPFE0 floatValueForFloatInput:domainOverlapMinimum] == [lineSegmentPFE1 floatValueForFloatInput:domainOverlapMinimum])	return CGPointMake(domainOverlapMinimum, [lineSegmentPFE0 floatValueForFloatInput:domainOverlapMinimum]);
	if([lineSegmentPFE0 floatValueForFloatInput:domainOverlapMinimum] < [lineSegmentPFE1 floatValueForFloatInput:domainOverlapMinimum])
	{
		if([lineSegmentPFE0 floatValueForFloatInput:domainOverlapMaximum] < [lineSegmentPFE1 floatValueForFloatInput:domainOverlapMaximum])	return CGPointMake(nanf(""), nanf(""));
	}
	else
	{
		if([lineSegmentPFE1 floatValueForFloatInput:domainOverlapMaximum] < [lineSegmentPFE0 floatValueForFloatInput:domainOverlapMaximum])	return CGPointMake(nanf(""), nanf(""));
	}
	float initialDifference = [lineSegmentPFE1 floatValueForFloatInput:domainOverlapMinimum] - [lineSegmentPFE0 floatValueForFloatInput:domainOverlapMinimum];
	float finalDifference = [lineSegmentPFE1 floatValueForFloatInput:domainOverlapMaximum] - [lineSegmentPFE0 floatValueForFloatInput:domainOverlapMaximum];
	float changeInDifference = finalDifference - initialDifference;
	float intersectionX = domainOverlapMinimum + (initialDifference / changeInDifference) * (domainOverlapMaximum - domainOverlapMinimum);
	return CGPointMake(intersectionX, [lineSegmentPFE0 floatValueForFloatInput:intersectionX]);
}

+(float)solutionForSystemWithLineSegmentPFE0:(LineSegmentPartialFloatEndomorphism*)lineSegmentPFE0 andLineSegmentPFE1:(LineSegmentPartialFloatEndomorphism*)lineSegmentPFE1
{
	float domainOverlapMinimum = MAX(lineSegmentPFE0.domainMinimum, lineSegmentPFE1.domainMinimum);
	float domainOverlapMaximum = MIN(lineSegmentPFE0.domainMaximum, lineSegmentPFE1.domainMaximum);
	if(domainOverlapMaximum < domainOverlapMinimum)	return nanf("");
	if(domainOverlapMaximum == domainOverlapMinimum)	return domainOverlapMinimum;
	if([lineSegmentPFE0 floatValueForFloatInput:domainOverlapMaximum] == [lineSegmentPFE1 floatValueForFloatInput:domainOverlapMaximum])	return domainOverlapMaximum;
	if([lineSegmentPFE0 floatValueForFloatInput:domainOverlapMinimum] == [lineSegmentPFE1 floatValueForFloatInput:domainOverlapMinimum])	return domainOverlapMinimum;
	if([lineSegmentPFE0 floatValueForFloatInput:domainOverlapMinimum] < [lineSegmentPFE1 floatValueForFloatInput:domainOverlapMinimum])
	{
		if([lineSegmentPFE0 floatValueForFloatInput:domainOverlapMaximum] < [lineSegmentPFE1 floatValueForFloatInput:domainOverlapMaximum])	return nanf("");
	}
	else
	{
		if([lineSegmentPFE1 floatValueForFloatInput:domainOverlapMaximum] < [lineSegmentPFE0 floatValueForFloatInput:domainOverlapMaximum])	return nanf("");
	}
	float initialDifference = [lineSegmentPFE1 floatValueForFloatInput:domainOverlapMinimum] - [lineSegmentPFE0 floatValueForFloatInput:domainOverlapMinimum];
	float finalDifference = [lineSegmentPFE1 floatValueForFloatInput:domainOverlapMaximum] - [lineSegmentPFE0 floatValueForFloatInput:domainOverlapMaximum];
	float changeInDifference = finalDifference - initialDifference;
	float intersectionX = domainOverlapMinimum - (initialDifference / changeInDifference) * (domainOverlapMaximum - domainOverlapMinimum);
	NSLog(@"f0: (%f, %f)\tf1: (%f, %f)", intersectionX, [lineSegmentPFE0 floatValueForFloatInput:intersectionX], intersectionX, [lineSegmentPFE1 floatValueForFloatInput:intersectionX]);
	return intersectionX;
}

-(float)slope{return [self.lineSegment2D slope];}

-(id)initWithLineSegment2D:(LineSegment2D*)lineSegment2D
{
	CGPoint vertex0 = lineSegment2D.vertex0;
	CGPoint vertex1 = lineSegment2D.vertex1;
	if(self = [super init])
	{
		self.lineSegment2D = lineSegment2D;
		if(vertex0.x < vertex1.x)
		{
			self.domainMinimum = vertex0.x;
			self.floatValueAtDomainMinimum = vertex0.y;
			self.domainMaximum = vertex1.x;
			self.floatValueAtDomainMaximum = vertex1.y;
		}
		else
		{
			self.domainMinimum = vertex1.x;
			self.floatValueAtDomainMinimum = vertex1.y;
			self.domainMaximum = vertex0.x;
			self.floatValueAtDomainMaximum = vertex0.y;
		}
	}
	return self;
}

-(float)floatValueForFloatInput:(float)input{return (self.domainMinimum <= input && input <= self.domainMaximum) ? self.floatValueAtDomainMinimum + (input - self.domainMinimum) * (self.floatValueAtDomainMaximum - self.floatValueAtDomainMinimum) / (self.domainMaximum - self.domainMinimum) : nanf("");}

-(void)moveUpByFloat:(float)value
{
	[self.lineSegment2D moveUpByFloat:value];
	self.floatValueAtDomainMinimum += value;
	self.floatValueAtDomainMaximum += value;
}

-(NSString*)stringValue{return [NSString stringWithFormat:@"(%f, %f), (%f, %f)", self.domainMinimum, self.floatValueAtDomainMinimum, self.domainMaximum, self.floatValueAtDomainMaximum];}

@end

@interface PiecewiseLinearPartialFloatEndomorphism()

@property	(nonatomic, readwrite, strong)	NSArray* disjointLineSegmentPFEsWithDomainsInAscendingOrder;
@property	(nonatomic, readwrite)	bool	maximizing;

-(void)moveUpByFloat:(float)value;

@end

@implementation PiecewiseLinearPartialFloatEndomorphism

@synthesize disjointLineSegmentPFEsWithDomainsInAscendingOrder = _disjointLineSegmentPFEsWithDomainsInAscendingOrder;
@synthesize maximizing = _maximizing;

+(PiecewiseLinearPartialFloatEndomorphism*)piecewiseLinearPFEWithLineSegmentPFEs:(NSArray*)lineSegmentPFEs maximizing:(bool)maximizing{return [[PiecewiseLinearPartialFloatEndomorphism alloc] initWithLineSegmentPFEs:lineSegmentPFEs maximizing:maximizing];}

+(PiecewiseLinearPartialFloatEndomorphism*)minUnionPiecewiseLinearPFEWithPiecewiseLinearPFE0:(PiecewiseLinearPartialFloatEndomorphism*)piecewiseLinearPFE0 piecewiseLinearPFE1:(PiecewiseLinearPartialFloatEndomorphism*)piecewiseLinearPFE1
{
	NSLog(@"entering minUnion");
	NSLog(@"f0:%@", mapWithSelector(@selector(stringValue), piecewiseLinearPFE0.disjointLineSegmentPFEsWithDomainsInAscendingOrder));
	NSLog(@"f1:%@", mapWithSelector(@selector(stringValue), piecewiseLinearPFE1.disjointLineSegmentPFEsWithDomainsInAscendingOrder));

	NSMutableArray* m_criticalInputIntervals = [NSMutableArray array];//the domain (sans a zero-measure set of trivial points) of the result.
	NSEnumerator* f0Enumerator = [piecewiseLinearPFE0.disjointLineSegmentPFEsWithDomainsInAscendingOrder objectEnumerator];
	NSEnumerator* f1Enumerator = [piecewiseLinearPFE1.disjointLineSegmentPFEsWithDomainsInAscendingOrder objectEnumerator];

	LineSegmentPartialFloatEndomorphism* f0 = [f0Enumerator nextObject];
	LineSegmentPartialFloatEndomorphism* f1 = [f1Enumerator nextObject];
	if(f0 == nil)	return piecewiseLinearPFE1;
	if(f1 == nil)	return piecewiseLinearPFE0;
	float startValue = MIN(f0.domainMinimum, f1.domainMinimum);
	while(f0 || f1)
	{
		//are we done with f0 or f1?
		if(!f0 || (f1 && f1.domainMaximum <= f0.domainMinimum))	//f0 has been exhausted or starts after f1 ends.  Increment startValue if left of domain of f1.  
		{
			if(startValue < f1.domainMinimum)	startValue = f1.domainMinimum;
			[m_criticalInputIntervals addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:startValue], [NSNumber numberWithFloat:f1.domainMaximum], nil]];
			startValue = f1.domainMaximum;
			f1 = [f1Enumerator nextObject];
		}
		else	if(!f1 || (f0 && f0.domainMaximum <= f1.domainMinimum))	//f1 has been exhausted or starts after f0 ends.  Increment startValue if left of domain of f0.
		{
			if(startValue < f0.domainMinimum)	startValue = f0.domainMinimum;
			[m_criticalInputIntervals addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:startValue], [NSNumber numberWithFloat:f0.domainMaximum], nil]];
			startValue = f0.domainMaximum;
			f0 = [f0Enumerator nextObject];
		}
		else
		{
			if(startValue < f0.domainMinimum && startValue < f1.domainMinimum)//need to cross the chasm...
			{
				startValue = MIN(f0.domainMinimum, f1.domainMinimum);//cross the chasm.
			}
			if(f0.domainMinimum <= startValue && f1.domainMinimum <= startValue)//we begin in a domain intersection
			{
				float domainIntersectionMaximum = MIN(f0.domainMaximum, f1.domainMaximum);
				//either they cross before domainIntersectionMaximum, the domains end at the same time, or one domain ends before the other.
				if(([f1 floatValueForFloatInput:startValue] - [f0 floatValueForFloatInput:startValue]) * ([f1 floatValueForFloatInput:domainIntersectionMaximum] - [f0 floatValueForFloatInput:domainIntersectionMaximum]) < 0)
				{
					//the two cross before the domain intersection maximum.
					//compute the crossing point.
					float crossingInput = [LineSegmentPartialFloatEndomorphism solutionForSystemWithLineSegmentPFE0:f0 andLineSegmentPFE1:f1];
					[m_criticalInputIntervals addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:startValue], [NSNumber numberWithFloat:crossingInput], nil]];
					startValue = crossingInput;
				}
				else
				{
					[m_criticalInputIntervals addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:startValue], [NSNumber numberWithFloat:domainIntersectionMaximum], nil]];
					startValue = domainIntersectionMaximum;
					if(f0.domainMaximum == domainIntersectionMaximum)	f0 = [f0Enumerator nextObject];
					if(f1.domainMaximum == domainIntersectionMaximum)	f1 = [f1Enumerator nextObject];
				}
			}
			else//we do not begin in a domain intersection, but the current intervals' domains do intersect.
			{
				float domainIntersectionMinimum = MAX(f0.domainMinimum, f1.domainMinimum);
				[m_criticalInputIntervals addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:startValue], [NSNumber numberWithFloat:domainIntersectionMinimum], nil]];
				startValue = domainIntersectionMinimum;
			}
		}
	}
	
	NSLog(@"critical input intervals and values:");
	[m_criticalInputIntervals
		enumerateObjectsUsingBlock:
			^(id obj, NSUInteger idx, BOOL *stop)
			{
				float x0 = [(NSNumber*)[(NSArray*)obj objectAtIndex:0] floatValue];
				float x1 = [(NSNumber*)[(NSArray*)obj objectAtIndex:1] floatValue];
				NSLog(@"x0: %f\tf0: %f\tf1: %f", x0, [piecewiseLinearPFE0 floatValueForFloatInput:x0], [piecewiseLinearPFE1 floatValueForFloatInput:x0]);
				NSLog(@"x1: %f\tf0: %f\tf1: %f", x1, [piecewiseLinearPFE0 floatValueForFloatInput:x1], [piecewiseLinearPFE1 floatValueForFloatInput:x1]);
			}
	];
	
	NSMutableArray* m_lineSegmentPFEs = [NSMutableArray array];
	f0Enumerator = [piecewiseLinearPFE0.disjointLineSegmentPFEsWithDomainsInAscendingOrder objectEnumerator];
	f1Enumerator = [piecewiseLinearPFE1.disjointLineSegmentPFEsWithDomainsInAscendingOrder objectEnumerator];
	f0 = [f0Enumerator nextObject];
	f1 = [f1Enumerator nextObject];
	for(NSArray* criticalInputInterval in m_criticalInputIntervals)
	{
		float x0 = [(NSNumber*)[criticalInputInterval objectAtIndex:0] floatValue];
		float x1 = [(NSNumber*)[criticalInputInterval objectAtIndex:1] floatValue];
		//increment f0 and f1.
		while(f0 && f0.domainMaximum <= x0)	f0 = [f0Enumerator nextObject];
		while(f1 && f1.domainMaximum <= x0)	f1 = [f1Enumerator nextObject];
		if(f0 && f0.domainMinimum <= x0)
		{
			if(f1 && f1.domainMinimum <= x0)
			{
				if([f0 floatValueForFloatInput:x0] < [f1 floatValueForFloatInput:x0] || [f0 floatValueForFloatInput:x1] < [f1 floatValueForFloatInput:x1])	//f0 is smaller.  Use it instead of f1 for this segment.
				{
					[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:CGPointMake(x0, [f0 floatValueForFloatInput:x0]) vertex1:CGPointMake(x1, [f0 floatValueForFloatInput:x1])]]];
				}
				else	//f1 is smaller.  Use it instead of f0 for this segment.
				{
					[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:CGPointMake(x0, [f1 floatValueForFloatInput:x0]) vertex1:CGPointMake(x1, [f1 floatValueForFloatInput:x1])]]];
				}
			}
			else
			{
				[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:CGPointMake(x0, [f0 floatValueForFloatInput:x0]) vertex1:CGPointMake(x1, [f0 floatValueForFloatInput:x1])]]];
			}
		}
		else	if(f1 && f1.domainMinimum <= [(NSNumber*)[criticalInputInterval objectAtIndex:0] floatValue])
		{
			[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:CGPointMake(x0, [f1 floatValueForFloatInput:x0]) vertex1:CGPointMake(x1, [f1 floatValueForFloatInput:x1])]]];
		}
		else
		{
			NSLog(@"INTERNAL LOGIC ERROR: exhausted f0 and f1 before we should have...");
		}
	}
	if(f0)	if((f0 = [f0Enumerator nextObject]))	NSLog(@"INTERNAL LOGIC ERROR: f0 not exhausted!");
	if(f1)	if((f1 = [f1Enumerator nextObject]))	NSLog(@"INTERNAL LOGIC ERROR: f1 not exhausted!");
	NSLog(@"result line segments: %@", mapWithSelector(@selector(stringValue), m_lineSegmentPFEs));
	NSLog(@"exiting minUnion");
	return [PiecewiseLinearPartialFloatEndomorphism piecewiseLinearPFEWithLineSegmentPFEs:[NSArray arrayWithArray:m_lineSegmentPFEs] maximizing:false];
}

+(PiecewiseLinearPartialFloatEndomorphism*)maxUnionPiecewiseLinearPFEWithPiecewiseLinearPFE0:(PiecewiseLinearPartialFloatEndomorphism*)piecewiseLinearPFE0 piecewiseLinearPFE1:(PiecewiseLinearPartialFloatEndomorphism*)piecewiseLinearPFE1
{
	NSLog(@"entering maxUnion");

	NSMutableArray* m_criticalInputIntervals = [NSMutableArray array];//the domain (sans a zero-measure set of trivial points) of the result.
	NSEnumerator* f0Enumerator = [piecewiseLinearPFE0.disjointLineSegmentPFEsWithDomainsInAscendingOrder objectEnumerator];
	NSEnumerator* f1Enumerator = [piecewiseLinearPFE1.disjointLineSegmentPFEsWithDomainsInAscendingOrder objectEnumerator];

	LineSegmentPartialFloatEndomorphism* f0 = [f0Enumerator nextObject];
	LineSegmentPartialFloatEndomorphism* f1 = [f1Enumerator nextObject];
	if(f0 == nil)	return piecewiseLinearPFE1;
	if(f1 == nil)	return piecewiseLinearPFE0;
	float startValue = MIN(f0.domainMinimum, f1.domainMinimum);
	while(f0 || f1)
	{
		//are we done with f0 or f1?
		if(!f0 || (f1 && f1.domainMaximum <= f0.domainMinimum))	//f0 has been exhausted or starts after f1 ends.  Increment startValue if left of domain of f1.  
		{
			if(startValue < f1.domainMinimum)	startValue = f1.domainMinimum;
			[m_criticalInputIntervals addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:startValue], [NSNumber numberWithFloat:f1.domainMaximum], nil]];
			startValue = f1.domainMaximum;
			f1 = [f1Enumerator nextObject];
		}
		else	if(!f1 || (f0 && f0.domainMaximum <= f1.domainMinimum))	//f1 has been exhausted or starts after f0 ends.  Increment startValue if left of domain of f0.
		{
			if(startValue < f0.domainMinimum)	startValue = f0.domainMinimum;
			[m_criticalInputIntervals addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:startValue], [NSNumber numberWithFloat:f0.domainMaximum], nil]];
			startValue = f0.domainMaximum;
			f0 = [f0Enumerator nextObject];
		}
		else
		{
			if(startValue < f0.domainMinimum && startValue < f1.domainMinimum)//need to cross the chasm...
			{
				startValue = MIN(f0.domainMinimum, f1.domainMinimum);//cross the chasm.
			}
			if(f0.domainMinimum <= startValue && f1.domainMinimum <= startValue)//we begin in a domain intersection
			{
				float domainIntersectionMaximum = MIN(f0.domainMaximum, f1.domainMaximum);
				//either they cross before domainIntersectionMaximum, the domains end at the same time, or one domain ends before the other.
				const float tolerance = -0.03125f;
				if(([f1 floatValueForFloatInput:startValue] - [f0 floatValueForFloatInput:startValue]) * ([f1 floatValueForFloatInput:domainIntersectionMaximum] - [f0 floatValueForFloatInput:domainIntersectionMaximum]) < tolerance)
				{
					NSLog(@"%f, %f", [f1 floatValueForFloatInput:startValue] - [f0 floatValueForFloatInput:startValue], [f1 floatValueForFloatInput:domainIntersectionMaximum] - [f0 floatValueForFloatInput:domainIntersectionMaximum]);
					//the two cross before the domain intersection maximum.
					//compute the crossing point.
					float crossingInput = [LineSegmentPartialFloatEndomorphism solutionForSystemWithLineSegmentPFE0:f0 andLineSegmentPFE1:f1];
					[m_criticalInputIntervals addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:startValue], [NSNumber numberWithFloat:crossingInput], nil]];
					startValue = crossingInput;
				}
				else
				{
					[m_criticalInputIntervals addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:startValue], [NSNumber numberWithFloat:domainIntersectionMaximum], nil]];
					startValue = domainIntersectionMaximum;
					if(f0.domainMaximum == domainIntersectionMaximum)	f0 = [f0Enumerator nextObject];
					if(f1.domainMaximum == domainIntersectionMaximum)	f1 = [f1Enumerator nextObject];
				}
			}
			else//we do not begin in a domain intersection, but the current intervals' domains do intersect.
			{
				float domainIntersectionMinimum = MAX(f0.domainMinimum, f1.domainMinimum);
				[m_criticalInputIntervals addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:startValue], [NSNumber numberWithFloat:domainIntersectionMinimum], nil]];
				startValue = domainIntersectionMinimum;
			}
		}
	}
	
	NSMutableArray* m_lineSegmentPFEs = [NSMutableArray array];
	f0Enumerator = [piecewiseLinearPFE0.disjointLineSegmentPFEsWithDomainsInAscendingOrder objectEnumerator];
	f1Enumerator = [piecewiseLinearPFE1.disjointLineSegmentPFEsWithDomainsInAscendingOrder objectEnumerator];
	f0 = [f0Enumerator nextObject];
	f1 = [f1Enumerator nextObject];
	for(NSArray* criticalInputInterval in m_criticalInputIntervals)
	{
		float x0 = [(NSNumber*)[criticalInputInterval objectAtIndex:0] floatValue];
		float x1 = [(NSNumber*)[criticalInputInterval objectAtIndex:1] floatValue];
		//increment f0 and f1.
		while(f0 && f0.domainMaximum <= x0)	f0 = [f0Enumerator nextObject];
		while(f1 && f1.domainMaximum <= x0)	f1 = [f1Enumerator nextObject];
		if(f0 && f0.domainMinimum <= x0)
		{
			if(f1 && f1.domainMinimum <= x0)
			{
				if([f0 floatValueForFloatInput:x0] > [f1 floatValueForFloatInput:x0] || [f0 floatValueForFloatInput:x1] > [f1 floatValueForFloatInput:x1])	//f0 is larger.  Use it instead of f1 for this segment.
				{
					[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:CGPointMake(x0, [f0 floatValueForFloatInput:x0]) vertex1:CGPointMake(x1, [f0 floatValueForFloatInput:x1])]]];
				}
				else	//f1 is larger.  Use it instead of f0 for this segment.
				{
					[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:CGPointMake(x0, [f1 floatValueForFloatInput:x0]) vertex1:CGPointMake(x1, [f1 floatValueForFloatInput:x1])]]];
				}
			}
			else
			{
				[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:CGPointMake(x0, [f0 floatValueForFloatInput:x0]) vertex1:CGPointMake(x1, [f0 floatValueForFloatInput:x1])]]];
			}
		}
		else	if(f1 && f1.domainMinimum <= [(NSNumber*)[criticalInputInterval objectAtIndex:0] floatValue])
		{
			[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:CGPointMake(x0, [f1 floatValueForFloatInput:x0]) vertex1:CGPointMake(x1, [f1 floatValueForFloatInput:x1])]]];
		}
		else
		{
			NSLog(@"INTERNAL LOGIC ERROR: exhausted f0 and f1 before we should have...");
		}
	}
	if(f0)	NSLog(@"INTERNAL LOGIC ERROR: f0 not exhausted!");
	if(f1)	NSLog(@"INTERNAL LOGIC ERROR: f1 not exhausted!");
 	NSLog(@"exiting maxUnion");
	return [PiecewiseLinearPartialFloatEndomorphism piecewiseLinearPFEWithLineSegmentPFEs:[NSArray arrayWithArray:m_lineSegmentPFEs] maximizing:false];
}

+(PiecewiseLinearPartialFloatEndomorphism*)differenceOnIntersectionPiecewiseLinearPFEWithPiecewiseLinearPFE0:(PiecewiseLinearPartialFloatEndomorphism*)piecewiseLinearPFE0 piecewiseLinearPFE1:(PiecewiseLinearPartialFloatEndomorphism*)piecewiseLinearPFE1
{
	NSMutableArray* m_lineSegmentPFEs = [NSMutableArray array];
	NSEnumerator* f0Enumerator = [piecewiseLinearPFE0.disjointLineSegmentPFEsWithDomainsInAscendingOrder objectEnumerator];
	NSEnumerator* f1Enumerator = [piecewiseLinearPFE1.disjointLineSegmentPFEsWithDomainsInAscendingOrder objectEnumerator];
	LineSegmentPartialFloatEndomorphism* f0 = [f0Enumerator nextObject];
	LineSegmentPartialFloatEndomorphism* f1 = [f1Enumerator nextObject];
	if(!f0 || !f1)
	{
		NSLog(@"got empty input!");
		return [PiecewiseLinearPartialFloatEndomorphism piecewiseLinearPFEWithLineSegmentPFEs:[NSArray array] maximizing:false];
	}
	float startX = MIN(f0.domainMinimum, f1.domainMinimum);
	while(f0 != nil && f1 != nil)
	{
		//do the domains overlap at all?
		if(f0.domainMaximum <= f1.domainMinimum)		f0 = [f0Enumerator nextObject];
		else if(f1.domainMaximum <= f0.domainMinimum)	f1 = [f1Enumerator nextObject];
		else//the domains overlap.
		{
			//are we in a domain intersection?
			if(startX < f0.domainMinimum)		startX = f0.domainMinimum;
			else if(startX < f1.domainMinimum)	startX = f1.domainMinimum;
			else//we're in a domain intersection.  
			{
				//which domain ends first?
				if(f0.domainMaximum < f1.domainMaximum)	//f0 ends first.
				{
					[m_lineSegmentPFEs
						addObject:
							[LineSegmentPartialFloatEndomorphism
								lineSegmentPFEWithLineSegment2D:
									[LineSegment2D
										lineSegment2DWithVertex0:
											CGPointMake(startX, [f1 floatValueForFloatInput:startX] - [f0 floatValueForFloatInput:startX])
										vertex1:
											CGPointMake(f0.domainMaximum, [f1 floatValueForFloatInput:f0.domainMaximum] - f0.floatValueAtDomainMaximum)
									]
							]
					];
					startX = f0.domainMaximum;
					f0 = [f0Enumerator nextObject];
				}
				else if(f0.domainMaximum == f1.domainMaximum)	//they end at the same time.
				{
					[m_lineSegmentPFEs
						addObject:
							[LineSegmentPartialFloatEndomorphism
								lineSegmentPFEWithLineSegment2D:
									[LineSegment2D
										lineSegment2DWithVertex0:
											CGPointMake(startX, [f1 floatValueForFloatInput:startX] - [f0 floatValueForFloatInput:startX])
										vertex1:
											CGPointMake(f0.domainMaximum, [f1 floatValueForFloatInput:f0.domainMaximum] - f0.floatValueAtDomainMaximum)
									]
							]
					];
					if((f0 = [f0Enumerator nextObject]) && (f1 = [f1Enumerator nextObject]))	startX = MIN(f0.domainMinimum, f1.domainMinimum);
				}
				else	//f1 ends first.
				{
					[m_lineSegmentPFEs
						addObject:
							[LineSegmentPartialFloatEndomorphism
								lineSegmentPFEWithLineSegment2D:
									[LineSegment2D
										lineSegment2DWithVertex0:
											CGPointMake(startX, [f1 floatValueForFloatInput:startX] - [f0 floatValueForFloatInput:startX])
										vertex1:
											CGPointMake(f1.domainMaximum, f1.floatValueAtDomainMaximum - [f0 floatValueForFloatInput:f1.domainMaximum])
									]
							]
					];
					startX = f1.domainMaximum;
					f1 = [f1Enumerator nextObject];
				}
			}
		}
	}
	return [PiecewiseLinearPartialFloatEndomorphism piecewiseLinearPFEWithLineSegmentPFEs:[NSArray arrayWithArray:m_lineSegmentPFEs] maximizing:false];
}

-(id)initWithLineSegmentPFEs:(NSArray*)lineSegmentPFEs maximizing:(bool)maximizing
{
	NSArray* disjointLineSegmentPFEsWithDomainsInAscendingOrder =
	[lineSegmentPFEs
		arrayByReorderingWithProjectionBlock:
			^id(id lineSegmentPartialFloatEndomorphism){return [NSNumber numberWithFloat:((LineSegmentPartialFloatEndomorphism*)lineSegmentPartialFloatEndomorphism).domainMinimum];}
		comparisonSelector:
			@selector(compare:)
	];
	//sew together coincident segments... later... and with a more precise comparison of slope...
	NSArray* nontrivialDisjointLineSegmentPFEsWithDomainsInAscendingOrder =
	filter
	(
		^_Bool(id x)
		{
			return ((LineSegmentPartialFloatEndomorphism*)x).domainMinimum != ((LineSegmentPartialFloatEndomorphism*)x).domainMaximum;
		},
		disjointLineSegmentPFEsWithDomainsInAscendingOrder
	);
	if(self = [super init])
	{
		self.disjointLineSegmentPFEsWithDomainsInAscendingOrder = nontrivialDisjointLineSegmentPFEsWithDomainsInAscendingOrder;
		self.maximizing = maximizing;
	}
	return self;
}

-(float)floatValueForFloatInput:(float)input
{
	float __block result = nanf("");
	[self.disjointLineSegmentPFEsWithDomainsInAscendingOrder
		enumerateObjectsUsingBlock:
			^(id lineSegmentPFE, NSUInteger idx, BOOL *stop)
			{
				float thisResult = [lineSegmentPFE floatValueForFloatInput:input];
				if(thisResult == thisResult)
				{
					if(result != result)							result = thisResult;
					else if(self.maximizing == result < thisResult)	result = thisResult;
				}
			}
	];
	return result;
}

-(float)minimumValue
{
	if([self.disjointLineSegmentPFEsWithDomainsInAscendingOrder count] == 0)	return nanf("");
	return
	[(NSNumber*)foldl1
	(
		^id(id lhs, id rhs)
		{
			return [NSNumber numberWithFloat:MIN([lhs floatValue], [rhs floatValue])];
		},
		map
		(
			^id(id x)
			{
				return [NSNumber numberWithFloat:MIN(((LineSegmentPartialFloatEndomorphism*)x).floatValueAtDomainMinimum, ((LineSegmentPartialFloatEndomorphism*)x).floatValueAtDomainMaximum)];
			},
			self.disjointLineSegmentPFEsWithDomainsInAscendingOrder
		)
	)
		floatValue
	];
}

-(float)maximumValue
{
	if([self.disjointLineSegmentPFEsWithDomainsInAscendingOrder count] == 0)	return nanf("");
	return
	[(NSNumber*)foldl1
	(
		^id(id lhs, id rhs)
		{
			return [NSNumber numberWithFloat:MAX([lhs floatValue], [rhs floatValue])];
		},
		map
		(
			^id(id x)
			{
				return [NSNumber numberWithFloat:MAX(((LineSegmentPartialFloatEndomorphism*)x).floatValueAtDomainMinimum, ((LineSegmentPartialFloatEndomorphism*)x).floatValueAtDomainMaximum)];
			},
			self.disjointLineSegmentPFEsWithDomainsInAscendingOrder
		)
	)
		floatValue
	];
}

-(void)moveUpByFloat:(float)value
{
	[self.disjointLineSegmentPFEsWithDomainsInAscendingOrder
		enumerateObjectsUsingBlock:
			^(id obj, NSUInteger idx, BOOL *stop)
			{
				[(LineSegmentPartialFloatEndomorphism*)obj moveUpByFloat:value];
			}
	];
}

@end

@interface PiecewiseLinearPartialFloatMinMaxEndomorphismPair()

@property	(nonatomic, readwrite, strong)	PiecewiseLinearPartialFloatEndomorphism*	minPFE;
@property	(nonatomic, readwrite, strong)	PiecewiseLinearPartialFloatEndomorphism*	maxPFE;

-(void)moveUpByFloat:(float)value;

@end

@implementation PiecewiseLinearPartialFloatMinMaxEndomorphismPair

@synthesize minPFE = _minPFE;
@synthesize maxPFE = _maxPFE;

+(PiecewiseLinearPartialFloatMinMaxEndomorphismPair*)piecewiseLinearPFEPairWithMinPFE:(PiecewiseLinearPartialFloatEndomorphism*)minPFE maxPFE:(PiecewiseLinearPartialFloatEndomorphism*)maxPFE
{
	return [[PiecewiseLinearPartialFloatMinMaxEndomorphismPair alloc] initWithMinPFE:minPFE maxPFE:maxPFE];
}

+(PiecewiseLinearPartialFloatMinMaxEndomorphismPair*)unionPiecewiseLinearPFEPairWithPiecewiseLinearPFEPairs:(NSArray*)piecewiseLinearPFEPairs
{
	return foldl
	(
		^id(id lhs, id rhs)
		{
			return
			[PiecewiseLinearPartialFloatMinMaxEndomorphismPair
				piecewiseLinearPFEPairWithMinPFE:
					[PiecewiseLinearPartialFloatEndomorphism
						minUnionPiecewiseLinearPFEWithPiecewiseLinearPFE0:
							((PiecewiseLinearPartialFloatMinMaxEndomorphismPair*)lhs).minPFE
						piecewiseLinearPFE1:
							((PiecewiseLinearPartialFloatMinMaxEndomorphismPair*)rhs).minPFE
					]
				maxPFE:
					[PiecewiseLinearPartialFloatEndomorphism
						maxUnionPiecewiseLinearPFEWithPiecewiseLinearPFE0:
							((PiecewiseLinearPartialFloatMinMaxEndomorphismPair*)lhs).maxPFE
						piecewiseLinearPFE1:
							((PiecewiseLinearPartialFloatMinMaxEndomorphismPair*)rhs).maxPFE
					]
			];
		},
		[PiecewiseLinearPartialFloatMinMaxEndomorphismPair
			piecewiseLinearPFEPairWithMinPFE:
				[PiecewiseLinearPartialFloatEndomorphism piecewiseLinearPFEWithLineSegmentPFEs:[NSArray array] maximizing:false]
			maxPFE:
				[PiecewiseLinearPartialFloatEndomorphism piecewiseLinearPFEWithLineSegmentPFEs:[NSArray array] maximizing:true]
		], //lolwut
		piecewiseLinearPFEPairs
	);
}

//+(PiecewiseLinearPartialFloatMinMaxEndomorphismPair*)intersectionPiecewiseLinearPFEPairWithPiecewiseLinearPFEPairs:(NSArray*)piecewiseLinearPFEPairs
//{
//}
//
//+(PiecewiseLinearPartialFloatMinMaxEndomorphismPair*)differencePiecewiseLinearPFEPairWithPiecewiseLinearPFEPairs:(NSArray*)piecewiseLinearPFEPairs
//{
//}

-(id)initWithMinPFE:(PiecewiseLinearPartialFloatEndomorphism*)minPFE maxPFE:(PiecewiseLinearPartialFloatEndomorphism*)maxPFE
{
	if(self = [super init])
	{
		self.minPFE = minPFE;
		self.maxPFE = maxPFE;
	}
	return self;
}

-(void)moveUpByFloat:(float)value
{
	[self.maxPFE moveUpByFloat:value];
	[self.minPFE moveUpByFloat:value];
}

@end


float planarCrossProd(CGPoint v0, CGPoint v1);
float planarCrossProd(CGPoint v0, CGPoint v1){return v0.x * v1.y - v1.x * v0.y;}

@interface PolygonTetrisCEGTriangle()

@property	(nonatomic, readwrite)	CGPoint vertex0;
@property	(nonatomic, readwrite)	CGPoint vertex1;
@property	(nonatomic, readwrite)	CGPoint vertex2;

@property	(nonatomic, readwrite, strong)	PiecewiseLinearPartialFloatMinMaxEndomorphismPair* piecewiseLinearPartialFloatMinMaxEndomorphismPair;

-(void)moveUpByFloat:(float)value;

@end

@implementation PolygonTetrisCEGTriangle

@synthesize vertex0 = _vertex0;
@synthesize vertex1 = _vertex1;
@synthesize vertex2 = _vertex2;
@synthesize piecewiseLinearPartialFloatMinMaxEndomorphismPair = _piecewiseLinearPartialFloatMinMaxEndomorphismPair;

+(PolygonTetrisCEGTriangle*)polygonTetrisCEGTriangleWithVertex0:(CGPoint)vertex0 vertex1:(CGPoint)vertex1 vertex2:(CGPoint)vertex2{return [[PolygonTetrisCEGTriangle alloc] initWithVertex0:vertex0 vertex1:vertex1 vertex2:vertex2];}

-(id)initWithVertex0:(CGPoint)vertex0 vertex1:(CGPoint)vertex1 vertex2:(CGPoint)vertex2
{
	//check for degenerate triangle?
	//...
	//return nil for degenerate triangles?
	
	//not degenerate
	//check each pair of vertices to see if it's vertical...
	NSMutableArray* upperLineSegmentPartialFloatEndomorphisms = [NSMutableArray array];
	NSMutableArray* lowerLineSegmentPartialFloatEndomorphisms = [NSMutableArray array];
	if(vertex0.x == vertex1.x)
	{
		//it's a vertical line segment...
	}
	else
	{
		LineSegmentPartialFloatEndomorphism* lineSegmentPFE = [LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:vertex0 vertex1:vertex1]];
		//is vertex2 above or below the line segment (vertex0, vertex1)?
		if([lineSegmentPFE.lineSegment2D distanceBelowVertex:vertex2] < 0)	[upperLineSegmentPartialFloatEndomorphisms addObject:lineSegmentPFE];
		else																[lowerLineSegmentPartialFloatEndomorphisms addObject:lineSegmentPFE];
	}
	if(vertex0.x == vertex2.x)
	{
		//it's a vertical line segment...
	}
	else
	{
		LineSegmentPartialFloatEndomorphism* lineSegmentPFE = [LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:vertex0 vertex1:vertex2]];
		//is vertex1 above or below the line segment (vertex0, vertex2)?
		if([lineSegmentPFE.lineSegment2D distanceBelowVertex:vertex1] < 0)	[upperLineSegmentPartialFloatEndomorphisms addObject:lineSegmentPFE];
		else																[lowerLineSegmentPartialFloatEndomorphisms addObject:lineSegmentPFE];
	}
	if(vertex1.x == vertex2.x)
	{
		//it's a vertical line segment...
	}
	else
	{
		LineSegmentPartialFloatEndomorphism* lineSegmentPFE = [LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:vertex1 vertex1:vertex2]];
		if([lineSegmentPFE.lineSegment2D distanceBelowVertex:vertex0] < 0)	[upperLineSegmentPartialFloatEndomorphisms addObject:lineSegmentPFE];
		else																[lowerLineSegmentPartialFloatEndomorphisms addObject:lineSegmentPFE];
	}
	if(self = [super init])
	{
		self.vertex0 = vertex0;
		self.vertex1 = vertex1;
		self.vertex2 = vertex2;
		self.piecewiseLinearPartialFloatMinMaxEndomorphismPair =
		[PiecewiseLinearPartialFloatMinMaxEndomorphismPair
			piecewiseLinearPFEPairWithMinPFE:
				[PiecewiseLinearPartialFloatEndomorphism piecewiseLinearPFEWithLineSegmentPFEs:[NSArray arrayWithArray:lowerLineSegmentPartialFloatEndomorphisms] maximizing:false]
			maxPFE:
				[PiecewiseLinearPartialFloatEndomorphism piecewiseLinearPFEWithLineSegmentPFEs:[NSArray arrayWithArray:upperLineSegmentPartialFloatEndomorphisms] maximizing:true]
		];
	}
	return self;
}

-(bool)interiorContainsPoint:(id<EGPoint>)point
{
	CGPoint p = CGPointMake([[point componentAtIndex:0] floatValue], [[point componentAtIndex:1] floatValue]);
	CGPoint e01 = CGPointMake(self.vertex1.x - self.vertex0.x, self.vertex1.y - self.vertex0.y);
	CGPoint e12 = CGPointMake(self.vertex2.x - self.vertex1.x, self.vertex2.y - self.vertex1.y);
	CGPoint e20 = CGPointMake(self.vertex0.x - self.vertex2.x, self.vertex0.y - self.vertex2.y);
	CGPoint p0 = CGPointMake(self.vertex0.x - p.x, self.vertex0.y - p.y);
	CGPoint p1 = CGPointMake(self.vertex1.x - p.x, self.vertex1.y - p.y);
	CGPoint p2 = CGPointMake(self.vertex2.x - p.x, self.vertex2.y - p.y);
	if(planarCrossProd(e01, e20) * planarCrossProd(e01, p0) <= 0)	return false;
	if(planarCrossProd(e12, e01) * planarCrossProd(e12, p1) <= 0)	return false;
	if(planarCrossProd(e20, e12) * planarCrossProd(e20, p2) <= 0)	return false;
	return true;
}

-(bool)exteriorContainsPoint:(id<EGPoint>)point
{
	CGPoint p = CGPointMake([[point componentAtIndex:0] floatValue], [[point componentAtIndex:1] floatValue]);
	CGPoint e01 = CGPointMake(self.vertex1.x - self.vertex0.x, self.vertex1.y - self.vertex0.y);
	CGPoint e12 = CGPointMake(self.vertex2.x - self.vertex1.x, self.vertex2.y - self.vertex1.y);
	CGPoint e20 = CGPointMake(self.vertex0.x - self.vertex2.x, self.vertex0.y - self.vertex2.y);
	CGPoint p0 = CGPointMake(self.vertex0.x - p.x, self.vertex0.y - p.y);
	CGPoint p1 = CGPointMake(self.vertex1.x - p.x, self.vertex1.y - p.y);
	CGPoint p2 = CGPointMake(self.vertex2.x - p.x, self.vertex2.y - p.y);
	if(planarCrossProd(e01, e20) * planarCrossProd(e01, p0) < 0)	return true;
	if(planarCrossProd(e12, e01) * planarCrossProd(e12, p1) < 0)	return true;
	if(planarCrossProd(e20, e12) * planarCrossProd(e20, p2) < 0)	return true;
	return false;
}

-(void)moveUpByFloat:(float)value
{
	self.vertex0 = CGPointMake(self.vertex0.x, self.vertex0.y + value);
	self.vertex1 = CGPointMake(self.vertex1.x, self.vertex1.y + value);
	self.vertex2 = CGPointMake(self.vertex2.x, self.vertex2.y + value);
	[self.piecewiseLinearPartialFloatMinMaxEndomorphismPair moveUpByFloat:value];
}

@end

@interface PolygonTetrisCEGUnion()

@property	(nonatomic, readwrite, strong)	PiecewiseLinearPartialFloatMinMaxEndomorphismPair* piecewiseLinearPartialFloatMinMaxEndomorphismPair;

-(void)moveUpByFloat:(float)value;

@end

@implementation PolygonTetrisCEGUnion

@synthesize piecewiseLinearPartialFloatMinMaxEndomorphismPair = _piecewiseLinearPartialFloatMinMaxEndomorphismPair;

+(PolygonTetrisCEGUnion*)polygonTetrisCEGUnionWithObjects:(NSArray*)objects
{
	return [[PolygonTetrisCEGUnion alloc] initWithObjects:objects];
}

-(id)initWithObjects:(NSArray*)objects
{
	if(self = [super initWithObjects:objects])
	{
		self.piecewiseLinearPartialFloatMinMaxEndomorphismPair =
		[PiecewiseLinearPartialFloatMinMaxEndomorphismPair
			unionPiecewiseLinearPFEPairWithPiecewiseLinearPFEPairs:
				mapWithSelector(@selector(piecewiseLinearPartialFloatMinMaxEndomorphismPair), objects)
		];
	}
	return self;
}

-(void)moveUpByFloat:(float)value
{
	[self.objects
		enumerateObjectsUsingBlock:
			^(id obj, NSUInteger idx, BOOL *stop)
			{
				[(id<PolygonTetrisCEGObject>)obj moveUpByFloat:value];
			}
	];
}

@end

@interface PolygonTetrisSystem()

@property	(nonatomic, readwrite)	float	floorHeight;
@property	(nonatomic, readwrite, strong)	id<PolygonTetrisCEGObject>	polygonTetrisCEGObject;

@end

@implementation PolygonTetrisSystem

@synthesize floorHeight = _floorHeight;
@synthesize polygonTetrisCEGObject = _polygonTetrisCEGObject;

+(PolygonTetrisSystem*)polygonTetrisSystemWithFloorHeight:(float)floorHeight{return [[PolygonTetrisSystem alloc] initWithFloorHeight:floorHeight];}

-(id)initWithFloorHeight:(float)floorHeight
{
	if(self = [super init])
	{
		self.floorHeight = floorHeight;
		self.polygonTetrisCEGObject = nil;
	}
	return self;
}

-(id)initWithFloorHeight:(float)floorHeight polygonTetrisCEGObject:(id<PolygonTetrisCEGObject>)polygonTetrisCEGObject//drop an object onto the floor
{
	if(self = [super init])
	{
		self.floorHeight = floorHeight;
		float minHeight = [polygonTetrisCEGObject.piecewiseLinearPartialFloatMinMaxEndomorphismPair.minPFE minimumValue];
		[polygonTetrisCEGObject moveUpByFloat:self.floorHeight - minHeight];
		self.polygonTetrisCEGObject = polygonTetrisCEGObject;
	}
	return self;
}

-(void)addPolygonTetrisCEGObject:(id<PolygonTetrisCEGObject>)polygonTetrisCEGObject//drop an object into the system, unioning the result with self.polygonTetrisCEGObject and setting the union as the value of self.polygonTetrisCEGObject.
{
	float minHeight = [polygonTetrisCEGObject.piecewiseLinearPartialFloatMinMaxEndomorphismPair.minPFE minimumValue];
	if(self.polygonTetrisCEGObject)
	{
		PiecewiseLinearPartialFloatEndomorphism* diff =
		[PiecewiseLinearPartialFloatEndomorphism
			differenceOnIntersectionPiecewiseLinearPFEWithPiecewiseLinearPFE0:
				self.polygonTetrisCEGObject.piecewiseLinearPartialFloatMinMaxEndomorphismPair.maxPFE
			piecewiseLinearPFE1:
				polygonTetrisCEGObject.piecewiseLinearPartialFloatMinMaxEndomorphismPair.minPFE
		];
		float minDistance = [diff minimumValue];
		NSLog(@"minDistance: %f", minDistance);
		[polygonTetrisCEGObject moveUpByFloat:MAX(self.floorHeight - minHeight, -minDistance)];
		self.polygonTetrisCEGObject = [PolygonTetrisCEGUnion polygonTetrisCEGUnionWithObjects:[NSArray arrayWithObjects:self.polygonTetrisCEGObject, polygonTetrisCEGObject, nil]];
	}
	else
	{
		[polygonTetrisCEGObject moveUpByFloat:self.floorHeight - minHeight];
		self.polygonTetrisCEGObject = polygonTetrisCEGObject;
	}
}

@end

@interface PolygonTetrisPacking()

@property	(nonatomic, readwrite, strong)	NSArray*	objectsInOptimalOrder;

@end

@implementation PolygonTetrisPacking

@synthesize objectsInOptimalOrder = _objectsInOptimalOrder;

-(id)initWithObjects:(NSArray*)objects
{
	
	if(self = [super init])
	{
	}
	return self;
}

@end
