#pragma once

#include <sql.h>
#include <sqlext.h>

#include <sqltypes.h>

#include <atlstr.h>

//#define _SQLNCLI_ODBC_

// example path, adjust as needed for local system
// using a full path is a one off and done for the demo 
// change the path, as needed, for the newer ODBC drivers 11,13,17,...
// there was some changes in the header files so use the correct header file or 
// the process will go south 
#include "C:\Program Files (x86)\Microsoft SQL Server\110\SDK\Include\sqlncli.h"			

#define DllExport   __declspec( dllexport )


extern "C" {
  DllExport HENV ClaBcpInit();

  DllExport int ClaBcpKill();

  DllExport HDBC ClaBcpConnect(char *connStr);

  // there are other functions in the API but this is all we need for inserts
  DllExport bool Bcp_init(LPCTSTR tName, LPCTSTR dataFile, LPCTSTR logFile, INT direction);
  DllExport bool sendRow_Bcp();
  DllExport long batch_bcp();
  DllExport int done_Bcp();
  DllExport bool Bcp_exec(LPDBINT pnRowsProcessed);
  DllExport RETCODE Bcp_control(INT eOption,void* iValue);
  DllExport RETCODE Bcp_setbulkmode(INT property, void* pField, INT cbField, void* pRow, INT cbRow);

#pragma region numbers
  // calls bcp_bind for the data type
  DllExport bool bind_Byte(byte *colv, long colOrd);
  DllExport bool bind_Short(short *colv, long colOrd);
  DllExport bool bind_Long(long *colv, long colOrd);
  DllExport bool bind_Real(double* colv, long colOrd);
  DllExport bool bind_Float(float* colv, long colOrd);
  DllExport bool bind_Decimal(char *colv, long colOrd);

  DllExport bool bind_Bool(bool* colv, long colOrd);
#pragma endregion numbers

#pragma region strings

  DllExport bool bind_String(char colv[], long colOrd, long slen);
  DllExport bool bind_CString(char colv[], long colOrd);

#pragma endregion

#pragma region Date times

  DllExport bool bind_Date(DATE_STRUCT *colv, long colOrd);

  DllExport bool bind_DateTime(char *colv, long colOrd);
  DllExport bool bind_Time(char *colv, long colOrd);

#pragma endregion Date times

  char *tableName;

  // holds the environment handle
  HENV    hEnv;

  // holds the connection handle from the calling instance database
  // set once and used until done
  HDBC		hDbc;
}