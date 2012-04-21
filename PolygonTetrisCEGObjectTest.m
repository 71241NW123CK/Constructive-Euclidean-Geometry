//
//  PolygonTetrisCEGObjectTest.m
//  Constructive Euclidean Geometry
//
//  Created by Ryan Tsukamoto on 4/21/12.
//  Copyright (c) 2012 Miso Media. All rights reserved.
//

#import "PolygonTetrisCEGObjectTest.h"

@implementation PolygonTetrisCEGObjectTest

+(void)runTest
{
	PolygonTetrisCEGTriangle* triangle0 =
	[[PolygonTetrisCEGTriangle alloc]
		initWithVertex0:
			CGPointMake(0, 0)
		vertex1:
			CGPointMake(2, 0)
		vertex2:
			CGPointMake(0, 2)
	];

	NSLog(@"triangle0: (%f, %f), (%f, %f), (%f, %f)", triangle0.vertex0.x, triangle0.vertex0.y, triangle0.vertex1.x, triangle0.vertex1.y, triangle0.vertex2.x, triangle0.vertex2.y);

	PolygonTetrisCEGTriangle* triangle1 =
	[[PolygonTetrisCEGTriangle alloc]
		initWithVertex0:
			CGPointMake(2, 2)
		vertex1:
			CGPointMake(4, 4)
		vertex2:
			CGPointMake(2, 4)
	];

	NSLog(@"triangle1: (%f, %f), (%f, %f), (%f, %f)", triangle1.vertex0.x, triangle1.vertex0.y, triangle1.vertex1.x, triangle1.vertex1.y, triangle1.vertex2.x, triangle1.vertex2.y);

	PolygonTetrisSystem* tetrisSystem =
	[[PolygonTetrisSystem alloc]
		initWithFloorHeight:-1.0f
		polygonTetrisCEGObject:triangle0
	];
	NSLog(@"floorHeight:%f", tetrisSystem.floorHeight);
	
	NSLog(@"triangle0: (%f, %f), (%f, %f), (%f, %f)", triangle0.vertex0.x, triangle0.vertex0.y, triangle0.vertex1.x, triangle0.vertex1.y, triangle0.vertex2.x, triangle0.vertex2.y);
	
	[tetrisSystem addPolygonTetrisCEGObject:triangle1];
	
	NSLog(@"triangle1: (%f, %f), (%f, %f), (%f, %f)", triangle1.vertex0.x, triangle1.vertex0.y, triangle1.vertex1.x, triangle1.vertex1.y, triangle1.vertex2.x, triangle1.vertex2.y);
}

@end
