// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// InstrHsi.h
// HSI (Horizonal situation indicator) for the Delta-Glider
// =============================================================================

#ifndef __INSTRHSI_H
#define __INSTRHSI_H

#include "Instrument.h"

// -----------------------------------------------------------------------------


class InstrHSI: public PanelElement 
{
	public:
		InstrHSI (VESSEL3 *v);
		void SetCrs (double newcrs);
		double GetCrs () const;
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
		
	private:
		void Orthodome (double lng1, double lat1, double lng2, double lat2,
			double &dist, double &dir);
	
		double crs;
		double dev;
		double gslope;
		NAVHANDLE nav;
		OBJHANDLE navRef;
		DWORD navType;
		double navlng, navlat;
};


#endif // !__INSTRHSI_H
