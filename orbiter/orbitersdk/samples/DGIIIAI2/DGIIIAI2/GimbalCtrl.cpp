// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// GimbalCtrl.cpp
// Gimbal controls and displays
// =============================================================================

#define STRICT 1
#include "GimbalCtrl.h"

// Constants for texture coordinates
static const float texw = (float)PANEL2D_TEXW; // texture width
static const float texh = (float)PANEL2D_TEXH; // texture height
static const float tx_x0 = 1147.5f;            // left edge of texture block
static const float tx_y0 = texh-614.5f;        // top edge of texture block
static const float tx_dx = 7.0f;               // texture block width
static const float tx_dy = 6.0f;               // texture block height

// Constants for panel coordinates
static const float bb_dx =  7.0f;
static const float bb_dy =  3.0f;
static const float pm_x0 = 27.0f;       // left edge of button block
static const float pm_y0 = 103.5f;      // top edge of button block
static const float sc_y0 = 431.5f;


//------------------------------------------------------------------------------

/**
Main gimbal def.
*/
PMainGimbalDisp::PMainGimbalDisp (VESSEL3 *v): PanelElement (v)
{
}


/**
Add mesh data for gimbal 3D.
*/
void PMainGimbalDisp::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	static const DWORD NVTX = 8;
	static const DWORD NIDX = 12;
	static const NTVERTEX VTX[NVTX] = {
		{pm_x0,      pm_y0-bb_dy,0,  0,0,0,  tx_x0/texw, tx_y0/texh},
		{pm_x0+bb_dx,pm_y0-bb_dy,0,  0,0,0,  (tx_x0+tx_dx)/texw, tx_y0/texh},
		{pm_x0,      pm_y0+bb_dy,0,  0,0,0,  tx_x0/texw, (tx_y0+tx_dy)/texh},
		{pm_x0+bb_dx,pm_y0+bb_dy,0,  0,0,0,  (tx_x0+tx_dx)/texw, (tx_y0+tx_dy)/texh},
		{pm_x0+2.0f*bb_dx+1.0f,pm_y0-bb_dy,0,  0,0,0,  tx_x0/texw, tx_y0/texh},
		{pm_x0+bb_dx+1.0f,pm_y0-bb_dy,0,  0,0,0,  (tx_x0+tx_dx)/texw, tx_y0/texh},
		{pm_x0+2.0f*bb_dx+1.0f,pm_y0+bb_dy,0,  0,0,0,  tx_x0/texw, (tx_y0+tx_dy)/texh},
		{pm_x0+bb_dx+1.0f,pm_y0+bb_dy,0,  0,0,0,  (tx_x0+tx_dx)/texw, (tx_y0+tx_dy)/texh}
	};
	static const WORD IDX[NIDX] = {
		0,1,2, 3,2,1,
		4,6,5, 7,5,6
	};

	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Redraw main gimbal 2D.
*/
bool PMainGimbalDisp::Redraw2D (SURFHANDLE surf)
{
	int i, j, lvl;
	for (i = 0; i < 2; i++) 
	{
		lvl = ((DeltaGlider*)vessel)->mpgimbalidx[i]-35;
		for (j = 0; j < 4; j++)
		{
			grp->Vtx[vtxofs+i*4+j].y = pm_y0-bb_dy+(j/2)*(2*bb_dy) + lvl;
		}
	}
	return false;
}


/**
Redraw main gimbal VC.
*/
bool PMainGimbalDisp::RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf)
{
	DeltaGlider *dg = (DeltaGlider*)vessel;
	oapiBlt (surf, dg->srf[8], 0, dg->mpgimbalidx[0], 0, 0, 6, 7, SURF_PREDEF_CK);
	oapiBlt (surf, dg->srf[8], 7, dg->mpgimbalidx[1], 6, 0, 6, 7, SURF_PREDEF_CK);
	return true;
}


/**
Main gimbal ctrl def.
*/
PMainGimbalCtrl::PMainGimbalCtrl (VESSEL3 *v): PanelElement (v)
{
}


