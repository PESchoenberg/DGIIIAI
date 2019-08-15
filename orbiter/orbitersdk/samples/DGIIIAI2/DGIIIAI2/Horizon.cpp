// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// Horizon.cpp
// Artificial horizon instrument for the Delta-Glider
// =============================================================================

#define STRICT 1
#include "Horizon.h"
#include "DeltaGlider.h"
#include <math.h>

extern GDIParams g_Param;

using namespace std;

//------------------------------------------------------------------------------


/**
Instr att constructor.
*/
InstrAtt::InstrAtt (VESSEL3 *v): PanelElement (v)
{
}


/**
Destructor.
*/
InstrAtt::~InstrAtt ()
{
}


/**
Instr att add mesh 2D data.
*/
void InstrAtt::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	const DWORD texw = PANEL2D_TEXW, texh = PANEL2D_TEXH;
	//const DWORD texw = INSTR3D_TEXW, texh = INSTR3D_TEXH;
	const float horzw = 154.0f, horzx = (float)(texw-1)-horzw;
	const float horzx2 = (float)(texw-312);
	const float out_y0 = (texh-20.5f)/(float)texh, out_y1 = (texh-3.5f)/(float)texh;
	const float xcnt = 0.5f*PANEL2D_WIDTH+1.0f, ycnt = 150.0f;
	const DWORD NVTX =  76;
	const DWORD NIDX = 120;
	static NTVERTEX VTX[NVTX] = {
		// Horizon display.
		{xcnt-108, ycnt- 54,0,  0,0,0,  horzx/(float)texw,0},
		{xcnt- 54, ycnt-108,0,  0,0,0,  horzx/(float)texw,0},
		{xcnt+ 54, ycnt-108,0,  0,0,0,  (horzx+horzw)/(float)texw,0},
		{xcnt+108, ycnt- 54,0,  0,0,0,  (horzx+horzw)/(float)texw,0},
		{xcnt-108, ycnt+ 54,0,  0,0,0,  horzx/(float)texw,0},
		{xcnt- 54, ycnt+108,0,  0,0,0,  horzx/(float)texw,0},
		{xcnt+ 54, ycnt+108,0,  0,0,0,  (horzx+horzw)/(float)texw,0},
		{xcnt+108, ycnt+ 54,0,  0,0,0,  (horzx+horzw)/(float)texw,0},
		// Bank indicator.
		{xcnt-6, ycnt-48,0, 0,0,0, (horzx2+ 0.5f)/(float)texw, (float)(texh-36)/(float)texh},
		{xcnt+6, ycnt-48,0, 0,0,0, (horzx2+11.5f)/(float)texw, (float)(texh-36)/(float)texh},
		{xcnt-6, ycnt-36,0, 0,0,0, (horzx2+ 0.5f)/(float)texw, (float)(texh-24)/(float)texh},
		{xcnt+6, ycnt-36,0, 0,0,0, (horzx2+11.5f)/(float)texw, (float)(texh-24)/(float)texh},
		// Compass ribbon.
		{xcnt-58, ycnt+58,0,  0,0,0,  0,                   0.5f/(float)texh},
		{xcnt+58, ycnt+58,0,  0,0,0,  1152.0f/(float)texw, 0.5f/(float)texh},
		{xcnt-58, ycnt+76,0,  0,0,0,  0,                  19.5f/(float)texh},
		{xcnt+58, ycnt+76,0,  0,0,0,  1152.0f/(float)texw,19.5f/(float)texh},
		// Altitude readout.
		{ xcnt+28,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt+35,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt+28,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt+35,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt+35,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt+42,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt+35,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt+42,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt+42,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt+49,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt+42,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt+49,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt+49,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt+56,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt+49,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt+56,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt+56,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt+63,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt+56,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt+63,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt+63,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt+70,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt+63,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt+70,ycnt-58,0,  0,0,0,  0, out_y1},
		// Speed readout.
		{ xcnt-70,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt-63,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt-70,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt-63,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt-63,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt-56,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt-63,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt-56,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt-56,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt-49,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt-56,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt-49,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt-49,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt-42,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt-49,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt-42,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt-42,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt-35,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt-42,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt-35,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt-35,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt-28,ycnt-70,0,  0,0,0,  0, out_y0},
		{ xcnt-35,ycnt-58,0,  0,0,0,  0, out_y1},
		{ xcnt-28,ycnt-58,0,  0,0,0,  0, out_y1},
		// Compass readout.
		{ xcnt-10.5f,ycnt+45,0,  0,0,0,  0, out_y0},
		{ xcnt- 3.5f,ycnt+45,0,  0,0,0,  0, out_y0},
		{ xcnt-10.5f,ycnt+58,0,  0,0,0,  0, out_y1},
		{ xcnt- 3.5f,ycnt+58,0,  0,0,0,  0, out_y1},
		{ xcnt- 3.5f,ycnt+45,0,  0,0,0,  0, out_y0},
		{ xcnt+ 3.5f,ycnt+45,0,  0,0,0,  0, out_y0},
		{ xcnt- 3.5f,ycnt+58,0,  0,0,0,  0, out_y1},
		{ xcnt+ 3.5f,ycnt+58,0,  0,0,0,  0, out_y1},
		{ xcnt+ 3.5f,ycnt+45,0,  0,0,0,  0, out_y0},
		{ xcnt+10.5f,ycnt+45,0,  0,0,0,  0, out_y0},
		{ xcnt+ 3.5f,ycnt+58,0,  0,0,0,  0, out_y1},
		{ xcnt+10.5f,ycnt+58,0,  0,0,0,  0, out_y1}
	};
	static WORD IDX[NIDX] = {
		// Horizon display.
		0,5,4,5,0,1,1,6,5,6,1,2,2,7,6,7,2,3,
		// Bank indicator.
		8,9,11,11,10,8,
		// compass ribbon
		12,13,15,15,14,12,
		// Altitude readout.
		16,17,19,19,18,16, 20,21,23,23,22,20, 24,25,27,27,26,24,
		28,29,31,31,30,28, 32,33,35,35,34,32, 36,37,39,39,38,36,
		// Speed readout.
		40,41,43,43,42,40, 44,45,47,47,46,44, 48,49,51,51,50,48,
		52,53,55,55,54,52, 56,57,59,59,58,56, 60,61,63,63,62,60,
		// Compass readout.
		64,65,67,67,66,64, 68,69,71,71,70,68, 72,73,75,75,74,72
	};

	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);

