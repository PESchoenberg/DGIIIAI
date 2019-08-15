// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// UndockBtn.h
// "Dock release" button interface
// =============================================================================

#ifndef __UNDOCKBTN_H
#define __UNDOCKBTN_H

#include "Instrument.h"

//------------------------------------------------------------------------------

class UndockButton: public PanelElement 
{
	public:
		UndockButton (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		void Reset2D ();
		bool Redraw2D (SURFHANDLE surf);
		bool ProcessMouse2D (int event, int mx, int my);
	
	private:
		bool btndown;
};

#endif // !__UNDOCKBTN_H
