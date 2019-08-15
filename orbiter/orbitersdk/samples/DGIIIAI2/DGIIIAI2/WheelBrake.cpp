// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2009 Martin Schweiger
//                   All rights reserved
//
// WheelBrake.cpp
// User interface for Wheel brake levers
// =============================================================================

#define STRICT 1
#include "WheelBrake.h"

// Constants for texture coordinates.
static const float texw = (float)PANEL2D_TEXW; // Texture width.
static const float texh = (float)PANEL2D_TEXH; // Texture height.
static const float tx_x0 = 0.0f;
static const float tx_x1 = 25.0f;
static const float tx_y0 = texh-650.0f;
static const float tx_dx = 25.0f;
static const float tx_dy = 77.0f;

// Constants for panel coordinates.
static const float bb_x0 = 1221.0f;
static const float bb_x1 = 1248.0f;
static const float bb_y0 =  493.0f;

//------------------------------------------------------------------------------

/**
Wheel brake lever constructor.
*/
WheelBrakeLever::WheelBrakeLever (VESSEL3 *v): PanelElement (v)
{
	int i;
	for (i = 0; i < 2; i++)
	{
		isdown[i] = false;
	}
}

/**
Add mesh data 2D for wheel brake lever.
*/
void WheelBrakeLever::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	static const DWORD NVTX = 8;
	static const DWORD NIDX = 12;
	static const NTVERTEX VTX[NVTX] = {
		{bb_x0,       bb_y0,       0,  0,0,0,  tx_x0/texw,         tx_y0/texh},
		{bb_x0+tx_dx, bb_y0,       0,  0,0,0,  (tx_x0+tx_dx)/texw, tx_y0/texh},
		{bb_x0,       bb_y0+tx_dy, 0,  0,0,0,  tx_x0/texw,         tx_y0/texh},
		{bb_x0+tx_dx, bb_y0+tx_dy, 0,  0,0,0,  (tx_x0+tx_dx)/texw, tx_y0/texh},
		{bb_x1,       bb_y0,       0,  0,0,0,  tx_x1/texw,         tx_y0/texh},
		{bb_x1+tx_dx, bb_y0,       0,  0,0,0,  (tx_x1+tx_dx)/texw, tx_y0/texh},
		{bb_x1,       bb_y0+tx_dy, 0,  0,0,0,  tx_x1/texw,         tx_y0/texh},
		{bb_x1+tx_dx, bb_y0+tx_dy, 0,  0,0,0,  (tx_x1+tx_dx)/texw, tx_y0/texh}
	};
	static const WORD IDX[NIDX] = {
		0,1,2, 3,2,1, 4,5,6, 7,6,5
	};
	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}

/**
Redraw 2D wheel brake lever.
*/
bool WheelBrakeLever::Redraw2D (SURFHANDLE surf)
{
	int i, j;
	for (i = 0; i < 2; i++) 
	{
		double lvl = vessel->GetWheelbrakeLevel (i+1);
		bool down = (lvl > 0.5);
		if (down != isdown[i]) 
		{
			float tv = (down ? tx_y0+tx_dy : tx_y0)/texh;
			for (j = 2; j < 4; j++)
			{
				grp->Vtx[vtxofs+i*4+j].tv = tv;
			}
			isdown[i] = down;
		}
	}
	return false;
}

/**
Process mouse 2D events for wheel brake lever.
*/
bool WheelBrakeLever::ProcessMouse2D (int event, int mx, int my)
{
	int which = (mx < 15 ? 1 : mx > 37 ? 2 : 0);
	bool press = (event == PANEL_MOUSE_LBDOWN);
	vessel->SetWheelbrakeLevel (press ? 1.0:0.0, which);
	return false;
}