#ifdef UNDEF
	int i;
	ofstream ofs ("dbg.msh");
	ofs << "MSHX1" << endl << "GROUPS 1" << endl;
	ofs << "GEOM " << NVTX << " " << NIDX/3 << endl;
	for (i = 0; i < NVTX; i++)
	{
		ofs << VTX[i].x << ' ' << VTX[i].y << ' ' << VTX[i].z << "  "
			<< VTX[i].nx << ' ' << VTX[i].ny << ' ' << VTX[i].nz << "  "
			<< VTX[i].tu << ' ' << VTX[i].tv << endl;
	}
	for (i = 0; i < NIDX/3; i++)
	{
		ofs << IDX[i*3+0] << ' ' << IDX[i*3+2] << ' ' << IDX[i*3+1] << endl;
	}
#endif
}


/**
Instr att redraw 2D.
*/
bool InstrAtt::Redraw2D (SURFHANDLE surf)
{
	if (grp) 
	{
		int i, j;
		double bank  = vessel->GetBank();
		double pitch = vessel->GetPitch();
		double yaw   = vessel->GetYaw();   if (yaw < 0.0) yaw += PI2;
		double alt   = vessel->GetAltitude();
		double spd   = vessel->GetAirspeed();
		double sinb = sin(bank), cosb = cos(bank);

		static double texw = PANEL2D_TEXW, texh = PANEL2D_TEXH;
		static double scaleh = 900.0, scalew = 154.0;
		static const double horzx2 = (double)(texw-312);

		// transform articfical horizon
		static double pitchscale = 315.0/(texh*PI05);  // texcrd/rad
		static double dy = pitchscale * (PI05/2.0), dy2 = dy*0.5;
		static double scalecnt = (texh-scaleh*0.5)/texh;
		static double xcnt = 0.5*PANEL2D_WIDTH+1.0, ycnt = 150.0;
		static double xp[12] = {-108.0,-54.0,54.0,108.0,-108.0,-54.0,54.0,108.0,-6,6,-6,6};
		static double yp[12] = {-54.0,-108.0,-108.0,-54.0, 54.0,108.0,108.0,54.0,-49,-49,-37,-37};
		static double tv[8] = {scalecnt-dy2,scalecnt-dy,scalecnt-dy,scalecnt-dy2,scalecnt+dy2,scalecnt+dy,scalecnt+dy,scalecnt+dy2};
		for (i = 0; i < 12; i++) 
		{
			grp->Vtx[i+vtxofs].x = (float)(cosb*xp[i] - sinb*yp[i] + xcnt);
			grp->Vtx[i+vtxofs].y = (float)(sinb*xp[i] + cosb*yp[i] + ycnt);
			if (i < 8) grp->Vtx[i+vtxofs].tv = (float)(tv[i]-pitch*pitchscale);
		}

		// Transform compass ribbon.
		static double yawrange = 145.0/(double)texw;
		static double yawscale   = 1008.0/(texw*PI2);
		static double tu_ofs[4] = {0,yawrange,0,yawrange};
		for (i = 0; i < 4; i++)
		{
			grp->Vtx[i+12+vtxofs].tu = (float)(tu_ofs[i] + yaw*yawscale);
		}

		// Speed and altitude readout.
		for (int disp = 0; disp < 3; disp++) 
		{
			char *c, *str, cbuf[6];
			int vofs, maxnum;
			switch (disp) 
			{
				case 0: 
					vofs = 16; 
					maxnum = 6; 
					str = DispStr (alt)+1; 
					break;
				case 1: 
					vofs = 40; 
					maxnum = 6; 
					str = DispStr (spd)+1; 
					break;
				case 2: 
					vofs = 64; 
					maxnum = 3;
					sprintf (cbuf, "%03d", (int)(yaw*DEG+0.5));
					str = cbuf;
					break;
			}
			vofs += vtxofs;
			static double numw = 10.0, num_ofs = 1737.0;
			static double tu_num[4] = {0,numw/texw,0,numw/texw};
			for (c = str, i = 0; *c && (i < maxnum); c++, i++) 
			{				
				if (*c >= '0' && *c <= '9') 
				{
					double x = ((*c-'0') * numw + num_ofs)/texw;
					for (j = 0; j < 4; j++) 
					{
						grp->Vtx[i*4+j+vofs].tu = (float)(tu_num[j]+x);
					}
				} 
				else 
				{
					double ofs;
					switch (*c) 
					{
						case ' ': 
							ofs = horzx2+107.5; 
							break;
						case '.': 
							ofs = horzx2+101.0; 
							break;
						case 'k': 
							ofs = horzx2+116.0; 
							break;
						case 'M': 
							ofs = horzx2+127.0; 
							break;
						case 'G': 
							ofs = horzx2+137.0; 
							break;
						default:  
							ofs = horzx2+0.0; 
							break;
					}
					if (ofs > 0.0) 
					{
						grp->Vtx[i*4+vofs+1].tu = grp->Vtx[i*4+vofs+3].tu = (float)(numw/texw) +
						(grp->Vtx[i*4+vofs].tu = grp->Vtx[i*4+vofs+2].tu = (float)(ofs/texw));
					}
				}
			}
		}
	}
	return false;
}


