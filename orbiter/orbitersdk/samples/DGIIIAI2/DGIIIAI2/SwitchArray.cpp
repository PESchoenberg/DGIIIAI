// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2009 Martin Schweiger
//                   All rights reserved
//
// SwitchArray.cpp
// User interface for row of switches on main panel
// =============================================================================

#define STRICT 1
#include "SwitchArray.h"
#include "DeltaGlider.h"

// Constants for texture coordinates.
static const float texw = (float)PANEL2D_TEXW; // Texture width.
static const float texh = (float)PANEL2D_TEXH; // Texture height.
static const float tx_dx = 25.0f;
static const float tx_dy = 38.0f;
static const float tx_x1 = 964.0f;
static const float tx_x0 = tx_x1+tx_dx;
static const float tx_y0 = texh-611.0f;
static const float bb_x0 = 856.0f;      // Left edge of left-most button.
static const float bb_y0 = 415.0f;      // Top edge of button row.
static const float bb_dx = 32.0f;       // Button spacing.

const DWORD nbutton = 8;

//------------------------------------------------------------------------------

/**
Switch array constructor.
*/
SwitchArray::SwitchArray (VESSEL3 *v): PanelElement (v)
{
}

/**
Reset 2D for switch array.
*/
void SwitchArray::Reset2D ()
{
	DWORD i;
	for (i = 0; i < nbutton; i++) btnstate[i] = 0;
}

/**
Add mesh data 2D for switch array.
*/
void SwitchArray::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	const DWORD NVTX = 4*nbutton;
	const DWORD NIDX = 6*nbutton;
	const WORD IDX_TPL[6] = {0,1,2,3,2,1};
	NTVERTEX VTX[NVTX];
	WORD IDX[NIDX];

	DWORD i, j;
	memset (VTX, 0, NVTX*sizeof(NTVERTEX));
	for (i = 0; i < nbutton; i++) 
	{
		for (j = 0; j < 4; j++) 
		{
			VTX[i*4+j].x = bb_x0 + i*bb_dx + (j%2)*tx_dx;
			VTX[i*4+j].y = bb_y0 + (j/2)*tx_dy;
			VTX[i*4+j].tu = (tx_x0 + (j%2)*tx_dx)/texw;
			VTX[i*4+j].tv = (tx_y0 + (j/2)*tx_dy)/texh;
		}
		for (j = 0; j < 6; j++)
			IDX[i*6+j] = (WORD)(i*4)+IDX_TPL[j];
	}
	AddGeometry(hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}

/**
Redraw 2D switch array.
*/
bool SwitchArray::Redraw2D (SURFHANDLE surf)
{
	DeltaGlider *dg = (DeltaGlider*)vessel;

	int i, j, state, vofs;
	for (i = 0; i < nbutton; i++) 
	{
		switch (i) 
		{
			case 0:
			case 1:
			case 2:
			case 3: 
				state = (dg->GetBeaconState(i) ? 1:0); 
				break;
			case 4: 
				state = (dg->radiator_status == DeltaGlider::DOOR_OPEN || dg->radiator_status == DeltaGlider::DOOR_OPENING ? 1:0); 
				break;
			case 5: 
				state = (dg->rcover_status == DeltaGlider::DOOR_OPEN || dg->rcover_status == DeltaGlider::DOOR_OPENING ? 1:0); 
				break;
			case 6: 
				state = (dg->hatch_status == DeltaGlider::DOOR_OPEN || dg->hatch_status == DeltaGlider::DOOR_OPENING ? 1:0); 
				break;
			case 7: 
				state = (dg->ladder_status == DeltaGlider::DOOR_OPEN || dg->ladder_status == DeltaGlider::DOOR_OPENING ? 1:0); 
				break;
		}
		if (state != btnstate[i]) 
		{
			btnstate[i] = state;
			vofs = vtxofs + i*4;
			for (j = 0; j < 4; j++)
			{
				grp->Vtx[vofs+j].tu = (tx_x0+(j%2-state)*tx_dx)/texw;
			}
		}
	}
	return false;
}

/**
Process mouse 2D events  for switch array.
*/
bool SwitchArray::ProcessMouse2D (int event, int mx, int my)
{
	DeltaGlider *dg = (DeltaGlider*)vessel;

	int state, btn = mx / 32;
	if (mx - btn*32 >= 26) 
	{
		return false;
	}
	state = (my < 19 ? 0:1);
	if (state != btnstate[btn]) 
	{
		switch (btn) 
		{
			case 0: 
				dg->SetNavlight (state != 0); 
				return true;
			case 1: 
				dg->SetBeacon (state != 0);   
				return true;
			case 2: 
				dg->SetStrobe (state != 0);   
				return true;
			case 3: 
				dg->SetDockingLight (state != 0); 
				return true;
			case 4: 
				dg->ActivateRadiator (state == 0 ? DeltaGlider::DOOR_CLOSING : DeltaGlider::DOOR_OPENING); 
				return true;
			case 5: 
				dg->ActivateRCover (state == 0 ? DeltaGlider::DOOR_CLOSING : DeltaGlider::DOOR_OPENING); 
				return true;
			case 6: 
				dg->ActivateHatch (state == 0 ? DeltaGlider::DOOR_CLOSING : DeltaGlider::DOOR_OPENING); 
				return true;
			case 7: 
				dg->ActivateLadder (state == 0 ? DeltaGlider::DOOR_CLOSING : DeltaGlider::DOOR_OPENING); 
				return true;
		}
	}
	return false;
}
