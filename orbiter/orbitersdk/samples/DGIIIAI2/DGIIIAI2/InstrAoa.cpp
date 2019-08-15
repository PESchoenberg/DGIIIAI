// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// InstrAoa.cpp
// Angle-of-attack tape instrument for the Delta-Glider
// =============================================================================

#define STRICT 1
#include "InstrAoa.h"
#include "DeltaGlider.h"

// -----------------------------------------------------------------------------


/**
Instr AOA def.
*/
InstrAOA::InstrAOA (VESSEL3 *v): PanelElement (v)
{
	paoa = 0.0;
}


// -----------------------------------------------------------------------------


/**
Add mesh data for instr AOA.
*/
void InstrAOA::AddMeshData2D (MESHHANDLE hMesh, DWORD grpidx)
{
	const DWORD texw = PANEL2D_TEXW, texh = PANEL2D_TEXH;
	const DWORD scaleh = 512;
	const float horzx = 1808.5f, horzw = 41.0f;
	const float horzy = (float)(texh-765);
	const float xcnt = 593.0f, ycnt = 311.0f;
	const DWORD NVTX = 40;
	const DWORD NIDX = 66;
	static NTVERTEX VTX[NVTX] = {
		// AOA tape.
		{xcnt-22.0f, ycnt-59,0,  0,0,0,  horzx/(float)texw,        horzy/(float)texh},
		{xcnt+22.0f, ycnt-59,0,  0,0,0,  (horzx+horzw)/(float)texw,horzy/(float)texh},
		{xcnt-22.0f, ycnt-59,0,  0,0,0,  horzx/(float)texw,        horzy/(float)texh},
		{xcnt+22.0f, ycnt-59,0,  0,0,0,  (horzx+horzw)/(float)texw,horzy/(float)texh},
		{xcnt-22.0f, ycnt+59,0,  0,0,0,  horzx/(float)texw,        (float)(horzy+scaleh)/(float)texh},
		{xcnt+22.0f, ycnt+59,0,  0,0,0,  (horzx+horzw)/(float)texw,(float)(horzy+scaleh)/(float)texh},
		{xcnt-22.0f, ycnt+59,0,  0,0,0,  horzx/(float)texw,        (float)(horzy+scaleh)/(float)texh},
		{xcnt+22.0f, ycnt+59,0,  0,0,0,  (horzx+horzw)/(float)texw,(float)(horzy+scaleh)/(float)texh},
		// Wing load background.
		{xcnt+29.0f,ycnt-60.5f,0, 0,0,0, 1861.0f/texw,(texh-303.5f)/texh},
		{xcnt+34.0f,ycnt-60.5f,0, 0,0,0, 1861.0f/texw,(texh-303.5f)/texh},
		{xcnt+29.0f,ycnt- 9.5f,0, 0,0,0, 1861.0f/texw,(texh-252.5f)/texh},
		{xcnt+34.0f,ycnt- 9.5f,0, 0,0,0, 1861.0f/texw,(texh-252.5f)/texh},
		{xcnt+29.0f,ycnt+ 9.5f,0, 0,0,0, 1863.0f/texw,(texh-252.5f)/texh},
		{xcnt+34.0f,ycnt+ 9.5f,0, 0,0,0, 1863.0f/texw,(texh-252.5f)/texh},
		{xcnt+29.0f,ycnt+60.5f,0, 0,0,0, 1863.0f/texw,(texh-303.5f)/texh},
		{xcnt+34.0f,ycnt+60.5f,0, 0,0,0, 1863.0f/texw,(texh-303.5f)/texh},
		// Wing load masks.
		{xcnt+29.0f,ycnt-60.5f,0, 0,0,0,  1862.0f/texw,(texh-305.0f)/texh},
		{xcnt+34.0f,ycnt-60.5f,0, 0,0,0,  1862.0f/texw,(texh-305.0f)/texh},
		{xcnt+29.0f,ycnt      ,0, 0,0,0,  1862.0f/texw,(texh-305.0f)/texh},
		{xcnt+34.0f,ycnt      ,0, 0,0,0,  1862.0f/texw,(texh-305.0f)/texh},
		{xcnt+29.0f,ycnt      ,0, 0,0,0,  1862.0f/texw,(texh-305.0f)/texh},
		{xcnt+34.0f,ycnt      ,0, 0,0,0,  1862.0f/texw,(texh-305.0f)/texh},
		{xcnt+29.0f,ycnt+60.5f,0, 0,0,0,  1862.0f/texw,(texh-305.0f)/texh},
		{xcnt+34.0f,ycnt+60.5f,0, 0,0,0,  1862.0f/texw,(texh-305.0f)/texh},
		// AOA readout.
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
		{xcnt+34.0f,ycnt+7.0f,0,  0,0,0,  0, 0}
	};
	static WORD IDX[NIDX] = {
		0,1,2, 3,2,1, 2,3,4, 5,4,3, 4,5,6, 7,6,5,
		8,9,10, 11,10,9,
		12,13,14, 15,14,13,
		16,17,18, 19,18,17,
		20,21,22, 23,22,21,
		24,25,26, 27,26,25,
		28,29,30, 31,30,29,
		32,33,34, 35,34,33,
		36,37,38, 39,38,37,
	};

	AddGeometry (hMesh, grpidx, VTX, NVTX, IDX, NIDX);
}