/**
Add mesh data for main gimbal 3D.
*/
void PMainGimbalCtrl::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	static const DWORD NVTX = 8;
	static const DWORD NIDX = 12;
	static const NTVERTEX VTX[NVTX] = {
		{64, 83,0,  0,0,0,  1054/texw, (texh-616)/texh},
		{78, 83,0,  0,0,0,  1068/texw, (texh-616)/texh},
		{64,125,0,  0,0,0,  1054/texw, (texh-574)/texh},
		{78,125,0,  0,0,0,  1068/texw, (texh-574)/texh},
		{83, 83,0,  0,0,0,  1054/texw, (texh-616)/texh},
		{97, 83,0,  0,0,0,  1068/texw, (texh-616)/texh},
		{83,125,0,  0,0,0,  1054/texw, (texh-574)/texh},
		{97,125,0,  0,0,0,  1068/texw, (texh-574)/texh}
	};
	static const WORD IDX[NIDX] = {
		0,1,2, 3,2,1,
		4,5,6, 7,6,5
	};
	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Redraw main gimbal 2D.
*/
bool PMainGimbalCtrl::Redraw2D (SURFHANDLE surf)
{
	int i, j, state;
	for (i = 0; i < 2; i++) 
	{
		state = ((DeltaGlider*)vessel)->mpswitch[i];
		for (j = 0; j < 4; j++)
		{
			grp->Vtx[vtxofs+i*4+j].tu = (1054+state*16+(j%2)*14)/texw;
		}
	}
	return false;
}


/**
Redraw main gimbal control VC.
*/
bool PMainGimbalCtrl::RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf)
{
	int i, state;
	DeltaGlider *dg = (DeltaGlider*)vessel;
	for (i = 0; i < 2; i++) 
	{
		state = dg->mpswitch[i];
		vessel->SetAnimation (dg->anim_pmaingimbal[i], state ? 2-state:0.5);
	}
	return false;
}


/**
Process mouse events 2D for main gimbal.
*/
bool PMainGimbalCtrl::ProcessMouse2D (int event, int mx, int my)
{
	static int ctrl = 0, mode = 0;
	if (event & PANEL_MOUSE_LBDOWN) 
	{
		if (mx <  10) 
		{
			ctrl = 1;
		}
		else if (mx >= 25) 
		{
			ctrl = 2;
		}
		else 
		{
			ctrl = 3;
		}
		if (my <  22) 
		{
			mode = 1;
		}
		else 
		{
			mode = 2;
		}
	} 
	else if (event & PANEL_MOUSE_LBUP) 
	{
		ctrl = 0;
	}
	if (((DeltaGlider*)vessel)->IncMainPGimbal (ctrl, mode))
	{
		oapiTriggerPanelRedrawArea (0, AID_PGIMBALMAINDISP);
	}
	return (event & PANEL_MOUSE_LBDOWN || event & PANEL_MOUSE_LBUP);
}


/**
Process mouse VC events for main gimbal.
*/
bool PMainGimbalCtrl::ProcessMouseVC (int event, VECTOR3 &p)
{
	static int ctrl = 0, mode = 0;
	if (event & PANEL_MOUSE_LBDOWN) 
	{
		if (p.x < 0.25) 
		{
			ctrl = 1;
		}
		else if (p.x > 0.75) 
		{
			ctrl = 2;
		}
		else 
		{
			ctrl = 3;
		}
		if (p.y < 0.5 ) 
		{
			mode = 1;
		}
		else 
		{
			mode = 2;
		}
	} 
	else if (event & PANEL_MOUSE_LBUP) 
	{
		ctrl = 0;
	}
	if (((DeltaGlider*)vessel)->IncMainPGimbal (ctrl, mode))
	{
		oapiVCTriggerRedrawArea (0, AID_PGIMBALMAINDISP);
	}
	return (event & PANEL_MOUSE_LBDOWN || event & PANEL_MOUSE_LBUP);
}


/**
Main gimbal cntr def.
*/
PMainGimbalCntr::PMainGimbalCntr (VESSEL3 *v): PanelElement (v)
{
}


