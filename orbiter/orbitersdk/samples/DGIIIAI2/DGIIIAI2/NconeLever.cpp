// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// NconeLever.cpp
// Nose cone open/close lever interface
// =============================================================================

#define STRICT 1
#include "NconeLever.h"

// constants for texture coordinates
static const float texw = (float)PANEL2D_TEXW; // texture width
static const float texh = (float)PANEL2D_TEXH; // texture height

//------------------------------------------------------------------------------ 


/**
Nose cone lever constructor.
*/
NoseconeLever::NoseconeLever (DeltaGlider *v): DGPanelElement (v)
{
}


/**
Add mesh data 2D for nose cone lever.
*/
void NoseconeLever::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	static const DWORD NVTX = 4;
	static const DWORD NIDX = 6;
	static const NTVERTEX VTX[NVTX] = {
		{1140.5f,326.5f,0,  0,0,0,  1047.5f/texw, (texh-696.5f)/texh},
		{1180.5f,326.5f,0,  0,0,0,  1087.5f/texw, (texh-696.5f)/texh},
		{1140.5f,345.5f,0,  0,0,0,  1047.5f/texw, (texh-677.5f)/texh},
		{1180.5f,345.5f,0,  0,0,0,  1087.5f/texw, (texh-677.5f)/texh}
	};
	static const WORD IDX[NIDX] = {
		0,1,2, 3,2,1
	};
	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Redraw 2D nose cone lever.
*/
bool NoseconeLever::Redraw2D (SURFHANDLE surf)
{
	DeltaGlider::DoorStatus action = dg->nose_status;
	bool leverdown = (action == DeltaGlider::DOOR_OPENING || action == DeltaGlider::DOOR_OPEN);

	float y0, dy, tv0;
	if (leverdown) 
	{
		y0 = 400.5f, dy = 21.0f, tv0 = texh-677.5f;
	}
	else
	{ 
		y0 = 326.5f, dy = 19.0f, tv0 = texh-696.5f;
	}
	int j;
	for (j = 0; j < 4; j++) 
	{
		grp->Vtx[vtxofs+j].y = y0 + (j/2)*dy;
		grp->Vtx[vtxofs+j].tv = (tv0 + (j/2)*dy)/texh;
	}
	return false;
}


/**
Process mouse 2D events for nose cone lever.
*/
bool NoseconeLever::ProcessMouse2D (int event, int mx, int my)
{
	DeltaGlider::DoorStatus action = dg->nose_status;
	if (action == DeltaGlider::DOOR_CLOSED || action == DeltaGlider::DOOR_CLOSING) 
	{
		if (my < 58) dg->ActivateDockingPort (DeltaGlider::DOOR_OPENING);
	} 
	else 
	{
		if (my > 36) 
		{
			dg->ActivateDockingPort (DeltaGlider::DOOR_CLOSING);
		}
	}
	return false;
}


/**
Nose cone indicator constructor.
*/
NoseconeIndicator::NoseconeIndicator (DeltaGlider *v): DGPanelElement (v)
{
	tofs = (double)rand()/(double)RAND_MAX;
}


/**
Add mesh data 2D for nose cone indicator.
*/
void NoseconeIndicator::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	static const DWORD NVTX = 4*3;
	static const DWORD NIDX = 4*3;
	static const NTVERTEX VTX[NVTX] = {
		{1147,293,0,  0,0,0,  1027/texw, (texh-611)/texh}, // top left
		{1159,293,0,  0,0,0,  1039/texw, (texh-611)/texh},
		{1147,305,0,  0,0,0,  1027/texw, (texh-599)/texh},
		{1173,293,0,  0,0,0,  1027/texw, (texh-611)/texh}, // top right
		{1173,305,0,  0,0,0,  1039/texw, (texh-611)/texh},
		{1161,293,0,  0,0,0,  1027/texw, (texh-599)/texh},
		{1173,319,0,  0,0,0,  1027/texw, (texh-611)/texh}, // bottom right
		{1161,319,0,  0,0,0,  1039/texw, (texh-611)/texh},
		{1173,307,0,  0,0,0,  1027/texw, (texh-599)/texh},
		{1147,319,0,  0,0,0,  1027/texw, (texh-611)/texh}, // bottom left
		{1147,307,0,  0,0,0,  1039/texw, (texh-611)/texh},
		{1159,319,0,  0,0,0,  1027/texw, (texh-599)/texh}
	};
	static const WORD IDX[NIDX] = {
		0,1,2,
		3,4,5,
		6,7,8,
		9,10,11
	};
	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Redraw 2D nose cone indicator.
*/
bool NoseconeIndicator::Redraw2D (SURFHANDLE surf)
{
	int i, j, xofs;
	double d;
	DeltaGlider::DoorStatus action = dg->nose_status;
	switch (action) 
	{
		case DeltaGlider::DOOR_CLOSED: 
			xofs = 1014; 
			break;
		case DeltaGlider::DOOR_OPEN:   
			xofs = 1027; 
			break;
		default: 
			xofs = (modf (oapiGetSimTime()+tofs, &d) < 0.5 ? 1040 : 1014); 
			break;
	}
	for (i = 0; i < 4; i++) 
	{
		for (j = 0; j < 3; j++)
		{
			grp->Vtx[vtxofs+i*3+j].tu = (xofs + (j%2)*12)/texw;
		}
	}
	return false;
}
