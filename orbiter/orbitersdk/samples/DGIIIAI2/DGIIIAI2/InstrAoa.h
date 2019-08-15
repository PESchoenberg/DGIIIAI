// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// InstrAoa.h
// Angle-of-attack tape instrument for the Delta-Glider
// =============================================================================

#ifndef __INSTRAOA_H
#define __INSTRAOA_H

#include "Instrument.h"


class InstrAOA: public PanelElement 
{
	public:
		InstrAOA (VESSEL3 *v);
	
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
	
		bool Redraw2D (SURFHANDLE surf);
	
	private:
		double paoa; // Previous AOA value.
};


#endif // !__INSTRAOA_H
