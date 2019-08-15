// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// ThrottleMain.cpp
// Main throttle sliders
// =============================================================================

#define STRICT 1
#include "ThrottleMain.h"
#include "DeltaGlider.h"-

//------------------------------------------------------------------------------

// Constants for texture coordinates.
static const float texw = (float)PANEL2D_TEXW; // texture width
static const float texh = (float)PANEL2D_TEXH; // texture height
static const float tx_x0 = 1135.0;
static const float tx_y0 = texh-599.0f;
static const float tx_dx = 24.0f;
static const float tx_dy = 18.0f;

// Constants for panel coordinates.
static const float bb_x0 = 108.5f;
static const float bb_x1 = bb_x0+26.0f;
static const float bb_y0 = 171.5f;

/**
Main throttle constructor.
*/
ThrottleMain::ThrottleMain (VESSEL3 *v): PanelElement (v)
{
	dg = (DeltaGlider*)v;
	Reset2D();
}

/**
Add mesh data 2D for main throttle.
*/
void ThrottleMain::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	static const DWORD NVTX = 8;
	static const DWORD NIDX = 12;
	static const NTVERTEX VTX[NVTX] = {
		// left slider
		{bb_x0,      bb_y0,      0,  0,0,0,  tx_x0/texw,        tx_y0/texh},
		{bb_x0+tx_dx,bb_y0,      0,  0,0,0,  (tx_x0+tx_dx)/texw,tx_y0/texh},
		{bb_x0,      bb_y0+tx_dy,0,  0,0,0,  tx_x0/texw,        (tx_y0+tx_dy)/texh},
		{bb_x0+tx_dx,bb_y0+tx_dy,0,  0,0,0,  (tx_x0+tx_dx)/texw,(tx_y0+tx_dy)/texh},
		// right slider
		{bb_x1,      bb_y0,      0,  0,0,0,  tx_x0/texw,        tx_y0/texh},
		{bb_x1+tx_dx,bb_y0,      0,  0,0,0,  (tx_x0+tx_dx)/texw,tx_y0/texh},
		{bb_x1,      bb_y0+tx_dy,0,  0,0,0,  tx_x0/texw,        (tx_y0+tx_dy)/texh},
		{bb_x1+tx_dx,bb_y0+tx_dy,0,  0,0,0,  (tx_x0+tx_dx)/texw,(tx_y0+tx_dy)/texh}
	};
	static const WORD IDX[NIDX] = {
		// Left slider.
		0,1,2, 3,2,1,
		// Right slider.
		4,5,6, 7,6,5
	};

	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}

/**
Reset 2D main throttle.
*/
void ThrottleMain::Reset2D ()
{
	for (int i = 0; i < 2; i++) 
	{
		ppos[i] = 0.0f;
	}
}

/**
Redraw 2D main throttle.
*/
bool ThrottleMain::Redraw2D (SURFHANDLE surf)
{
	int i, j, vofs;
	float pos;
	static const float sy[4] = {bb_y0,bb_y0,bb_y0+tx_dy,bb_y0+tx_dy};

	for (i = 0; i < 2; i++) 
	{
		double level = dg->GetThrusterLevel (dg->th_main[i]);
		if (level > 0) 
		{
			pos = (float)(-8.0-level*108.0);
		}
		else 
		{
			level = dg->GetThrusterLevel (dg->th_retro[i]);
			if (level > 0) 
			{
				pos = (float)(8.0+level*30.0);
			}
			else 
			{
				pos = 0.0f;
			}
		}
		if (pos != ppos[i]) 
		{
			vofs = vtxofs+i*4;
			for (j = 0; j < 4; j++) 
			{
				grp->Vtx[vofs+j].y = sy[j]+pos;
			}
			ppos[i] = pos;
		}
	}
	return false;
}

/**
Process mouse 2D events for main throttle.
*/
bool ThrottleMain::ProcessMouse2D (int event, int mx, int my)
{
	static int ctrl = 0;
	if (event & PANEL_MOUSE_LBDOWN) 
	{ 
		// Record which slider to operate.
		if (mx <  12) 
		{
			ctrl = 0; // Left engine.
		}
		else if (mx >= 37) 
		{
			ctrl = 1; // Right engine.
		}
		else 
		{
			ctrl = 2; // Both.
		}
	}
	if ((my -= 9) < 0) 
	{
		my = 0;
	}
	else if (my > 157) 
	{
		my = 157;
	}
	dg->SetMainRetroLevel (ctrl, my <= 108 ? 1.0-my/108.0  : 0.0,   // Main thruster level.
			                     my >= 125 ? (my-125)/32.0 : 0.0);  // Retro thruster level.
	return true;
}
