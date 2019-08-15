// =============================================================================
//                ORBITER MODULE: DeltaGlider
//                  Part of the ORBITER SDK
//          Copyright (C) 2001-2008 Martin Schweiger
//                   All rights reserved
//
// DeltaGlider.h
// Class interface for delta glider vessel class module
//
// Notes:
// * Two alternative sets of vessel capabilities are provided
//   ("easy" and "complex"), depending on user-selected option.
// * This interface covers both the "classic" (DeltaGlider) and
//   scramjet (DG-S) versions, distinguished by the SCRAMJET
//   entry in the definition file.
// =============================================================================

#ifndef __DELTAGLIDER_H
#define __DELTAGLIDER_H

#define STRICT 1

#include "stdafx.h"
#include "orbitersdk.h"
#include "Ramjet.h"
#include "Instrument.h"
#include "resource.h"

#define LOADBMP(id) (LoadBitmap (g_Param.hDLL, MAKEINTRESOURCE (id)))

// -----------------------------------------------------------------------------
// Some vessel class caps
// Where an entry consists of two values, the first refers to the
// "easy", the second to the "complex" flight model.


// DG mass w/o fuel
const double EMPTY_MASS    = 11000.0;  // Standard configuration
const double EMPTY_MASS_SC = 13000.0;  // Ramjet configuration

// Mass per passenger (including life support system)
const double PSNGR_MASS    =     85.0;

// Main fuel tank capacities [kg] (can be split between rocket fuel and scramjet fuel)
const double TANK1_CAPACITY = 10400.0;
const double TANK2_CAPACITY =  2500.0;

// Max fuel capacity: RCS tank [kg]
const double RCS_FUEL_CAPACITY = 600.0;

// Main engine max vacuum thrust [N] per engine. (x2 for total)
const double MAX_MAIN_THRUST[2] = {2.0e5, 1.6e5};

// Retro engine max vacuum thrust [N] per engine. (x2 for total)
const double MAX_RETRO_THRUST = 3.4e4;

// Hover engine max vacuum thrust [N] (x2 for total)
const double MAX_HOVER_THRUST[2] = {1.4e5, 1.1e5};

// Attitude control system max thrust [N] per engine.
const double MAX_RCS_THRUST = 2.5e3;

// Vacuum Isp (fuel-specific impulse) for all thrusters [m/s]
const double ISP = 4e4;

// Opening/closing speed of landing gear (1/sec)
// => gear cycle ~ 6.7 sec
const double GEAR_OPERATING_SPEED = 0.15;

// Opening/closing speed of nose cone docking mechanism (1/sec)
// => cycle = 20 sec
const double NOSE_OPERATING_SPEED = 0.05;

// Opening/closing speed of outer airlock (1/sec)
// => cycle = 10 sec
const double AIRLOCK_OPERATING_SPEED = 0.1;

// Deployment speed of radiator (1/sec)
// => cycle = 32 sec
const double RADIATOR_OPERATING_SPEED = 0.03125;

// Deployment speed of airbrakes
// => cycle = 3.3 sec
const double AIRBRAKE_OPERATING_SPEED = 0.3;

// Deployment speed of escape ladder
const double LADDER_OPERATING_SPEED = 0.1;

// Opening/closing speed of top hatch
const double HATCH_OPERATING_SPEED = 0.15;

// Retro cover opening/closing speed
const double RCOVER_OPERATING_SPEED = 0.3;

// -----------------------------------------------------------------------------
// Main engine parameters.

// Main engine pitch and yaw gimbal range (tan).
const double MAIN_PGIMBAL_RANGE = tan (1.0*RAD);
const double MAIN_YGIMBAL_RANGE = 1.0/7.7;

// Operating speed of main engine pitch and yaw gimbals.
const double MAIN_PGIMBAL_SPEED = 0.007;
const double MAIN_YGIMBAL_SPEED = 0.035;

