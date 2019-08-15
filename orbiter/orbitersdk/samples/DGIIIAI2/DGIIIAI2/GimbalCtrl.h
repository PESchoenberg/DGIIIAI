// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2009 Martin Schweiger
//                   All rights reserved
//
// GimbalCtrl.h
// Gimbal controls and displays
// =============================================================================

#ifndef __GIMBALCTRL_H
#define __GIMBALCTRL_H

#include "DeltaGlider.h"

//------------------------------------------------------------------------------

class PMainGimbalDisp: public PanelElement 
{
	public:
		PMainGimbalDisp (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
		bool RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf);
};


class PMainGimbalCtrl: public PanelElement 
{
	public:
		PMainGimbalCtrl (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
		bool RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf);
		bool ProcessMouse2D (int event, int mx, int my);
		bool ProcessMouseVC (int event, VECTOR3 &p);
};


class PMainGimbalCntr: public PanelElement 
{
	public:
		PMainGimbalCntr (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
		bool ProcessMouse2D (int event, int mx, int my);
		bool ProcessMouseVC (int event, VECTOR3 &p);
};


class YMainGimbalDisp: public PanelElement 
{
	public:
		YMainGimbalDisp (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
		bool RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf);
};


class YMainGimbalCtrl: public PanelElement 
{
	public:
		YMainGimbalCtrl (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
		bool RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf);
		bool ProcessMouse2D (int event, int mx, int my);
		bool ProcessMouseVC (int event, VECTOR3 &p);
};


class YMainGimbalMode: public PanelElement 
{
	public:
		YMainGimbalMode (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
		bool RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf);
		bool ProcessMouse2D (int event, int mx, int my);
		bool ProcessMouseVC (int event, VECTOR3 &p);
};


class HoverBalanceDisp: public PanelElement 
{
	public:
		HoverBalanceDisp (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
};


class HoverBalanceCtrl: public PanelElement 
{
	public:
		HoverBalanceCtrl (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
		bool ProcessMouse2D (int event, int mx, int my);
};


class HoverBalanceCntr: public PanelElement 
{
	public:
		HoverBalanceCntr (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
		bool ProcessMouse2D (int event, int mx, int my);
};


class ScramGimbalDisp: public DGPanelElement 
{
	public:
		ScramGimbalDisp (DeltaGlider *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
		bool RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf);
};


class ScramGimbalCtrl: public DGPanelElement 
{
	public:
		ScramGimbalCtrl (DeltaGlider *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
		bool RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf);
		bool ProcessMouse2D (int event, int mx, int my);
		bool ProcessMouseVC (int event, VECTOR3 &p);
};


class ScramGimbalCntr: public DGPanelElement 
{
public:
	ScramGimbalCntr (DeltaGlider *v);
	void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
	bool Redraw2D (SURFHANDLE surf);
	bool RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf);
	bool ProcessMouse2D (int event, int mx, int my);
	bool ProcessMouseVC (int event, VECTOR3 &p);
};

#endif // !__GIMBALCTRL_H
