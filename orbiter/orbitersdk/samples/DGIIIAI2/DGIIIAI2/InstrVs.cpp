// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// InstrVs.cpp
// Vertical speed tape instrument for the Delta-Glider
// =============================================================================

#define STRICT 1
#include "InstrVs.h"
#include "DeltaGlider.h"


/**
Instrument VS def.
*/
InstrVS::InstrVS (VESSEL3 *v): PanelElement (v)
{
	pvmin = 100000; // invalidate
}


/**
Add mesh data 2D for Instrument VS.
*/
void InstrVS::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	const DWORD texw = PANEL2D_TEXW, texh = PANEL2D_TEXH;
	const float tapex0 = 1850.5f, tapew = 41.0f;
	const float tapey0 = (float)(texh-764), tapeh = 512.0f;
	const float xcnt = 682.0f, ycnt = 311.0f;

	const DWORD NVTX = 24;
	const DWORD NIDX = 36;
	static NTVERTEX VTX[NVTX] = {
		// VS tape.
		{xcnt-22,ycnt-59,0,  0,0,0,  tapex0/(float)texw,        tapey0/(float)texh},
		{xcnt+22,ycnt-59,0,  0,0,0,  (tapex0+tapew)/(float)texw,tapey0/(float)texh},
		{xcnt-22,ycnt+59,0,  0,0,0,  tapex0/(float)texw,        (tapey0+tapeh)/(float)texh},
		{xcnt+22,ycnt+59,0,  0,0,0,  (tapex0+tapew)/(float)texw,(tapey0+tapeh)/(float)texh},
		// VS readout.
		{xcnt+ 6.0f,ycnt-7.0f,0,  0,0,0,  0, 0},
		{xcnt+13.0f,ycnt-7.0f,0,  0,0,0,  0, 0},
		{xcnt+ 6.0f,ycnt+7.0f,0,  0,0,0,  0, 0},
		{xcnt+13.0f,ycnt+7.0f,0,  0,0,0,  0, 0},
		{xcnt+13.0f,ycnt-7.0f,0,  0,0,0,  0, 0},
		{xcnt+20.0f,ycnt-7.0f,0,  0,0,0,  0, 0},
		{xcnt+13.0f,ycnt+7.0f,0,  0,0,0,  0, 0},
		{xcnt+20.0f,ycnt+7.0f,0,  0,0,0,  0, 0},
		{xcnt+20.0f,ycnt-7.0f,0,  0,0,0,  0, 0},
		{xcnt+27.0f,ycnt-7.0f,0,  0,0,0,  0, 0},
		{xcnt+20.0f,ycnt+7.0f,0,  0,0,0,  0, 0},
		{xcnt+27.0f,ycnt+7.0f,0,  0,0,0,  0, 0},
		{xcnt+27.0f,ycnt-7.0f,0,  0,0,0,  0, 0},
		{xcnt+34.0f,ycnt-7.0f,0,  0,0,0,  0, 0},
		{xcnt+27.0f,ycnt+7.0f,0,  0,0,0,  0, 0},
		{xcnt+34.0f,ycnt+7.0f,0,  0,0,0,  0, 0},
		{xcnt+34.0f,ycnt-7.0f,0,  0,0,0,  0, 0},
		{xcnt+41.0f,ycnt-7.0f,0,  0,0,0,  0, 0},
		{xcnt+34.0f,ycnt+7.0f,0,  0,0,0,  0, 0},
		{xcnt+41.0f,ycnt+7.0f,0,  0,0,0,  0, 0}
	};
	static WORD IDX[NIDX] = {
		0,1,2, 3,2,1,
		4,5,6, 7,6,5,
		8,9,10, 11,10,9,
		12,13,14, 15,14,13,
		16,17,18, 19,18,17,
		20,21,22, 23,22,21,
	};

	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Redraw 2D Instrument VS.
