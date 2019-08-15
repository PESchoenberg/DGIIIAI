#include "DeltaGlider.h"
#include <stdio.h>

extern "C" {
#include "lua\lua.h"
#include "lua\lualib.h"
#include "lua\lauxlib.h"
}

// -----------------------------------------------------------------------------
// API function prototypes


DeltaGlider *lua_toDG (lua_State *L, int idx = 1);
int dgGear (lua_State *L);
int dgNosecone (lua_State *L);
int dgHatch (lua_State *L);
int dgRetro (lua_State *L);
int dgOLock (lua_State *L);
int dgILock (lua_State *L);
int dgRadiator (lua_State *L);
int dgABrake (lua_State *L);

// -----------------------------------------------------------------------------
// API initialization



/**
Initialize Lua interpreter.
*/
int DeltaGlider::Lua_InitInterpreter (void *context)
{
	lua_State *L = (lua_State*)context;

	// Load atmospheric autopilot
	luaL_dofile (L, "Script\\dg\\aap.lua");

	return 0;
}


/**
Initialize Lua instance.
*/
int DeltaGlider::Lua_InitInstance (void *context)
{
	lua_State *L = (lua_State*)context;

	// Check if interpreter has DG table loaded already
	luaL_getmetatable (L, "VESSEL.DG");

	if (lua_isnil (L, -1)) 
	{ 
		// Register new functions
		lua_pop (L, 1);
		static const struct luaL_reg dgLib[] = {
			{"Gear", dgGear},
			{"Nosecone", dgNosecone},
			{"Hatch", dgHatch},
			{"Retro", dgRetro},
			{"OLock", dgOLock},
			{"ILock", dgILock},
			{"Radiator", dgRadiator},
			{"ABrake", dgABrake},
			{NULL, NULL}
		};

		// Create metatable for vessel userdata
		luaL_newmetatable (L, "DG.vtable");

		// Create a table for the overloaded methods
		luaL_openlib (L, "DG.method", dgLib, 0);

		// Create metatable for accessing inherited methods from VESSEL
		luaL_newmetatable (L, "DG.base");
		lua_pushstring (L, "__index");
		luaL_getmetatable (L, "VESSEL.vtable");
		lua_settable (L, -3);

		// Set DG.base as metatable for DG.method
		lua_setmetatable (L, -2);

		// Point vessel userdata to DG.method
		lua_pushstring (L, "__index");
		lua_pushvalue (L, -2); // push DG.method
		lua_settable (L, -4);

		// Pop DG.method from the stack
		lua_pop (L, 1);
	}

	lua_setmetatable (L, -2);

	return 0;
}


// -----------------------------------------------------------------------------
// Script API functions


/**
Lua to DG.
*/
DeltaGlider *lua_toDG (lua_State *L, int idx)
{
	VESSEL **pv = (VESSEL**)lua_touserdata (L, idx);
	DeltaGlider *dg = (DeltaGlider*)*pv;
	return dg;
}


//Go elsewhere?
static DeltaGlider::DoorStatus DGaction[4] = {
	DeltaGlider::DOOR_CLOSING,
	DeltaGlider::DOOR_OPENING,
	DeltaGlider::DOOR_CLOSING,
	DeltaGlider::DOOR_OPENING
};


/**
DG gear.
*/
static int dgGear (lua_State *L)
{
	DeltaGlider *dg = lua_toDG (L, 1);
	int action = lua_tointeger (L, 2);
	if (dg && action >= 2 && action < 4)
	{
		dg->ActivateLandingGear (DGaction[action]);
	}
	return 0;
}


/**
DG nosecone.
*/
static int dgNosecone (lua_State *L)
{
	DeltaGlider *dg = lua_toDG (L, 1);
	int action = lua_tointeger (L, 2);
	if (dg && action >= 0 && action < 2)
	{
		dg->ActivateDockingPort (DGaction[action]);
	}
	return 0;
}


/**
DG hatch.
*/
static int dgHatch (lua_State *L)
{
	DeltaGlider *dg = lua_toDG (L, 1);
	int action = lua_tointeger (L, 2);
	if (dg && action >= 0 && action < 2)
	{
		dg->ActivateHatch (DGaction[action]);
	}
	return 0;
}


/**
DG retro.
*/
static int dgRetro (lua_State *L)
{
	DeltaGlider *dg = lua_toDG (L, 1);
	int action = lua_tointeger (L, 2);
	if (dg && action >= 0 && action < 2)
	{
		dg->ActivateRCover (DGaction[action]);
	}
	return 0;
}


/**
DG outer lock.
*/
static int dgOLock (lua_State *L)
{
	DeltaGlider *dg = lua_toDG (L, 1);
	int action = lua_tointeger (L, 2);
	if (dg && action >= 0 && action < 2)
	{
		dg->ActivateOuterAirlock (DGaction[action]);
	}
	return 0;
}


/**
DG inner lock.
*/
static int dgILock (lua_State *L)
{
	DeltaGlider *dg = lua_toDG (L, 1);
	int action = lua_tointeger (L, 2);
	if (dg && action >= 0 && action < 2)
	{
		dg->ActivateInnerAirlock (DGaction[action]);
	}
	return 0;
}


/**
DG radiator.
*/
static int dgRadiator (lua_State *L)
{
	DeltaGlider *dg = lua_toDG (L, 1);
	int action = lua_tointeger (L, 2);
	if (dg && action >= 0 && action < 2)
	{
		dg->ActivateRadiator (DGaction[action]);
	}
	return 0;
}


/**
DG airbrake.
*/
static int dgABrake (lua_State *L)
{
	DeltaGlider *dg = lua_toDG (L, 1);
	int action = lua_tointeger (L, 2);
	if (dg && action >= 0 && action < 2)
	{
		dg->ActivateAirbrake (DGaction[action]);
	}
	return 0;
}