/**
Add mesh data for main gimbal cntr.
*/
void PMainGimbalCntr::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	static const DWORD NVTX = 4;
	static const DWORD NIDX = 6;
	static const NTVERTEX VTX[NVTX] = {
		{58,140,0,  0,0,0,  1029/texw, (texh-584)/texh},
		{68,140,0,  0,0,0,  1039/texw, (texh-584)/texh},
		{58,150,0,  0,0,0,  1029/texw, (texh-574)/texh},
		{68,150,0,  0,0,0,  1039/texw, (texh-574)/texh}
	};
	static const WORD IDX[NIDX] = {
		0,1,2, 3,2,1
	};
	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Redraw main gimbal cntr 2D.
*/
bool PMainGimbalCntr::Redraw2D (SURFHANDLE surf)
{
	int j, mode = ((DeltaGlider*)vessel)->mpmode;
	for (j = 0; j < 4; j++)
	{
		grp->Vtx[vtxofs+j].tu = (1029+(j%2)*10+mode*12)/texw;
	}
	return false;
}


/**
Process mouse 2D events for main gimbal cntr.
*/
bool PMainGimbalCntr::ProcessMouse2D (int event, int mx, int my)
{
	((DeltaGlider*)vessel)->mpmode = 1-((DeltaGlider*)vessel)->mpmode;
	return true;
}


/**
Process mouse VC events for main gimbal cntr.
*/
bool PMainGimbalCntr::ProcessMouseVC (int event, VECTOR3 &p)
{
	((DeltaGlider*)vessel)->mpmode = 1-((DeltaGlider*)vessel)->mpmode;
	return true;
}


/**
Y main gimbal disp def.
*/
YMainGimbalDisp::YMainGimbalDisp (VESSEL3 *v): PanelElement (v)
{
}


/**
Add mesh data 2D for Y gimbal disp.
*/
void YMainGimbalDisp::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	static const DWORD NVTX = 8;
	static const DWORD NIDX = 12;
	static const NTVERTEX VTX[NVTX] = {
		{59.5f-3.0f,239.0f,0,  0,0,0,  1147.5f/texw, (texh-608.5f)/texh},
		{59.5f+3.0f,239.0f,0,  0,0,0,  1147.5f/texw, (texh-614.5f)/texh},
		{59.5f-3.0f,246.0f,0,  0,0,0,  1154.5f/texw, (texh-608.5f)/texh},
		{59.5f+3.0f,246.0f,0,  0,0,0,  1154.5f/texw, (texh-614.5f)/texh},
		{59.5f-3.0f,254.0f,0,  0,0,0,  1147.5f/texw, (texh-608.5f)/texh},
		{59.5f+3.0f,254.0f,0,  0,0,0,  1147.5f/texw, (texh-614.5f)/texh},
		{59.5f-3.0f,247.0f,0,  0,0,0,  1154.5f/texw, (texh-608.5f)/texh},
		{59.5f+3.0f,247.0f,0,  0,0,0,  1154.5f/texw, (texh-614.5f)/texh}
	};
	static const WORD IDX[NIDX] = {
		0,1,2, 3,2,1,
		4,6,5, 7,5,6
	};

	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
redraw 2D for Y main gimbal disp.
*/
bool YMainGimbalDisp::Redraw2D (SURFHANDLE surf)
{
	int i, j, lvl;
	for (i = 0; i < 2; i++) 
	{
		lvl = ((DeltaGlider*)vessel)->mygimbalidx[i]-35;
		for (j = 0; j < 4; j++)
		{
			grp->Vtx[vtxofs+i*4+j].x = 59.5f-3.0f+(j%2)*6.0f + lvl;
		}
	}
	return false;
}


/**
Redraw VC for Y main gimbal disp.
*/
bool YMainGimbalDisp::RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf)
{
	DeltaGlider *dg = (DeltaGlider*)vessel;
	oapiBlt (surf, dg->srf[8], dg->mygimbalidx[0], 0, 0, 8, 7, 6, SURF_PREDEF_CK);
	oapiBlt (surf, dg->srf[8], dg->mygimbalidx[1], 7, 7, 8, 7, 6, SURF_PREDEF_CK);
	return true;
}


/**
Y main gimbal control def.
*/
YMainGimbalCtrl::YMainGimbalCtrl (VESSEL3 *v): PanelElement (v)
{
}