/**
Mesh data VC for instr att.
*/
NTVERTEX *InstrAtt::MeshDataVC ()
{
	const DWORD texw = INSTR3D_TEXW, texh = INSTR3D_TEXH;
	const float horzw = 154.0f, horzx = (float)(texw-1)-horzw;
	const float horzx2 = (float)(texw-312);
	const float out_y0 = (texh-20.5f)/(float)texh, out_y1 = (texh-3.5f)/(float)texh;
	const float xcnt = 0, ycnt = 0;
	const DWORD NVTX =  80;
	static bool need_transform = true;
	static NTVERTEX VTX[NVTX] = {
		// Horizon display.
		{-108, - 54,-0.0005,  0,0,0,  horzx/(float)texw,0},
		{- 54, -108,-0.0005,  0,0,0,  horzx/(float)texw,0},
		{+ 54, -108,-0.0005,  0,0,0,  (horzx+horzw)/(float)texw,0},
		{+108, - 54,-0.0005,  0,0,0,  (horzx+horzw)/(float)texw,0},
		{-108, + 54,-0.0005,  0,0,0,  horzx/(float)texw,0},
		{- 54, +108,-0.0005,  0,0,0,  horzx/(float)texw,0},
		{+ 54, +108,-0.0005,  0,0,0,  (horzx+horzw)/(float)texw,0},
		{+108, + 54,-0.0005,  0,0,0,  (horzx+horzw)/(float)texw,0},
		// Bank indicator.
		{-6, -48,-0.001, 0,0,0, (horzx2+ 0.5f)/(float)texw, (float)(texh-36)/(float)texh},
		{+6, -48,-0.001, 0,0,0, (horzx2+11.5f)/(float)texw, (float)(texh-36)/(float)texh},
		{-6, -36,-0.001, 0,0,0, (horzx2+ 0.5f)/(float)texw, (float)(texh-24)/(float)texh},
		{+6, -36,-0.001, 0,0,0, (horzx2+11.5f)/(float)texw, (float)(texh-24)/(float)texh},
		// Compass ribbon.
		{-58, -76,-0.001,  0,0,0,  0,                   0.5f/(float)texh},
		{+58, -76,-0.001,  0,0,0,  1152.0f/(float)texw, 0.5f/(float)texh},
		{-58, -58,-0.001,  0,0,0,  0,                  19.5f/(float)texh},
		{+58, -58,-0.001,  0,0,0,  1152.0f/(float)texw,19.5f/(float)texh},
		// Altitude readout.
		{ +28,+58,-0.001,  0,0,0,  0, out_y1},
		{ +35,+58,-0.001,  0,0,0,  0, out_y1},
		{ +28,+70,-0.001,  0,0,0,  0, out_y0},
		{ +35,+70,-0.001,  0,0,0,  0, out_y0},
		{ +35,+58,-0.001,  0,0,0,  0, out_y1},
		{ +42,+58,-0.001,  0,0,0,  0, out_y1},
		{ +35,+70,-0.001,  0,0,0,  0, out_y0},
		{ +42,+70,-0.001,  0,0,0,  0, out_y0},
		{ +42,+58,-0.001,  0,0,0,  0, out_y1},
		{ +49,+58,-0.001,  0,0,0,  0, out_y1},
		{ +42,+70,-0.001,  0,0,0,  0, out_y0},
		{ +49,+70,-0.001,  0,0,0,  0, out_y0},
		{ +49,+58,-0.001,  0,0,0,  0, out_y1},
		{ +56,+58,-0.001,  0,0,0,  0, out_y1},
		{ +49,+70,-0.001,  0,0,0,  0, out_y0},
		{ +56,+70,-0.001,  0,0,0,  0, out_y0},
		{ +56,+58,-0.001,  0,0,0,  0, out_y1},
		{ +63,+58,-0.001,  0,0,0,  0, out_y1},
		{ +56,+70,-0.001,  0,0,0,  0, out_y0},
		{ +63,+70,-0.001,  0,0,0,  0, out_y0},
		{ +63,+58,-0.001,  0,0,0,  0, out_y1},
		{ +70,+58,-0.001,  0,0,0,  0, out_y1},
		{ +63,+70,-0.001,  0,0,0,  0, out_y0},
		{ +70,+70,-0.001,  0,0,0,  0, out_y0},
		// Speed readout.
		{ -70,+58,-0.001,  0,0,0,  0, out_y1},
		{ -63,+58,-0.001,  0,0,0,  0, out_y1},
		{ -70,+70,-0.001,  0,0,0,  0, out_y0},
		{ -63,+70,-0.001,  0,0,0,  0, out_y0},
		{ -63,+58,-0.001,  0,0,0,  0, out_y1},
		{ -56,+58,-0.001,  0,0,0,  0, out_y1},
		{ -63,+70,-0.001,  0,0,0,  0, out_y0},
		{ -56,+70,-0.001,  0,0,0,  0, out_y0},
		{ -56,+58,-0.001,  0,0,0,  0, out_y1},
		{ -49,+58,-0.001,  0,0,0,  0, out_y1},
		{ -56,+70,-0.001,  0,0,0,  0, out_y0},
		{ -49,+70,-0.001,  0,0,0,  0, out_y0},
		{ -49,+58,-0.001,  0,0,0,  0, out_y1},
		{ -42,+58,-0.001,  0,0,0,  0, out_y1},
		{ -49,+70,-0.001,  0,0,0,  0, out_y0},
		{ -42,+70,-0.001,  0,0,0,  0, out_y0},
		{ -42,+58,-0.001,  0,0,0,  0, out_y1},
		{ -35,+58,-0.001,  0,0,0,  0, out_y1},
		{ -42,+70,-0.001,  0,0,0,  0, out_y0},
		{ -35,+70,-0.001,  0,0,0,  0, out_y0},
		{ -35,+58,-0.001,  0,0,0,  0, out_y1},
		{ -28,+58,-0.001,  0,0,0,  0, out_y1},
		{ -35,+70,-0.001,  0,0,0,  0, out_y0},
		{ -28,+70,-0.001,  0,0,0,  0, out_y0},
		// Compass readout.
		{ -10.5f,-58,-0.001,  0,0,0,  0, out_y1},
		{ - 3.5f,-58,-0.001,  0,0,0,  0, out_y1},
		{ -10.5f,-45,-0.001,  0,0,0,  0, out_y0},
		{ - 3.5f,-45,-0.001,  0,0,0,  0, out_y0},
		{ - 3.5f,-58,-0.001,  0,0,0,  0, out_y1},
		{ + 3.5f,-58,-0.001,  0,0,0,  0, out_y1},
		{ - 3.5f,-45,-0.001,  0,0,0,  0, out_y0},
		{ + 3.5f,-45,-0.001,  0,0,0,  0, out_y0},
		{ + 3.5f,-58,-0.001,  0,0,0,  0, out_y1},
		{ +10.5f,-58,-0.001,  0,0,0,  0, out_y1},
		{ + 3.5f,-45,-0.001,  0,0,0,  0, out_y0},
		{ +10.5f,-45,-0.001,  0,0,0,  0, out_y0},
		// Cover plate.
		{ -85,-85,-0.002,  0,0,0, (float)(texw-483)/(float)texw, (float)(texh-1)/(float)texh},
		{ +85,-85,-0.002,  0,0,0, (float)(texw-313)/(float)texw, (float)(texh-1)/(float)texh},
		{ -85,+85,-0.002,  0,0,0, (float)(texw-483)/(float)texw, (float)(texh-171)/(float)texh},
		{ +85,+85,-0.002,  0,0,0, (float)(texw-313)/(float)texw, (float)(texh-171)/(float)texh}
	};

	if (need_transform) 
	{
		TransformVtxVC (VTX, NVTX);
		need_transform = false;
	}

	#ifdef UNDEF
	// TEMPORARY
	static NTVERTEX tmp[20] = {
		{ -86, -86,-0.005, 0,0,-1, 0,0},
		{ +86, -86,-0.005, 0,0,-1, 0,0},
		{ -86, +86,-0.005, 0,0,-1, 0,0},
		{ +86, +86,-0.005, 0,0,-1, 0,0},
		{-120,-120,-0.005, 0,0,-1, 0,0},
		{+120,-120,-0.005, 0,0,-1, 0,0},
		{-120,+120,-0.005, 0,0,-1, 0,0},
		{+120,+120,-0.005, 0,0,-1, 0,0},

		{-86,-86,-0.005,  0,1,0,  0,0},
		{+86,-86,-0.005,  0,1,0,  0,0},
		{-85,-85,0,       0,1,0,  0,0},
		{+85,-85,0,       0,1,0,  0,0},

		{-86,-86,-0.005,  1,0,0,  0,0},
		{-86,+86,-0.005,  1,0,0,  0,0},
		{-85,-85,0,       1,0,0,  0,0},
		{-85,+85,0,       1,0,0,  0,0},

		{+86,-86,-0.005,  -1,0,0, 0,0},
		{+86,+86,-0.005,  -1,0,0, 0,0},
		{+85,-85,0,       -1,0,0, 0,0},
		{+85,+85,0,       -1,0,0, 0,0}
	};
	static bool do_debug = true;
	if (do_debug) 
	{
		TransformVtxVC (tmp, 20);
		TransformNmlVC (tmp, 20);
		ofstream ofs("dbg.msh");
		for (int i = 0; i < 20; i++)
		{
			ofs << tmp[i].x << ' ' << tmp[i].y << ' ' << tmp[i].z << ' '
				<< tmp[i].nx << ' ' << tmp[i].ny << ' ' << tmp[i].nz << ' '
				<< 0 << ' ' << 0 << endl;
		}
		//DGIIIAI2 unclear if this should go into the for loop or not.
		do_debug = false;
	}
	#endif

	return VTX;
}


