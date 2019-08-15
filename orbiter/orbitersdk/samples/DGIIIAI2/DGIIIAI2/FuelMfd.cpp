// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// FuelMfd.cpp
// Fuel status display
// =============================================================================

#define STRICT 1
#include "FuelMfd.h"
#include "DeltaGlider.h"

// Constants for texture coordinates
static const float texw = (float)PANEL2D_TEXW/*INSTR3_TEXW*/;
static const float texh = (float)PANEL2D_TEXH/*INSTR3_TEXH*/;
static const float horzx = texw-580.0f;
static const float horzy = texh-188.0f;
static const float tx_x0 = horzx+  0.5f;
static const float tx_dx = 267.0f;
static const float tx_y0 = horzy+ 20.5f;
static const float tx_dy = 167.0f;
static const float greenx = (horzx+267.0f)/texw;
static const float greeny = (horzy+  1.0f)/texh;

// Constants for panel coordinates
static const float fd_x0 = 187.5f;
static const float fd_y0 = 395.5f;
static const float fuelh =  86.0f;
static const float fuelw =  28.0f;
static const float fuely = fd_y0+29.5f+fuelh;


//------------------------------------------------------------------------------


/**
Fuel MFD def.
*/
FuelMFD::FuelMFD (VESSEL3 *v): PanelElement (v)
{
	int i, j;
	isScram = false;
	for (i = 0; i < 9; i++)
	{
		for (j = 0; j < 5; j++) 
		{
			sout[i][j] = 0;
		}
	}
}


/**
Add mesh data for fuel MFD.
*/
void FuelMFD::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	DeltaGlider *dg = (DeltaGlider*)vessel;
	isScram = dg->ScramVersion();

	if (isScram) 
	{
		AddMeshData_scram (hMesh, grpidx);
	}
	else 
	{
		AddMeshData_noscram (hMesh, grpidx);
	}

	Tsample = oapiGetSimTime();
	Mmain = dg->GetPropellantMass (dg->ph_main);
	Mrcs  = dg->GetPropellantMass (dg->ph_rcs);
	if (isScram)
	{
		Mscram = dg->GetPropellantMass (dg->ph_scram);
	}
}


