//
//  PolygonTetrisCEGObject.h
//  Constructive Euclidean Geometry
//
//  Created by Ryan Tsukamoto on 4/18/12.
//  Copyright (c) 2012 Miso Media. All rights reserved.
//

#import "CEGObject.h"

//!	A protocol for partial float endomorphisms (float-valued functions which are defined on some subset of the floats).
@protocol PartialFloatEndomorphism

-(float)floatValueForFloatInput:(float)input;	//!<	return NaN if input is outside of the domain.

@end

//!	A partial endomorphism y = f(x) from floats to floats defined on a compact closed subset of the floats {x | domainMinimum <= x <= domainMaximum}.
@protocol CompactPartialFloatEndomorphism <PartialFloatEndomorphism>

@property	(nonatomic, readonly)	float	domainMinimum;
@property	(nonatomic, readonly)	float	domainMaximum;

@end

//@interface LineSegment : NSObject
//
//@property	(nonatomic, readonly)	id<EGPoint> vertex0;
//@property	(nonatomic, readonly)	id<EGPoint>	vertex1;
//
//@end

@interface LineSegment2D : NSObject // should eventually be of LineSegment

@property	(nonatomic, readonly)	CGPoint	vertex0;
@property	(nonatomic, readonly)	CGPoint	vertex1;

+(LineSegment2D*)lineSegment2DWithVertex0:(CGPoint)vertex0 vertex1:(CGPoint)vertex1;

-(id)initWithVertex0:(CGPoint)vertex0 vertex1:(CGPoint)vertex1;
-(float)distanceBelowVertex:(CGPoint)vertex;	//!<	if the point lies above the line defined by the line segment, then return a positive result.  Below, a negative result.

@end

//!	A line segment ((x_0, y_0), (x_1, y_1)) with x_0 \neq x_1 (with finite slope, so not vertical) viewed as a function y = f(x) for 
@interface LineSegmentPartialFloatEndomorphism : NSObject <CompactPartialFloatEndomorphism>

@property	(nonatomic, readonly, strong)	LineSegment2D*	lineSegment2D;

+(LineSegmentPartialFloatEndomorphism*)lineSegmentPFEWithLineSegment2D:(LineSegment2D*)lineSegment2D;

-(id)initWithLineSegment2D:(LineSegment2D*)lineSegment2D;

@end

@interface PiecewiseLinearPartialFloatEndomorphism : NSObject <PartialFloatEndomorphism>

@property	(nonatomic, readonly, strong)	NSArray* disjointLineSegmentsInAscendingOrder;	//!<	An array of LineSegmentPartialFloatEndomorphism instances with non-overlapping domains (except for singletons).
@property	(nonatomic, readonly)	bool	maximizing;	//!<	when two line-segments-as-a-function instances share a single point in their domain, do we use the larger of the two (possibly different) values?

+(PiecewiseLinearPartialFloatEndomorphism*)piecewiseLinearPFEWithLineSegmentsPartialFloatEndomorphisms:(NSArray*)lineSegmentPartialFloatEndomorphisms maximizing:(bool)maximizing;	//!<	sort them by domain.

-(id)initWithLineSegmentsPartialFloatEndomorphisms:(NSArray*)lineSegmentPartialFloatEndomorphisms maximizing:(bool)maximizing;	//!<	sort them by domain.

@end

//!	A protocol for polygon tetris objects
@protocol PolygonTetrisCEGObject

@property	(nonatomic, readonly, strong)	PiecewiseLinearPartialFloatEndomorphism*	upperPartialFloatEndomorphism;
@property	(nonatomic, readonly, strong)	PiecewiseLinearPartialFloatEndomorphism*	lowerPartialFloatEndomorphism;

@end

@interface PolygonTetrisCEGTriangle : CEGObject <PolygonTetrisCEGObject>

-(id)initWithVertex0:(CGPoint)vertex0 vertex1:(CGPoint)vertex1 vertex2:(CGPoint)vertex2;

@end

@interface PolygonTetrisCEGUnion : CEGUnion <PolygonTetrisCEGObject>

@end

@interface PolygonTetrisCEGIntersection : CEGIntersection <PolygonTetrisCEGObject>

@end

@interface PolygonTetrisCEGDifference : CEGDifference <PolygonTetrisCEGObject>

@end

@interface PolygonTetrisSystem : NSObject

@property	(nonatomic, readonly)	float	floorHeight;
@property	(nonatomic, readonly, strong)	id<PolygonTetrisCEGObject>	polygonTetrisCEGObject;

-(id)initWithFloorHeight:(float)floorHeight polygonTetrisCEGObject:(id<PolygonTetrisCEGObject>)polygonTetrisCEGObject;//drop an object onto the floor

-(void)addPolygonTetrisCEGObject:(id<PolygonTetrisCEGObject>)polygonTetrisCEGObject;//drop an object into the system, unioning the result with self.polygonTetrisCEGObject and setting the union as the value of self.polygonTetrisCEGObject.

@end
