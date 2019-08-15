// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// AtctrlDial.h
// Atmospheric control selector dial user interface
// =============================================================================

#ifndef __ATCTRLDIAL_H
#define __ATCTRLDIAL_H

#include "Instrument.h"

// -----------------------------------------------------------------------------

class ATCtrlDial: public PanelElement 
{
	public:
		ATCtrlDial (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
		bool ProcessMouse2D (int event, int mx, int my);
};

#endif // !__ATCTRLDIAL_H
