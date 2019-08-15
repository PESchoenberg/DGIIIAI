// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2009 Martin Schweiger
//                   All rights reserved
//
// WheelBrake.h
// User interface for Wheel brake levers
// =============================================================================

#ifndef __WHEELBRAKE_H
#define __WHEELBRAKE_H

#include "DeltaGlider.h"

//------------------------------------------------------------------------------

/**
 * \brief Defines the user interface for the wheel brake levers
 */
class WheelBrakeLever: public PanelElement 
{
	public:
		WheelBrakeLever (VESSEL3 *v);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
		bool ProcessMouse2D (int event, int mx, int my);
	
	private:
		bool isdown[2];
};

#endif // !__WHEELBRAKE_H