/**
Add no scram fuel mesh data.
*/
void FuelMFD::AddMeshData_noscram (MESHHANDLE hMesh, DWORD grpidx)
{
	float dx = 46.0f;
	float main_x0 = fd_x0+dx+5.5f;
	static const DWORD NVTX = 16;
	static const DWORD NIDX = 24;
	static const NTVERTEX VTX[NVTX] = {
		// Propellant title
		{fd_x0,         fd_y0,      0,  0,0,0,  tx_x0/texw,        tx_y0/texh},
		{fd_x0+tx_dx,   fd_y0,      0,  0,0,0,  (tx_x0+tx_dx)/texw,tx_y0/texh},
		{fd_x0,         fd_y0+14,   0,  0,0,0,  tx_x0/texw,        (tx_y0+14)/texh},
		{fd_x0+tx_dx,   fd_y0+14,   0,  0,0,0,  (tx_x0+tx_dx)/texw,(tx_y0+14)/texh},
		// Propellant status display
		{fd_x0+dx,      fd_y0+14,   0,  0,0,0,  tx_x0/texw,             (tx_y0+14)/texh},
		{fd_x0+tx_dx-dx,fd_y0+14,   0,  0,0,0,  (tx_x0+tx_dx-2*dx)/texw,(tx_y0+14)/texh},
		{fd_x0+dx,      fd_y0+tx_dy,0,  0,0,0,  tx_x0/texw,             (tx_y0+tx_dy)/texh},
		{fd_x0+tx_dx-dx,fd_y0+tx_dy,0,  0,0,0,  (tx_x0+tx_dx-2*dx)/texw,(tx_y0+tx_dy)/texh},
		// Main level
		{main_x0,      fuely,0,  0,0,0,  greenx, greeny},
		{main_x0+fuelw,fuely,0,  0,0,0,  greenx, greeny},
		{main_x0,      fuely,0,  0,0,0,  greenx, greeny},
		{main_x0+fuelw,fuely,0,  0,0,0,  greenx, greeny},
		// Rcs level
		{main_x0+92,      fuely,0,  0,0,0,  greenx, greeny},
		{main_x0+92+fuelw,fuely,0,  0,0,0,  greenx, greeny},
		{main_x0+92,      fuely,0,  0,0,0,  greenx, greeny},
		{main_x0+92+fuelw,fuely,0,  0,0,0,  greenx, greeny}
	};
	static const WORD IDX[NIDX] = {
		0,1,2, 3,2,1,
		4,5,6, 7,6,5,
		8,9,10, 11,10,9,
		12,13,14, 15,14,13
	};

	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Add scram fuel mesh data.
*/
void FuelMFD::AddMeshData_scram (MESHHANDLE hMesh, DWORD grpidx)
{
	float main_x0 = fd_x0+5.5f;
	static const DWORD NVTX = 20;
	static const DWORD NIDX = 30;
	static const NTVERTEX VTX[NVTX] = {
		// Propellant title
		{fd_x0,         fd_y0,      0,  0,0,0,  tx_x0/texw,        tx_y0/texh},
		{fd_x0+tx_dx,   fd_y0,      0,  0,0,0,  (tx_x0+tx_dx)/texw,tx_y0/texh},
		{fd_x0,         fd_y0+14,   0,  0,0,0,  tx_x0/texw,        (tx_y0+14)/texh},
		{fd_x0+tx_dx,   fd_y0+14,   0,  0,0,0,  (tx_x0+tx_dx)/texw,(tx_y0+14)/texh},
		// Propellant status display
		{fd_x0,      fd_y0+14,   0,  0,0,0,  tx_x0/texw,     (tx_y0+14)/texh},
		{fd_x0+tx_dx,fd_y0+14,   0,  0,0,0,  (tx_x0+tx_dx)/texw,(tx_y0+14)/texh},
		{fd_x0,      fd_y0+tx_dy,0,  0,0,0,  tx_x0/texw,     (tx_y0+tx_dy)/texh},
		{fd_x0+tx_dx,fd_y0+tx_dy,0,  0,0,0,  (tx_x0+tx_dx)/texw,(tx_y0+tx_dy)/texh},
		// Main level
		{main_x0,      fuely,0,  0,0,0,  greenx, greeny},
		{main_x0+fuelw,fuely,0,  0,0,0,  greenx, greeny},
		{main_x0,      fuely,0,  0,0,0,  greenx, greeny},
		{main_x0+fuelw,fuely,0,  0,0,0,  greenx, greeny},
		// Rcs level
		{main_x0+92,      fuely,0,  0,0,0,  greenx, greeny},
		{main_x0+92+fuelw,fuely,0,  0,0,0,  greenx, greeny},
		{main_x0+92,      fuely,0,  0,0,0,  greenx, greeny},
		{main_x0+92+fuelw,fuely,0,  0,0,0,  greenx, greeny},
		// Scram level
		{main_x0+184,      fuely,0,  0,0,0,  greenx, greeny},
		{main_x0+184+fuelw,fuely,0,  0,0,0,  greenx, greeny},
		{main_x0+184,      fuely,0,  0,0,0,  greenx, greeny},
		{main_x0+184+fuelw,fuely,0,  0,0,0,  greenx, greeny}
	};
	static const WORD IDX[NIDX] = {
		0,1,2, 3,2,1,
		4,5,6, 7,6,5,
		8,9,10, 11,10,9,
		12,13,14, 15,14,13,
		16,17,18, 19,18,17
	};

	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Redraw fuel MFD 2D.
*/
bool FuelMFD::Redraw2D (SURFHANDLE surf)
{
	DeltaGlider *dg = (DeltaGlider*)vessel;

	static const int xofs = (int)horzx, yofs = (int)horzy;
	double m, m0, lvl, dv, isp;
	float y1;
	int vofs;
	char cbuf[16];
	double T = oapiGetSimTime();
	double dT = T-Tsample;
	m0 = dg->GetMass();

	// Main level
	m = dg->GetPropellantMass (dg->ph_main);
	lvl = m / max (1.0, dg->max_rocketfuel);
	isp = dg->GetThrusterIsp (dg->th_main[0]);
	dv = isp * log(m0/(m0-m));
	y1 = (float)(fuely - lvl * fuelh);
	vofs = vtxofs+8;
	grp->Vtx[vofs].y = grp->Vtx[vofs+1].y = y1;
	sprintf (cbuf, "% 6d", (int)(m+0.5));
	BltString (cbuf+1, sout[0], 5, xofs+42, yofs+78, surf);
	sprintf (cbuf, "% 6d", (int)(dv+0.5));
	BltString (cbuf+1, sout[6], 5, xofs+42, yofs+106, surf);
	if (dT > 0.0) 
	{
		sprintf (cbuf, "% 5.2f", (Mmain-m)/(T-Tsample));
		BltString (cbuf, sout[3], 5, xofs+42, yofs+156, surf);
		Mmain = m;
	}

	// Tcs level
	m = dg->GetPropellantMass (dg->ph_rcs);
	lvl = m / RCS_FUEL_CAPACITY;
	isp = ISP;
	dv = isp * log(m0/(m0-m));
	y1 = (float)(fuely - lvl * fuelh);
	vofs = vtxofs+12;
	grp->Vtx[vofs].y = grp->Vtx[vofs+1].y = y1;
	sprintf (cbuf, "% 6d", (int)(m+0.5));
	BltString (cbuf+1, sout[1], 5, xofs+134, yofs+78, surf);
	sprintf (cbuf, "% 6d", (int)(dv+0.5));
	BltString (cbuf+1, sout[7], 5, xofs+134, yofs+106, surf);
	if (dT > 0.0) 
	{
		sprintf (cbuf, "% 5.2f", (Mrcs-m)/(T-Tsample));
		BltString (cbuf, sout[4], 5, xofs+134, yofs+156, surf);
		Mrcs = m;
	}

	if (isScram) 
	{
		// Scram level
		m = dg->GetPropellantMass (dg->ph_scram);
		lvl = m / max (1.0, dg->max_scramfuel);
		isp = dg->GetThrusterIsp (dg->th_scram[0]);
		dv = isp * log(m0/(m0-m));
		y1 = (float)(fuely - lvl * fuelh);
		vofs = vtxofs+16;
		grp->Vtx[vofs].y = grp->Vtx[vofs+1].y = y1;
		sprintf (cbuf, "% 6d", (int)(m+0.5));
		BltString (cbuf+1, sout[2], 5, xofs+226, yofs+78, surf);
		sprintf (cbuf, "% 6d", (int)(dv+0.5));
		BltString (cbuf+1, sout[8], 5, xofs+226, yofs+106, surf);
		if (dT > 0.0) 
		{
			sprintf (cbuf, "% 5.2f", (Mscram-m)/(T-Tsample));
			BltString (cbuf, sout[5], 5, xofs+226, yofs+156, surf);
			Mscram = m;
		}
	}

	Tsample = T;
	return false;
}


/**
Fuel MFD blt str.
*/
void FuelMFD::BltString (char *str, char *pstr, int maxlen, int x, int y, SURFHANDLE surf)
{
	int i, xsrc, xofs = (int)horzx+131, ysrc = (int)horzy+1;
	char *c = str;
	for (i = 0; i < maxlen && *c; i++, c++) 
	{
		if (*c != pstr[i]) 
		{
			if (*c >= '0' && *c <= '9') 
			{
				xsrc = xofs+(*c-'0')*7;
			} 
			else 
			{
				switch(*c) 
				{
					case '.': 
						xsrc = xofs+70; 
						break;
					default:  
						xsrc = xofs+77; 
						break;
				}
			}
			oapiBlt (surf, surf, x, y, xsrc, ysrc, 7, 9);
			pstr[i] = *c;
		}
		x += 7;
	}
}