/**
Add mesh data 2d for Y main gimbal control.
*/
void YMainGimbalCtrl::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	static const DWORD NVTX = 8;
	static const DWORD NIDX = 12;
	static const NTVERTEX VTX[NVTX] = {
		{56,179,0,  0,0,0,  1054/texw, (texh-574)/texh},
		{98,179,0,  0,0,0,  1054/texw, (texh-616)/texh},
		{56,193,0,  0,0,0,  1068/texw, (texh-574)/texh},
		{98,193,0,  0,0,0,  1068/texw, (texh-616)/texh},
		{56,198,0,  0,0,0,  1054/texw, (texh-574)/texh},
		{98,198,0,  0,0,0,  1054/texw, (texh-616)/texh},
		{56,212,0,  0,0,0,  1068/texw, (texh-574)/texh},
		{98,212,0,  0,0,0,  1068/texw, (texh-616)/texh}
	};
	static const WORD IDX[NIDX] = {
		0,1,2, 3,2,1,
		4,5,6, 7,6,5
	};

	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Redraw 2D for Y main gimbal control.
*/
bool YMainGimbalCtrl::Redraw2D (SURFHANDLE surf)
{
	int i, j, state;
	for (i = 0; i < 2; i++) 
	{
		static int map[3] = {0,2,1};
		state = map[((DeltaGlider*)vessel)->myswitch[i]];
		for (j = 0; j < 4; j++)
		{
			grp->Vtx[vtxofs+i*4+j].tu = (1054+state*16+(j%2)*14)/texw;
		}
	}
	return false;
}


/**
Redraw VC for main gimbal control.
*/
bool YMainGimbalCtrl::RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf)
{
	int i, state;
	DeltaGlider *dg = (DeltaGlider*)vessel;
	for (i = 0; i < 2; i++) 
	{
		state = dg->myswitch[i];
		vessel->SetAnimation (dg->anim_ymaingimbal[i], state ? 2-state:0.5);
	}
	return false;
}


/**
Process mouse 2D events for Y main gimbal control.
*/
bool YMainGimbalCtrl::ProcessMouse2D (int event, int mx, int my)
{
	static int ctrl = 0, mode = 0;
	if (event & PANEL_MOUSE_LBDOWN) 
	{
		if (my <  10)
		{ 
			ctrl = 1;
		}
		else if (my >= 25) 
		{
			ctrl = 2;
		}
		else 
		{
			ctrl = 3;
		}
		if (mx <  22) 
		{
			mode = 1;
		}
		else 
		{
			mode = 2;
		}
	} 
	else if (event & PANEL_MOUSE_LBUP) 
	{
		ctrl = 0;
	}
	if (((DeltaGlider*)vessel)->IncMainYGimbal (ctrl, mode))
	{
		oapiTriggerPanelRedrawArea (0, AID_YGIMBALMAINDISP);
	}
	return (event & PANEL_MOUSE_LBDOWN || event & PANEL_MOUSE_LBUP);
}


/**
Process mouse VC events for Y main gimbal control.
*/
bool YMainGimbalCtrl::ProcessMouseVC (int event, VECTOR3 &p)
{
	static int ctrl = 0, mode = 0;
	if (event & PANEL_MOUSE_LBDOWN) 
	{
		if (p.y < 0.25) 
		{
			ctrl = 1;
		}
		else if (p.y > 0.75) 
		{
			ctrl = 2;
		}
		else
		{ 
			ctrl = 3;
		}
		if (p.x < 0.5 )
		{ 
			mode = 1;
		}
		else
		{ 
			mode = 2;
		}
	} 
	else if (event & PANEL_MOUSE_LBUP) 
	{
		ctrl = 0;
	}
	if (((DeltaGlider*)vessel)->IncMainYGimbal (ctrl, mode))
	{
		oapiVCTriggerRedrawArea (0, AID_YGIMBALMAINDISP);
	}
	return (event & PANEL_MOUSE_LBDOWN || event & PANEL_MOUSE_LBUP);
}


/**
Y main gimbal mode def.
*/ 
YMainGimbalMode::YMainGimbalMode (VESSEL3 *v): PanelElement (v)
{
}


