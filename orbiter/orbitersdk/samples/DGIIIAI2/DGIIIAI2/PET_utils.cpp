/*
PET_utils.cpp
*/

#include "PET_utils.h"

using namespace std;


/**
Cast a string to double.
*/
double PetS2D ( std::string p_string )
{
	std::string str = p_string; 	
	double result;
	
	istringstream(str) >> result; 
	return result;
}


/**
Cast a double to string.
*/
std::string PetD2S(double p_value)
{
	double value=p_value;
	std::ostringstream strs;
	
	strs << value;
	std::string result = strs.str();
	return result;
}


/**
Cast a string to int.
*/
int PetS2I(std::string p_string)
{
	std::string str=p_string; 	
	int result;
	
	istringstream(str) >> result; 
	return result;
}


/**
Cast a double to char.
*/
const char* PetD2Cc(double p_num)
{
	const char* result=PetD2S(p_num).c_str();
	return result;
}


/**
Cast an int to string.
*/
std::string PetI2S(int p_value)
{
	int value=p_value;
	std::ostringstream strs;
	
	strs << value;
	std::string result = strs.str();
	return result;
}


/*double PetDw2D(dword p_value)
{
	std::string str=p_value
	return PetS2D();
}*/


/**
Casts a boolean value as a real number. true = 1.00, false=0.00.
*/
double PetB2D(bool p_val)
{
	double result=0.00;
	
	if (p_val==true)
	{
		result=1.00;	
	}
	return result;
}


/**
Casts a real number as a bool value. 1.00 = true, false otherwise.
*/
bool PetD2B(double p_val)
{
	bool result=false;
	
	if (p_val==1.00)
	{
		result=true;	
	}
	return result;
}


/**
Truncates input value into the interval [-1.00,1.00]. all values < min will 
become min, and all values passed > max will be returned as 1.
*/
double PetTruncate(double p_min, double p_max, double p_val)
{
	double result=p_val;

	if(p_min>p_max)
	{
		p_min=0.00;
		p_max=0.00;	
	}
	if (result < p_min)
	{
		result=p_min;	
	}
	if (result > p_max)
	{
		result=p_max;	
	}
	return result;
}


/**
Returns as a result the last element of a vector of results.
*/
double PetRes2D(std::vector<std::string>&p_sql_results)
{
	double result=0;
	std::string svalue;	
	
	int n=p_sql_results.size();
	svalue=p_sql_results[n-1];
	result=PetS2D(svalue);	
	p_sql_results.erase(p_sql_results.begin(),p_sql_results.end());	
	return result;
}


/**
Converts radians to degrees.

Parameters:
- p_rad: value expressed in radians.

- Returns:
- Value expressed in degrees as a double type.
*/
double PetRad2Deg(double p_rad)
{
	return (p_rad * 57.2958);
}


/**
Converts degrees to radians.

Parameters:
- p_deg: value expressed in degrees as a double.

- Returns:
- Value expressed in radians as a double type.
*/
double PetDeg2Rad(double p_deg)
{
	return (p_deg / 57.2958);
}


/**
returns true if p_num is positive, false otherwise.
*/
bool PetIsPositive ( double p_num )
{
	if ( p_num >= 0.00 )
	{
		return true;
	}
	else
	{
		return false;
	}
}


