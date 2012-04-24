//
//  OpenGLStructures.m
//  SMNStaff
//
//  Created by Ryan Tsukamoto on 4/13/12.
//  Copyright (c) 2012 Miso Media. All rights reserved.
//

#import "OpenGLStructures.h"

Vertex2f Vertex2fMake(GLfloat x, GLfloat y)
{
	Vertex2f result;
	result.x = x;
	result.y = y;
	return result;
}

Vertex3f Vertex3fMake(GLfloat x, GLfloat y, GLfloat z)
{
	Vertex3f result;
	result.x = x;
	result.y = y;
	result.z = z;
	return result;
}

Color4u Color4uMake(GLubyte r, GLubyte g, GLubyte b, GLubyte a)
{
	Color4u result;
	result.r = r;
	result.g = g;
	result.b = b;
	result.a = a;
	return result;
}

TexCoords2f TexCoords2fMake(GLfloat u, GLfloat v)
{
	TexCoords2f result;
	result.u = u;
	result.v = v;
	return result;
}

Vertex2fTexCoords2f Vertex2fTexCoords2fMake(GLfloat x, GLfloat y, GLfloat u, GLfloat v)
{
	Vertex2fTexCoords2f result;
	result.vertex = Vertex2fMake(x, y);
	result.texCoords = TexCoords2fMake(u, v);
	return result;
}

void Vertex2fTexCoords2fSetPointers(Vertex2fTexCoords2f* vertex2fTexCoords2f)
{
	glVertexPointer(2, GL_FLOAT, 4, &(vertex2fTexCoords2f->vertex));
	glTexCoordPointer(2, GL_UNSIGNED_BYTE, 4, &(vertex2fTexCoords2f->texCoords));
}
