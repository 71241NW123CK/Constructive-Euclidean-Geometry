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

-(void)moveUpByFloat:(float)value;

-(float)slope;

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
	NSMutableArray* m_lineSegmentPFEs = [NSMutableArray array];
	NSEnumerator* f0Enumerator = [piecewiseLinearPFE0.disjointLineSegmentPFEsWithDomainsInAscendingOrder objectEnumerator];
	NSEnumerator* f1Enumerator = [piecewiseLinearPFE1.disjointLineSegmentPFEsWithDomainsInAscendingOrder objectEnumerator];
	bool noStartPoint = true;
	LineSegmentPartialFloatEndomorphism* f0 = [f0Enumerator nextObject];
	LineSegmentPartialFloatEndomorphism* f1 = [f1Enumerator nextObject];
	if(f0 == nil)	return piecewiseLinearPFE1;
	if(f1 == nil)	return piecewiseLinearPFE0;
	CGPoint segmentStartPoint;
	CGPoint segmentEndPoint;
	while(f0 || f1)//we lay down a (possibly extraneous) segment each run through the loop.
	{
		if(noStartPoint)
		{
			if(!f0)
			{
				segmentStartPoint = CGPointMake(f1.domainMinimum, f1.floatValueAtDomainMinimum);
			}
			else	if(!f1)
			{
				segmentStartPoint = CGPointMake(f0.domainMinimum, f0.floatValueAtDomainMinimum);
			}
			else	if(f0.domainMinimum < f1.domainMinimum || (f0.domainMinimum == f1.domainMinimum && (f0.floatValueAtDomainMinimum < f1.floatValueAtDomainMinimum || (f0.floatValueAtDomainMinimum == f1.floatValueAtDomainMinimum && [f0 slope] < [f1 slope]))))
			{
				segmentStartPoint = CGPointMake(f0.domainMinimum, f0.floatValueAtDomainMinimum);
			}
			else
			{
				segmentStartPoint = CGPointMake(f1.domainMinimum, f1.floatValueAtDomainMinimum);
			}
			noStartPoint = false;
		}
		if(!f0)
		{
			segmentEndPoint = CGPointMake(f1.domainMaximum, f1.floatValueAtDomainMaximum);
			[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
			if((f1 = [f1Enumerator nextObject]))	segmentStartPoint = CGPointMake(f1.domainMinimum, f1.floatValueAtDomainMinimum);
		}
		else	if(!f1)
		{
			segmentEndPoint = CGPointMake(f0.domainMaximum, f0.floatValueAtDomainMaximum);
			[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
			if((f0 = [f1Enumerator nextObject]))	segmentStartPoint = CGPointMake(f0.domainMinimum, f0.floatValueAtDomainMinimum);
		}
		else	if(segmentStartPoint.x < f0.domainMinimum)//starting before domain of f0.
		{
			//is there domain overlap?
			if(f1.domainMaximum < f0.domainMinimum)//there is no domain overlap.
			{
				//lay down the rest of f1.  Then ditch 
				segmentEndPoint = CGPointMake(f1.domainMaximum, f1.floatValueAtDomainMaximum);
				[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
				segmentStartPoint = segmentEndPoint;
				f1 = [f1Enumerator nextObject];
				noStartPoint = true;
			}
			else//there is domain overlap.
			{
				//lay down f1 until the domain overlap.  Then recompute segmentStartPoint.
				segmentEndPoint = CGPointMake(f0.domainMinimum, [f1 floatValueForFloatInput:f0.domainMinimum]);
				[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
				if(f0.floatValueAtDomainMinimum < segmentEndPoint.y || (f0.floatValueAtDomainMinimum == segmentEndPoint.y && [f0 slope] < [f1 slope]))
				{
					segmentStartPoint = CGPointMake(f0.domainMinimum, f0.floatValueAtDomainMinimum);
				}
				else
				{
					segmentStartPoint = segmentEndPoint;
				}
			}
		}
		else if(segmentStartPoint.x < f1.domainMinimum)//starting before domain of f1.
		{
			//is there domain overlap?
			if(f0.domainMaximum < f1.domainMinimum)//there is no domain overlap.
			{
				//lay down the rest of f0.  Then ditch
				segmentEndPoint = CGPointMake(f0.domainMaximum, f0.floatValueAtDomainMaximum);
				[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
				segmentStartPoint = segmentEndPoint;
				f0 = [f0Enumerator nextObject];
				noStartPoint = true;
			}
			else //there is domain overlap.
			{
				//lay down f0 until the domain overlap.  Then recompute segmentStartPoint.
				segmentEndPoint = CGPointMake(f1.domainMinimum, [f0 floatValueForFloatInput:f1.domainMinimum]);
				[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
				if(f1.floatValueAtDomainMinimum < segmentEndPoint.y || (f1.floatValueAtDomainMinimum == segmentEndPoint.y && [f1 slope] < [f0 slope]))
				{
					segmentStartPoint = CGPointMake(f1.domainMinimum, f1.floatValueAtDomainMinimum);
				}
				else
				{
					segmentStartPoint = segmentEndPoint;
				}
			}
		}
		else//starting in a domain overlap.
		{
			//which function ends first?
			if(f0.domainMaximum < f1.domainMaximum)//f0 ends first.
			{
				//do both functions contain the start point?
				if([f0 floatValueForFloatInput:segmentStartPoint.x] < [f1 floatValueForFloatInput:segmentStartPoint.x])//f0 is smaller at the start.
				{
					//is there crossover between the start point and the end of the domain of f0?
					if(f0.floatValueAtDomainMaximum <= [f1 floatValueForFloatInput:f0.domainMaximum])//there is no crossover.
					{
						//lay down the remainder of f0.  increment f0.  recompute segmentStartPoint
						segmentEndPoint = CGPointMake(f0.domainMaximum, f0.floatValueAtDomainMaximum);
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						if((f0 = [f0Enumerator nextObject]))
						{
							if(f0.domainMinimum == segmentEndPoint.x)
							{
								if(f0.floatValueAtDomainMinimum < [f1 floatValueForFloatInput:f0.domainMinimum])	segmentStartPoint = CGPointMake(f0.domainMinimum, f0.floatValueAtDomainMinimum);
								else																				segmentStartPoint = CGPointMake(f0.domainMinimum, [f1 floatValueForFloatInput:f0.domainMinimum]);
							}
							else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f1 floatValueForFloatInput:segmentEndPoint.x]);
						}
						else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f1 floatValueForFloatInput:segmentEndPoint.x]);
					}
					else	//there is crossover.
					{
						//compute the crossing point.  Lay down f0 until the crossing point.  Set segmentStartPoint = segmentEndPoint.
						segmentEndPoint = [LineSegmentPartialFloatEndomorphism pointOfIntersectionBetweenLineSegmentPFE0:f0 andLineSegmentPFE1:f1];
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						segmentStartPoint = segmentEndPoint;
					}
				}
				else if([f0 floatValueForFloatInput:segmentStartPoint.x] == [f1 floatValueForFloatInput:segmentStartPoint.x])//f0 = f1 at the start.
				{
					//are their slopes equal?
					if([f1 slope] < [f0 slope])//f1 has smaller slope.
					{
						//Lay down f1 until the end of the domain of f0.  Increment f0 and recompute the startPoint.
						segmentEndPoint = CGPointMake(f0.domainMaximum, [f1 floatValueForFloatInput:f0.domainMaximum]);
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						if((f0 = [f0Enumerator nextObject]))
						{
							if(f0.domainMinimum == segmentEndPoint.x)
							{
								if(f0.floatValueAtDomainMinimum < [f1 floatValueForFloatInput:f0.domainMinimum])	segmentStartPoint = CGPointMake(f0.domainMinimum, f0.floatValueAtDomainMinimum);
								else																				segmentStartPoint = CGPointMake(f0.domainMinimum, [f1 floatValueForFloatInput:f0.domainMinimum]);
							}
							else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f1 floatValueForFloatInput:segmentEndPoint.x]);
						}
						else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f1 floatValueForFloatInput:segmentEndPoint.x]);
					}
					else//they have the same slope or f0 has smaller slope.
					{
						//lay down the remainder of f0.  increment f0.  recompute segmentStartPoint.
						segmentEndPoint = CGPointMake(f0.domainMaximum, f0.floatValueAtDomainMaximum);
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						if((f0 = [f0Enumerator nextObject]))
						{
							if(f0.domainMinimum == segmentEndPoint.x)
							{
								if(f0.floatValueAtDomainMinimum < [f1 floatValueForFloatInput:f0.domainMinimum])	segmentStartPoint = CGPointMake(f0.domainMinimum, f0.floatValueAtDomainMinimum);
								else																				segmentStartPoint = CGPointMake(f0.domainMinimum, [f1 floatValueForFloatInput:f0.domainMinimum]);
							}
							else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f1 floatValueForFloatInput:segmentEndPoint.x]);
						}
						else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f1 floatValueForFloatInput:segmentEndPoint.x]);
					}
				}
				else//f1 is smaller at the start.
				{
					//is there crossover between the start point and the end of the domain of f0?
					if([f1 floatValueForFloatInput:f0.domainMaximum] <= f0.floatValueAtDomainMaximum)//there is no crossover.
					{
						//lay down f1 until the end of the domain of f0.  Increment f0.  Recompute segmentStartPoint
						segmentEndPoint = CGPointMake(f0.domainMaximum, [f1 floatValueForFloatInput:f0.domainMaximum]);
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						if((f0 = [f0Enumerator nextObject]))
						{
							if(f0.domainMinimum == segmentEndPoint.x)
							{
								if(f0.floatValueAtDomainMinimum < [f1 floatValueForFloatInput:f0.domainMinimum])	segmentStartPoint = CGPointMake(f0.domainMinimum, f0.floatValueAtDomainMinimum);
								else																				segmentStartPoint = CGPointMake(f0.domainMinimum, [f1 floatValueForFloatInput:f0.domainMinimum]);
							}
							else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f1 floatValueForFloatInput:segmentEndPoint.x]);
						}
						else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f1 floatValueForFloatInput:segmentEndPoint.x]);
					}
					else	//there is crossover.
					{
						//compute the crossing point.  Lay down f1 until the crossing point.  Set segmentStartPoint = segmentEndPoint.
						segmentEndPoint = [LineSegmentPartialFloatEndomorphism pointOfIntersectionBetweenLineSegmentPFE0:f0 andLineSegmentPFE1:f1];
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						segmentStartPoint = segmentEndPoint;
					}
				}
			}
			else//f1 ends first
			{
				//do both functions contain the start point?
				if([f1 floatValueForFloatInput:segmentStartPoint.x] < [f0 floatValueForFloatInput:segmentStartPoint.x])//f1 is smaller at the start.
				{
					//is there crossover between the start point and the end of the domain of f1?
					if(f1.floatValueAtDomainMaximum <= [f0 floatValueForFloatInput:f1.domainMaximum])//there is no crossover.
					{
						//lay down the remainder of f1.  increment f1.  recompute segmentStartPoint
						segmentEndPoint = CGPointMake(f1.domainMaximum, f1.floatValueAtDomainMaximum);
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						if((f1 = [f1Enumerator nextObject]))
						{
							if(f1.domainMinimum == segmentEndPoint.x)
							{
								if(f1.floatValueAtDomainMinimum < [f0 floatValueForFloatInput:f1.domainMinimum])	segmentStartPoint = CGPointMake(f1.domainMinimum, f1.floatValueAtDomainMinimum);
								else																				segmentStartPoint = CGPointMake(f1.domainMinimum, [f0 floatValueForFloatInput:f1.domainMinimum]);
							}
							else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f0 floatValueForFloatInput:segmentEndPoint.x]);
						}
						else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f0 floatValueForFloatInput:segmentEndPoint.x]);
					}
					else	//there is crossover.
					{
						//compute the crossing point.  Lay down f1 until the crossing point.  Set segmentStartPoint = segmentEndPoint.
						segmentEndPoint = [LineSegmentPartialFloatEndomorphism pointOfIntersectionBetweenLineSegmentPFE0:f1 andLineSegmentPFE1:f0];
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						segmentStartPoint = segmentEndPoint;
					}
				}
				else if([f1 floatValueForFloatInput:segmentStartPoint.x] == [f0 floatValueForFloatInput:segmentStartPoint.x])//f1 = f0 at the start.
				{
					//are their slopes equal?
					if([f0 slope] < [f1 slope])//f0 has smaller slope.
					{
						//Lay down f0 until the end of the domain of f1.  Increment f1 and recompute the startPoint.
						segmentEndPoint = CGPointMake(f1.domainMaximum, [f0 floatValueForFloatInput:f1.domainMaximum]);
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						if((f1 = [f1Enumerator nextObject]))
						{
							if(f1.domainMinimum == segmentEndPoint.x)
							{
								if(f1.floatValueAtDomainMinimum < [f0 floatValueForFloatInput:f1.domainMinimum])	segmentStartPoint = CGPointMake(f1.domainMinimum, f1.floatValueAtDomainMinimum);
								else																				segmentStartPoint = CGPointMake(f1.domainMinimum, [f0 floatValueForFloatInput:f1.domainMinimum]);
							}
							else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f0 floatValueForFloatInput:segmentEndPoint.x]);
						}
						else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f0 floatValueForFloatInput:segmentEndPoint.x]);
					}
					else//they have the same slope or f1 has smaller slope.
					{
						//lay down the remainder of f1.  increment f1.  recompute segmentStartPoint.
						segmentEndPoint = CGPointMake(f1.domainMaximum, f1.floatValueAtDomainMaximum);
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						if((f1 = [f1Enumerator nextObject]))
						{
							if(f1.domainMinimum == segmentEndPoint.x)
							{
								if(f1.floatValueAtDomainMinimum < [f0 floatValueForFloatInput:f1.domainMinimum])	segmentStartPoint = CGPointMake(f1.domainMinimum, f1.floatValueAtDomainMinimum);
								else																				segmentStartPoint = CGPointMake(f1.domainMinimum, [f0 floatValueForFloatInput:f1.domainMinimum]);
							}
							else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f0 floatValueForFloatInput:segmentEndPoint.x]);
						}
						else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f0 floatValueForFloatInput:segmentEndPoint.x]);
					}
				}
				else//f0 is smaller at the start.
				{
					//is there crossover between the start point and the end of the domain of f1?
					if([f0 floatValueForFloatInput:f1.domainMaximum] <= f1.floatValueAtDomainMaximum)//there is no crossover.
					{
						//lay down f0 until the end of the domain of f1.  Increment f1.  Recompute segmentStartPoint
						segmentEndPoint = CGPointMake(f1.domainMaximum, [f0 floatValueForFloatInput:f1.domainMaximum]);
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						if((f1 = [f1Enumerator nextObject]))
						{
							if(f1.domainMinimum == segmentEndPoint.x)
							{
								if(f1.floatValueAtDomainMinimum < [f0 floatValueForFloatInput:f1.domainMinimum])	segmentStartPoint = CGPointMake(f1.domainMinimum, f1.floatValueAtDomainMinimum);
								else																				segmentStartPoint = CGPointMake(f1.domainMinimum, [f0 floatValueForFloatInput:f1.domainMinimum]);
							}
							else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f0 floatValueForFloatInput:segmentEndPoint.x]);
						}
						else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f0 floatValueForFloatInput:segmentEndPoint.x]);
					}
					else	//there is crossover.
					{
						//compute the crossing point.  Lay down f0 until the crossing point.  Set segmentStartPoint = segmentEndPoint.
						segmentEndPoint = [LineSegmentPartialFloatEndomorphism pointOfIntersectionBetweenLineSegmentPFE0:f1 andLineSegmentPFE1:f0];
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						segmentStartPoint = segmentEndPoint;
					}
				}
			}
		}
	}
	return [PiecewiseLinearPartialFloatEndomorphism piecewiseLinearPFEWithLineSegmentPFEs:[NSArray arrayWithArray:m_lineSegmentPFEs] maximizing:false];
}

