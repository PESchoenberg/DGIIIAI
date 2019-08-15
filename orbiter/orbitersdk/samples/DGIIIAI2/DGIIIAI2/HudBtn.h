// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// HudBtn.h
// HUD mode selector button interface
// =============================================================================

#ifndef __HUDBTN_H
#define __HUDBTN_H

#include "Instrument.h"

//------------------------------------------------------------------------------


class HUDButton: public PanelElement 
{
	public:
		HUDButton (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
		bool RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf);
		bool ProcessMouse2D (int event, int mx, int my);
};

#endif // !__HUDBTN_H
