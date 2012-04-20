//
//  CEGAxisAlignedOrthotope.h
//  Constructive Euclidean Geometry
//
//  Created by Ryan Tsukamoto on 4/17/12.
//  Copyright (c) 2012 Miso Media. All rights reserved.
//

#import "CEGObject.h"

//!	A helper class for n-1 dimenional regions.  Think of a region -1/2 < x < 1/2 as being encoded by {index:0,minValue:-1/2,maxValue:1/2}
@interface CEG1DRange : CEGObject

@property	(nonatomic, readonly)	int	index;	//!<	The index into the array of components.
@property	(nonatomic, readonly)	float	minValue;	//!<	The minimum value
@property	(nonatomic, readonly)	float	maxValue;	//!<	The maximum value

+(CEG1DRange*)ceg1dRangeWithIndex:(int)index minValue:(float)minValue maxValue:(float)maxValue;
-(id)initWithIndex:(int)index minValue:(float)minValue maxValue:(float)maxValue;

@end

//!	A class for axis aligned orthotopes in constructive euclidean geometry.  Simply the intersection of n n-1 dimensional regions.  Think of a unit square centered at the origin as \{(x,y,...) | -1/2 < x < 1/2\} \cap \{(x,y,...) | -1/2 < y < 1/2\}.
@interface CEGAxisAlignedOrthotope : CEGIntersection

@property	(nonatomic, readonly, strong)	NSArray*	pairsOfMinsAndMaxes;//!<	the pairs of mins and maxes as NSNumbers

-(id)initWithPairsOfMinsAndMaxes:(NSArray*)pairsOfMinsAndMaxes;

@end