+(PiecewiseLinearPartialFloatEndomorphism*)maxUnionPiecewiseLinearPFEWithPiecewiseLinearPFE0:(PiecewiseLinearPartialFloatEndomorphism*)piecewiseLinearPFE0 piecewiseLinearPFE1:(PiecewiseLinearPartialFloatEndomorphism*)piecewiseLinearPFE1
{
	NSMutableArray* m_lineSegmentPFEs = [NSMutableArray array];
	NSEnumerator* f0Enumerator = [piecewiseLinearPFE0.disjointLineSegmentPFEsWithDomainsInAscendingOrder objectEnumerator];
	NSEnumerator* f1Enumerator = [piecewiseLinearPFE1.disjointLineSegmentPFEsWithDomainsInAscendingOrder objectEnumerator];
	bool noStartPoint = true;
	LineSegmentPartialFloatEndomorphism* f0 = [f0Enumerator nextObject];
	LineSegmentPartialFloatEndomorphism* f1 = [f1Enumerator nextObject];
	if(f0 == nil)	return piecewiseLinearPFE1;
	if(f1 == nil)	return piecewiseLinearPFE0;
	CGPoint segmentStartPoint;
	CGPoint segmentEndPoint;
	while(f0 || f1)//we lay down a (possibly extraneous) segment each run through the loop.
	{
		if(noStartPoint)
		{
			if(!f0)
			{
				segmentStartPoint = CGPointMake(f1.domainMinimum, f1.floatValueAtDomainMinimum);
			}
			else	if(!f1)
			{
				segmentStartPoint = CGPointMake(f0.domainMinimum, f0.floatValueAtDomainMinimum);
			}
			else	if(f0.domainMinimum < f1.domainMinimum || (f0.domainMinimum == f1.domainMinimum && (f0.floatValueAtDomainMinimum > f1.floatValueAtDomainMinimum || (f0.floatValueAtDomainMinimum == f1.floatValueAtDomainMinimum && [f0 slope] > [f1 slope]))))
			{
				segmentStartPoint = CGPointMake(f0.domainMinimum, f0.floatValueAtDomainMinimum);
			}
			else
			{
				segmentStartPoint = CGPointMake(f1.domainMinimum, f1.floatValueAtDomainMinimum);
			}
			noStartPoint = false;
		}
		if(!f0)
		{
			segmentEndPoint = CGPointMake(f1.domainMaximum, f1.floatValueAtDomainMaximum);
			[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
			if((f1 = [f1Enumerator nextObject]))	segmentStartPoint = CGPointMake(f1.domainMinimum, f1.floatValueAtDomainMinimum);
		}
		else	if(!f1)
		{
			segmentEndPoint = CGPointMake(f0.domainMaximum, f0.floatValueAtDomainMaximum);
			[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
			if((f0 = [f1Enumerator nextObject]))	segmentStartPoint = CGPointMake(f0.domainMinimum, f0.floatValueAtDomainMinimum);
		}
		else	if(segmentStartPoint.x < f0.domainMinimum)//starting before domain of f0.
		{
			//is there domain overlap?
			if(f1.domainMaximum < f0.domainMinimum)//there is no domain overlap.
			{
				//lay down the rest of f1.  Then ditch 
				segmentEndPoint = CGPointMake(f1.domainMaximum, f1.floatValueAtDomainMaximum);
				[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
				segmentStartPoint = segmentEndPoint;
				f1 = [f1Enumerator nextObject];
				noStartPoint = true;
			}
			else//there is domain overlap.
			{
				//lay down f1 until the domain overlap.  Then recompute segmentStartPoint.
				segmentEndPoint = CGPointMake(f0.domainMinimum, [f1 floatValueForFloatInput:f0.domainMinimum]);
				[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
				if(f0.floatValueAtDomainMinimum > segmentEndPoint.y || (f0.floatValueAtDomainMinimum == segmentEndPoint.y && [f0 slope] > [f1 slope]))
				{
					segmentStartPoint = CGPointMake(f0.domainMinimum, f0.floatValueAtDomainMinimum);
				}
				else
				{
					segmentStartPoint = segmentEndPoint;
				}
			}
		}
		else if(segmentStartPoint.x < f1.domainMinimum)//starting before domain of f1.
		{
			//is there domain overlap?
			if(f0.domainMaximum < f1.domainMinimum)//there is no domain overlap.
			{
				//lay down the rest of f0.  Then ditch
				segmentEndPoint = CGPointMake(f0.domainMaximum, f0.floatValueAtDomainMaximum);
				[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
				segmentStartPoint = segmentEndPoint;
				f0 = [f0Enumerator nextObject];
				noStartPoint = true;
			}
			else //there is domain overlap.
			{
				//lay down f0 until the domain overlap.  Then recompute segmentStartPoint.
				segmentEndPoint = CGPointMake(f1.domainMinimum, [f0 floatValueForFloatInput:f1.domainMinimum]);
				[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
				if(f1.floatValueAtDomainMinimum > segmentEndPoint.y || (f1.floatValueAtDomainMinimum == segmentEndPoint.y && [f1 slope] > [f0 slope]))
				{
					segmentStartPoint = CGPointMake(f1.domainMinimum, f1.floatValueAtDomainMinimum);
				}
				else
				{
					segmentStartPoint = segmentEndPoint;
				}
			}
		}
		else//starting in a domain overlap.
		{
			//which function ends first?
			if(f0.domainMaximum < f1.domainMaximum)//f0 ends first.
			{
				//do both functions contain the start point?
				if([f0 floatValueForFloatInput:segmentStartPoint.x] > [f1 floatValueForFloatInput:segmentStartPoint.x])//f0 is larger at the start.
				{
					//is there crossover between the start point and the end of the domain of f0?
					if(f0.floatValueAtDomainMaximum >= [f1 floatValueForFloatInput:f0.domainMaximum])//there is no crossover.
					{
						//lay down the remainder of f0.  increment f0.  recompute segmentStartPoint
						segmentEndPoint = CGPointMake(f0.domainMaximum, f0.floatValueAtDomainMaximum);
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						if((f0 = [f0Enumerator nextObject]))
						{
							if(f0.domainMinimum == segmentEndPoint.x)
							{
								if(f0.floatValueAtDomainMinimum > [f1 floatValueForFloatInput:f0.domainMinimum])	segmentStartPoint = CGPointMake(f0.domainMinimum, f0.floatValueAtDomainMinimum);
								else																				segmentStartPoint = CGPointMake(f0.domainMinimum, [f1 floatValueForFloatInput:f0.domainMinimum]);
							}
							else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f1 floatValueForFloatInput:segmentEndPoint.x]);
						}
						else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f1 floatValueForFloatInput:segmentEndPoint.x]);
					}
					else	//there is crossover.
					{
						//compute the crossing point.  Lay down f0 until the crossing point.  Set segmentStartPoint = segmentEndPoint.
						segmentEndPoint = [LineSegmentPartialFloatEndomorphism pointOfIntersectionBetweenLineSegmentPFE0:f0 andLineSegmentPFE1:f1];
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						segmentStartPoint = segmentEndPoint;
					}
				}
				else if([f0 floatValueForFloatInput:segmentStartPoint.x] == [f1 floatValueForFloatInput:segmentStartPoint.x])//f0 = f1 at the start.
				{
					//are their slopes equal?
					if([f1 slope] > [f0 slope])//f1 has larger slope.
					{
						//Lay down f1 until the end of the domain of f0.  Increment f0 and recompute the startPoint.
						segmentEndPoint = CGPointMake(f0.domainMaximum, [f1 floatValueForFloatInput:f0.domainMaximum]);
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						if((f0 = [f0Enumerator nextObject]))
						{
							if(f0.domainMinimum == segmentEndPoint.x)
							{
								if(f0.floatValueAtDomainMinimum > [f1 floatValueForFloatInput:f0.domainMinimum])	segmentStartPoint = CGPointMake(f0.domainMinimum, f0.floatValueAtDomainMinimum);
								else																				segmentStartPoint = CGPointMake(f0.domainMinimum, [f1 floatValueForFloatInput:f0.domainMinimum]);
							}
							else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f1 floatValueForFloatInput:segmentEndPoint.x]);
						}
						else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f1 floatValueForFloatInput:segmentEndPoint.x]);
					}
					else//they have the same slope or f0 has larger slope.
					{
						//lay down the remainder of f0.  increment f0.  recompute segmentStartPoint.
						segmentEndPoint = CGPointMake(f0.domainMaximum, f0.floatValueAtDomainMaximum);
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						if((f0 = [f0Enumerator nextObject]))
						{
							if(f0.domainMinimum == segmentEndPoint.x)
							{
								if(f0.floatValueAtDomainMinimum > [f1 floatValueForFloatInput:f0.domainMinimum])	segmentStartPoint = CGPointMake(f0.domainMinimum, f0.floatValueAtDomainMinimum);
								else																				segmentStartPoint = CGPointMake(f0.domainMinimum, [f1 floatValueForFloatInput:f0.domainMinimum]);
							}
							else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f1 floatValueForFloatInput:segmentEndPoint.x]);
						}
						else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f1 floatValueForFloatInput:segmentEndPoint.x]);
					}
				}
				else//f1 is larger at the start.
				{
					//is there crossover between the start point and the end of the domain of f0?
					if([f1 floatValueForFloatInput:f0.domainMaximum] >= f0.floatValueAtDomainMaximum)//there is no crossover.
					{
						//lay down f1 until the end of the domain of f0.  Increment f0.  Recompute segmentStartPoint
						segmentEndPoint = CGPointMake(f0.domainMaximum, [f1 floatValueForFloatInput:f0.domainMaximum]);
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						if((f0 = [f0Enumerator nextObject]))
						{
							if(f0.domainMinimum == segmentEndPoint.x)
							{
								if(f0.floatValueAtDomainMinimum > [f1 floatValueForFloatInput:f0.domainMinimum])	segmentStartPoint = CGPointMake(f0.domainMinimum, f0.floatValueAtDomainMinimum);
								else																				segmentStartPoint = CGPointMake(f0.domainMinimum, [f1 floatValueForFloatInput:f0.domainMinimum]);
							}
							else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f1 floatValueForFloatInput:segmentEndPoint.x]);
						}
						else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f1 floatValueForFloatInput:segmentEndPoint.x]);
					}
					else	//there is crossover.
					{
						//compute the crossing point.  Lay down f1 until the crossing point.  Set segmentStartPoint = segmentEndPoint.
						segmentEndPoint = [LineSegmentPartialFloatEndomorphism pointOfIntersectionBetweenLineSegmentPFE0:f0 andLineSegmentPFE1:f1];
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						segmentStartPoint = segmentEndPoint;
					}
				}
			}
			else//f1 ends first
			{
				//do both functions contain the start point?
				if([f1 floatValueForFloatInput:segmentStartPoint.x] > [f0 floatValueForFloatInput:segmentStartPoint.x])//f1 is larger at the start.
				{
					//is there crossover between the start point and the end of the domain of f1?
					if(f1.floatValueAtDomainMaximum >= [f0 floatValueForFloatInput:f1.domainMaximum])//there is no crossover.
					{
						//lay down the remainder of f1.  increment f1.  recompute segmentStartPoint
						segmentEndPoint = CGPointMake(f1.domainMaximum, f1.floatValueAtDomainMaximum);
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						if((f1 = [f1Enumerator nextObject]))
						{
							if(f1.domainMinimum == segmentEndPoint.x)
							{
								if(f1.floatValueAtDomainMinimum > [f0 floatValueForFloatInput:f1.domainMinimum])	segmentStartPoint = CGPointMake(f1.domainMinimum, f1.floatValueAtDomainMinimum);
								else																				segmentStartPoint = CGPointMake(f1.domainMinimum, [f0 floatValueForFloatInput:f1.domainMinimum]);
							}
							else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f0 floatValueForFloatInput:segmentEndPoint.x]);
						}
						else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f0 floatValueForFloatInput:segmentEndPoint.x]);
					}
					else	//there is crossover.
					{
						//compute the crossing point.  Lay down f1 until the crossing point.  Set segmentStartPoint = segmentEndPoint.
						segmentEndPoint = [LineSegmentPartialFloatEndomorphism pointOfIntersectionBetweenLineSegmentPFE0:f1 andLineSegmentPFE1:f0];
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						segmentStartPoint = segmentEndPoint;
					}
				}
				else if([f1 floatValueForFloatInput:segmentStartPoint.x] == [f0 floatValueForFloatInput:segmentStartPoint.x])//f1 = f0 at the start.
				{
					//are their slopes equal?
					if([f0 slope] > [f1 slope])//f0 has larger slope.
					{
						//Lay down f0 until the end of the domain of f1.  Increment f1 and recompute the startPoint.
						segmentEndPoint = CGPointMake(f1.domainMaximum, [f0 floatValueForFloatInput:f1.domainMaximum]);
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						if((f1 = [f1Enumerator nextObject]))
						{
							if(f1.domainMinimum == segmentEndPoint.x)
							{
								if(f1.floatValueAtDomainMinimum > [f0 floatValueForFloatInput:f1.domainMinimum])	segmentStartPoint = CGPointMake(f1.domainMinimum, f1.floatValueAtDomainMinimum);
								else																				segmentStartPoint = CGPointMake(f1.domainMinimum, [f0 floatValueForFloatInput:f1.domainMinimum]);
							}
							else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f0 floatValueForFloatInput:segmentEndPoint.x]);
						}
						else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f0 floatValueForFloatInput:segmentEndPoint.x]);
					}
					else//they have the same slope or f1 has larger slope.
					{
						//lay down the remainder of f1.  increment f1.  recompute segmentStartPoint.
						segmentEndPoint = CGPointMake(f1.domainMaximum, f1.floatValueAtDomainMaximum);
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						if((f1 = [f1Enumerator nextObject]))
						{
							if(f1.domainMinimum == segmentEndPoint.x)
							{
								if(f1.floatValueAtDomainMinimum > [f0 floatValueForFloatInput:f1.domainMinimum])	segmentStartPoint = CGPointMake(f1.domainMinimum, f1.floatValueAtDomainMinimum);
								else																				segmentStartPoint = CGPointMake(f1.domainMinimum, [f0 floatValueForFloatInput:f1.domainMinimum]);
							}
							else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f0 floatValueForFloatInput:segmentEndPoint.x]);
						}
						else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f0 floatValueForFloatInput:segmentEndPoint.x]);
					}
				}
				else//f0 is larger at the start.
				{
					//is there crossover between the start point and the end of the domain of f1?
					if([f0 floatValueForFloatInput:f1.domainMaximum] >= f1.floatValueAtDomainMaximum)//there is no crossover.
					{
						//lay down f0 until the end of the domain of f1.  Increment f1.  Recompute segmentStartPoint
						segmentEndPoint = CGPointMake(f1.domainMaximum, [f0 floatValueForFloatInput:f1.domainMaximum]);
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						if((f1 = [f1Enumerator nextObject]))
						{
							if(f1.domainMinimum == segmentEndPoint.x)
							{
								if(f1.floatValueAtDomainMinimum > [f0 floatValueForFloatInput:f1.domainMinimum])	segmentStartPoint = CGPointMake(f1.domainMinimum, f1.floatValueAtDomainMinimum);
								else																				segmentStartPoint = CGPointMake(f1.domainMinimum, [f0 floatValueForFloatInput:f1.domainMinimum]);
							}
							else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f0 floatValueForFloatInput:segmentEndPoint.x]);
						}
						else	segmentStartPoint = CGPointMake(segmentEndPoint.x, [f0 floatValueForFloatInput:segmentEndPoint.x]);
					}
					else	//there is crossover.
					{
						//compute the crossing point.  Lay down f0 until the crossing point.  Set segmentStartPoint = segmentEndPoint.
						segmentEndPoint = [LineSegmentPartialFloatEndomorphism pointOfIntersectionBetweenLineSegmentPFE0:f1 andLineSegmentPFE1:f0];
						[m_lineSegmentPFEs addObject:[LineSegmentPartialFloatEndomorphism lineSegmentPFEWithLineSegment2D:[LineSegment2D lineSegment2DWithVertex0:segmentStartPoint vertex1:segmentEndPoint]]];
						segmentStartPoint = segmentEndPoint;
					}
				}
			}
		}
	}
	return [PiecewiseLinearPartialFloatEndomorphism piecewiseLinearPFEWithLineSegmentPFEs:[NSArray arrayWithArray:m_lineSegmentPFEs] maximizing:true];
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
	if(self = [super init])
	{
		self.disjointLineSegmentPFEsWithDomainsInAscendingOrder = disjointLineSegmentPFEsWithDomainsInAscendingOrder;
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

@end
