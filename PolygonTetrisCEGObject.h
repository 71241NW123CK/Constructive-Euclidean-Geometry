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
+(LineSegmentPartialFloatEndomorphism*)lineSegmentPFEBySplicingLineSegmentPFE0:(LineSegmentPartialFloatEndomorphism*)lineSegmentPFE0 togetherWithLineSegmentPFE1:(LineSegmentPartialFloatEndomorphism*)lineSegmentPFE1;
+(NSArray*)arrayBySewingCoincidentLineSegmentPFEs:(NSArray*)lineSegmentPFEs;

-(id)initWithLineSegment2D:(LineSegment2D*)lineSegment2D;
-(id)initBySplicingLineSegmentPFE0:(LineSegmentPartialFloatEndomorphism*)lineSegmentPFE0 togetherWithLineSegmentPFE1:(LineSegmentPartialFloatEndomorphism*)lineSegmentPFE1;
-(bool)isCoincidentToTheLeftOf:(LineSegmentPartialFloatEndomorphism*)lineSegmentPFE;

@end

@interface PiecewiseLinearPartialFloatEndomorphism : NSObject <PartialFloatEndomorphism>

@property	(nonatomic, readonly, strong)	NSArray* disjointLineSegmentPFEsWithDomainsInAscendingOrder;	//!<	An array of LineSegmentPartialFloatEndomorphism instances with non-overlapping domains (except for singletons).
@property	(nonatomic, readonly)	bool	maximizing;	//!<	when two line-segments-as-a-function instances share a single point in their domain, do we use the larger of the two (possibly different) values?

+(PiecewiseLinearPartialFloatEndomorphism*)piecewiseLinearPFEWithLineSegmentPFEs:(NSArray*)lineSegmentPFEs maximizing:(bool)maximizing;	//!<	sort them by domain.  (Domains as open intervals MUST BE DISJOINT!!!!)

+(PiecewiseLinearPartialFloatEndomorphism*)minUnionPiecewiseLinearPFEWithPiecewiseLinearPFE0:(PiecewiseLinearPartialFloatEndomorphism*)piecewiseLinearPFE0 piecewiseLinearPFE1:(PiecewiseLinearPartialFloatEndomorphism*)piecewiseLinearPFE1;
+(PiecewiseLinearPartialFloatEndomorphism*)maxUnionPiecewiseLinearPFEWithPiecewiseLinearPFE0:(PiecewiseLinearPartialFloatEndomorphism*)piecewiseLinearPFE0 piecewiseLinearPFE1:(PiecewiseLinearPartialFloatEndomorphism*)piecewiseLinearPFE1;

//computes f = f1 - f0 wherever both are defined.
+(PiecewiseLinearPartialFloatEndomorphism*)differenceOnIntersectionPiecewiseLinearPFEWithPiecewiseLinearPFE0:(PiecewiseLinearPartialFloatEndomorphism*)piecewiseLinearPFE0 piecewiseLinearPFE1:(PiecewiseLinearPartialFloatEndomorphism*)piecewiseLinearPFE1;

-(id)initWithLineSegmentPFEs:(NSArray*)lineSegmentPFEs maximizing:(bool)maximizing;	//!<	sort them by domain.
-(float)minimumValue;
-(float)maximumValue;

@end

@interface PiecewiseLinearPartialFloatMinMaxEndomorphismPair : NSObject

@property	(nonatomic, readonly, strong)	PiecewiseLinearPartialFloatEndomorphism*	minPFE;
@property	(nonatomic, readonly, strong)	PiecewiseLinearPartialFloatEndomorphism*	maxPFE;

+(PiecewiseLinearPartialFloatMinMaxEndomorphismPair*)piecewiseLinearPFEPairWithMinPFE:(PiecewiseLinearPartialFloatEndomorphism*)minPFE maxPFE:(PiecewiseLinearPartialFloatEndomorphism*)maxPFE;

+(PiecewiseLinearPartialFloatMinMaxEndomorphismPair*)unionPiecewiseLinearPFEPairWithPiecewiseLinearPFEPairs:(NSArray*)piecewiseLinearPFEPairs;
//+(PiecewiseLinearPartialFloatMinMaxEndomorphismPair*)intersectionPiecewiseLinearPFEPairWithPiecewiseLinearPFEPairs:(NSArray*)piecewiseLinearPFEPairs;
//+(PiecewiseLinearPartialFloatMinMaxEndomorphismPair*)differencePiecewiseLinearPFEPairWithPiecewiseLinearPFEPairs:(NSArray*)piecewiseLinearPFEPairs;

-(id)initWithMinPFE:(PiecewiseLinearPartialFloatEndomorphism*)minPFE maxPFE:(PiecewiseLinearPartialFloatEndomorphism*)maxPFE;

@end

//!	A protocol for polygon tetris objects
@protocol PolygonTetrisCEGObject

@property	(nonatomic, readonly, strong)	PiecewiseLinearPartialFloatMinMaxEndomorphismPair* piecewiseLinearPartialFloatMinMaxEndomorphismPair;
-(void)draw;

-(void)moveUpByFloat:(float)value;

//@property	(nonatomic, readonly, strong)	PiecewiseLinearPartialFloatEndomorphism*	upperPartialFloatEndomorphism;
//@property	(nonatomic, readonly, strong)	PiecewiseLinearPartialFloatEndomorphism*	lowerPartialFloatEndomorphism;

@end

@interface PolygonTetrisCEGTriangle : CEGObject <PolygonTetrisCEGObject>

@property	(nonatomic, readonly)	CGPoint vertex0;
@property	(nonatomic, readonly)	CGPoint vertex1;
@property	(nonatomic, readonly)	CGPoint vertex2;

+(PolygonTetrisCEGTriangle*)polygonTetrisCEGTriangleWithVertex0:(CGPoint)vertex0 vertex1:(CGPoint)vertex1 vertex2:(CGPoint)vertex2;

-(id)initWithVertex0:(CGPoint)vertex0 vertex1:(CGPoint)vertex1 vertex2:(CGPoint)vertex2;

@end

@interface PolygonTetrisCEGUnion : CEGUnion <PolygonTetrisCEGObject>

+(PolygonTetrisCEGUnion*)polygonTetrisCEGUnionWithObjects:(NSArray*)objects;

@end

//@interface PolygonTetrisCEGIntersection : CEGIntersection <PolygonTetrisCEGObject>
//
//@end
//
//@interface PolygonTetrisCEGDifference : CEGDifference <PolygonTetrisCEGObject>
//
//@end

@interface PolygonTetrisSystem : NSObject

@property	(nonatomic, readonly)	float	floorHeight;
@property	(nonatomic, readonly, strong)	id<PolygonTetrisCEGObject>	polygonTetrisCEGObject;

+(PolygonTetrisSystem*)polygonTetrisSystemWithFloorHeight:(float)floorHeight;

-(id)initWithFloorHeight:(float)floorHeight;

-(id)initWithFloorHeight:(float)floorHeight polygonTetrisCEGObject:(id<PolygonTetrisCEGObject>)polygonTetrisCEGObject;//drop an object onto the floor

-(void)addPolygonTetrisCEGObject:(id<PolygonTetrisCEGObject>)polygonTetrisCEGObject;//drop an object into the system, unioning the result with self.polygonTetrisCEGObject and setting the union as the value of self.polygonTetrisCEGObject.

@end

@interface PolygonTetrisPacking : NSObject	//goes through the permutations of an array (a short one!) to find the minimum packing.

@property	(nonatomic, readonly, strong)	NSArray*	objectsInOptimalOrder;

-(id)initWithObjects:(NSArray*)objects;

@end