/**
Transform Vtx VC.
*/
void InstrAtt::TransformVtxVC (NTVERTEX *vtx, DWORD nvtx)
{
	static const float rad = 0.06f; // Display radius [m]
	static const float scale = rad/108.0f;
	static const double alpha = 40.0*RAD; // Display tilt
	static const float cosa = (float)cos(alpha);
	static const float sina = (float)sin(alpha);
	static const float shifty = 0.95f;
	static const float shiftz = 7.244f;
	DWORD i;
	for (i = 0; i < nvtx; i++) 
	{
		vtx[i].x *= scale;
		vtx[i].y *= scale;
	}
	for (i = 0; i < nvtx; i++) 
	{
		float y = vtx[i].y*cosa - vtx[i].z*sina;
		float z = vtx[i].y*sina + vtx[i].z*cosa;
		vtx[i].y = y + shifty;
		vtx[i].z = z + shiftz;
	}
}


/**
Transform Nml VC.
*/
void InstrAtt::TransformNmlVC (NTVERTEX *vtx, DWORD nvtx)
{
	static const double alpha = 40.0*RAD; // Display tilt
	static const float cosa = (float)cos(alpha);
	static const float sina = (float)sin(alpha);
	DWORD i;
	for (i = 0; i < nvtx; i++) 
	{
		float ny = vtx[i].ny*cosa - vtx[i].nz*sina;
		float nz = vtx[i].ny*sina + vtx[i].nz*cosa;
		vtx[i].ny = ny;
		vtx[i].nz = nz;
	}
}


