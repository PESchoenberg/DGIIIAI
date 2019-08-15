/*
PET_utils.h
*/

#ifndef __PETUTILS_
#define __PETUTILS_

#include "stdafx.h"

//------------------------------------------------------------------.....-------

/**
Functions.
*/

double PetS2D ( std::string p_string );

std::string PetD2S ( double p_value );

int PetS2I ( std::string p_string );

std::string PetI2S ( int p_value );

const char* PetD2Cc ( double p_num );

double PetB2D ( bool p_val );

//double PetDw2D ( dword p_value );

bool PetD2B ( double p_val );

double PetTruncate ( double p_min, double p_max, double p_val );

double PetRes2D ( std::vector<std::string>&p_sql_results );

double PetRad2Deg ( double p_rad );

double PetDeg2Rad ( double p_deg );

bool PetIsPositive ( double p_num );

std::vector<double> PetGreatCircleRoute( std::vector<double> &p_vec );

std::vector<double> PetBrgDist2Point( std::vector<double> &p_vec );

#endif // __PETUTILS_
