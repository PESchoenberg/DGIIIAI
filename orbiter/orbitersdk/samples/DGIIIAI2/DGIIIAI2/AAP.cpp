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

#include "AAP.h"
#include "DeltaGlider.h"
#include "InstrHsi.h"

static const float texw = (float)PANEL2D_TEXW; // texture width
static const float texh = (float)PANEL2D_TEXH; // texture height
static const int xofs = 742;
static const int yofs = 400;
static const WORD idx_bb[6] = {0,1,2,3,2,1};


/**
Delta glider panel element.
*/
AAP::AAP (DeltaGlider *vessel): DGPanelElement (vessel)
{
	int i;
	hAAP = oapiCreateInterpreter();
	hsi = NULL;
	oapiAsyncScriptCmd (hAAP, "run('DGIIIAI2/aap')"); // Load the autopilot code.
	active_block = -1;
	for (i = 0; i < 3; i++) 
	{
		tgt[i] = 0;
		active[i] = pactive[i] = false;
	}
	scanmode = scanpmode = 0;
}


/**
Register panel.
*/
void AAP::RegisterPanel (PANELHANDLE hPanel)
{
	int i;
	dg->RegisterPanelArea (hPanel, AID_AAP, _R(xofs,yofs,xofs+98,yofs+151), PANEL_REDRAW_MOUSE, PANEL_MOUSE_LBDOWN | PANEL_MOUSE_LBPRESSED | PANEL_MOUSE_LBUP, 0, this);
	for (i = 0; i < 3; i++) 
	{
		strcpy (readout[i], "      ");
	}
}


/**
Add mesh 2G data.
*/
void AAP::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	int i, j, block, ybofs, vofs;
	static const DWORD NVTX = 24*4;
	static const DWORD NIDX = 24*6;
	NTVERTEX VTX[NVTX];
	WORD IDX[NIDX];
	memset (VTX, 0, NVTX*sizeof(NTVERTEX));

	for (block = vofs = 0; block < 3; block++) 
	{
		ybofs = yofs + block*46;

		// Readout digits
		for (i = 0; i < 6; i++) 
		{
			for (j = 0; j < 4; j++) 
			{
				VTX[vofs+i*4+j].x = xofs + 50 + (i+j%2)*7.0f;
				VTX[vofs+i*4+j].y = ybofs + 21 + (j/2)*13.0f;
				VTX[vofs+i*4+j].tu = 1222/texw;
				VTX[vofs+i*4+j].tv = (texh - 708 + (j/2)*15)/texh;
			}
		}
		vofs += 6*4;
		// Activation button
		for (j = 0; j < 4; j++) {
			VTX[vofs+j].x = xofs + 29 + (j%2)*12.0f;
			VTX[vofs+j].y = ybofs + 22 + (j/2)*12.0f;
			VTX[vofs+j].tu = (1034 + (j%2)*12.0f)/texw;
			VTX[vofs+j].tv = (texh - 683 + (j/2)*12.0f)/texh;
		}
		vofs += 4;
		// Scan switch
		for (j = 0; j < 4; j++) 
		{
			VTX[vofs+j].x = xofs + 50 + (j%2)*42.0f;
			VTX[vofs+j].y = ybofs + 41 + (j/2)*11.0f;
			VTX[vofs+j].tu = (1068 - (j/2)*14.0f)/texw;
			VTX[vofs+j].tv = (texh-616+(j%2)*42.0f)/texh;
		}
		vofs += 4;
	}
	for (i = 0; i < 24; i++)
	{
		for (j = 0; j < 6; j++)
		{
			IDX[i*6+j] = i*4+idx_bb[j];
		}
	}
	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Redraw 2D.
