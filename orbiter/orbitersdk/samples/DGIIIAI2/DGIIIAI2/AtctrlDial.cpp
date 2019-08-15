// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// AtCtrlDial.cpp
// Atmospheric control selector dial user interface
// =============================================================================

#define STRICT 1
#include "AtctrlDial.h"
#include "DeltaGlider.h"

// Constants for texture coordinates.
static const float texw = (float)PANEL2D_TEXW; // texture width
static const float texh = (float)PANEL2D_TEXH; // texture height
static const float tx_x0 = 1160.5f;            // left edge of texture block
static const float tx_y0 = texh-615.5f;        // top edge of texture block
static const float tx_dx = 39.0f;              // texture block width
static const float tx_dy = 43.0f;              // texture block height

// Constants for panel coordinates.
static const float bb_x0 = 1217.5f;            // left edge of button block
static const float bb_y0 =   69.5f;            // top edge of button block

// -----------------------------------------------------------------------------


/**
ATC control dialog def.
*/
ATCtrlDial::ATCtrlDial (VESSEL3 *v): PanelElement (v)
{
}


/**
Add mesh data for ATC 2D.
*/
void ATCtrlDial::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
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
Redraw ATC control dial 2D.
*/
bool ATCtrlDial::Redraw2D (SURFHANDLE surf)
{
	static float tu[4] = {tx_x0/texw,(tx_x0+tx_dx)/texw,tx_x0/texw,(tx_x0+tx_dx)/texw};
	float dtu = (float)(min(vessel->GetADCtrlMode(),2)*40.0)/texw;
	for (int i = 0; i < 4; i++)
	{
		grp->Vtx[vtxofs+i].tu = tu[i]+dtu;
	}
	return false;
}


/**
Process mouse events for ATC 2D.
*/
bool ATCtrlDial::ProcessMouse2D (int event, int mx, int my)
{
	if (event & PANEL_MOUSE_LBDOWN)
	{ 
		return ((DeltaGlider*)vessel)->DecADCMode();
	}
	if (event & PANEL_MOUSE_RBDOWN) 
	{
		return ((DeltaGlider*)vessel)->IncADCMode();
	}
	return false;
}