/**
Add mesh data 2D for Y main gimbal mode.
*/
void YMainGimbalMode::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	static const DWORD NVTX = 4*3;
	static const DWORD NIDX = 6*3;
	static const NTVERTEX VTX[NVTX] = {
		{ 9,166,0,  0,0,0,  1029/texw, (texh-584)/texh},
		{19,166,0,  0,0,0,  1039/texw, (texh-584)/texh},
		{ 9,176,0,  0,0,0,  1029/texw, (texh-574)/texh},
		{19,176,0,  0,0,0,  1039/texw, (texh-574)/texh},
		{ 9,183,0,  0,0,0,  1029/texw, (texh-584)/texh},
		{19,183,0,  0,0,0,  1039/texw, (texh-584)/texh},
		{ 9,193,0,  0,0,0,  1029/texw, (texh-574)/texh},
		{19,193,0,  0,0,0,  1039/texw, (texh-574)/texh},
		{ 9,200,0,  0,0,0,  1029/texw, (texh-584)/texh},
		{19,200,0,  0,0,0,  1039/texw, (texh-584)/texh},
		{ 9,210,0,  0,0,0,  1029/texw, (texh-574)/texh},
		{19,210,0,  0,0,0,  1039/texw, (texh-574)/texh}
	};
	static const WORD IDX[NIDX] = {
		0,1,2, 3,2,1,
		4,5,6, 7,6,5,
		8,9,10, 11,10,9
	};

	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Redraw 2D for Y main gimbal mode.
*/
bool YMainGimbalMode::Redraw2D (SURFHANDLE surf)
{
	DeltaGlider *dg = (DeltaGlider*)vessel;
	int i, j, ofs;
	for (i = 0; i < 3; i++) 
	{
		ofs = (dg->mymode == i+1 ? 12:0);
		for (j = 0; j < 4; j++)
		{
			grp->Vtx[vtxofs+i*4+j].tu = (1029+(j%2)*10+ofs)/texw;
		}
	}
	return false;
}


/**
Redraw VC for Y main gimbal mode.
*/
bool YMainGimbalMode::RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf)
{
	((DeltaGlider*)vessel)->SetVC_YGimbalMode();
	return false;
}


/**
Process mouse 2D events for Y main gimbal mode.
*/
bool YMainGimbalMode::ProcessMouse2D (int event, int mx, int my)
{
	DeltaGlider *dg = (DeltaGlider*)vessel;
	int mode = dg->mymode;
	if (my < 12) 
	{
		dg->mymode = (mode == 1 ? 0 : 1);
	}
	else if (my >= 17 && my < 29) 
	{
		dg->mymode = (mode == 2 ? 0 : 2);
	}
	else if (my >= 34)
	{
		dg->mymode = (mode == 3 ? 0 : 3);
	}
	return (mode != dg->mymode);
}


/**
Process mouse VC events for Y main gimbal mode.
*/
bool YMainGimbalMode::ProcessMouseVC (int event, VECTOR3 &p)
{
	DeltaGlider *dg = (DeltaGlider*)vessel;
	int mode = dg->mymode;
	if (p.y < 0.25)
	{ 
		dg->mymode = (mode == 1 ? 0 : 1);
	}
	else if (p.y >= 0.375 && p.y < 0.625) 
	{
		dg->mymode = (mode == 2 ? 0 : 2);
	}
	else if (p.y >= 0.75) 
	{
		dg->mymode = (mode == 3 ? 0 : 3);
	}
	return (mode != dg->mymode);
}


/**
Hover balance disp def.
*/
HoverBalanceDisp::HoverBalanceDisp (VESSEL3 *v): PanelElement (v)
{
}


/**
Add mesh data 2D for hover balance disp.
*/
void HoverBalanceDisp::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	static const DWORD NVTX = 4;
	static const DWORD NIDX = 6;
	static const NTVERTEX VTX[NVTX] = {
		{27,  327.5f-3,0,  0,0,0,  tx_x0/texw, tx_y0/texh},
		{27+7,327.5f-3,0,  0,0,0,  (tx_x0+tx_dx)/texw, tx_y0/texh},
		{27,  327.5f+3,0,  0,0,0,  tx_x0/texw, (tx_y0+tx_dy)/texh},
		{27+7,327.5f+3,0,  0,0,0,  (tx_x0+tx_dx)/texw, (tx_y0+tx_dy)/texh}
	};
	static const WORD IDX[NIDX] = {
		0,1,2, 3,2,1
	};

	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Redraw 2D for hover balance disp.
