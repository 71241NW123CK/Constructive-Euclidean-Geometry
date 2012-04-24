//
//  PolygonTetrisCEGObjectTest.h
//  Constructive Euclidean Geometry
//
//  Created by Ryan Tsukamoto on 4/21/12.
//  Copyright (c) 2012 Miso Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PolygonTetrisCEGObject.h"

@interface LineSegment2D(OpenGL)

-(void)draw;

@end

@interface LineSegmentPartialFloatEndomorphism(OpenGL)

-(void)draw;

@end

@interface PiecewiseLinearPartialFloatMinMaxEndomorphismPair(OpenGL)

-(void)draw;

@end

@interface PolygonTetrisCEGTriangle(OpenGL)

-(void)draw;

@end

@interface PolygonTetrisCEGUnion(OpenGL)

-(void)draw;

@end

@interface PolygonTetrisSystem(OpenGL)

-(void)draw;

@end

@interface PolygonTetrisCEGObjectTest : NSObject

+(void)runTest;

@end

@interface TetrisGLView : UIView
{
    GLint					backingWidth;
    GLint					backingHeight;
    EAGLContext*			context;
    GLuint					viewRenderbuffer, viewFramebuffer;
    GLuint					depthRenderbuffer;
    NSTimer*				animationTimer;
    NSTimeInterval			animationInterval;
}

@property	NSTimeInterval			animationInterval;
@property	(nonatomic, readonly, strong)	PolygonTetrisSystem*	polygonTetrisSystem;
@property	(nonatomic, readonly, strong)	NSArray*	freeTetrisObjects;
@property	(nonatomic, readonly, strong)	UIButton*	tetrisButton;//tetris all the freeTetrisObjects.
@property	(nonatomic, readonly, strong)	NSArray*	inputPoints;//NSArray* of NSArray* of length 2
@property	(nonatomic, readonly)	CGPoint inputPoint;	//the point being input.
@property	(nonatomic, readonly)	bool	input;

-(void)startAnimation;
-(void)stopAnimation;
-(void)drawView;
-(void)tetrisButtonPressed;


@end