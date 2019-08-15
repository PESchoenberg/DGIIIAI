// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// ThrottleMain.h
// Main throttle sliders
// =============================================================================

#ifndef __THROTTLEMAIN_H
#define __THROTTLEMAIN_H

#include "Instrument.h"

class DeltaGlider;

class ThrottleMain: public PanelElement 
{
	public:
		ThrottleMain (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		void Reset2D ();
		bool Redraw2D (SURFHANDLE surf);
		bool ProcessMouse2D (int event, int mx, int my);
	
	private:
		DeltaGlider *dg;
		float ppos[2];
};

#endif // !__THROTTLEMAIN_H