*/
bool HoverBalanceDisp::Redraw2D (SURFHANDLE surf)
{
	int j, lvl = ((DeltaGlider*)vessel)->hbalanceidx - 28;
	for (j = 0; j < 4; j++)
	{
		grp->Vtx[vtxofs+j].y = 327.5f-3.0f+(j/2)*6.0f + lvl;
	}
	return false;
}


/**
Hover balance control def.
*/
HoverBalanceCtrl::HoverBalanceCtrl (VESSEL3 *v): PanelElement (v)
{
}


/**
Add mesh data 2D for hover balance control.
*/
void HoverBalanceCtrl::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	static const DWORD NVTX = 4;
	static const DWORD NIDX = 6;
	static const NTVERTEX VTX[NVTX] = {
		{64,305,0,  0,0,0,  1054/texw, (texh-616)/texh},
		{78,305,0,  0,0,0,  1068/texw, (texh-616)/texh},
		{64,347,0,  0,0,0,  1054/texw, (texh-574)/texh},
		{78,347,0,  0,0,0,  1068/texw, (texh-574)/texh}
	};
	static const WORD IDX[NIDX] = {
		0,1,2, 3,2,1
	};
	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Redraw 2D for hover balance control.
*/
bool HoverBalanceCtrl::Redraw2D (SURFHANDLE surf)
{
	int j, state = ((DeltaGlider*)vessel)->hbswitch;
	for (j = 0; j < 4; j++)
	{
		grp->Vtx[vtxofs+j].tu = (1054+state*16+(j%2)*14)/texw;
	}
	return false;
}


/**
Process mouse 2D events for hover balance control.
*/
bool HoverBalanceCtrl::ProcessMouse2D (int event, int mx, int my)
{
	static int mode = 0;

	if (event & PANEL_MOUSE_LBDOWN) 
	{
		if (my < 22)
		{ 
			mode = 1;
		}
		else
		{ 
			mode = 2;
		}
	} 
	else if (event & PANEL_MOUSE_LBUP) 
	{
		mode = 0;
	}
	if (((DeltaGlider*)vessel)->ShiftHoverBalance (mode))
	{
		oapiTriggerPanelRedrawArea (0, AID_HBALANCEDISP);
	}
	return (event & PANEL_MOUSE_LBDOWN || event & PANEL_MOUSE_LBUP);
}


/**
Hover balance cntr def.
*/
HoverBalanceCntr::HoverBalanceCntr (VESSEL3 *v): PanelElement (v)
{
}


/**
Add mesh data 2D for hover balance cntr.
*/
void HoverBalanceCntr::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	static const DWORD NVTX = 4;
	static const DWORD NIDX = 6;
	static const NTVERTEX VTX[NVTX] = {
		{58,355,0,  0,0,0,  1029/texw, (texh-584)/texh},
		{68,355,0,  0,0,0,  1039/texw, (texh-584)/texh},
		{58,365,0,  0,0,0,  1029/texw, (texh-574)/texh},
		{68,365,0,  0,0,0,  1039/texw, (texh-574)/texh}
	};
	static const WORD IDX[NIDX] = {
		0,1,2, 3,2,1
	};
	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Redraw 2D for hover balance cntr.
*/
bool HoverBalanceCntr::Redraw2D (SURFHANDLE surf)
{
	int j, mode = ((DeltaGlider*)vessel)->hbmode;
	for (j = 0; j < 4; j++)
	{
		grp->Vtx[vtxofs+j].tu = (1029+(j%2)*10+mode*12)/texw;
	}
	return false;
}


/**
Process mouse 2D events for hover balance cntr.
*/
bool HoverBalanceCntr::ProcessMouse2D (int event, int mx, int my)
{
	((DeltaGlider*)vessel)->hbmode = 1-((DeltaGlider*)vessel)->hbmode;
	return true;
}


/**
Scram gimbal disp def.
*/
ScramGimbalDisp::ScramGimbalDisp (DeltaGlider *v): DGPanelElement (v)
{
}


