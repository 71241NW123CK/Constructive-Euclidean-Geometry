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

-(void)moveUpByFloat:(float)value;

@end

@implementation LineSegmentPartialFloatEndomorphism

@synthesize	lineSegment2D = _lineSegment2D;
@synthesize domainMinimum = _domainMinimum;
@synthesize floatValueAtDomainMinimum = _floatValueAtDomainMinimum;
@synthesize domainMaximum = _domainMaximum;
@synthesize floatValueAtDomainMaximum = _floatValueAtDomainMaximum;

+(LineSegmentPartialFloatEndomorphism*)lineSegmentPFEWithLineSegment2D:(LineSegment2D*)lineSegment2D{return [[LineSegmentPartialFloatEndomorphism alloc] initWithLineSegment2D:lineSegment2D];}

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

-(void)moveUpByFloat:(float)value{[self.lineSegment2D moveUpByFloat:value];}

@end

@interface PiecewiseLinearPartialFloatEndomorphism()

@property	(nonatomic, readwrite, strong)	NSArray* disjointLineSegmentsInAscendingOrder;	//!<	An array of LineSegmentPartialFloatEndomorphism instances with non-overlapping domains (except for singletons).
@property	(nonatomic, readwrite)	bool	maximizing;	//!<	when two line-segments-as-a-function instances share a single point in their domain, do we use the larger of the two (possibly different) values?

@end

@implementation PiecewiseLinearPartialFloatEndomorphism

@synthesize disjointLineSegmentsInAscendingOrder = _disjointLineSegmentsInAscendingOrder;
@synthesize maximizing = _maximizing;

-(id)initWithLineSegmentsPartialFloatEndomorphisms:(NSArray*)lineSegmentPartialFloatEndomorphisms maximizing:(bool)maximizing//!<	sort them by domain.
{
	if(self = [super init])
	{
		self.disjointLineSegmentsInAscendingOrder =
		[lineSegmentPartialFloatEndomorphisms
			arrayByReorderingWithProjectionBlock:
				^id(id lineSegmentPartialFloatEndomorphism){return [NSNumber numberWithFloat:((LineSegmentPartialFloatEndomorphism*)lineSegmentPartialFloatEndomorphism).domainMinimum];}
			comparisonSelector:
				@selector(compare:)
		];
		self.maximizing = maximizing;
	}
	return self;
}

-(float)floatValueForFloatInput:(float)input
{
	float __block result = nanf("");
	[self.disjointLineSegmentsInAscendingOrder
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

@end

float planarCrossProd(CGPoint v0, CGPoint v1);
float planarCrossProd(CGPoint v0, CGPoint v1){return v0.x * v1.y - v1.x * v0.y;}

@interface PolygonTetrisCEGTriangle()

@property	(nonatomic, readwrite)	CGPoint vertex0;
@property	(nonatomic, readwrite)	CGPoint vertex1;
@property	(nonatomic, readwrite)	CGPoint vertex2;

@property	(nonatomic, readwrite, strong)	PiecewiseLinearPartialFloatEndomorphism*	upperPartialFloatEndomorphism;
@property	(nonatomic, readwrite, strong)	PiecewiseLinearPartialFloatEndomorphism*	lowerPartialFloatEndomorphism;

+(float)lengthProductTimesAngleSineVector0:(CGPoint)vector0 vector1:(CGPoint)vector1;	//!<	Like a cross product, but restricted to two input vectors with zero z component.

@end

@implementation PolygonTetrisCEGTriangle

@synthesize vertex0 = _vertex0;
@synthesize vertex1 = _vertex1;
@synthesize vertex2 = _vertex2;
@synthesize upperPartialFloatEndomorphism = _upperPartialFloatEndomorphism;
@synthesize lowerPartialFloatEndomorphism = _lowerPartialFloatEndomorphism;

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
		self.upperPartialFloatEndomorphism = [PiecewiseLinearPartialFloatEndomorphism piecewiseLinearPFEWithLineSegmentsPartialFloatEndomorphisms:[NSArray arrayWithArray:upperLineSegmentPartialFloatEndomorphisms] maximizing:true];
		self.lowerPartialFloatEndomorphism = [PiecewiseLinearPartialFloatEndomorphism piecewiseLinearPFEWithLineSegmentsPartialFloatEndomorphisms:[NSArray arrayWithArray:lowerLineSegmentPartialFloatEndomorphisms] maximizing:false];
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

@end

@interface PolygonTetrisCEGUnion()

@property	(nonatomic, readwrite, strong)	PiecewiseLinearPartialFloatEndomorphism*	upperPartialFloatEndomorphism;
@property	(nonatomic, readwrite, strong)	PiecewiseLinearPartialFloatEndomorphism*	lowerPartialFloatEndomorphism;

@end

@implementation PolygonTetrisCEGUnion

@synthesize upperPartialFloatEndomorphism = _upperPartialFloatEndomorphism;
@synthesize lowerPartialFloatEndomorphism = _lowerPartialFloatEndomorphism;

-(id)initWithObjects:(NSArray*)objects
{
	if(self = [super initWithObjects:objects])
	{
		//compute the upper and lower PFEs from the upper and lower PFEs of the objects.
	}
	return self;
}

@end

@implementation PolygonTetrisCEGIntersection

@end

@implementation PolygonTetrisCEGDifference

@end


@interface PolygonTetrisSystem : NSObject

@property	(nonatomic, readonly)	float	floorHeight;
@property	(nonatomic, readonly, strong)	id<PolygonTetrisCEGObject>	polygonTetrisCEGObject;

-(id)initWithFloorHeight:(float)floorHeight polygonTetrisCEGObject:(id<PolygonTetrisCEGObject>)polygonTetrisCEGObject;//drop an object onto the floor

-(void)addPolygonTetrisCEGObject:(id<PolygonTetrisCEGObject>)polygonTetrisCEGObject;//drop an object into the system, unioning the result with self.polygonTetrisCEGObject and setting the union as the value of self.polygonTetrisCEGObject.

@end