*/
bool AAP::Redraw2D (SURFHANDLE surf)
{
	char *c, cbuf[16];
	int i, j, vofs;
	float xofs, yofs;

	// Readouts
	c = DispStr(tgt[0])+1; // altitude
	UpdateStr (c, readout[0], 6, grp->Vtx+vtxofs);
	c = DispStr(tgt[1])+1; // airspeed
	UpdateStr (c, readout[1], 6, grp->Vtx+vtxofs+8*4);
	sprintf (cbuf, "%03d", (int)(tgt[2]*DEG+0.5) % 360);
	UpdateStr (cbuf, readout[2], 3, grp->Vtx+vtxofs+18*4);

	// Activation buttons
	for (i = 0; i < 3; i++) 
	{
		if (active[i] != pactive[i]) 
		{
			pactive[i] = active[i];
			yofs = texh - 683 + (active[i] ? 14:0);
			vofs = vtxofs + 4*(8*i + 6);
			for (j = 0; j < 4; j++)
			{
				grp->Vtx[vofs+j].tv = (yofs + (j/2)*12.0f)/texh;
			}
		}
	}

	if (active_block >= 0) 
	{
		// Scan switch
		if (scanmode != scanpmode) 
		{
			scanpmode = scanmode;
			xofs = 1068.0f + (scanmode == 0 ? 0 : scanmode == -1 ? 16:32);
			vofs = vtxofs + 8*4*active_block + 4*7;
			for (j = 0; j < 4; j++)
			{
				grp->Vtx[vofs+j].tu = (xofs - (j/2)*14.0f)/texw;
			}
		}
	}
	return false;
}


/**
Process mouse 2D.
*/
bool AAP::ProcessMouse2D (int event, int mx, int my)
{
	static double t0 = 0.0, tp = 0.0;

	if (event & PANEL_MOUSE_LBDOWN) 
	{
		if (my >= 21 && my < 145) 
		{
			active_block = (my-21)/46;
			int dmy = my-21-active_block*46;
			if (mx >= 28 && mx < 42 && dmy >= 0 && dmy < 14) 
			{
				// Activation button
				ToggleActive (active_block);
				return true;
			} 
			else if (mx >= 49 && mx < 93 && dmy >= 19 && dmy < 32) 
			{
				// Scan switch
				scanmode = (mx-49 < 22 ? -1 : 1);
				t0 = tp = oapiGetSysTime();
				return true;
			}
		} 
		else 
		{
			active_block = -1;
		}
	} 
	else if (event == PANEL_MOUSE_LBUP) 
	{
		scanmode = 0;
		return (scanmode != scanpmode);
	}

	if (scanmode && event == PANEL_MOUSE_LBPRESSED) 
	{
		double t = oapiGetSysTime();
		double dt = max (t-t0, 0.0);
		double step, mag;
		switch (active_block) 
		{
			case 0:
			case 1:
				mag = (dt < 1 ? 2 : dt < 2 ? 1 : 0);
				if (t-tp > 0.5-mag*0.2) 
				{
					tp = t;
					step = max(1,min(1e4,pow(10,floor(log10 (max(tgt[active_block],1)))-mag)));
					tgt[active_block] = max(0,floor(tgt[active_block]/step)*step + scanmode*step);
					if (active[active_block]) SetValue (active_block, tgt[active_block]);
					return true;
				}
				break;
			case 2: 
				// Heading/Course
				mag = min (sqrt(dt)*0.2, 0.8);
				step = oapiGetSysStep() * mag * scanmode;
				tgt[2] += step;
				while (tgt[2] < 0.0)
				{ 
					tgt[2] += PI2;
				}
				while (tgt[2] >= PI2)
				{ 
					tgt[2] -= PI2;
				}
				if (active[2])
				{ 
					SetValue (2, tgt[2]);
				}
				if (hsi)
				{ 
					hsi->SetCrs (tgt[2]);
				}
				return true;
		}
	}
	return false;
}


