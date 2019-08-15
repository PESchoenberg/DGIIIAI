// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// InstrHsi.cpp
// HSI (Horizonal situation indicator) for the Delta-Glider
// =============================================================================

#define STRICT 1
#include "InstrHsi.h"
#include "DeltaGlider.h"

// Constants for texture coordinates.
static const DWORD texw = PANEL2D_TEXW, texh = PANEL2D_TEXH;
static const float xcnt = 0.5f*PANEL2D_WIDTH+1.0f, ycnt = 473.0f;

// -----------------------------------------------------------------------------


/**
Panel element def.
*/
InstrHSI::InstrHSI (VESSEL3 *v): PanelElement (v)
{
	crs = 0.0;
	dev = 0.0;
	nav = NULL;
	navType = TRANSMITTER_NONE;
}


/**
Set course def.
*/
void InstrHSI::SetCrs (double newcrs)
{
	if (navType != TRANSMITTER_ILS) 
	{ 
		// Course indicator fixed for ILS approach.
		crs = newcrs;
		while (crs < 0.0) 
		{
			crs += PI2;
		}
		while (crs >= PI2)
		{
			crs -= PI2;
		}
	}
}

double InstrHSI::GetCrs () const
{
	return crs;
}


/**
Add mesh data 2D for instrument HSI.
*/
void InstrHSI::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	const float horzx = (float)(texw-312), horzy = (float)(texh-252);
	const float rosex = horzx+2.0f, rosew = 152.0f;
	const float rosey = horzy+2.0f, roseh = 152.0f;
	const float arrowy = horzy+172.5f, arrowh = 17.0f;
	const float devy = arrowy+17.5f, devh = 10.0f;
	const float scalex = horzx+12.0f, scalew = 82.0f;
	const float scaley = horzy+216.0f, scaleh = 12.0f;
	const float out_y0 = (horzy+231.5f)/(float)texh, out_y1 = (horzy+248.5f)/(float)texh;
	const DWORD NVTX = 44;
	const DWORD NIDX = 66;
	static NTVERTEX VTX[NVTX] = {
		// Compass rose.
		{xcnt-60.5f,ycnt-60.5f,0,  0,0,0,  rosex/(float)texw, rosey/(float)texh},
		{xcnt+60.5f,ycnt-60.5f,0,  0,0,0,  (rosex+rosew)/(float)texw, rosey/(float)texh},
		{xcnt-60.5f,ycnt+60.5f,0,  0,0,0,  rosex/(float)texw, (rosey+roseh)/(float)texh},
		{xcnt+60.5f,ycnt+60.5f,0,  0,0,0,  (rosex+rosew)/(float)texw, (rosey+roseh)/(float)texh},
		// Glideslope background.
		{xcnt+62.0f,ycnt-60,0, 0,0,0,  (horzx+  0.5f)/(float)texw, (horzy+154.5f)/(float)texh},
		{xcnt+76.5f,ycnt-60,0, 0,0,0,  (horzx+  0.5f)/(float)texw, (horzy+154.5f)/(float)texh},
		{xcnt+62.0f,ycnt+60,0, 0,0,0,  (horzx+155.5f)/(float)texw, (horzy+154.5f)/(float)texh},
		{xcnt+76.5f,ycnt+60,0, 0,0,0,  (horzx+155.5f)/(float)texw, (horzy+154.5f)/(float)texh},
		// Glideslope indicator.
		{xcnt+64.0f,ycnt-64,0, 0,0,0,  (horzx+ 94.5f)/(float)texw, (horzy+216.5f)/(float)texh},
		{xcnt+76.5f,ycnt-64,0, 0,0,0,  (horzx+107.5f)/(float)texw, (horzy+216.5f)/(float)texh},
		{xcnt+64.0f,ycnt-64,0, 0,0,0,  (horzx+ 94.5f)/(float)texw, (horzy+227.5f)/(float)texh},
		{xcnt+76.5f,ycnt-64,0, 0,0,0,  (horzx+107.5f)/(float)texw, (horzy+227.5f)/(float)texh},
		// Source bearing indicator.
		{xcnt-6.2f,ycnt-61,0,  0,0,0,  (horzx+ 0.5f)/float(texw), (arrowy+arrowh+18.0f)/(float)texh},
		{xcnt+6.2f,ycnt-61,0,  0,0,0,  (horzx+ 0.5f)/float(texw), (arrowy+arrowh+1.0f)/(float)texh},
		{xcnt-6.2f,ycnt-45,0,  0,0,0,  (horzx+18.0f)/float(texw), (arrowy+arrowh+18.0f)/(float)texh},
		{xcnt+6.2f,ycnt-45,0,  0,0,0,  (horzx+18.0f)/float(texw), (arrowy+arrowh+1.0f)/(float)texh},
		// deviation scale
		{xcnt-32.2f,ycnt- 4.7f,0,  0,0,0,  scalex/(float)texw,scaley/(float)texh},
		{xcnt+32.2f,ycnt- 4.7f,0,  0,0,0,  (scalex+scalew)/(float)texw,scaley/(float)texh},
		{xcnt-32.2f,ycnt+ 4.7f,0,  0,0,0,  scalex/(float)texw,(scaley+scaleh)/(float)texh},
		{xcnt+32.2f,ycnt+ 4.7f,0,  0,0,0,  (scalex+scalew)/(float)texw,(scaley+scaleh)/(float)texh},
		// Course indicator.
		{xcnt- 6.2f,ycnt-60.5f,0,  0,0,0,  rosex/float(texw), (arrowy+arrowh)/(float)texh},
		{xcnt+ 6.2f,ycnt-60.5f,0,  0,0,0,  rosex/float(texw), arrowy/(float)texh},
		{xcnt- 6.2f,ycnt+60.5f,0,  0,0,0,  (rosex+rosew)/float(texw), (arrowy+arrowh)/(float)texh},
		{xcnt+ 6.2f,ycnt+60.5f,0,  0,0,0,  (rosex+rosew)/float(texw), arrowy/(float)texh},
		// Deviation indicator.
		{xcnt-3.65f,ycnt-25.82f,0, 0,0,0, (horzx+91.0f)/(float)texw,devy/(float)texh},
		{xcnt+3.65f,ycnt-25.82f,0, 0,0,0, (horzx+91.0f)/(float)texw,(devy+devh)/(float)texh},
		{xcnt-3.65f,ycnt+25.82f,0, 0,0,0, (horzx+91.0f+64.0f)/(float)texw,devy/(float)texh},
		{xcnt+3.65f,ycnt+25.82f,0, 0,0,0, (horzx+91.0f+64.0f)/(float)texw,(devy+devh)/(float)texh},
		// Course readout background.
		{xcnt-57,ycnt-72,0,  0,0,0,  0,0},
		{xcnt-36,ycnt-72,0,  0,0,0,  0,0},
		{xcnt-57,ycnt-60,0,  0,0,0,  0,0},
		{xcnt-36,ycnt-60,0,  0,0,0,  0,0},
		// Course readout.
		{xcnt-57,ycnt-72,0,  0,0,0,  0,out_y0},
		{xcnt-50,ycnt-72,0,  0,0,0,  0,out_y0},
		{xcnt-57,ycnt-60,0,  0,0,0,  0,out_y1},
		{xcnt-50,ycnt-60,0,  0,0,0,  0,out_y1},
		{xcnt-50,ycnt-72,0,  0,0,0,  0,out_y0},
		{xcnt-43,ycnt-72,0,  0,0,0,  0,out_y0},
		{xcnt-50,ycnt-60,0,  0,0,0,  0,out_y1},
		{xcnt-43,ycnt-60,0,  0,0,0,  0,out_y1},
		{xcnt-43,ycnt-72,0,  0,0,0,  0,out_y0},
		{xcnt-36,ycnt-72,0,  0,0,0,  0,out_y0},
		{xcnt-43,ycnt-60,0,  0,0,0,  0,out_y1},
		{xcnt-36,ycnt-60,0,  0,0,0,  0,out_y1}
	};
	static WORD IDX[NIDX] = {
		// Compass rose.
		0,1,2, 3,2,1,
		4,5,6, 7,6,5,
		8,9,10, 11,10,9,
		12,13,14, 15,14,13,
		16,17,18, 19,18,17,
		20,21,22, 23,22,21,
		24,25,26, 27,26,25,
		28,29,30, 31,30,29,
		32,33,34, 35,34,33,
		36,37,38, 39,38,37,
		40,41,42, 43,42,41
	};

	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Redraw 2D instrument HSI.
