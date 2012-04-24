//
//  OpenGLStructures.h
//  SMNStaff
//
//  Created by Ryan Tsukamoto on 4/13/12.
//  Copyright (c) 2012 Miso Media. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGlES/ES2/glext.h>

typedef struct
{
	GLfloat	x;
	GLfloat	y;
}	Vertex2f;

Vertex2f Vertex2fMake(GLfloat x, GLfloat y);

typedef struct
{
	GLfloat	x;
	GLfloat	y;
	GLfloat	z;
}	Vertex3f;

Vertex3f Vertex3fMake(GLfloat x, GLfloat y, GLfloat z);

typedef struct
{
	GLubyte	r;
	GLubyte	g;
	GLubyte	b;
	GLubyte	a;
}	Color4u;

Color4u Color4uMake(GLubyte r, GLubyte g, GLubyte b, GLubyte a);

typedef struct
{
	GLfloat	u;
	GLfloat	v;
}	TexCoords2f;

TexCoords2f TexCoords2fMake(GLfloat u, GLfloat v);

typedef struct
{
	Vertex2f	vertex;
	TexCoords2f	texCoords;
}	Vertex2fTexCoords2f;

Vertex2fTexCoords2f Vertex2fTexCoords2fMake(GLfloat x, GLfloat y, GLfloat u, GLfloat v);
void Vertex2fTexCoords2fSetPointers(Vertex2fTexCoords2f* vertex2fTexCoords2f);