/**
Set value.
*/
void AAP::SetValue (int block, double val)
{
	char cbuf[256];
	switch (block) 
	{
		case 0: 
			// Altitude
			sprintf (cbuf, "aap.alt(%e)", val);
			oapiAsyncScriptCmd (hAAP, cbuf);
			break;
		case 1: 
			// Airspeed
			sprintf (cbuf, "aap.spd(%e)", val);
			oapiAsyncScriptCmd (hAAP, cbuf);
			break;
		case 2: 
			// Heading/course
			sprintf (cbuf, "aap.hdg(%e)", val*DEG);
			oapiAsyncScriptCmd (hAAP, cbuf);
			break;
	}
}


/**
Toggle active.
*/
void AAP::ToggleActive (int block)
{
	SetActive (block, !active[block]);
}


/**
Set active.
*/
void AAP::SetActive (int block, bool activate)
{
	if (activate == active[block])
	{ 
		return; // nothing to do
	}

	char cbuf[256];

	active[block] = activate;
	switch (block) 
	{
		case 0: 
			// Altitude
			if (activate)
			{ 
				sprintf (cbuf, "aap.alt(%e)", tgt[block]);
			}
			else
			{ 
				strcpy (cbuf, "aap.alt()");
			}
			oapiAsyncScriptCmd (hAAP, cbuf);
			break;
		case 1: 
			// Airspeed
			if (activate)
			{ 
				sprintf (cbuf, "aap.spd(%e)", tgt[block]);
			}
			else
			{ 
				strcpy (cbuf, "aap.spd()");
			}
			oapiAsyncScriptCmd (hAAP, cbuf);
			break;
		case 2: 
			// Heading
			if (activate)
			{
				sprintf (cbuf, "aap.hdg(%e)", tgt[block]*DEG);
			}
			else
			{ 
				strcpy (cbuf, "aap.hdg()");
			}
			oapiAsyncScriptCmd (hAAP, cbuf);
			break;
	}
}


/**
Write AAP info to scenario file.
*/
void AAP::WriteScenario (FILEHANDLE scn)
{
	int i;
	char cbuf[256], line[256] = "";
	for (i = 0; i < 3; i++) 
	{
		sprintf (cbuf, "%s%d:%g", i ? " ":"", active[i], tgt[i]);
		strcat (line, cbuf);
	}
	oapiWriteScenario_string (scn, "AAP", line);
}


/**
Set state.
*/
void AAP::SetState (const char *str)
{
	int i, nitem, state[3];
	double val[3];
	nitem = sscanf (str, "AAP %d:%lf %d:%lf %d:%lf",
		state+0, val+0, state+1, val+1, state+2, val+2);
	if (nitem == 6) 
	{
		for (i = 0; i < 3; i++) 
		{
			tgt[i] = val[i];
			SetActive (i, state[i] != 0);
		}
	}
}


/**
Update str.
*/
void AAP::UpdateStr (char *str, char *pstr, int n, NTVERTEX *vtx)
{
	static char cbuf[16], *s, *p;
	float x;
	static const float dx = 9.0f;
	int i, j, len;
	len = strlen(str);
	if (len < n) 
	{ 
		// Flush right.
		memset (cbuf, ' ', n-len);
		memcpy (cbuf+(n-len), str, len);
		str = cbuf;
	}
	for (i = 0, s = str, p = pstr; i < n; i++, s++, p++) 
	{
		if (*s != *p) 
		{
			*p = *s;
			if (*s >= '0' && *s <= '9') 
			{
				x = 1126 + (*s-'0')*dx;
			} 
			else switch (*s) 
			{
				case '.': 
					x = 1215.5f; 
					break;
				case 'k': 
					x = 1229.5f; 
					break;
				case 'M': 
					x = 1238.5f; 
					break;
				case 'G': 
					x = 1248.5f; 
					break;
				default:  
					x = 1221.5f; 
					break;
			}
			for (j = 0; j < 4; j++)
			{
				vtx[i*4+j].tu = (x + (j%2)*dx)/texw;
			}
		}
	}
}
