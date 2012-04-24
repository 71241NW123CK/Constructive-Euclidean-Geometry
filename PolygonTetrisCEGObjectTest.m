//
//  PolygonTetrisCEGObjectTest.m
//  Constructive Euclidean Geometry
//
//  Created by Ryan Tsukamoto on 4/21/12.
//  Copyright (c) 2012 Miso Media. All rights reserved.
//

#import "PolygonTetrisCEGObjectTest.h"
#import "OpenGLStructures.h"

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#define USE_DEPTH_BUFFER 0

@implementation LineSegment2D(OpenGL)

-(void)draw
{
	//draw a line segment using a 8 wide line in red.
	glLineWidth(8.0f);
	glColor4f(1.0f, 0.0f, 0.0f, 1.0f);
	Vertex2f lineSegmentVertices[] =
	{
		{self.vertex0.x, self.vertex0.y},
		{self.vertex1.x, self.vertex1.y}
	};
	glVertexPointer(2, GL_FLOAT, 0, lineSegmentVertices);
	glDrawArrays(GL_LINES, 0, 2);
}

@end

@implementation	LineSegmentPartialFloatEndomorphism(OpenGL)-(void)draw{[self.lineSegment2D draw];}@end

@implementation PiecewiseLinearPartialFloatEndomorphism(OpenGL)-(void)draw{[self.disjointLineSegmentPFEsWithDomainsInAscendingOrder makeObjectsPerformSelector:@selector(draw)];}@end

@implementation PiecewiseLinearPartialFloatMinMaxEndomorphismPair(OpenGL)

-(void)draw
{
	[self.minPFE draw];
	[self.maxPFE draw];
}

@end

@implementation PolygonTetrisCEGTriangle(OpenGL)

-(void)draw
{
	//draw a filled in triangle in green
	glColor4f(0.0f, 1.0f, 0.0f, 1.0f);
	Vertex2f triangleVertices[] =
	{
		{self.vertex0.x,	self.vertex0.y},
		{self.vertex1.x,	self.vertex1.y},
		{self.vertex2.x,	self.vertex2.y},
	};
	GLuint triangleIndices[] =
	{
		0, 1,
		1, 2,
		2, 0,
	};//this is problematic if culling back facing polygons!
	glVertexPointer(2, GL_FLOAT, 0, triangleVertices);
	glDrawArrays(GL_TRIANGLES, 0, 3);
	//draw the edges using a 5 wide line in black.
	glLineWidth(5.0f);
	glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
	glDrawElements(GL_LINES, 6, GL_UNSIGNED_INT, triangleIndices);
}

@end

@implementation PolygonTetrisCEGUnion(OpenGL)-(void)draw{[self.objects makeObjectsPerformSelector:@selector(draw)];}@end

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

	PolygonTetrisCEGTriangle* triangle2 =
	[[PolygonTetrisCEGTriangle alloc]
		initWithVertex0:
			CGPointMake(-1, 0)
		vertex1:
			CGPointMake(3, 0)
		vertex2:
			CGPointMake(1, -2)
	];

	NSLog(@"triangle2: (%f, %f), (%f, %f), (%f, %f)", triangle2.vertex0.x, triangle2.vertex0.y, triangle2.vertex1.x, triangle2.vertex1.y, triangle2.vertex2.x, triangle2.vertex2.y);

	PolygonTetrisSystem* tetrisSystem =
	[[PolygonTetrisSystem alloc]
		initWithFloorHeight:-1.0f
		polygonTetrisCEGObject:triangle0
	];
	NSLog(@"floorHeight:%f", tetrisSystem.floorHeight);
	
	NSLog(@"triangle0: (%f, %f), (%f, %f), (%f, %f)", triangle0.vertex0.x, triangle0.vertex0.y, triangle0.vertex1.x, triangle0.vertex1.y, triangle0.vertex2.x, triangle0.vertex2.y);
	
	[tetrisSystem addPolygonTetrisCEGObject:triangle1];
	
	NSLog(@"triangle1: (%f, %f), (%f, %f), (%f, %f)", triangle1.vertex0.x, triangle1.vertex0.y, triangle1.vertex1.x, triangle1.vertex1.y, triangle1.vertex2.x, triangle1.vertex2.y);

	[tetrisSystem addPolygonTetrisCEGObject:triangle2];
	
	NSLog(@"triangle2: (%f, %f), (%f, %f), (%f, %f)", triangle2.vertex0.x, triangle2.vertex0.y, triangle2.vertex1.x, triangle2.vertex1.y, triangle2.vertex2.x, triangle2.vertex2.y);
}