// Max thrust imbalance between front and aft hover engines [N].
const double MAX_HOVER_IMBALANCE = 4e3;

// Operating speed of hover balance shift control.
const double HOVER_BALANCE_SPEED = 2e3;

// -----------------------------------------------------------------------------
// Scramjet parameters.

// Max. scramjet fuel capacity [kg].
const double SCRAM_FUEL_CAPACITY = 5000.0;

// Max. scramjet exhaust temperature [K].
const double SCRAM_TEMAX[2] = {3500.0, 3200.0};

// Scramjet fuel heating value [J/kg]: Amount of heat energy obtained from burning 1kg of propellant.
const double SCRAM_FHV[2] = {3.5e8, 2.0e8};

// Max. scramjet fuel flow rate [kg/s].
const double SCRAM_MAX_DMF[2] = {2.0,3.0};

// Scramjet intake cross section (per engine) [m^2].
const double SCRAM_INTAKE_AREA = 1.0;

// Default scramjet thrust angle (rad).
const double SCRAM_DEFAULT_DIR = 9.0*RAD;

// Scramjet gimbal range (rad).
const double SCRAM_GIMBAL_RANGE = 5.0*RAD;

// Operating speed of scramjet pitch gimbals (rad/s).
const double SCRAM_GIMBAL_SPEED = SCRAM_GIMBAL_RANGE/3.0;

// -----------------------------------------------------------------------------
// Damage parameters.

// Max. allowed positive and negative wing load [N/m^2].
const double WINGLOAD_MAX =  16e3;
const double WINGLOAD_MIN = -10e3;

// Max. allowed dynamic pressure [Pa].
const double DYNP_MAX = 300e3;

// -----------------------------------------------------------------------------
// Number of bitmap handles.
const int nsurf = 12; 

// -----------------------------------------------------------------------------
// 2D instrument panel parameters.

const DWORD PANEL2D_WIDTH = 1280;  // panel width [pixel]
const DWORD PANEL2D_TEXW  = 2048;  // texture width
const DWORD PANEL2D_TEXH  = 1024;  // texture height
const DWORD INSTR3D_TEXW  =  512;
const DWORD INSTR3D_TEXH  = 1024;
const DWORD INSTR1_TEXW   =  176;
const DWORD INSTR1_TEXH   = 1152;
const DWORD INSTR2_TEXW   =   84;
const DWORD INSTR2_TEXH   =  512;
const DWORD INSTR3_TEXW   =  268;
const DWORD INSTR3_TEXH   =  188;

// -----------------------------------------------------------------------------
// Interface for derived vessel class: DeltaGlider
// -----------------------------------------------------------------------------

class DeltaGlider: public VESSEL3 
{
	friend class AAP;
	friend class FuelMFD;
	friend class ThrottleMain;
	friend class ThrottleHover;
	friend class ThrottleScram;