/**
Instr att redraw VC.
*/
bool InstrAtt::RedrawVC (DEVMESHHANDLE hMesh, SURFHANDLE surf)
{
	const int HORZGRP = 140; // should be extracted from mesh label
	const int NVTX = 80;

	if (hMesh) 
	{
		GROUPEDITSPEC ges;
		NTVERTEX *VTX = MeshDataVC();
		ges.flags = GRPEDIT_VTXCRD | GRPEDIT_VTXTEX;
		ges.nVtx = NVTX;
		ges.Vtx  = VTX;
		ges.vIdx = 0;

		int i, j;
		double bank  = vessel->GetBank();
		double pitch = vessel->GetPitch();
		double yaw   = vessel->GetYaw();   if (yaw < 0.0) yaw += PI2;
		double alt   = vessel->GetAltitude();
		double spd   = vessel->GetAirspeed();
		double sinb = sin(bank), cosb = cos(bank);

		static double texw = INSTR3D_TEXW, texh = INSTR3D_TEXH;
		static double scaleh = 900.0, scalew = 154.0;
		static const double horzx2 = (double)(texw-312);

		// Transform artificial horizon.
		static double pitchscale = 315.0/(texh*PI05);  // texcrd/rad
		static double dy = pitchscale * (PI05/2.0), dy2 = dy*0.5;
		static double scalecnt = (texh-scaleh*0.5)/texh;
		static double xp[12] = {-108.0,-54.0,54.0,108.0,-108.0,-54.0,54.0,108.0,+6,-6,+6,-6};
		static double yp[12] = {-54.0,-108.0,-108.0,-54.0, 54.0,108.0,108.0,54.0,+49,+49,+37,+37};
		static double tv[8] = {scalecnt+dy2,scalecnt+dy,scalecnt+dy,scalecnt+dy2,scalecnt-dy2,scalecnt-dy,scalecnt-dy,scalecnt-dy2};
		for (i = 0; i < 12; i++) 
		{
			VTX[i].x = (float)( cosb*xp[i] + sinb*yp[i]);
			VTX[i].y = (float)(-sinb*xp[i] + cosb*yp[i]);
			if (i < 8) 
			{
				VTX[i].z = -0.0005f;
				VTX[i].tv = (float)(tv[i]-pitch*pitchscale);
			} 
			else 
			{
				VTX[i].z = -0.001f;
			}
		}
		TransformVtxVC (VTX, 12);

		// Transform compass ribbon.
		static double yawrange = 145.0/(double)texw;
		static double yawscale   = 1008.0/(texw*PI2);
		static double tu_ofs[4] = {0,yawrange,0,yawrange};
		for (i = 0; i < 4; i++)
		{
			VTX[i+12].tu = (float)(tu_ofs[i] + yaw*yawscale);
		}

		// Speed and altitude readout.
		for (int disp = 0; disp < 3; disp++) 
		{
			char *c, *str, cbuf[6];
			int vofs, maxnum;
			switch (disp) 
			{
				case 0: 
					vofs = 16; 
					maxnum = 6; 
					str = DispStr (alt)+1; 
					break;
				case 1: 
					vofs = 40; 
					maxnum = 6; 
					str = DispStr (spd)+1; 
					break;
				case 2: vofs = 64; maxnum = 3;
					sprintf (cbuf, "%03d", (int)(yaw*DEG+0.5));
					str = cbuf;
					break;
			}
			static double numw = 10.0, num_ofs = 201.0; //1737.0;
			static double tu_num[4] = {0,numw/texw,0,numw/texw};
			for (c = str, i = 0; *c && (i < maxnum); c++, i++) 
			{
				if (*c >= '0' && *c <= '9') 
				{
					double x = ((*c-'0') * numw + num_ofs)/texw;
					for (j = 0; j < 4; j++) 
					{
						VTX[i*4+j+vofs].tu = (float)(tu_num[j]+x);
					}
				} 
				else 
				{
					double ofs;
					switch (*c) 
					{
						case ' ': 
							ofs = horzx2+107.5; 
							break;
						case '.': 
							ofs = horzx2+101.0; 
							break;
						case 'k': 
							ofs = horzx2+116.0; 
							break;
						case 'M': 
							ofs = horzx2+127.0; 
							break;
						case 'G': 
							ofs = horzx2+137.0; 
							break;
						default:  
							ofs = horzx2+0.0; 
							break;
					}
					if (ofs > 0.0) 
					{
						VTX[i*4+vofs+1].tu = VTX[i*4+vofs+3].tu = (float)(numw/texw) +
						(VTX[i*4+vofs].tu = VTX[i*4+vofs+2].tu = (float)(ofs/texw));
					}
				}
			}
		}

		oapiEditMeshGroup (hMesh, HORZGRP, &ges);
	}

	return false;
}
