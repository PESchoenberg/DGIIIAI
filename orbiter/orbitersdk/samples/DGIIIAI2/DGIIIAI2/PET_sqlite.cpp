/*
PET_sqlite.cpp
*/

#include "PET_sqlite.h"

using namespace std;

/**
Update a record's Value field defined by its Item. 
*/
std::string PetStrUval ( std::string p_sitem, std::string p_svalue )
{			
	std::string sql_sentence = "UPDATE sde_facts SET Value = "+p_svalue+" WHERE Status = 'sentodb' AND Item = '"+p_sitem+"'";
	return sql_sentence;
}

/**
Update a record's Probability field defined by its Item. 
*/
std::string PetStrProb ( std::string p_sitem, std::string p_sprob )
{			
	std::string sql_sentence = "UPDATE sde_facts SET Probability = "+p_sprob+" WHERE Status = 'sentodb' AND Item = '"+p_sitem+"'";
	return sql_sentence;
}

/**
Update a record's Value and Probability fields defined by its Item. 
*/
std::string PetStrUvalProb ( std::string p_sitem, std::string p_svalue, std::string p_sprob )
{			
	std::string sql_sentence = "UPDATE sde_facts SET Value = "+p_svalue+", Probability = "+p_sprob+" WHERE Status = 'sentodb' AND Item = '"+p_sitem+"'";
	return sql_sentence;
}

/**
Retrieve a value for a given record characterized by its Item and status. 
*/
std::string PetStrUite ( std::string p_sitem )
{			
	std::string sql_sentence = "SELECT Value FROM sde_facts WHERE (Status = 'dbtoact' and Item = '"+p_sitem+"')";		
	return sql_sentence;
}

/**
Callback result function.
*/
static int PetSqlResult1 ( void *data, int argc, char **argv, char **azColName )
{
   int i;
   fprintf ( stderr, "%s: ", ( const char* ) data );
   for ( i = 0; i < argc; i++ )
   {
      printf ( "%s = %s\n", azColName[i], argv[i] ? argv[i] : "NULL" );
   }
   printf("\n");
   return 0;
}

/**
Callback result function.
*/
static int PetSqlResult2 ( void *data, int argc, char **argv, char **azColName )
{
   int i;

   for ( i = 0; i < argc; i++ )
   {
      printf ( "%s = %s\n", azColName[i], argv[i] ? argv[i] : "NULL" );
   }
   printf ( "\n" );
   return 0;
}