	public:
		DeltaGlider (OBJHANDLE hObj, int fmodel);
		~DeltaGlider ();
		void SetEmptyMass () const;
		void CreatePanelElements ();
		void DefineAnimations ();
		void ReleaseSurfaces();
		void InitPanel (int panel);
		void InitVC (int vc);
		inline bool ScramVersion() const { return scramjet != NULL; }
		void DrawHUD (int mode, const HUDPAINTSPEC *hps, HDC hDC);
		void DrawNeedle (HDC hDC, int x, int w, double rad, double angle, double *pangle = 0, double speed = PI);
		void UpdateStatusIndicators();
		void SetPassengerVisuals ();
		void SetDamageVisuals ();
		void SetPanelScale (PANELHANDLE hPanel, DWORD viewW, DWORD viewH);
		void DefinePanelMain (PANELHANDLE hPanel);
		void DefinePanelOverhead (PANELHANDLE hPanel);
		bool RedrawPanel_AOA (SURFHANDLE surf, bool force = false);
		bool RedrawPanel_Slip (SURFHANDLE surf, bool force = false);
		bool RedrawPanel_Wingload (SURFHANDLE surf, bool force = false);
		bool RedrawPanel_RotVelocity (SURFHANDLE surf, int which);
		bool RedrawPanel_RotAcceleration (SURFHANDLE surf, int which);
		bool RedrawPanel_RotMoment (SURFHANDLE surf, int which);
		bool RedrawPanel_ScramTempDisp (SURFHANDLE surf);
		bool RedrawPanel_WBrake (SURFHANDLE surf, int which);
		void RedrawPanel_MFDButton (SURFHANDLE surf, int mfd, int side);
		bool RedrawPanel_MainFlow (SURFHANDLE surf);
		bool RedrawPanel_RetroFlow (SURFHANDLE surf);
		bool RedrawPanel_HoverFlow (SURFHANDLE surf);
		bool RedrawPanel_ScramFlow (SURFHANDLE surf);
		bool RedrawPanel_MainTSFC (SURFHANDLE surf);
		bool RedrawPanel_ScramTSFC (SURFHANDLE surf);
		bool RedrawPanel_MainProp (SURFHANDLE surf);
		bool RedrawPanel_MainPropMass (SURFHANDLE surf);
		bool RedrawPanel_RCSProp (SURFHANDLE surf);
		bool RedrawPanel_RCSPropMass (SURFHANDLE surf);
		bool RedrawPanel_ScramProp (SURFHANDLE surf);
		bool RedrawPanel_ScramPropMass (SURFHANDLE surf);
		bool RedrawPanel_GimbalScramDisp (SURFHANDLE surf);
		bool RedrawPanel_HoverBalanceDisp (SURFHANDLE surf);
		bool RedrawPanel_GearIndicator (SURFHANDLE surf);
		bool RedrawPanel_NoseconeIndicator (SURFHANDLE surf);
		void RedrawVC_ThMain ();
		void RedrawVC_ThHover ();
		void RedrawVC_ThScram ();
		void InitVCMesh ();
		//void SetVC_HUDMode();
		void SetVC_PGimbalMode();
		void SetVC_YGimbalMode();
		void SetVC_ScramGimbalMode();
		void SetVC_HoverBalanceMode ();

		bool DecAttMode ();
		bool IncAttMode ();
		bool DecADCMode ();
		bool IncADCMode ();
		void SetMainRetroLevel (int which, double lmain, double lretro);
		void SetScramLevel (int which, double level);
		void EnableRetroThrusters (bool state);
		bool IncMainPGimbal (int which, int mode);
		void AdjustMainPGimbal (int &mode);
		bool IncMainYGimbal (int which, int mode);
		void AdjustMainYGimbal (int &mode);
		bool IncScramGimbal (int which, int mode);
		void AdjustScramGimbal (int &mode);
		bool ShiftHoverBalance (int mode);
		void AdjustHoverBalance (int &mode);
		void TestDamage ();
		void ApplyDamage ();
		void RepairDamage ();
		bool MWSActive() const { return bMWSActive; }
		void MWSReset() { bMWSActive = false; }

