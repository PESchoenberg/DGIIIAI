// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// RcsDial.h
// RCS selector dial user interface
// =============================================================================

#ifndef __RCSDIAL_H
#define __RCSDIAL_H

#include "Instrument.h"

//------------------------------------------------------------------------------

class RCSDial: public PanelElement 
{
	public:
		RCSDial (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
		bool ProcessMouse2D (int event, int mx, int my);
};

#endif // !__RCSDIAL_H
