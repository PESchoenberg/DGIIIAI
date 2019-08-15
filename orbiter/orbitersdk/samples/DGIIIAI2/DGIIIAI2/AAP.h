// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// AAP.h
// Atmospheric autopilot
//
// Notes:
// The atmospheric autopilot provides functions for altitude,
// airspeed and heading/course.
// The autopilot drives the aerodynamic control surfaces, but
// not the RCS thrusters. It works only at sufficient 
// atmospheric pressure.
// The actual autopilot algorithms are implemented as scripts
// (Script/DG/aap.lua). This class simply provides the user
// interface to the script functions.
// =============================================================================

#ifndef __AAP_H
#define __AAP_H

#include "Orbitersdk.h"
#include "Instrument.h"
#include "DeltaGlider.h"

class InstrHSI;

class AAP: public DGPanelElement 
{
	public:
		AAP (DeltaGlider *vessel);
		void RegisterPanel (PANELHANDLE hPanel);
		void AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx);
		bool Redraw2D (SURFHANDLE surf);
		bool ProcessMouse2D (int event, int mx, int my);
		void AttachHSI (InstrHSI *_hsi) { hsi = _hsi; }
		void WriteScenario (FILEHANDLE scn);
		void SetState (const char *str);
	
	protected:
		void ToggleActive (int block);
		void SetActive (int block, bool activate);
		void SetValue (int block, double val);
		void UpdateStr (char *str, char *pstr, int n, NTVERTEX *vtx);
	
	private:
		INTERPRETERHANDLE hAAP;       // Script interpreter.
		InstrHSI *hsi;                // Attached HSI instrument.
		int active_block;             // Active AAP segment (0=alt, 1=spd, 2=hdg, -1=none).
		double tgt[3];                // Target values for : altitude [m], speed [m/s], heading [deg].
		bool active[3], pactive[3];   // AP segment active?
		int  scanmode, scanpmode;     // Scan mode for currently active block.
		char readout[3][8];           // Readout strings.
};

#endif // !__AAP_H