		// Overloaded callback functions
		void clbkSetClassCaps (FILEHANDLE cfg);
		void clbkLoadStateEx (FILEHANDLE scn, void *vs);
		void clbkSaveState (FILEHANDLE scn);
		void clbkPostCreation ();
		void clbkVisualCreated (VISHANDLE vis, int refcount);
		void clbkVisualDestroyed (VISHANDLE vis, int refcount);
		void clbkPostStep (double simt, double simdt, double mjd);
		bool clbkPlaybackEvent (double simt, double event_t, const char *event_type, const char *event);
		bool clbkDrawHUD (int mode, const HUDPAINTSPEC *hps, oapi::Sketchpad *skp);
		void clbkRenderHUD (int mode, const HUDPAINTSPEC *hps, SURFHANDLE hTex);
		void clbkRCSMode (int mode);
		void clbkADCtrlMode (DWORD mode);
		void clbkHUDMode (int mode);
		void clbkMFDMode (int mfd, int mode);
		void clbkNavMode (int mode, bool active);
		int  clbkConsumeDirectKey (char *kstate);
		int  clbkConsumeBufferedKey (DWORD key, bool down, char *kstate);
		bool clbkLoadGenericCockpit ();
		//bool clbkLoadPanel (int id);
		bool clbkLoadPanel2D (int id, PANELHANDLE hPanel, DWORD viewW, DWORD viewH);
		bool clbkPanelMouseEvent (int id, int event, int mx, int my, void *context);
		bool clbkPanelRedrawEvent (int id, int event, SURFHANDLE surf, void *context);
		bool clbkLoadVC (int id);
		bool clbkVCMouseEvent (int id, int event, VECTOR3 &p);
		bool clbkVCRedrawEvent (int id, int event, SURFHANDLE surf);
		int  clbkGeneric (int msgid, int prm, void *context);

		double range;     // Glide range.
		double aoa_ind;   // Angle of AOA needle (NOT AOA!).
		double slip_ind;  // Angle of slip indicator needle.
		double load_ind;  // Angle of load indicator needle.
		int mpgimbalidx[2], mpswitch[2], mpmode; // Main pitch gimbal slider positions and button states.
		int mygimbalidx[2], myswitch[2], mymode; // Main yaw gimbal slider positions and button states.
		int scgimbalidx[2], sgswitch[2], spmode; // Scramjet gimbal slider positions and button states.
		int hbalanceidx, hbswitch, hbmode;       // Hover balance slider position.
		bool psngr[4];                           // Passengers?
		bool bDamageEnabled;                     // Damage/failure testing?

		// Parameters for failure modelling.
		double lwingstatus, rwingstatus;
		int hatchfail;
		bool aileronfail[4];

		enum DoorStatus { DOOR_CLOSED, DOOR_OPEN, DOOR_CLOSING, DOOR_OPENING }
			nose_status, ladder_status, gear_status, rcover_status, olock_status, ilock_status, hatch_status, radiator_status, brake_status;
		void ActivateLandingGear (DoorStatus action);
		void ActivateRCover (DoorStatus action);
		void ActivateDockingPort (DoorStatus action);
		void ActivateLadder (DoorStatus action);
		void ActivateOuterAirlock (DoorStatus action);
		void ActivateInnerAirlock (DoorStatus action);
		void ActivateHatch (DoorStatus action);
		void ActivateAirbrake (DoorStatus action);
		void ActivateRadiator (DoorStatus action);
		void RevertLandingGear ();
		void RevertDockingPort ();
		void RevertLadder ();
		void RevertOuterAirlock ();
		void RevertInnerAirlock ();
		void RevertHatch ();
		void RevertAirbrake ();
		void RevertRadiator ();
		void SetGearParameters (double state);
		double nose_proc, ladder_proc, gear_proc, rcover_proc, olock_proc, ilock_proc, hatch_proc, radiator_proc, brake_proc;     // logical status
		UINT anim_gear;         // Handle for landing gear animation.
		UINT anim_rcover;       // Handle for retro cover animation.
		UINT anim_nose;         // Handle for nose cone animation.
		UINT anim_ladder;       // Handle for front escape ladder animation.
		UINT anim_olock;        // Handle for outer airlock animation.
		UINT anim_ilock;        // Handle for inner airlock animation.
		UINT anim_hatch;        // Handle for top hatch animation.
		UINT anim_radiator;     // Handle for radiator animation.
		UINT anim_rudder;       // Handle for rudder animation.
		UINT anim_elevator;     // Handle for elevator animation.
		UINT anim_elevatortrim; // Handle for elevator trim animation.
		UINT anim_laileron;     // Handle for left aileron animation.
		UINT anim_raileron;     // Handle for right aileron animation.
		UINT anim_brake;        // Handle for airbrake animation.
		UINT anim_mainthrottle[2];  // VC main/retro throttle levers (left and right).
		UINT anim_hoverthrottle;    // VC hover throttle.
		UINT anim_scramthrottle[2]; // VC scram throttle levers (left and right).
		UINT anim_gearlever;        // VC gear lever.
		UINT anim_nconelever;       // VC nose cone lever.
		UINT anim_pmaingimbal[2];   // VC main engine pitch gimbal switch (left and right engine).
		UINT anim_ymaingimbal[2];   // VC main engine yaw gimbal switch (left and right engine).
		UINT anim_scramgimbal[2];   // VC scram engine pitch gimbal switch (left and right engine).
		UINT anim_hbalance;         // VC hover balance switch.
		UINT anim_hudintens;        // VC HUD intensity switch.
		UINT anim_rcsdial;          // VC RCS dial animation.
		UINT anim_afdial;           // VC AF dial animation.
		UINT anim_olockswitch;      // VC outer airlock switch animation.
		UINT anim_ilockswitch;      // VC inner airlock switch animation.
		UINT anim_retroswitch;      // VC retro cover switch animation.
		UINT anim_ladderswitch;     // VC ladder switch animation.
		UINT anim_hatchswitch;      // VC hatch switch animation.
		UINT anim_radiatorswitch;   // VC radiator switch animation.

