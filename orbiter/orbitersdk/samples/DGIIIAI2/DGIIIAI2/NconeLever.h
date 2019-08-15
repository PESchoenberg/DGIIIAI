// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// NconeLever.h
// Nose cone open/close lever interface
// =============================================================================

#ifndef __NCONELEVER_H
#define __NCONELEVER_H

#include "DeltaGlider.h"

//------------------------------------------------------------------------------ 


class NoseconeLever: public DGPanelElement 
{
	public:
		NoseconeLever (DeltaGlider *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
		bool ProcessMouse2D (int event, int mx, int my);
};

class NoseconeIndicator: public DGPanelElement 
{
	public:
		NoseconeIndicator (DeltaGlider *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
	
	private:
		double tofs;
};


#endif // !__NCONELEVER_H