*/
bool InstrHSI::Redraw2D (SURFHANDLE surf)
{
	const float horzx = (float)(texw-312), horzy = (float)(texh-252);
	DWORD tp;
	int i, j, vofs;
	double c, sinc, cosc, brg, slope;
	double yaw = vessel->GetYaw();   if (yaw < 0.0) yaw += PI2;
	double siny = sin(yaw), cosy = cos(yaw);

	dev = 0.0;
	NAVHANDLE nv = vessel->GetNavSource (0);
	if (nv) 
	{
		tp = oapiGetNavType(nv);
		if (tp != TRANSMITTER_VOR && tp != TRANSMITTER_ILS)
		{
			nv = NULL;
		}
	}
	if (nv != nav) 
	{
		if (nav = nv) 
		{
			navRef = vessel->GetSurfaceRef();
			navType = tp;
			if (navRef) 
			{
				VECTOR3 npos;
				NAVDATA data;
				double rad;
				oapiGetNavPos (nav, &npos);
				oapiGlobalToEqu (navRef, npos, &navlng, &navlat, &rad);
				oapiGetNavData (nav, &data);
				if (navType == TRANSMITTER_ILS) crs = data.ils.appdir;
			} 
			else 
			{
				nav = NULL;
			}
		} 
		else 
		{
			navType = TRANSMITTER_NONE;
		}
		// Transform glideslope background.
		static float gs_tv[4] = {(horzy+171.5f)/(float)texh,(horzy+154.5f)/(float)texh,(horzy+171.5f)/(float)texh,(horzy+154.5f)/(float)texh};
		vofs = vtxofs+4;
		for (i = 0; i < 4; i++)
		{
			grp->Vtx[vofs+i].tv = (navType == TRANSMITTER_ILS ? gs_tv[i] : (horzy+154.5f)/(float)texh);
		}		
		// Transform glideslope indicator.
		if (navType != TRANSMITTER_ILS) 
		{
			vofs = vtxofs+8;
			for (i = 0; i < 4; i++) 
			{
				grp->Vtx[vofs+i].y = ycnt-64;
			}
		}
	}
	if (nav) 
	{
		double vlng, vlat, vrad, adist;
		OBJHANDLE hRef = vessel->GetEquPos (vlng, vlat, vrad);
		if (hRef && hRef == navRef) 
		{
			Orthodome (vlng, vlat, navlng, navlat, adist, brg);
			adist *= oapiGetSize (hRef);
			dev = brg-crs;
			if (dev < -PI) 
			{
				dev += PI2;
			}
			else if (dev >= PI) 
			{
				dev -= PI2;
			}
			if (dev < -PI05) 
			{
				dev = -PI-dev;
			}
			else if (dev >= PI05) 
			{
				dev =  PI-dev;
			}

			// Calculate slope.
			if (navType == TRANSMITTER_ILS) 
			{
				double s = adist * cos(crs-brg);
				double alt = vessel->GetAltitude();
				slope = atan2 (alt, s) * DEG;

				// Transform glideslope indicator.
				const double tgtslope = 4.0;
				double dslope = slope - tgtslope;
				float yshift = (float)min(fabs(dslope)*20.0,45.0);
				if (dslope < 0.0) 
				{
					yshift = -yshift;
				}
				static float gs_y[4] = {ycnt-4.0f, ycnt-4.0f, ycnt+4.0f, ycnt+4.0f};
				vofs = vtxofs+8;
				for (i = 0; i < 4; i++)
				{
					grp->Vtx[vofs+i].y = gs_y[i]+yshift;
				}
			}
		}
	}

	static double xp[4] = {-60.5,60.5,-60.5,60.5};
	static double yp[4] = {-60.5,-60.5,60.5,60.5};

	// Transform compass rose.
	vofs = vtxofs;
	for (i = 0; i < 4; i++) 
	{
		grp->Vtx[i+vofs].x = (float)(cosy*xp[i] + siny*yp[i] + xcnt);
		grp->Vtx[i+vofs].y = (float)(-siny*xp[i] + cosy*yp[i] + ycnt);
	}
	// Transform source bearing indicator.
	vofs = vtxofs+12;
	if (nav) 
	{
		c = yaw-brg;
		sinc = sin(c), cosc = cos(c);
		static double xs[4] = {-6.2,6.2,-6.2,6.2};
		static double ys[4] = {-61,-61,-45,-45};
		for (i = 0; i < 4; i++) 
		{
			grp->Vtx[i+vofs].x = (float)(cosc*xs[i] + sinc*ys[i] + xcnt);
			grp->Vtx[i+vofs].y = (float)(-sinc*xs[i] + cosc*ys[i] + ycnt);
		}
	} 
	else 
	{ 
		// Hide indicator.
		for (i = 0; i < 4; i++) 
		{
			grp->Vtx[i+vofs].x = (float)(xcnt-65.0);
			grp->Vtx[i+vofs].y = (float)ycnt;
		}
	}
	// Transform course indicator + scale.
	c = yaw-crs;
	sinc = sin(c), cosc = cos(c);
	static double xc[8] = {-32.2,32.2,-32.2,32.2, -6.2, 6.2, -6.2, 6.2};
	static double yc[8] = { -4.7, -4.7, 4.7, 4.7,-60.5,-60.5,60.5,60.5};
	vofs = vtxofs+16;
	for (i = 0; i < 8; i++) 
	{
		grp->Vtx[i+vofs].x = (float)(cosc*xc[i] + sinc*yc[i] + xcnt);
		grp->Vtx[i+vofs].y = (float)(-sinc*xc[i] + cosc*yc[i] + ycnt);
	}
	// Transform deviation indicator.
	static double xd[4] = {-3.65,3.65,-3.65,3.65};
	static double yd[4] = {-26.82,-26.82,26.82,26.82};
	double dx = min(8.0,fabs(dev)*DEG)*5.175;
	if (dev < 0.0) 
	{
		dx = -dx;
	}
	vofs = vtxofs+24;
	for (i = 0; i < 4; i++) 
	{
		grp->Vtx[i+vofs].x = (float)(cosc*(xd[i]+dx) + sinc*yd[i] + xcnt);
		grp->Vtx[i+vofs].y = (float)(-sinc*(xd[i]+dx) + cosc*yd[i] + ycnt);
	}

	// Course readout.
	int icrs = (int)(crs*DEG+0.5) % 360;
	char *cc, cbuf[16];
	sprintf (cbuf, "%03d", icrs);
	vofs = vtxofs+32;
	static double numw = 10.0, num_ofs = horzx+1.0;
	static double tu_num[4] = {0,numw/texw,0,numw/texw};
	for (cc = cbuf, i = 0; i < 3; cc++, i++) 
	{
		double x = ((*cc-'0') * numw + num_ofs)/texw;
		for (j = 0; j < 4; j++)
		{
			grp->Vtx[i*4+j+vofs].tu = (float)(tu_num[j]+x);
		}
	}

	return false;
}


/**
Orthodome for instrument HSI.
*/
void InstrHSI::Orthodome (double lng1, double lat1, double lng2, double lat2, double &dist, double &dir)
{
	double A     = lng2-lng1;
	double sinA  = sin(A),    cosA  = cos(A);
	double slat1 = sin(lat1), clat1 = cos(lat1);
	double slat2 = sin(lat2), clat2 = cos(lat2);
	double cosa  = slat2*slat1 + clat2*clat1*cosA;
	dist = acos (cosa);
	dir  = asin (clat2*sinA/sin(dist));
	if (lat2 < lat1) 
	{
		dir = PI-dir; // Point 2 further south than point 1.
	}
	if (dir < 0.0) 
	{
		dir += PI2;     // Quadrant 4.
	}
}
