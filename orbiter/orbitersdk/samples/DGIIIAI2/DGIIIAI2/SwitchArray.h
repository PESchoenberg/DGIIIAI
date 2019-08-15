// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2009 Martin Schweiger
//                   All rights reserved
//
// SwitchArray.h
// User interface for row of switches on main panel
// =============================================================================

#ifndef __SWITCHARRAY_H
#define __SWITCHARRAY_H

#include "Instrument.h"

//------------------------------------------------------------------------------

class SwitchArray: public PanelElement 
{
	public:
		SwitchArray (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		void Reset2D ();
		bool Redraw2D (SURFHANDLE surf);
		bool ProcessMouse2D (int event, int mx, int my);
	
	private:
		int btnstate[8]; // 0=up, 1=down.
};

#endif // !__SWITCHARRAY_H
