//
//  CEGObject.m
//  Constructive Euclidean Geometry
//
//  Created by Ryan Tsukamoto on 4/16/12.
//  Copyright (c) 2012 Miso Media. All rights reserved.
//

#import "CEGObject.h"
#import "Generics.h"

@interface EGPoint()

@property	(nonatomic, readwrite, strong)	NSArray*	components;

@end

@implementation	EGPoint

-(int)dimension{return [self.components count];}

-(NSNumber*)componentAtIndex:(int)index{return index < [self.components count]	? [self.components objectAtIndex:index] : nil;}

@end

//!	A class for representing an object constructed in Constructive Euclidean Geometry (my name for generalized Constructive Solid Geometry) in an arbitrary number of dimensions (infinite dimensions, most of which are flattened or not used).
@implementation CEGObject

-(bool)exteriorContainsPoint:(EGPoint*)point{return true;}

-(bool)borderContainsPoint:(EGPoint*)point{return !([self interiorContainsPoint:point] || [self exteriorContainsPoint:point]);}

-(bool)interiorContainsPoint:(EGPoint*)point{return false;}

@end

@interface CEGUnion()

@property	(nonatomic, readwrite, strong)	NSArray*	objects;

@end

@implementation CEGUnion

@synthesize objects = _objects;

-(id)initWithObjects:(NSArray*)objects
{
	if(self = [super init])	self.objects = objects;
	return self;
}

-(bool)exteriorContainsPoint:(EGPoint*)point
{
	return
	[(NSNumber*)foldl
		(
			^id(id lhs, id rhs){return [NSNumber numberWithBool:[lhs boolValue] && [rhs exteriorContainsPoint:point]];},
			[NSNumber numberWithBool:YES],
			self.objects
		)
		boolValue
	];
}

-(bool)interiorContainsPoint:(EGPoint*)point
{
	return
	[(NSNumber*)foldl
		(
			^id(id lhs, id rhs){return [NSNumber numberWithBool:[lhs boolValue] || [rhs interiorContainsPoint:point]];},
			[NSNumber numberWithBool:NO],
			self.objects
		)
		boolValue
	];
}

@end

@interface CEGIntersection()

@property	(nonatomic, readwrite, strong)	NSArray*	objects;

@end

@implementation CEGIntersection

@synthesize objects = _objects;

-(id)initWithObjects:(NSArray*)objects
{
	if(self = [super init])	self.objects = objects;
	return self;
}

-(bool)exteriorContainsPoint:(EGPoint*)point
{
	return
	[(NSNumber*)foldl
		(
			^id(id lhs, id rhs)
			{
				return [NSNumber numberWithBool:[lhs boolValue] || [rhs exteriorContainsPoint:point]];
			},
			[NSNumber numberWithBool:NO],
			self.objects
		)
		boolValue
	];
}

-(bool)interiorContainsPoint:(EGPoint*)point
{
	return
	[(NSNumber*)foldl
		(
			^id(id lhs, id rhs)
			{
				return [NSNumber numberWithBool:[lhs boolValue] && [rhs interiorContainsPoint:point]];
			},
			[NSNumber numberWithBool:YES],
			self.objects
		)
		boolValue
	];
}

@end

@interface CEGDifference()

@property	(nonatomic, readwrite, strong)	CEGObject*	positiveObject;
@property	(nonatomic, readwrite, strong)	CEGObject*	negativeObject;

@end

@implementation CEGDifference

@synthesize positiveObject = _positiveObject;
@synthesize negativeObject = _negativeObject;

-(id)initWithPositiveObject:(CEGObject*)positiveObject negativeObject:(CEGObject*)negativeObject
{
	if(self = [super init])
	{
		self.positiveObject = positiveObject;
		self.negativeObject = negativeObject;
	}
	return self;
}

-(bool)exteriorContainsPoint:(EGPoint*)point{return [self.positiveObject exteriorContainsPoint:point] && [self.negativeObject interiorContainsPoint:point];}

-(bool)interiorContainsPoint:(EGPoint*)point{return [self.positiveObject interiorContainsPoint:point] && [self.negativeObject exteriorContainsPoint:point];}

@end