		SURFHANDLE srf[nsurf];          // Handles for panel bitmaps.
		SURFHANDLE insignia_tex;        // Vessel-specific fuselage markings.
		SURFHANDLE contrail_tex;        // Contrail particle texture.
		static SURFHANDLE panel2dtex;   // Texture for 2D instrument panel.
		MESHHANDLE exmesh_tpl;          // Vessel mesh: global template.
		MESHHANDLE vcmesh_tpl;          // VC mesh: global template.
		DEVMESHHANDLE exmesh;           // Vessel mesh: instance.
		DEVMESHHANDLE vcmesh;           // VC mesh: instance.
		THGROUP_HANDLE thg_main;
		THGROUP_HANDLE thg_retro;
		THGROUP_HANDLE thg_hover;

		enum {CAM_GENERIC, CAM_PANELMAIN, CAM_PANELUP, CAM_PANELDN, CAM_VCPILOT, CAM_VCPSNGR1, CAM_VCPSNGR2, CAM_VCPSNGR3, CAM_VCPSNGR4} campos;

		BEACONLIGHTSPEC beacon[8];                   // Light beacon definitions.
		void SetNavlight (bool on);
		void SetBeacon (bool on);
		void SetStrobe (bool on);
		void SetDockingLight (bool on);
		bool GetBeaconState (int which); // which=0:nav, 1:beacon, 2:strobe

		double GetThrusterFlowRate(THRUSTER_HANDLE th);  // D. Beachy: get thruster flow rate in kg/s.

		// Script interface-related methods
		int Lua_InitInterpreter (void *context);
		int Lua_InitInstance (void *context);

		// -----------------------------------------------------------------------
		//DGIIIAI2
		void ExsysSetup();
		void ExsysReadSen();
		void ExsysReadMod();
		void ExsysThink();
		void ExsysWrite();
		void ExsysSeq();
		void ExsysManage();
		double ExsysCalcVs(double p_num);
		double ExsysGetEnergySrc(double p_num);
		double ExsysGetEnergyBus(double p_num);
		double ExsysGetEnergyLvl(double p_num);
		double ExsysGetHdg();
		double ExsysGetTgthdg(int p_num);
		double ExsysGetTgtyaw(double p_num);
		double ExsysGetTgtpitch(double p_num);
		double ExsysGetAirbrakeStatus();
		double ExsysGetRetroCoverStatus();
		double ExsysGetHatchStatus();
		double ExsysGetNoseConeStatus();
		double ExsysGetInnerLockStatus();
		double ExsysGetOuterLockStatus();
		double ExsysGetGearStatus();
		double ExsysGetLadderStatus();
		double ExsysGetRadiatorStatus();
		double ExsysGetDockingStatus(int p_port);
		double ExsysGetNavMode( int p_mode );
		void ExsysSetNavMode( int p_mode, double p_value );
		bool ExsysGetStatus( double p_status, double p_value );
		double ExsysCondUpdate(std::string p_item, double p_value);
		std::string ExsysDin(std::string p_sensor_name, double p_val);
		std::string ExsysSvout(std::string p_actuator_name);