/**
Redraw 2D for instrAOA.
*/
bool InstrAOA::Redraw2D (SURFHANDLE surf)
{
	if (grp) 
	{
		double aoa = vessel->GetAOA();
		double aoa_abs = fabs(aoa);

		int i, j;
		char *c, aoastr[6];
		sprintf (aoastr, DEG*aoa_abs < 10.0 ? "%+0.1f" : "%+0.0f", aoa*DEG);

		// Tape range limits.
		if (aoa_abs > 45.0*RAD) 
		{
			aoa_abs = 45.0*RAD;
			aoa = (aoa >= 0.0 ? 45.0*RAD : -45.0*RAD);
		}

		// Tape response delay.
		static double tapespeed = 20.0*RAD;
		double daoa = aoa-paoa;
		if (fabs(daoa)/oapiGetSimStep() > tapespeed) 
		{
			aoa = paoa + oapiGetSimStep()*(daoa>0 ? tapespeed:-tapespeed);
			aoa_abs = fabs(aoa);
		}
		paoa = aoa;

		double dx, dy, y0, y1;
		float tv0, tv1, vy0, vy1;
		bool rescale0 = false, rescale1 = false;

		static double texw = PANEL2D_TEXW, texh = PANEL2D_TEXH;
		static double scaley = texh-765.0, scaleh = 512.0;
		static double viewh = 50.0;
		static double scalecnt = 0.5*scaleh+scaley+1.0;
		static float ycnt = 311.0f;

		// AOA tape.
		if (aoa_abs <= 5.0*RAD) 
		{
			dy = -aoa*DEG*12.0;
		} 
		else 
		{
			dy = (aoa_abs*DEG-5.0)*5.0+60.0;
			if (aoa >= 0.0) dy = -dy;
		}

		y0 = dy-viewh;
		y1 = dy+viewh;
		if (y0 < -scaleh/2) 
		{
			tv0 = (float)scaley/(float)texh;
			rescale0 = true;
		} 
		else 
		{
			tv0 = (float)(y0+scalecnt)/(float)texh;
		}
		if (y1 > scaleh/2) 
		{
			tv1 = (float)(scaley+scaleh)/(float)texh;
			rescale1 = true;
		} 
		else 
		{
			tv1 = (float)(y1+scalecnt)/(float)texh;
		}
		if (rescale0) 
		{
			float h = (float)(59.0*2 * (tv1-tv0)/(2.0*viewh)*texh);
			vy0 = ycnt+59-h;
		} 
		else 
		{
			vy0 = ycnt-59;
		}
		if (rescale1) 
		{
			float h = (float)(59.0*2 * (tv1-tv0)/(2.0*viewh)*texh);
			vy1 = ycnt-59+h;
		} 
		else 
		{
			vy1 = ycnt+59;
		}
		grp->Vtx[2+vtxofs].y  = grp->Vtx[3+vtxofs].y  = vy0;
		grp->Vtx[4+vtxofs].y  = grp->Vtx[5+vtxofs].y  = vy1;
		grp->Vtx[2+vtxofs].tv = grp->Vtx[3+vtxofs].tv = tv0;
		grp->Vtx[4+vtxofs].tv = grp->Vtx[5+vtxofs].tv = tv1;

		// AOA readout.
		static double numx = 1808.0+63.0, numy = texh-423.5, numw = 10.0, numh = 19.0;
		static double tu_num[4] = {numx/texw,(numx+numw)/texw,numx/texw,(numx+numw)/texw};
		static double tv_num[4] = {numy/texh,numy/texh,(numy+numh)/texh,(numy+numh)/texh};
		int vofs = 24+vtxofs;
		for (c = aoastr, i = 0; i < 4; c++, i++) 
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

		// Wing load LEDs.
		double load = vessel->GetLift() / 190.0;
		static double rowh = 60.0;
		static double loadmax = WINGLOAD_MAX*60.0/51.0;
		double h = min(fabs(load)/loadmax,1.0)*rowh;
		vofs = 16+vtxofs;
		if (load >= 0) 
		{
			grp->Vtx[vofs+2].y = grp->Vtx[vofs+3].y = (float)(ycnt-h);
			grp->Vtx[vofs+4].y = grp->Vtx[vofs+5].y = ycnt;
		} 
		else 
		{
			grp->Vtx[vofs+2].y = grp->Vtx[vofs+3].y = ycnt;
			grp->Vtx[vofs+4].y = grp->Vtx[vofs+5].y = (float)(ycnt+h);
		}
	}
	return false;
}
