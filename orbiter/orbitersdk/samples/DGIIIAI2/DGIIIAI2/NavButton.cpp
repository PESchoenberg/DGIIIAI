// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// NavButton.cpp
// Navigation mode button user interface
// =============================================================================

#define STRICT 1
#include "NavButton.h"
#include "DeltaGlider.h"

// Constants for texture coordinates.
static const float texw = (float)PANEL2D_TEXW; // texture width
static const float texh = (float)PANEL2D_TEXH; // texture height
static const float tx_x0 = 1021.0f;            // left edge of texture block
static const float tx_y0 = texh-655.0f;        // top edge of texture block
static const float tx_dx = 37.0f;              // texture block width
static const float tx_dy = 37.0f;              // texture block height

// Constants for panel coordinates.
static const float bb_x0 = 1121.5f;            // left edge of button block
static const float bb_y0 =  119.0f;            // top edge of button block
static const float bb_dx =   39.0f;            // button width
static const float bb_dy =   39.0f;            // button height

//------------------------------------------------------------------------------ 


/**
Nav button constructor.
*/
NavButton::NavButton (VESSEL3 *v): PanelElement (v)
{
}


/**
Add mesh data 2D for nav button.
*/
void NavButton::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	const DWORD NVTX = 7*4;
	const DWORD NIDX = 7*6;
	static NTVERTEX VTX[NVTX] = {
		// "Kill rot" button.
		{bb_x0+20,          bb_y0,               0, 0,0,0, (tx_x0)/texw,         (tx_y0)/texh},
		{bb_x0+20+tx_dx,    bb_y0,               0, 0,0,0, (tx_x0+tx_dx)/texw,   (tx_y0)/texh},
		{bb_x0+20,          bb_y0+tx_dy,         0, 0,0,0, (tx_x0)/texw,         (tx_y0+tx_dy)/texh},
		{bb_x0+20+tx_dx,    bb_y0+tx_dy,         0, 0,0,0, (tx_x0+tx_dx)/texw,   (tx_y0+tx_dy)/texh},
		// "HLevel" button.
		{bb_x0,             bb_y0+3*bb_dy,       0, 0,0,0, (tx_x0+5*tx_dx)/texw, (tx_y0)/texh},
		{bb_x0+tx_dx,       bb_y0+3*bb_dy,       0, 0,0,0, (tx_x0+6*tx_dx)/texw, (tx_y0)/texh},
		{bb_x0,             bb_y0+3*bb_dy+tx_dy, 0, 0,0,0, (tx_x0+5*tx_dx)/texw, (tx_y0+tx_dy)/texh},
		{bb_x0+tx_dx,       bb_y0+3*bb_dy+tx_dy, 0, 0,0,0, (tx_x0+6*tx_dx)/texw, (tx_y0+tx_dy)/texh},
		// "Prograde" button.
		{bb_x0,             bb_y0+bb_dy,         0, 0,0,0, (tx_x0+tx_dx)/texw,   (tx_y0)/texh},
		{bb_x0+tx_dx,       bb_y0+bb_dy,         0, 0,0,0, (tx_x0+2*tx_dx)/texw, (tx_y0)/texh},
		{bb_x0,             bb_y0+bb_dy+tx_dy,   0, 0,0,0, (tx_x0+tx_dx)/texw,   (tx_y0+tx_dy)/texh},
		{bb_x0+tx_dx,       bb_y0+bb_dy+tx_dy,   0, 0,0,0, (tx_x0+2*tx_dx)/texw, (tx_y0+tx_dy)/texh},
		// "Retrograde" button.
		{bb_x0+bb_dx,       bb_y0+bb_dy,         0, 0,0,0, (tx_x0+2*tx_dx)/texw, (tx_y0)/texh},
		{bb_x0+bb_dx+tx_dx, bb_y0+bb_dy,         0, 0,0,0, (tx_x0+3*tx_dx)/texw, (tx_y0)/texh},
		{bb_x0+bb_dx,       bb_y0+bb_dy+tx_dy,   0, 0,0,0, (tx_x0+2*tx_dx)/texw, (tx_y0+tx_dy)/texh},
		{bb_x0+bb_dx+tx_dx, bb_y0+bb_dy+tx_dx,   0, 0,0,0, (tx_x0+3*tx_dx)/texw, (tx_y0+tx_dy)/texh},
		// "Normal+" button.
		{bb_x0,             bb_y0+2*bb_dy,       0, 0,0,0, (tx_x0+3*tx_dx)/texw, (tx_y0)/texh},
		{bb_x0+tx_dx,       bb_y0+2*bb_dy,       0, 0,0,0, (tx_x0+4*tx_dx)/texw, (tx_y0)/texh},
		{bb_x0,             bb_y0+2*bb_dy+tx_dy, 0, 0,0,0, (tx_x0+3*tx_dx)/texw, (tx_y0+tx_dy)/texh},
		{bb_x0+tx_dx,       bb_y0+2*bb_dy+tx_dy, 0, 0,0,0, (tx_x0+4*tx_dx)/texw, (tx_y0+tx_dy)/texh},
		// "Normal-" button.
		{bb_x0+bb_dx,       bb_y0+2*bb_dy,       0, 0,0,0, (tx_x0+4*tx_dx)/texw, (tx_y0)/texh},
		{bb_x0+bb_dx+tx_dx, bb_y0+2*bb_dy,       0, 0,0,0, (tx_x0+5*tx_dx)/texw, (tx_y0)/texh},
		{bb_x0+bb_dx,       bb_y0+2*bb_dy+tx_dy, 0, 0,0,0, (tx_x0+4*tx_dx)/texw, (tx_y0+tx_dy)/texh},
		{bb_x0+bb_dx+tx_dx, bb_y0+2*bb_dy+tx_dx, 0, 0,0,0, (tx_x0+5*tx_dx)/texw, (tx_y0+tx_dy)/texh},
		// "HoldAlt" button.
		{bb_x0+bb_dx,       bb_y0+3*bb_dy,       0, 0,0,0, (tx_x0+6*tx_dx)/texw, (tx_y0)/texh},
		{bb_x0+bb_dx+tx_dx, bb_y0+3*bb_dy,       0, 0,0,0, (tx_x0+7*tx_dx)/texw, (tx_y0)/texh},
		{bb_x0+bb_dx,       bb_y0+3*bb_dy+tx_dy, 0, 0,0,0, (tx_x0+6*tx_dx)/texw, (tx_y0+tx_dy)/texh},
		{bb_x0+bb_dx+tx_dx, bb_y0+3*bb_dy+tx_dx, 0, 0,0,0, (tx_x0+7*tx_dx)/texw, (tx_y0+tx_dy)/texh}
	};
	static WORD IDX[NIDX] = {
		0,1,2, 3,2,1,
		4,5,6, 7,6,5,
		8,9,10, 11,10,9,
		12,13,14, 15,14,13,
		16,17,18, 19,18,17,
		20,21,22, 23,22,21,
		24,25,26, 27,26,25
	};

	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Redraw 2D nav button.