		int exsys_iter;
		int exsys_sleep;
		int num_records;
		int tot_applykbr_iter;
		int *alt_res_agl;
		int *alt_res_amr;	
		double val;
		double resh;
		double damage_extent;
		double *heading;
		double *rel_equ_lat;
		double *rel_equ_lon;
		double *rel_equ_rad;	
		bool kb_flag;
		bool use_exsys;
		bool db_lock;	
		bool is_exsys_setup;
		std::string sitem;
		std::string sql_sentence;
		sqlite3 *db;
		char *zErrMsg;
		int rc;
	   const char* data;	
	   VECTOR3 globalorientationvec;
		VECTOR3 airspeedvec_global;
		VECTOR3 airspeedvec_local;
		VECTOR3 airspeedvec_reflocal;
		VECTOR3 airspeedvec_horizon;	
		VECTOR3 angularaccvec;
		VECTOR3 angularmoment;
		VECTOR3 angularvel;
		VECTOR3 dragvector;
		VECTOR3 globalvel;
		VECTOR3 groundspeedvector;
		VECTOR3 liftvector;
		VECTOR3 linearmoment;
		VECTOR3 pmi;
		VECTOR3 superstructurecg;
		VECTOR3 supervesselcg;
		VECTOR3 surfacenormal;
		VECTOR3 torquevector;
		VECTOR3 thrustvector;
		VECTOR3 weightvector;
		VECTOR3 attitudelinlevel;
		VECTOR3 attituderotlevel;
		//VECTOR3 relativepos;
		VECTOR3 globalpos_ecl;
		VECTOR3 localpos_ecl;
		VECTOR3 relativepos_ecl;
		VECTOR3 localpos_ecl_tgt1;
	   
	private:
		bool RedrawPanel_IndicatorPair (SURFHANDLE surf, int *p, int range);
		bool RedrawPanel_Number (SURFHANDLE surf, int x, int y, char *num);
		void ApplySkin();                            // Apply custom skin.
		void PaintMarkings (SURFHANDLE tex);         // Paint individual vessel markings.

		Ramjet *scramjet;                            // Scramjet module (NULL = none).
		void ScramjetThrust ();                      // Scramjet thrust calculation.

		AAP *aap;                                    // Atmospheric autopilot.

		PanelElement **instr;                        // Panel instrument objects.
		DWORD ninstr;                                // Total number of instruments.
		DWORD ninstr_main, ninstr_ovhd;              // Number of instruments on main/overhead panels .
		DWORD instr_scram0, instr_ovhd0;             // Instrument index offsets.