/**
Calculates the great circle distance and heading between two points using the 
haversine formula. 

Parameters:
- Vector p_vec of length nine, with the following structure.
-- [0]: current lat.
-- [1]: current lon.
-- [2]: current alt.
-- [3]: target lat.
-- [4]: target lon.
-- [5]: target alt.
-- [6]: leg brg.
-- [7]: leg dist.
-- [8]: leg alt.

Returns
- Vector p_vec with updated values.

Sources:
- http://www.movable-type.co.uk/scripts/latlong.html

*/
std::vector<double> PetGreatCircleRoute( std::vector<double> &p_vec )
{
	/*New altitude. For now, just use p_target.z and the distance to target will be
	calculated by that arc, not by the arc defined by the surface of the celestial body. This 
	seems more accurate, since the real distance traveled by the ship will correspond to the
	arc defined at mean altitude instead at MSL. However, since ship will need to fly at a
	cruise level, instead of using the mean value of altitudes, it is better to use the
	target altitude as cruise altitude, so that the ship acquires it on the beginning of the
	leg. 
	*/
	p_vec[8] = p_vec[5];
	
	//Convert to radians r lat, l, lon.
	double r1 = PetDeg2Rad ( p_vec[0] );
	double r2 = PetDeg2Rad ( p_vec[3] );
	double l1 = PetDeg2Rad ( p_vec[1] );
	double l2 = PetDeg2Rad ( p_vec[4] );
	double dr = r2 - r1;
	double dl = l2 - l1;
	
	/*Calculate distance:
	 a = sin²(Δφ/2) + cos φ1 ⋅ cos φ2 ⋅ sin²(Δλ/2)
	 c = 2 ⋅ atan2( √a, √(1−a) )
	 d = R ⋅ c 
	*/
	double a = pow ( sin ( dr / 2 ), 2) + ( cos ( r1 ) * ( cos ( r2 ) * pow ( sin ( dl / 2 ), 2 ) ) );
	p_vec[7] = p_vec[8] * ( 2 * pow ( atan ( sqrt ( a ) / sqrt ( ( 1 - a ) ) ), 2 )  );
		
	/*Calculate heading (updated on each instance as Initial bearing (forward azimuth))
	 θ = atan2( sin Δλ ⋅ cos φ2 , cos φ1 ⋅ sin φ2 − sin φ1 ⋅ cos φ2 ⋅ cos Δλ )
	*/
	//p_vec[6] = pow ( atan ( ( sin ( dl ) * cos ( r2 ) ) / ( ( cos ( r1 ) * sin ( r2 ) ) - ( sin ( r1 ) * cos ( r2 ) * cos ( dl ) ) ) ), 2 );
	p_vec[6] = PetRad2Deg ( pow ( atan ( ( sin ( dl ) * cos ( r2 ) ) / ( ( cos ( r1 ) * sin ( r2 ) ) - ( sin ( r1 ) * cos ( r2 ) * cos ( dl ) ) ) ), 2 ) );

	return p_vec;
}


/**
Calculates coordinates of a target point based on current coordinates, a given bearing and distance.

Parameters:
- Vector p_vec of length nine, with the following structure.
-- [0]: current lat.
-- [1]: current lon.
-- [2]: current alt.
-- [3]: target lat.
-- [4]: target lon.
-- [5]: target alt.
-- [6]: leg brg.
-- [7]: leg dist.
-- [8]: leg alt.

Returns
- Vector p_vec with updated values. In this case, 3,4,5 provide the desired results.

Sources:
- http://www.movable-type.co.uk/scripts/latlong.html
*/
std::vector<double> PetBrgDist2Point( std::vector<double> &p_vec )
{
	p_vec[8] = p_vec[5];
	
	//Convert to radians r lat, l, lon.
	double r1 = PetDeg2Rad ( p_vec[0] );
	//double r2 = PetDeg2Rad ( p_vec[3] );
	double l1 = PetDeg2Rad ( p_vec[1] );
	//double l2 = PetDeg2Rad ( p_vec[4] );
	//double dr = r2 - r1;
	//double dl = l2 - l1;
	double g = PetDeg2Rad ( p_vec[6] );
	
	//φ2 = asin( sin φ1 ⋅ cos δ + cos φ1 ⋅ sin δ ⋅ cos θ )
	//λ2 = λ1 + atan2( sin θ ⋅ sin δ ⋅ cos φ1, cos δ − sin φ1 ⋅ sin φ2 )	
	//	where 	φ is latitude, λ is longitude, θ is the bearing (clockwise from north), δ is the angular 
	//distance d/R; d being the distance travelled, R the earth’s radius
	double r2 = asin ( ( ( sin ( r1 ) * cos ( g ) ) + ( ( cos ( r1 ) * sin ( g ) ) * cos (  ) ) ) );	

	return p_vec;
}
