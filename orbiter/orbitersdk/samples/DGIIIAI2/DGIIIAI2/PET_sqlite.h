/*
PET_sqlite.h
*/

#ifndef __PETSQLITE_
#define __PETSQLITE_

#include "stdafx.h"

/**
Functions.
*/

std::string PetStrUval ( std::string p_sitem, std::string p_svalue );

std::string PetStrProb ( std::string p_sitem, std::string p_sprob );

std::string PetStrUvalProb ( std::string p_sitem, std::string p_svalue, std::string p_sprob );

std::string PetStrUite ( std::string p_sitem );

static int PetSqlResult1 ( void *data, int argc, char **argv, char **azColName );

static int PetSqlResult2 ( void *data, int argc, char **argv, char **azColName );

#endif // __PETSQLITE_
