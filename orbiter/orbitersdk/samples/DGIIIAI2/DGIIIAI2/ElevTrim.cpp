// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// ElevTrim.cpp
// Elevator trim control
// =============================================================================

#define STRICT 1
#include "ElevTrim.h"
#include "DeltaGlider.h"

// Constants for texture coordinates
static const float texw = (float)PANEL2D_TEXW; // texture width
static const float texh = (float)PANEL2D_TEXH; // texture height
static const float tx_x0 = 1138.0f;
static const float tx_y0 = texh-580.0f;

// Constants for panel coordinates
static const float bb_x0 = 1242.5f;
static const float bb_y0 =  161.5f;
static const float bb_dx =   21.0f;
static const float bb_dy =    7.0f;


//------------------------------------------------------------------------------


/**
Elevator trim def.
*/
ElevatorTrim::ElevatorTrim (VESSEL3 *v): PanelElement (v)
{
	Reset2D();
	elevtrimpos = (UINT)-1;
}


/**
Add mesh data for elevator trim.
*/
void ElevatorTrim::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	static const DWORD NVTX = 4;
	static const DWORD NIDX = 6;
	static const NTVERTEX VTX[NVTX] = {
		{bb_x0,      bb_y0,      0,  0,0,0,  tx_x0/texw,         tx_y0/texh},
		{bb_x0+bb_dx,bb_y0,      0,  0,0,0,  (tx_x0+bb_dx)/texw, tx_y0/texh},
		{bb_x0,      bb_y0+bb_dy,0,  0,0,0,  tx_x0/texw,         (tx_y0+bb_dy)/texh},
		{bb_x0+bb_dx,bb_y0+bb_dy,0,  0,0,0,  (tx_x0+bb_dx)/texw, (tx_y0+bb_dy)/texh}
	};
	static const WORD IDX[NIDX] = {
		0,1,2, 3,2,1
	};

	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Reset elevator trim 2D.
*/
void ElevatorTrim::Reset2D ()
{
	trim = 0.0;
}


/**
Redraw elevator trim 2D.
*/
bool ElevatorTrim::Redraw2D (SURFHANDLE surf)
{
	double level = vessel->GetControlSurfaceLevel (AIRCTRL_ELEVATORTRIM);
	if (level != trim) 
	{
		static const float yp[4] = {bb_y0, bb_y0, bb_y0+bb_dy, bb_y0+bb_dy};
		float yshift = (float)(level*24.0);
		int i;
		for (i = 0; i < 4; i++)
		{
			grp->Vtx[vtxofs+i].y = yp[i]+yshift;
		}
		trim = level;
	}
	return false;
}


/**
Redraw elevator trim VC.
*/
bool ElevatorTrim::RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf)
{
	double level = vessel->GetControlSurfaceLevel (AIRCTRL_ELEVATORTRIM);
	UINT pos = (UINT)((1.0+level)*23.0);
	if (pos != elevtrimpos) 
	{
		int w = (oapiCockpitMode() == COCKPIT_VIRTUAL ? 2:15);
		oapiColourFill (surf, 0);
		oapiColourFill (surf, oapiGetColour (210,210,210), 1, pos, w, 6);
		elevtrimpos = pos;
		return true;
	} 
	else
	{ 
		return false;
	}
}


/**
Process elevator trim 2D mouse events.
*/
bool ElevatorTrim::ProcessMouse2D (int event, int mx, int my)
{
	double tgtlvl = vessel->GetControlSurfaceLevel (AIRCTRL_ELEVATORTRIM);
	tgtlvl += oapiGetSimStep() * (my < 30 ? -0.2:0.2);
	tgtlvl = max (-1.0, min (1.0, tgtlvl));
	vessel->SetControlSurfaceLevel (AIRCTRL_ELEVATORTRIM, tgtlvl);
	return true;
}
