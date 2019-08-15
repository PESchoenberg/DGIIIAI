// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// ElevTrim.h
// Elevator trim control
// =============================================================================

#ifndef __ELEVTRIM_H
#define __ELEVTRIM_H

#include "Instrument.h"

class ElevatorTrim: public PanelElement 
{
	public:
		ElevatorTrim (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		void Reset2D ();
		bool Redraw2D (SURFHANDLE surf);
		bool RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf);
		bool ProcessMouse2D (int event, int mx, int my);
	
	private:
		double trim;
		UINT elevtrimpos;
};

#endif // !__ELEVTRIM_H