*/
bool NavButton::Redraw2D (SURFHANDLE surf)
{
	static const float tv0_active = (tx_y0)/texh, tv1_active = (tx_y0+tx_dy)/texh;
	static const float tv0_idle = (tx_y0+tx_dy+0.5f)/texh, tv1_idle = (tx_y0+tx_dy+0.5f)/texh;
	float tv0, tv1;
	int vofs;

	for (DWORD i = NAVMODE_KILLROT; i <= NAVMODE_HOLDALT; i++) 
	{
		if (vessel->GetNavmodeState (i)) 
		{
			tv0 = tv0_active; 
			tv1 = tv1_active;
		}
		else 
		{
			tv0 = tv0_idle; 
			tv1 = tv1_idle;
		}
		vofs = vtxofs+(i-NAVMODE_KILLROT)*4;
		grp->Vtx[vofs+0].tv = grp->Vtx[vofs+1].tv = tv0;
		grp->Vtx[vofs+2].tv = grp->Vtx[vofs+3].tv = tv1;
	}
		
	return false;
}


/**
Redraw VC nav button.
*/
bool NavButton::RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf)
{
	if (!hMesh) 
	{
		return false;
	}
	NTVERTEX vtx[24];
	GROUPEDITSPEC ges;
	ges.flags = GRPEDIT_VTXTEXU;
	ges.Vtx = vtx;
	ges.nVtx = 24;
	ges.vIdx = NULL;

	for (int i = 0; i < 6; i++) 
	{
		bool hilight = vessel->GetNavmodeState (i + NAVMODE_KILLROT);
		vtx[i*4  ].tu = vtx[i*4+1].tu = (hilight ? 0.1172f : 0.0f);
		vtx[i*4+2].tu = vtx[i*4+3].tu = (hilight ? 0.2344f : 0.1172f);
	}
	oapiEditMeshGroup (hMesh, MESHGRP_VC_NAVMODE, &ges);
	return false;
}


/**
Process mouse 2D events for nav button.
*/
bool NavButton::ProcessMouse2D (int event, int mx, int my)
{
	int mode = 0;
	if (my < 39) 
	{
		if (mx >= 20 && mx < 59) 
		{
			mode = NAVMODE_KILLROT;
		}
	} 
	else 
	{
		static int navmode[6] = {
			NAVMODE_PROGRADE, NAVMODE_RETROGRADE,
			NAVMODE_NORMAL, NAVMODE_ANTINORMAL,
			NAVMODE_HLEVEL, NAVMODE_HOLDALT
		};
		mode = navmode[mx/39 + ((my-39)/39)*2];
	}
	if (mode) 
	{
		vessel->ToggleNavmode (mode);
	}
	return (mode != 0);
}
