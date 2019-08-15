// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2009 Martin Schweiger
//                   All rights reserved
//
// MwsButton.cpp
// User interface for Master Warning System
// =============================================================================

#include "MwsButton.h"

// Constants for texture coordinates.
static const float texw = (float)PANEL2D_TEXW; // texture width
static const float texh = (float)PANEL2D_TEXH; // texture height
static const float tx_x0 =  991.0f;
static const float tx_y0 = texh-643.0f;
static const float tx_dx =   29.0f;
static const float tx_dy =   30.0f;

// Constants for panel coordinates.
static const float bb_x0 = 1071.0f;
static const float bb_y0 =    4.0f;

// ----------------------------------------------------------------------------- 


/**
MWS button constructor.
*/
MWSButton::MWSButton (VESSEL3 *v): PanelElement (v)
{
	dg = (DeltaGlider*)v;
	active = false;
	islit = false;
}


/**
Add mesh 2D data for MWS button.
*/
void MWSButton::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	static const DWORD NVTX = 4;
	static const DWORD NIDX = 6;
	static const NTVERTEX VTX[NVTX] = {
		{bb_x0,      bb_y0,      0,  0,0,0,  tx_x0/texw,         tx_y0/texh},
		{bb_x0+tx_dx,bb_y0,      0,  0,0,0,  (tx_x0+tx_dx)/texw, tx_y0/texh},
		{bb_x0,      bb_y0+tx_dy,0,  0,0,0,  tx_x0/texw,         tx_y0/texh},
		{bb_x0+tx_dx,bb_y0+tx_dy,0,  0,0,0,  (tx_x0+tx_dx)/texw, tx_y0/texh}
	};
	static const WORD IDX[NIDX] = {
		0,1,2, 3,2,1
	};
	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
MWS button reset 2D.
*/
void MWSButton::Reset2D ()
{
	active = islit = false;
}


/**
MWS button redraw 2D.
*/
bool MWSButton::Redraw2D (SURFHANDLE surf)
{
	bool light;
	if (dg->MWSActive()) 
	{
		double di, simt = oapiGetSimTime();
		light = (modf (simt, &di) < 0.5);
	}
	else 
	{
		light = false;
	}

	if (light != islit) 
	{
		int i;
		float tv = (light ? tx_y0+tx_dy : tx_y0)/texh;
		for (i = 2; i < 4; i++)
		{
			grp->Vtx[vtxofs+i].tv = tv;
		}
		islit = light;
	}
	return false;
}


/**
Process mouse 2D events for MWS button.
*/
bool MWSButton::ProcessMouse2D (int event, int mx, int my)
{
	dg->MWSReset();
	return false;
}


/**
Redraw VC for MWS button.
*/
bool MWSButton::RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf)
{
	bool light;
	if (dg->MWSActive()) 
	{
		double di, simt = oapiGetSimTime();
		light = (modf (simt, &di) < 0.5);
	} 
	else
	{ 
		light = false;
	}

	if (light != islit) 
	{
		NTVERTEX vtx[4];
		static WORD vidx[4] = {32,33,34,35};
		GROUPEDITSPEC ges;
		ges.flags = GRPEDIT_VTXTEXU;
		ges.nVtx = 4;
		ges.vIdx = vidx;
		ges.Vtx = vtx;
		float xofs = 0.2246f + (light ? 0.12891f : 0.0f);
		vtx[0].tu = vtx[1].tu = xofs;
		vtx[2].tu = vtx[3].tu = xofs + 0.125f;
		oapiEditMeshGroup (hMesh, MESHGRP_VC_STATUSIND, &ges);
		islit = light;
	}
	return false;
}