@end

@implementation PolygonTetrisSystem(OpenGL)

-(void)draw
{
	//draw the floor as a 4.0f thick blue line.
	glLineWidth(4.0f);
	glColor4f(0.0f, 0.0f, 1.0f, 1.0f);
	Vertex2f floorVertices[] =
	{
		{-4096.0f, self.floorHeight},
		{4096.0f, self.floorHeight},
	};
	glVertexPointer(2, GL_FLOAT, 0, floorVertices);
	glDrawArrays(GL_LINES, 0, 2);
	//draw the object.
	[self.polygonTetrisCEGObject.piecewiseLinearPartialFloatMinMaxEndomorphismPair draw];
	[self.polygonTetrisCEGObject draw];
}

@end

@interface TetrisGLView()

@property (nonatomic, strong) EAGLContext* context;
@property (nonatomic, strong) NSTimer* animationTimer;

@property	(nonatomic, readwrite, strong)	PolygonTetrisSystem*	polygonTetrisSystem;
@property	(nonatomic, readwrite, strong)	NSArray*	freeTetrisObjects;
@property	(nonatomic, readwrite, strong)	UIButton*	tetrisButton;//tetris all the freeTetrisObjects.
@property	(nonatomic, readwrite, strong)	NSArray*	inputPoints;//NSArray* of NSArray* of length 2
@property	(nonatomic, readwrite)	CGPoint inputPoint;	//the point being input.
@property	(nonatomic, readwrite)	bool	input;

-(BOOL)createFramebuffer;
-(void)destroyFramebuffer;

-(CGPoint)pointFromPoint:(CGPoint)point;

@end

@implementation TetrisGLView

@synthesize context;
@synthesize animationTimer;
@synthesize animationInterval;
@synthesize polygonTetrisSystem = _polygonTetrisSystem;
@synthesize freeTetrisObjects = _freeTetrisObjects;
@synthesize tetrisButton = _tetrisButton;
@synthesize inputPoints = _inputPoints;
@synthesize inputPoint = _inputPoint;
@synthesize input = _input;

