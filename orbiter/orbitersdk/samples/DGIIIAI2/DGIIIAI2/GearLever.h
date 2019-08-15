// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// GearLever.h
// Gear up/down lever interface
// =============================================================================

#ifndef __GEARLEVER_H
#define __GEARLEVER_H

#include "Instrument.h"

//------------------------------------------------------------------------------


class GearLever: public PanelElement 
{
	public:
		GearLever (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
		bool ProcessMouse2D (int event, int mx, int my);
};


class GearIndicator: public PanelElement 
{
	public:
		GearIndicator (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
	
	private:
		double tofs;
};

#endif // !__GEARLEVER_H