/**
Add mesh data 2D for scram gimbal disp.
*/
void ScramGimbalDisp::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	static const DWORD NVTX = 8;
	static const DWORD NIDX = 12;
	static const NTVERTEX VTX[NVTX] = {
		{pm_x0,      sc_y0-bb_dy,0,  0,0,0,  tx_x0/texw, tx_y0/texh},
		{pm_x0+bb_dx,sc_y0-bb_dy,0,  0,0,0,  (tx_x0+tx_dx)/texw, tx_y0/texh},
		{pm_x0,      sc_y0+bb_dy,0,  0,0,0,  tx_x0/texw, (tx_y0+tx_dy)/texh},
		{pm_x0+bb_dx,sc_y0+bb_dy,0,  0,0,0,  (tx_x0+tx_dx)/texw, (tx_y0+tx_dy)/texh},
		{pm_x0+2.0f*bb_dx+1.0f,sc_y0-bb_dy,0,  0,0,0,  tx_x0/texw, tx_y0/texh},
		{pm_x0+bb_dx+1.0f,sc_y0-bb_dy,0,  0,0,0,  (tx_x0+tx_dx)/texw, tx_y0/texh},
		{pm_x0+2.0f*bb_dx+1.0f,sc_y0+bb_dy,0,  0,0,0,  tx_x0/texw, (tx_y0+tx_dy)/texh},
		{pm_x0+bb_dx+1.0f,sc_y0+bb_dy,0,  0,0,0,  (tx_x0+tx_dx)/texw, (tx_y0+tx_dy)/texh}
	};
	static const WORD IDX[NIDX] = {
		0,1,2, 3,2,1,
		4,6,5, 7,5,6
	};
	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Redraw 2D for scram gimbal disp.
*/
bool ScramGimbalDisp::Redraw2D (SURFHANDLE surf)
{
	int i, j, lvl;
	for (i = 0; i < 2; i++) 
	{
		lvl = dg->scgimbalidx[i]-35;
		for (j = 0; j < 4; j++)
		{
			grp->Vtx[vtxofs+i*4+j].y = sc_y0-bb_dy+(j/2)*(2*bb_dy) + lvl;
		}
	}
	return false;
}


/**
Redraw VC for scram gimbal disp.
*/
bool ScramGimbalDisp::RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf)
{
	oapiBlt (surf, dg->srf[8], 0, dg->scgimbalidx[0], 0, 0, 6, 7, SURF_PREDEF_CK);
	oapiBlt (surf, dg->srf[8], 7, dg->scgimbalidx[1], 6, 0, 6, 7, SURF_PREDEF_CK);
	return true;
}


/**
Scram gimbal control def.
*/
ScramGimbalCtrl::ScramGimbalCtrl (DeltaGlider *v): DGPanelElement (v)
{
}


/**
Add mesh data 2D for scram gimbal control.
*/
void ScramGimbalCtrl::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	static const DWORD NVTX = 8;
	static const DWORD NIDX = 12;
	static const NTVERTEX VTX[NVTX] = {
		{64,412,0,  0,0,0,  1054/texw, (texh-616)/texh},
		{78,412,0,  0,0,0,  1068/texw, (texh-616)/texh},
		{64,454,0,  0,0,0,  1054/texw, (texh-574)/texh},
		{78,454,0,  0,0,0,  1068/texw, (texh-574)/texh},
		{83,412,0,  0,0,0,  1054/texw, (texh-616)/texh},
		{97,412,0,  0,0,0,  1068/texw, (texh-616)/texh},
		{83,454,0,  0,0,0,  1054/texw, (texh-574)/texh},
		{97,454,0,  0,0,0,  1068/texw, (texh-574)/texh}
	};
	static const WORD IDX[NIDX] = {
		0,1,2, 3,2,1,
		4,5,6, 7,6,5
	};
	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Redraw 2D for scram gimbal control.
*/
bool ScramGimbalCtrl::Redraw2D (SURFHANDLE surf)
{
	int i, j, state;
	for (i = 0; i < 2; i++) 
	{
		state = dg->sgswitch[i];
		for (j = 0; j < 4; j++)
		{
			grp->Vtx[vtxofs+i*4+j].tu = (1054+state*16+(j%2)*14)/texw;
		}
	}
	return false;
}