*/
bool InstrVS::Redraw2D (SURFHANDLE surf)
{
	VECTOR3 V;
	double vspd;
	if (vessel->GetHorizonAirspeedVector (V))
	{		
		vspd = V.y*0.1; // unit is 10m
	}
	else
	{
		vspd = 0.0;
	}

	static double texw = PANEL2D_TEXW, texh = PANEL2D_TEXH;
	static double scalecnt = texh-764.0+152.0;
	static int scaleunit = 15;
	static double viewh = 50.0;
	double ycnt, y0, y1, dx, dy;
	char *c, cbuf[12];
	bool centered = (fabs(vspd) <= 4.0);

	dy = vspd-floor(vspd);
	if (centered) 
	{
		ycnt = scalecnt - vspd*scaleunit;
	} 
	else 
	{
		if (vspd > 0.0) 
		{
			ycnt = scalecnt - (5.0+dy)*scaleunit;
		}
		else
		{            
			ycnt = scalecnt + (5.0-dy)*scaleunit;
		}
	}
	y0 = ycnt-viewh;
	y1 = ycnt+viewh;
	grp->Vtx[0+vtxofs].tv = grp->Vtx[1+vtxofs].tv = (float)(y0/texh);
	grp->Vtx[2+vtxofs].tv = grp->Vtx[3+vtxofs].tv = (float)(y1/texh);

	// copy labels onto scale
	const int labelx = 1863;
	int i, j, n, vmin, vmax, iy, len, xsrc, ysrc;
	vmin = (int)floor(vspd)-3;
	if (vmin != pvmin) 
	{
		pvmin = vmin;
		vmax = vmin+7;
		for (i = vmin; i <= vmax; i++) 
		{
			sprintf (cbuf, "%d", abs((i%1000)*10));
			len = strlen(cbuf);
			if (centered) 
			{
				if (!i) 
				{
					continue;
				}
				iy = (int)scalecnt-i*scaleunit-5;
			} 
			else 
			{
				if (i > 0) 
				{
					iy = (int)scalecnt-(2+i-vmin)*scaleunit-5;
				}
				else
				{       
					iy = (int)scalecnt+(8-i+vmin)*scaleunit-5;
				}
			}
			for (j = 0, c = cbuf; j < 4; c++, j++) 
			{
				if (j < len) 
				{
					n = *c-'0';
					xsrc = 1864;
					ysrc = (int)texh-428+n*8;
				} 
				else 
				{
					xsrc = 1864;
					ysrc = (int)texh-348;
				}
				if (i < 0) 
				{
					ysrc += 88;
				}
				oapiBlt (surf, surf, labelx+j*6, iy, xsrc, ysrc, 6, 8);
			}
		}
	}

	// VS readout.
	if (fabs(vspd) < 1e3)
	{
		sprintf (cbuf, fabs(vspd) < 10.0 ? "%+0.1f" : "%+0.0f", vspd*10.0);
	}
	else
	{
		sprintf (cbuf, "%+3.0fk", vspd > 0.0 ? floor(vspd*0.01) : ceil(vspd*0.01));
	}

	static double numx = 1871.0, numy = texh-423.5, numw = 10.0, numh = 19.0;
	static double tu_num[4] = {numx/texw,(numx+numw)/texw,numx/texw,(numx+numw)/texw};
	static double tv_num[4] = {numy/texh,numy/texh,(numy+numh)/texh,(numy+numh)/texh};
	int vofs = 4+vtxofs;
	for (c = cbuf, i = 0; i < 5; c++, i++) 
	{
		if (*c >= '0' && *c <= '9') 
		{
			dx = 0.0;
			dy = ((*c-'0') * 17.0)/texh;
		} 
		else 
		{
			dx = 10.0f/texw;
			switch (*c) 
			{
				case '.': 
					dy =  0.0;      
					break;
				case '-': 
					dy = 34.0/texh; 
					break;
				case '+': 
					dy = 51.0/texh; 
					break;
				case 'k': 
					dy = 68.0/texh; 
					break;
				default:  
					dy = 17.0/texh; 
					break;
			}
		}
		for (j = 0; j < 4; j++) 
		{
			grp->Vtx[i*4+j+vofs].tu = (float)(tu_num[j]+dx);
			grp->Vtx[i*4+j+vofs].tv = (float)(tv_num[j]+dy);
		}
	}

	//DGIIIAI2 Redundant return?
	return false;
	return false;
}
