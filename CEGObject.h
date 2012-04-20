//
//  CEGObject.h
//  Constructive Euclidean Geometry
//
//  Created by Ryan Tsukamoto on 4/16/12.
//  Copyright (c) 2012 Miso Media. All rights reserved.
//

#import <Foundation/Foundation.h>

//!	A protocol for representing a point in an arbitrary number of dimensions.
@protocol EGPoint <NSObject>

-(int)dimension;
-(NSNumber*)componentAtIndex:(int)index;	//!<	returns nil for an index for a dimension greater than the dimension of the point (rendering its value undefined.  Think of the line x = 1 in the x-y plane.  Y is anything, and so all the other components are thus undefined.

@end

//!	A class for representing an object constructed in Constructive Euclidean Geometry (my name for generalized Constructive Solid Geometry) in an arbitrary number of dimensions (infinite dimensions, most of which are flattened or not used).
@interface CEGObject : NSObject

-(bool)exteriorContainsPoint:(id<EGPoint>)point;
-(bool)borderContainsPoint:(id<EGPoint>)point;
-(bool)interiorContainsPoint:(id<EGPoint>)point;

@end

//!	A class for representing the result of folding with setwise union over some list of objects.
@interface CEGUnion : CEGObject

@property	(nonatomic, readonly, strong)	NSArray*	objects;

-(id)initWithObjects:(NSArray*)objects;

@end

//!	A class for representing the result of folding with setwise intersection over some list of objects.
@interface CEGIntersection : CEGObject

@property	(nonatomic, readonly, strong)	NSArray*	objects;

-(id)initWithObjects:(NSArray*)objects;

@end

//!	A class for representing the setwise difference between two objects.
@interface CEGDifference : CEGObject

@property	(nonatomic, readonly, strong)	CEGObject*	positiveObject;
@property	(nonatomic, readonly, strong)	CEGObject*	negativeObject;

-(id)initWithPositiveObject:(CEGObject*)positiveObject negativeObject:(CEGObject*)negativeObject;

@end
