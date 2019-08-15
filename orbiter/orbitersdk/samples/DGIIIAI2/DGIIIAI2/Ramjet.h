// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// Ramjet.h
// Interface for the delta glider ramjet engine
//
// Notes:
// This class only requires a generic VESSEL reference, so it can
// be ported to other vessel classes.
// It is designed to manage all ramjet/scramjet engines of a
// vessel, so only a single instance should be created. Individual
// engines can then be defined by the AddThrusterDefinition method.
// =============================================================================

#ifndef __RAMJET_H
#define __RAMJET_H

#include "Orbitersdk.h"

class Ramjet 
{
	public:
		Ramjet (VESSEL *_vessel);
		
		~Ramjet ();
	
		void AddThrusterDefinition (THRUSTER_HANDLE th, double Qr, double Ai, double Tb_max, double dmf_max);
	
		void Thrust (double *F) const;
		
		double TSFC (UINT idx) const;
	
		// Returns current fuel mass flow of thruster idx.
		inline double DMF (UINT idx) const { return thdef[idx]->dmf; }
		
		// Returns diffuser, combustion or exhaust temperature [K] of thruster idx.
		inline double Temp (UINT idx, UINT which) const { return thdef[idx]->T[which]; }
		
	private:
		VESSEL *vessel;            // Vessel pointer.
		
		struct THDEF {             // list of ramjet thrusters.
			THRUSTER_HANDLE th;    //   Thruster handle  .              -+
			double Qr;             //   Fuel heating parameter [J/kg].   | static
			double Ai;             //   Air intake cross section [m^2].  | parameters
			double Tb_max;         //   Max. burner temperature [K] .    |
			double dmf_max;        //   Max. fuel flow rate [kg/s] .    -+
	
			double dmf;            //   Current fuel mass rate [kg/s].  -+ dynamic
			double F;              //   Current thrust [N].              | parameters
			double T[3];           //   Temperatures  .                 -+
		} **thdef;
		UINT nthdef;               // Number of ramjet thrusters.
};

#endif // !__RAMJET_H
