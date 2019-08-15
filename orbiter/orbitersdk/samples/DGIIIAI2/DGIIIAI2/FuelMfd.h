// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// FuelMfd.h
// Fuel status display
// =============================================================================

#ifndef __FUELMFD_H
#define __FUELMFD_H

#include "Instrument.h"

class FuelMFD: public PanelElement 
{
	public:
		FuelMFD (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
	
	private:
		void AddMeshData_noscram (MESHHANDLE hMesh, DWORD grpidx);
		void AddMeshData_scram (MESHHANDLE hMesh, DWORD grpidx);
		void BltString (char *str, char *pstr, int maxlen, int x, int y, SURFHANDLE surf);
	
		bool isScram;
		double Tsample;
		double Mmain, Mrcs, Mscram;
		char sout[9][5];
};

#endif // !__FUELMFD_H