		bool bMWSActive, bMWSOn;                     // Master warning flags.
		int modelidx;                                // Flight model index.
		int tankconfig;                              // 0=rocket fuel only, 1=scramjet fuel only, 2=both.
		double max_rocketfuel, max_scramfuel;        // Max capacity for rocket and scramjet fuel.
		VISHANDLE visual;                            // Handle to DG visual representation.
		SURFHANDLE skin[3];                          // Custom skin textures, if applicable.
		MESHHANDLE hPanelMesh;                       // 2-D instrument panel mesh handle.
		char skinpath[32];                           // Skin directory, if applicable.
		PROPELLANT_HANDLE ph_main, ph_rcs, ph_scram; // Propellant resource handles.
		THRUSTER_HANDLE th_main[2];                  // Main engine handles.
		THRUSTER_HANDLE th_retro[2];                 // Retro engine handles.
		THRUSTER_HANDLE th_hover[2];                 // Hover engine handles.
		THRUSTER_HANDLE th_scram[2];                 // Scramjet handles.
		double th_main_level;                        // Mean thruster main level.
		AIRFOILHANDLE hwing;                         // Airfoil handle for wings.
		CTRLSURFHANDLE hlaileron, hraileron;         // Control surface handles.
		PSTREAM_HANDLE hatch_vent;
		double hatch_vent_t;
		bool dockreleasedown;
		SpotLight *docking_light;

		UINT engsliderpos[5];    // Throttle settings for main,hover,scram engines.
		double scram_intensity[2];
		double scram_max[2];
		UINT wbrake_pos[2];
		int mainflowidx[2], retroflowidx[2], hoverflowidx, scflowidx[2];
		int mainTSFCidx, scTSFCidx[2];
		int mainpropidx[2], rcspropidx[2], scrampropidx[2];
		int mainpropmass, rcspropmass, scrampropmass;
		int rotidx[3][3];

		// Propellant status display parameters.
		struct PrpDisp 
		{        
			int dsp_main,      dsp_rcs;
			char lvl_main[8],  lvl_rcs[8];
			char mass_main[8], mass_rcs[8];
			char flow_main[8], flow_rcs[8];
		} p_prpdisp;

		// Engine status display parameters.
		struct EngDisp 
		{       
			int  bar[2];
			char dsp[6][8];
		} p_engdisp;

		struct RngDisp 
		{
			char dsp[2][10];
		} p_rngdisp;
};

// -----------------------------------------------------------------------------
class DGPanelElement: public PanelElement 
{
	public:
		DGPanelElement (DeltaGlider *_dg): PanelElement (dg), dg(_dg) {}

	protected:
		DeltaGlider *dg;
};

// -----------------------------------------------------------------------------
typedef struct 
{
	HINSTANCE hDLL;
	HFONT font[2];
	DWORD col[4];
	HBRUSH brush[4];
	HPEN pen[2];
} GDIParams;

// Some mesh groups referenced in the code.
#define MESHGRP_VC_HUDMODE          0
#define MESHGRP_VC_HBALANCECNT     18
#define MESHGRP_VC_SCRAMGIMBALCNT  19
#define MESHGRP_VC_PGIMBALCNT      20
#define MESHGRP_VC_YGIMBALCNT      21
#define MESHGRP_VC_NAVMODE         59
#define MESHGRP_VC_LMFDDISP       109
#define MESHGRP_VC_RMFDDISP       110
#define MESHGRP_VC_STATUSIND      118
#define MESHGRP_VC_HORIZON        120
#define MESHGRP_VC_HUDDISP        136

