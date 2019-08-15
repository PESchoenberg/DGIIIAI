// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// NavButton.h
// Navigation mode button user interface
// =============================================================================

#ifndef __NAVBUTTON_H
#define __NAVBUTTON_H

#include "Instrument.h"

//------------------------------------------------------------------------------ 


class NavButton: public PanelElement 
{
	public:
		NavButton (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
		bool RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf);
		bool ProcessMouse2D (int event, int mx, int my);
};


#endif // !__NAVBUTTON_H
