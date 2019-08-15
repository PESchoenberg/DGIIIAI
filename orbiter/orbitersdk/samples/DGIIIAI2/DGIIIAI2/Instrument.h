// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// Instrument.h
// Base class for panel and VC instrument visualisations
// =============================================================================

#ifndef __INSTRUMENT_H
#define __INSTRUMENT_H

#include "Orbitersdk.h"

class VESSEL3;

// -----------------------------------------------------------------------------


class PanelElement 
{
	public:
		PanelElement (VESSEL3 *v);
		virtual ~PanelElement ();
	
		virtual void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx) {}
		virtual void AddMeshDataVC (MESHHANDLE hMesh, DWORD grpidx) {}
		virtual void Reset2D ();
		virtual bool Redraw2D (SURFHANDLE surf);
		virtual bool RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf);
		virtual bool ProcessMouse2D (int event, int mx, int my);
		virtual bool ProcessMouseVC (int event, VECTOR3 &p);
	
	protected:
		void AddGeometry (MESHHANDLE hMesh, DWORD grpidx, const NTVERTEX *vtx, DWORD nvtx, const WORD *idx, DWORD nidx);
	
		char *DispStr (double dist, int precision=4);
	
		VESSEL3 *vessel;
		MESHHANDLE mesh;
		DWORD gidx;
		MESHGROUP *grp; // Panel mesh group representing the instrument
		DWORD vtxofs;   // Vertex offset in mesh group
};


#endif // !__INSTRUMENT_H