// Panel area identifiers:
// Panel 0
#define AID_PROPELLANTSTATUS     0
#define AID_ENGINEMAIN           2
#define AID_ENGINEHOVER          3
#define AID_ENGINESCRAM          4
#define AID_ATTITUDEMODE         5
#define AID_ADCTRLMODE           6
#define AID_NAVMODE              7
#define AID_HUDMODE              8
#define AID_AOAINSTR             9
#define AID_VSINSTR             10
#define AID_SLIPINSTR           11
#define AID_LOADINSTR           12
#define AID_HSIINSTR            13
#define AID_HORIZON             14
#define AID_MFD1_BBUTTONS       15
#define AID_MFD1_LBUTTONS       16
#define AID_MFD1_RBUTTONS       17
#define AID_MFD2_BBUTTONS       18
#define AID_MFD2_LBUTTONS       19
#define AID_MFD2_RBUTTONS       20
#define AID_PGIMBALMAIN         22
#define AID_PGIMBALMAINMODE     23
#define AID_YGIMBALMAIN         24
#define AID_YGIMBALMAINMODE     25
#define AID_GIMBALSCRAM         26
#define AID_GIMBALSCRAMMODE     27
#define AID_ELEVATORTRIM        28
#define AID_PGIMBALMAINDISP     29
#define AID_YGIMBALMAINDISP     30
#define AID_GIMBALSCRAMDISP     31
#define AID_MAINDISP1           32
#define AID_MAINDISP2           33
#define AID_MAINDISP3           34
#define AID_MAINDISP4           35
#define AID_SCRAMDISP2          36
#define AID_SCRAMDISP3          37
#define AID_MAINPROP            38
#define AID_MAINPROPMASS        39
#define AID_RCSPROP             40
#define AID_RCSPROPMASS         41
#define AID_SCRAMPROP           42
#define AID_SCRAMPROPMASS       43
#define AID_HOVERBALANCE        44
#define AID_HBALANCEMODE        45
#define AID_HBALANCEDISP        46
#define AID_RADIATORSWITCH      47
#define AID_RETRODOORSWITCH     48
#define AID_HATCHSWITCH         49
#define AID_LADDERSWITCH        50
#define AID_MWS                 51
#define AID_AIRBRAKE            52
#define AID_SWITCHARRAY         53
#define AID_AAP                 54

// Panel 1
#define AID_AIRLOCKSWITCH      100
#define AID_NAVLIGHTBUTTON     102
#define AID_BEACONBUTTON       103
#define AID_STROBEBUTTON       104
#define AID_VPITCH             105
#define AID_VBANK              106
#define AID_VYAW               107
#define AID_APITCH             108
#define AID_ABANK              109
#define AID_AYAW               110
#define AID_MPITCH             111
#define AID_MBANK              112
#define AID_MYAW               113
#define AID_SCRAMTEMPDISP      114

// Panel 2
#define AID_WBRAKE_BOTH        200
#define AID_WBRAKE_LEFT        201
#define AID_WBRAKE_RIGHT       202
#define AID_GEARLEVER          203
#define AID_NOSECONELEVER      204
#define AID_GEARINDICATOR      205
#define AID_NOSECONEINDICATOR  206
#define AID_DOCKRELEASE        207

// Virtual cockpit-specific area identifiers:
#define AID_MFD1_PWR          1024
#define AID_MFD1_SEL          1025
#define AID_MFD1_MNU          1026
#define AID_MFD2_PWR          1027
#define AID_MFD2_SEL          1028
#define AID_MFD2_MNU          1029
#define AID_HUDBUTTON1        1030
#define AID_HUDBUTTON2        1031
#define AID_HUDBUTTON3        1032
#define AID_HUDBUTTON4        1033
#define AID_HUDCOLOUR         1034
#define AID_HUDINCINTENS      1035
#define AID_HUDDECINTENS      1036
#define AID_NAVBUTTON1        1037
#define AID_NAVBUTTON2        1038
#define AID_NAVBUTTON3        1039
#define AID_NAVBUTTON4        1040
#define AID_NAVBUTTON5        1041
#define AID_NAVBUTTON6        1042
#define AID_RADIATOREX        1043
#define AID_RADIATORIN        1044
#define AID_HATCHOPEN         1045
#define AID_HATCHCLOSE        1046
#define AID_LADDEREX          1047
#define AID_LADDERIN          1048
#define AID_RCOVEROPEN        1049
#define AID_RCOVERCLOSE       1050
#define AID_ILOCKOPEN         1051
#define AID_ILOCKCLOSE        1052
#define AID_OLOCKOPEN         1053
#define AID_OLOCKCLOSE        1054
#define AID_NCONEOPEN         1055
#define AID_NCONECLOSE        1056
#define AID_GEARDOWN          1057
#define AID_GEARUP            1058

#endif // !__DELTAGLIDER_H
