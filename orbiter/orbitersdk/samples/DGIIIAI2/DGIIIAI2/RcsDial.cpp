// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// RcsDial.cpp
// RCS selector dial user interface
// =============================================================================

#define STRICT 1
#include "RcsDial.h"
#include "DeltaGlider.h"

// Constants for texture coordinates.
static const float texw = (float)PANEL2D_TEXW; // Texture width.
static const float texh = (float)PANEL2D_TEXH; // Texture height.
static const float tx_x0 = 1160.5f;            // Left edge of texture block.
static const float tx_y0 = texh-615.5f;        // Top edge of texture block.
static const float tx_dx = 39.0f;              // Texture block width.
static const float tx_dy = 43.0f;              // Texture block height.

// Constants for panel coordinates.
static const float bb_x0 = 1136.5f;            // Left edge of button block.
static const float bb_y0 =   69.5f;            // Top edge of button block.

//------------------------------------------------------------------------------

/**
RCS dial constructor.
*/
RCSDial::RCSDial (VESSEL3 *v): PanelElement (v)
{
}

/**
Add mesh data 2D for RCS dial.
*/
void RCSDial::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	static const DWORD NVTX = 4;
	static const DWORD NIDX = 6;
	static const NTVERTEX VTX[NVTX] = {
		{bb_x0,      bb_y0,      0,  0,0,0, tx_x0/texw,         tx_y0/texh},
		{bb_x0+tx_dx,bb_y0,      0,  0,0,0, (tx_x0+tx_dx)/texw, tx_y0/texh},
		{bb_x0,      bb_y0+tx_dy,0,  0,0,0, tx_x0/texw,         (tx_y0+tx_dy)/texh},
		{bb_x0+tx_dx,bb_y0+tx_dy,0,  0,0,0, (tx_x0+tx_dx)/texw, (tx_y0+tx_dy)/texh}
	};
	static const WORD IDX[NIDX] = {
		0,1,2, 3,2,1
	};

	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}

/**
Redraw 2D for RCS dial.
*/
bool RCSDial::Redraw2D (SURFHANDLE surf)
{
	static float tu[4] = {tx_x0/texw,(tx_x0+tx_dx)/texw,tx_x0/texw,(tx_x0+tx_dx)/texw};
	float dtu = (float)(vessel->GetAttitudeMode()*40.0)/texw;
	for (int i = 0; i < 4; i++)
	{
		grp->Vtx[vtxofs+i].tu = tu[i]+dtu;
	}
	return false;
}

/**
Process mouse 2D events for RCS dial.
*/
bool RCSDial::ProcessMouse2D (int event, int mx, int my)
{
	if (event & PANEL_MOUSE_LBDOWN) 
	{
		return ((DeltaGlider*)vessel)->DecAttMode();
	}
	if (event & PANEL_MOUSE_RBDOWN) 
	{
		return ((DeltaGlider*)vessel)->IncAttMode();
	}
	return false;
}
