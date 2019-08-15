// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2009 Martin Schweiger
//                   All rights reserved
//
// MwsButton.h
// User interface for Master Warning System
// =============================================================================

#ifndef __MWSBUTTON_H
#define __MWSBUTTON_H

#include "DeltaGlider.h"

// ----------------------------------------------------------------------------- 


/**
 * \brief Defines the user interface for the Master Warning System
 */
class MWSButton: public PanelElement 
{
	public:
		MWSButton (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		void Reset2D ();
		bool Redraw2D (SURFHANDLE surf);
		bool ProcessMouse2D (int event, int mx, int my);
		bool RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf);
	
	private:
		DeltaGlider *dg;
		bool active;
		bool islit;
};


#endif // !__MWSBUTTON_H