-(id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
        CAEAGLLayer* eaglLayer = (CAEAGLLayer*)self.layer;
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        if (!context || ![EAGLContext setCurrentContext:context])
		{
            return nil;
        }
		self.polygonTetrisSystem = [PolygonTetrisSystem polygonTetrisSystemWithFloorHeight:-42.0f];
		self.freeTetrisObjects = [NSArray array];
		self.tetrisButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		self.tetrisButton.frame = CGRectMake(0.0f, 0.0f, 64.0f, 64.0f);
		[self.tetrisButton addTarget:self action:@selector(tetrisButtonPressed) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.tetrisButton];
		self.inputPoints = [NSArray array];
		self.inputPoint = CGPointMake(0.0f, 0.0f);
		self.input = false;
		animationInterval = 1.0 / 20.0;
	}
	return self;
}
+(Class)layerClass	{    return [CAEAGLLayer class];	}
-(void)layoutSubviews
{
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
	[self drawView];
}
-(BOOL)createFramebuffer
{
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    if(USE_DEPTH_BUFFER)
	{
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) return NO;
    return YES;
}
-(void)destroyFramebuffer
{
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    if(depthRenderbuffer)
	{
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}
-(void)startAnimation	{	self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(drawView) userInfo:nil repeats:YES];	}
-(void)stopAnimation	{	self.animationTimer = nil;																															}
-(void)setAnimationTimer:(NSTimer*)newTimer
{
    [animationTimer invalidate];
    animationTimer = newTimer;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	for(UITouch* touch in touches)
	{
		self.input = true;
		self.inputPoint = [self pointFromPoint:[touch locationInView:self]];
	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{for(UITouch* touch in touches)	if(self.input)	self.inputPoint = [self pointFromPoint:[touch locationInView:self]];}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for(UITouch* touch in touches)
	{
		if(self.input)
		{
			self.inputPoint = [self pointFromPoint:[touch locationInView:self]];
			if([self.inputPoints count] == 2)	//we've got enough points to make a triangle.  Make it and flush inputPoints.
			{
				NSMutableArray* m_freeTetrisObjects = [NSMutableArray arrayWithArray:self.freeTetrisObjects];
				PolygonTetrisCEGTriangle* triangle =
				[PolygonTetrisCEGTriangle
					polygonTetrisCEGTriangleWithVertex0:
						self.inputPoint
					vertex1:
						CGPointMake
						(
							[(NSNumber*)[(NSArray*)[self.inputPoints objectAtIndex:0] objectAtIndex:0] floatValue],
							[(NSNumber*)[(NSArray*)[self.inputPoints objectAtIndex:0] objectAtIndex:1] floatValue]
						)
					vertex2:
						CGPointMake
						(
							[(NSNumber*)[(NSArray*)[self.inputPoints objectAtIndex:1] objectAtIndex:0] floatValue],
							[(NSNumber*)[(NSArray*)[self.inputPoints objectAtIndex:1] objectAtIndex:1] floatValue]
						)
				];
				[m_freeTetrisObjects addObject:triangle];
				self.freeTetrisObjects = [NSArray arrayWithArray:m_freeTetrisObjects];
				self.inputPoints = [NSArray array];
			}
			else
			{
				NSMutableArray* m_inputPoints = [NSMutableArray arrayWithArray:self.inputPoints];
				[m_inputPoints addObject:[NSArray arrayWithObjects:[NSNumber numberWithFloat:self.inputPoint.x], [NSNumber numberWithFloat:self.inputPoint.y], nil]];
				self.inputPoints = [NSArray arrayWithArray:m_inputPoints];
			}
			self.input = false;
		}
	}
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{for(UITouch* touch in touches){self.input = false;}}

-(void)drawView
{
    [EAGLContext setCurrentContext:context];
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
	glOrthof(-backingWidth * 0.5f, backingWidth * 0.5f, -backingHeight * 0.5f, backingHeight * 0.5f, -1.0f, 1.0f);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT);
	glEnableClientState(GL_VERTEX_ARRAY);
	[self.polygonTetrisSystem draw];
	[self.freeTetrisObjects makeObjectsPerformSelector:@selector(draw)];
	int inputPointsCount = [self.inputPoints count];
	//draw set inputPoints with a pointSize of 10.0f in 0.0, 0.75, 0.75 cyan.
	//draw set edges with lineWidth of 5.0f in  0.0, 0.5, 0.5 cyan.
	//draw floating inputPoint with a pointSize of 16.0f in 0.25, 0.75, 0.75 cyan.
	//draw floating edges with lineWidth of 8.0f in 0.25, 0.5, 0.5 cyan.
	switch(inputPointsCount)
	{
		case 0:
		{
			if(self.input)
			{
				Vertex2f inputPointVertex[] = {{self.inputPoint.x, self.inputPoint.y}};
				glPointSize(16.0f);
				glColor4f(0.25f, 0.75f, 0.75f, 0.75f);
				glVertexPointer(2, GL_FLOAT, 0, inputPointVertex);
				glDrawArrays(GL_POINTS, 0, 1);
			}
			break;
		}
		case 1:
		{
			if(self.input)
			{
				Vertex2f edgeVertices[] =
				{
					{[(NSNumber*)[(NSArray*)[self.inputPoints objectAtIndex:0] objectAtIndex:0] floatValue], [(NSNumber*)[(NSArray*)[self.inputPoints objectAtIndex:0] objectAtIndex:1] floatValue]},
					{self.inputPoint.x, self.inputPoint.y}
				};
				glLineWidth(8.0f);
				glColor4f(0.25f, 0.5f, 0.5f, 1.0f);
				glVertexPointer(2, GL_FLOAT, 0, edgeVertices);
				glDrawArrays(GL_LINES, 0, 2);
			}
			Vertex2f onePointVertex[] = {{[(NSNumber*)[(NSArray*)[self.inputPoints objectAtIndex:0] objectAtIndex:0] floatValue], [(NSNumber*)[(NSArray*)[self.inputPoints objectAtIndex:0] objectAtIndex:1] floatValue]}};
			glPointSize(10.0f);
			glColor4f(0.0f, 0.75f, 0.75f, 1.0f);
			glVertexPointer(2, GL_FLOAT, 0, onePointVertex);
			glDrawArrays(GL_POINTS, 0, 1);
			if(self.input)
			{
				Vertex2f inputPointVertex[] = {{self.inputPoint.x, self.inputPoint.y}};
				glPointSize(16.0f);
				glColor4f(0.25f, 0.75f, 0.75f, 0.75f);
				glVertexPointer(2, GL_FLOAT, 0, inputPointVertex);
				glDrawArrays(GL_POINTS, 0, 1);
			}
			break;
		}
		case 2:
		{
			if(self.input)
			{
				Vertex2f inputEdgeVertices[] =
				{
					{[(NSNumber*)[(NSArray*)[self.inputPoints objectAtIndex:0] objectAtIndex:0] floatValue], [(NSNumber*)[(NSArray*)[self.inputPoints objectAtIndex:0] objectAtIndex:1] floatValue]},
					{self.inputPoint.x, self.inputPoint.y},
					{[(NSNumber*)[(NSArray*)[self.inputPoints objectAtIndex:1] objectAtIndex:0] floatValue], [(NSNumber*)[(NSArray*)[self.inputPoints objectAtIndex:1] objectAtIndex:1] floatValue]},
				};
				glLineWidth(8.0f);
				glColor4f(0.25f, 0.5f, 0.5f, 1.0f);
				glVertexPointer(2, GL_FLOAT, 0, inputEdgeVertices);
				glDrawArrays(GL_LINE_STRIP, 0, 3);
			}
			Vertex2f edgeVertices[] =
			{
				{[(NSNumber*)[(NSArray*)[self.inputPoints objectAtIndex:0] objectAtIndex:0] floatValue], [(NSNumber*)[(NSArray*)[self.inputPoints objectAtIndex:0] objectAtIndex:1] floatValue]},
				{[(NSNumber*)[(NSArray*)[self.inputPoints objectAtIndex:1] objectAtIndex:0] floatValue], [(NSNumber*)[(NSArray*)[self.inputPoints objectAtIndex:1] objectAtIndex:1] floatValue]},
			};
			glLineWidth(5.0f);
			glColor4f(0.0f, 0.5f, 0.5f, 1.0f);
			glVertexPointer(2, GL_FLOAT, 0, edgeVertices);
			glDrawArrays(GL_LINES, 0, 2);
			glPointSize(10.0f);
			glColor4f(0.0f, 0.75f, 0.75f, 1.0f);
			glDrawArrays(GL_POINTS, 0, 2);
			if(self.input)
			{
				Vertex2f inputPointVertex[] = {{self.inputPoint.x, self.inputPoint.y}};
				glPointSize(16.0f);
				glColor4f(0.25f, 0.75f, 0.75f, 0.75f);
				glVertexPointer(2, GL_FLOAT, 0, inputPointVertex);
				glDrawArrays(GL_POINTS, 0, 1);
			}
			break;
		}
		default:	break;
	}
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}
-(void)tetrisButtonPressed
{
	[self.freeTetrisObjects
		enumerateObjectsUsingBlock:
			^(id obj, NSUInteger idx, BOOL *stop)
			{
				[self.polygonTetrisSystem addPolygonTetrisCEGObject:obj];
			}
	];
	self.freeTetrisObjects = [NSArray array];
}
-(CGPoint)pointFromPoint:(CGPoint)point
{
	return CGPointMake(point.x - 0.5 * backingWidth, 0.5 * backingHeight - point.y);
}

@end