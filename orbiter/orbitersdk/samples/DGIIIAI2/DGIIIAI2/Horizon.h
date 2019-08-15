// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// Horizon.h
// Artificial horizon instrument (attitude indicator) for the
// Delta-Glider
// =============================================================================

#ifndef __HORIZON_H
#define __HORIZON_H

#include "Instrument.h"

//------------------------------------------------------------------------------


class InstrAtt: public PanelElement 
{
	public:
		InstrAtt (VESSEL3 *v);
		~InstrAtt ();
	
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
	
		/**
		 * \brief Update instrument display (2D panel)
		 * \param surf texture used by the instrument
		 * \return \e false to indicate that the texture was not modified
		 */
		bool Redraw2D (SURFHANDLE surf);
	
		/**
		 * \brief Return the base configuration for the horizon
		 *   mesh group.
		 */
		NTVERTEX *MeshDataVC ();
	
		void TransformVtxVC (NTVERTEX *vtx, DWORD nvtx);
		void TransformNmlVC (NTVERTEX *vtx, DWORD nvtx);
	
		/**
		 * \brief Update instrument display (virtual cockpit)
		 * \param hMesh VC mesh handle
		 * \param surf texture used by the instrument
		 * \return \e true to indicate that the texture was modified
		 */
		bool RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf);
};

#endif // !__HORIZON_H
