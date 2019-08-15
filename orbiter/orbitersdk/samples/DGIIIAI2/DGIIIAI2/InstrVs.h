// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// InstrVs.h
// Vertical speed tape instrument for the Delta-Glider
// =============================================================================

#ifndef __INSTRVS_H
#define __INSTRVS_H

#include "Instrument.h"


class InstrVS: public PanelElement 
{
	public:
		InstrVS (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
	
	private:
		int pvmin;
};


#endif // !__INSTRVS_H
