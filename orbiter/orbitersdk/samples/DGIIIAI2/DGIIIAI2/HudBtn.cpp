// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// HudBtn.cpp
// HUD mode selector button interface
// =============================================================================

#define STRICT 1
#include "HudBtn.h"
#include "DeltaGlider.h"

// Constants for texture coordinates.
static const float texw = (float)PANEL2D_TEXW; // Texture width.
static const float texh = (float)PANEL2D_TEXH; // texture height.
static const float tx_x0 = 1143.5f;     // Left edge of texture block.
static const float tx_y0 = texh-604.5f; // Top edge of texture block.
static const float tx_dx = 15.0f;       // Texture block width.
static const float tx_dy =  4.0f;       // Texture block height.

// Constants for panel coordinates.
static const float bb_x0 = 46.5f;       // Left edge of HUD mode 1 indicator.
static const float bb_x1 = bb_x0+29.0f; // Left edge of HUD mode 2 indicator.
static const float bb_x2 = bb_x1+29.0f; // Left edge of HUD mode 3 indicator.
static const float bb_y0 = 19.5f;       // Top edge of button block.

//------------------------------------------------------------------------------


/**
HUD butt on def.
*/
HUDButton::HUDButton (VESSEL3 *v): PanelElement (v)
{
}


/**
Add mesh data 2D for HUD btn.
*/
void HUDButton::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	static const DWORD NVTX = 4*3;
	static const DWORD NIDX = 6*3;
	static const NTVERTEX VTX[NVTX] = {
		// Orbit mode indicator.
		{bb_x0,      bb_y0,      0,  0,0,0,  tx_x0/texw,        tx_y0/texh},
		{bb_x0+tx_dx,bb_y0,      0,  0,0,0,  (tx_x0+tx_dx)/texw,tx_y0/texh},
		{bb_x0,      bb_y0+tx_dy,0,  0,0,0,  tx_x0/texw,        (tx_y0+tx_dy)/texh},
		{bb_x0+tx_dx,bb_y0+tx_dy,0,  0,0,0,  (tx_x0+tx_dx)/texw,(tx_y0+tx_dy)/texh},
		// Surface mode indicator.
		{bb_x1,      bb_y0,      0,  0,0,0,  tx_x0/texw,        tx_y0/texh},
		{bb_x1+tx_dx,bb_y0,      0,  0,0,0,  (tx_x0+tx_dx)/texw,tx_y0/texh},
		{bb_x1,      bb_y0+tx_dy,0,  0,0,0,  tx_x0/texw,        (tx_y0+tx_dy)/texh},
		{bb_x1+tx_dx,bb_y0+tx_dy,0,  0,0,0,  (tx_x0+tx_dx)/texw,(tx_y0+tx_dy)/texh},
		// Docking mode indicator.
		{bb_x2,      bb_y0,      0,  0,0,0,  tx_x0/texw,        tx_y0/texh},
		{bb_x2+tx_dx,bb_y0,      0,  0,0,0,  (tx_x0+tx_dx)/texw,tx_y0/texh},
		{bb_x2,      bb_y0+tx_dy,0,  0,0,0,  tx_x0/texw,        (tx_y0+tx_dy)/texh},
		{bb_x2+tx_dx,bb_y0+tx_dy,0,  0,0,0,  (tx_x0+tx_dx)/texw,(tx_y0+tx_dy)/texh}
	};
	static const WORD IDX[NIDX] = {
		// Orbit mode indicator.
		0,1,2, 3,2,1,
		// Surface mode indicator.
		4,5,6, 7,6,5,
		// Docking mode indicator.
		8,9,10, 11,10,9
	};

	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Redraw 2D for HUD btn.
*/
bool HUDButton::Redraw2D (SURFHANDLE surf)
{
	float y, y0 = bb_y0, y1 = bb_y0+tx_dy;
	int i, j, mode = oapiGetHUDMode();
	for (i = 0; i < 3; i++) 
	{
		y = (i+1 == mode ? y1 : y0);
		for (j = 2; j < 4; j++)
		{
			grp->Vtx[vtxofs+i*4+j].y = y;
		}
	}
	return false;
}


/**
Redraw VC for HUD btn.
*/
bool HUDButton::RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf)
{
	if (!hMesh)
	{ 
		return false;
	}
	NTVERTEX vtx[12];
	GROUPEDITSPEC ges;
	ges.flags = GRPEDIT_VTXTEXU;
	ges.Vtx = vtx;
	ges.nVtx = 12;
	ges.vIdx = NULL;

	for (int i = 0; i < 3; i++) 
	{
		bool hilight = (oapiGetHUDMode() == 3-i);
		vtx[i*4  ].tu = vtx[i*4+1].tu = (hilight ? 0.1543f : 0.0762f);
		vtx[i*4+2].tu = vtx[i*4+3].tu = (hilight ? 0.0801f : 0.0020f);
	}
	oapiEditMeshGroup (hMesh, MESHGRP_VC_HUDMODE, &ges);

	//for (int i = 0; i < 3; i++) {
	//	bool hilight = (oapiGetHUDMode() == 3-i);
	//	_grp->Vtx[i*4  ].tu = _grp->Vtx[i*4+1].tu = (hilight ? 0.1543f : 0.0762f);
	//	_grp->Vtx[i*4+2].tu = _grp->Vtx[i*4+3].tu = (hilight ? 0.0801f : 0.0020f);
	//}
	//vessel->MeshModified (mesh, gidx, 0);
	return false;
}


/**
Process mouse 2D events for HUD btn.
*/
bool HUDButton::ProcessMouse2D (int event, int mx, int my)
{
	if (mx%29 < 20)
	{ 
		oapiSetHUDMode (HUD_NONE+(mx/29));
	}
	return false;
}