/**
Redraw VC for scram gimbal control.
*/
bool ScramGimbalCtrl::RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf)
{
	int i, state;
	for (i = 0; i < 2; i++) 
	{
		state = dg->sgswitch[i];
		dg->SetAnimation (dg->anim_scramgimbal[i], state ? 2-state:0.5);
	}
	return false;
}


/**
Process mouse 2 for scram gimbal controlD.
*/
bool ScramGimbalCtrl::ProcessMouse2D (int event, int mx, int my)
{
	static int ctrl = 0, mode = 0;
	if (event & PANEL_MOUSE_LBDOWN) 
	{
		if (mx <  10) 
		{
			ctrl = 1;
		}
		else if (mx >= 25) 
		{
			ctrl = 2;
		}
		else 
		{
			ctrl = 3;
		}
		if (my <  22) 
		{
			mode = 1;
		}
		else 
		{
			mode = 2;
		}
	} 
	else if (event & PANEL_MOUSE_LBUP) 
	{
		ctrl = 0;
	}
	if (dg->IncScramGimbal (ctrl, mode))
	{
		oapiTriggerPanelRedrawArea (0, AID_GIMBALSCRAMDISP);
	}
	return (event & PANEL_MOUSE_LBDOWN || event & PANEL_MOUSE_LBUP);
}


/**
Process mouse VC for scram gimbal control.
*/
bool ScramGimbalCtrl::ProcessMouseVC (int event, VECTOR3 &p)
{
	static int ctrl = 0, mode = 0;
	if (event & PANEL_MOUSE_LBDOWN) 
	{
		if (p.x < 0.25)
		{ 
			ctrl = 1;
		}
		else if (p.x > 0.75) 
		{
			ctrl = 2;
		}
		else 
		{
			ctrl = 3;
		}
		if (p.y < 0.5 )
		{ 
			mode = 1;
		}
		else 
		{
			mode = 2;
		}
	}
	else if (event & PANEL_MOUSE_LBUP) 
	{
		ctrl = 0;
	}
	if (dg->IncScramGimbal (ctrl, mode))
	{
		oapiVCTriggerRedrawArea (0, AID_GIMBALSCRAMDISP);
	}
	return (event & PANEL_MOUSE_LBDOWN || event & PANEL_MOUSE_LBUP);
}


/**
Scram gimbal cntr def.
*/
ScramGimbalCntr::ScramGimbalCntr (DeltaGlider *v): DGPanelElement (v)
{
}


/**
Add mesh data 2D for scram gimbal cntr.
*/
void ScramGimbalCntr::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	static const DWORD NVTX = 4;
	static const DWORD NIDX = 6;
	static const NTVERTEX VTX[NVTX] = {
		{58,469,0,  0,0,0,  1029/texw, (texh-584)/texh},
		{68,469,0,  0,0,0,  1039/texw, (texh-584)/texh},
		{58,479,0,  0,0,0,  1029/texw, (texh-574)/texh},
		{68,479,0,  0,0,0,  1039/texw, (texh-574)/texh}
	};
	static const WORD IDX[NIDX] = {
		0,1,2, 3,2,1
	};
	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Redraw 2D scram gimbal cntr.
*/
bool ScramGimbalCntr::Redraw2D (SURFHANDLE surf)
{
	int j, mode = dg->spmode;
	for (j = 0; j < 4; j++)
	{
		grp->Vtx[vtxofs+j].tu = (1029+(j%2)*10+mode*12)/texw;
	}
	return false;
}


/**
Redraw VC for scram gimbal cntr.
*/
bool ScramGimbalCntr::RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf)
{
	dg->SetVC_ScramGimbalMode();
	return false;
}


/**
Process mouse 2D events for scram gimbal cntr.
*/
bool ScramGimbalCntr::ProcessMouse2D (int event, int mx, int my)
{
	dg->spmode = 1-dg->mpmode;
	return true;
}


/**
Process mouse VC events for scram gimbal cntr.
*/
bool ScramGimbalCntr::ProcessMouseVC (int event, VECTOR3 &p)
{
	dg->spmode = 1-dg->spmode;
	return true;
}
