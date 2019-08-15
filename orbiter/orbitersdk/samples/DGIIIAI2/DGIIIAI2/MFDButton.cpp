// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2009 Martin Schweiger
//                   All rights reserved
//
// MFDButton.cpp
// User interface for MFD buttons
// =============================================================================

#define STRICT 1
#include "MFDButton.h"

// Constants for texture coordinates.
static const int texw = PANEL2D_TEXW; // texture width
static const int texh = PANEL2D_TEXH; // texture height
static const int tx_x = 996;
static const int tx_y = texh-624;
static const int tx_w = 28;
static const int tx_h = 226;

// Constants for panel coordinates.
static const int btn_y0 = texh-473;
static const int btn_dy = 41;
static const int btn_x0[2][2] = {{172,519},{735,1082}};

extern GDIParams g_Param;

const int CHX[256] = { // MFD label font: character x-offsets.
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,642/*+*/,0,661/*-*/,0,596/* / */,
	492/*0*/,501/*1*/,510/*2*/,520/*3*/,529/*4*/,538/*5*/,547/*6*/,556/*7*/,565/*8*/,575/*9*/,627/*:*/,621/*;*/,602/*<*/,652/*=*/,612/*>*/,0,
	0,1/*A*/,11/*B*/,21/*C*/,32/*D*/,43/*E*/,54/*F*/,63/*G*/,75/*H*/,86/*I*/,92/*J*/,101/*K*/,111/*L*/,120/*M*/,132/*N*/,143/*O*/,
	155/*P*/,165/*Q*/,176/*R*/,187/*S*/,198/*T*/,207/*U*/,218/*V*/,229/*W*/,242/*X*/,253/*Y*/,263/*Z*/,0,0,0,0,0,
	0,273/*a*/,282/*b*/,291/*c*/,299/*d*/,309/*e*/,318/*f*/,324/*g*/,333/*h*/,342/*i*/,347/*j*/,353/*k*/,362/*l*/,367/*m*/,380/*n*/,389/*o*/,
	398/*p*/,407/*q*/,416/*r*/,423/*s*/,431/*t*/,438/*u*/,447/*v*/,456/*w*/,466/*x*/,475/*y*/,483/*z*/,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
};

const int CHW[256] = { // MFD label font: character widths.
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,6/*+*/,0,4/*-*/,0,4/* / */,
	6/*0*/,6/*1*/,6/*2*/,6/*3*/,6/*4*/,6/*5*/,6/*6*/,6/*7*/,6/*8*/,6/*9*/,2/*:*/,2/*;*/,6/*<*/,6/*=*/,6/*>*/,0,
	0,8/*A*/,7/*B*/,7/*C*/,7/*D*/,6/*E*/,6/*F*/,8/*G*/,7/*H*/,2/*I*/,5/*J*/,7/*K*/,6/*L*/,8/*M*/,7/*N*/,8/*O*/,
	6/*P*/,8/*Q*/,7/*R*/,7/*S*/,6/*T*/,7/*U*/,8/*V*/,11/*W*/,7/*X*/,8/*Y*/,7/*Z*/,0,0,0,0,0,
	0,6/*a*/,6/*b*/,6/*c*/,6/*d*/,6/*e*/,4/*f*/,6/*g*/,6/*h*/,2/*i*/,3/*j*/,5/*k*/,2/*l*/,8/*m*/,6/*n*/,6/*o*/,
	6/*p*/,6/*q*/,4/*r*/,6/*s*/,4/*t*/,6/*u*/,6/*v*/,9/*w*/,6/*x*/,6/*y*/,6/*z*/,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
};

const int CHY = 22;
const int CHH = 12;

const int lblx[2][2] = {{185,533},{748,1095}};
const int lbly[6] = {texh-467,texh-426,texh-385,texh-344,texh-303,texh-262};

// ----------------------------------------------------------------------------- 


/**
MFD button col constructor.
*/
MFDButtonCol::MFDButtonCol (VESSEL3 *v, DWORD _mfdid, DWORD _lr): PanelElement (v)
{
	mfdid = _mfdid;
	lr = _lr;
	xcnt = lblx[mfdid][lr];
}


/**
MFD button col destructor.
*/
MFDButtonCol::~MFDButtonCol ()
{
}


/**
MFD button col redraw 2D.
*/
bool MFDButtonCol::Redraw2D (SURFHANDLE surf)
{
	int btn, x, y, len, i, w;
	const char *label;

	// Write labels.
	x = tx_w/2;
	y = 4;
	for (btn = 0; btn < 6; btn++)
	{
		oapiBlt (surf, surf, xcnt-14, lbly[btn], 773, 22, 28, CHH); // blank label
	}
	for (btn = 0; btn < 6; btn++) 
	{
		if (label = oapiMFDButtonLabel (mfdid, btn+lr*6)) 
		{
			len = strlen(label);
			for (w = i = 0; i < len; i++) 
			{
				w += CHW[label[i]];
			}
			for (i = 0, x = xcnt-w/2; i < len; i++) 
			{
				w = CHW[label[i]];
				if (w) 
				{
					oapiBlt (surf, surf, x, lbly[btn], CHX[label[i]], CHY, w, CHH);
					x += w;
				}
			}
		} 
		else
		{ 
			break;
		}
	}
   return false;
}


/**
Process mouse 2D events for MFD button col.
*/
bool MFDButtonCol::ProcessMouse2D (int event, int mx, int my)
{
	if (my%41 < 18) 
	{
		int bt = my/41 + lr*6;
		oapiProcessMFDButton (mfdid, bt, event);
		return true;
	} 
	else
	{
		return false;
	}
}


/**
MFD button row constructor.
*/
MFDButtonRow::MFDButtonRow (VESSEL3 *v, DWORD _mfdid): PanelElement (v)
{
	mfdid = _mfdid;
}


/**
Process mouse 2D events for MFD button row.
*/
bool MFDButtonRow::ProcessMouse2D (int event, int mx, int my)
{
	bool proc = false;
	if (mx < 26) 
	{
		oapiToggleMFD_on (mfdid), proc = true;
	}
	else if (mx >= 214 && mx < 240) 
	{
		oapiSendMFDKey (mfdid, OAPI_KEY_F1), proc = true;
	}
	else if (mx > 244) 
	{
		oapiSendMFDKey (mfdid, OAPI_KEY_GRAVE), proc = true;
	}
	return proc;
}
