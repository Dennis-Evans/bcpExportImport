// cla_bcp.cpp : Defines the exported functions for the DLL application.
//

#include "stdafx.h"
#include "cla_bcp.h"

DllExport HENV ClaBcpInit() {

  SQLRETURN result; 
  
  result = SQLAllocHandle(SQL_HANDLE_ENV, NULL, &hEnv);
  //result = SQLAllocEnv(&hEnv);
  if ((result != SQL_SUCCESS) && (result != SQL_SUCCESS_WITH_INFO)) {
    hEnv = 0;
  }
  else {
    result = SQLSetEnvAttr(hEnv, SQL_ATTR_ODBC_VERSION, (SQLPOINTER)SQL_OV_ODBC3_80, SQL_IS_INTEGER);
    if ((result != SQL_SUCCESS) && (result != SQL_SUCCESS_WITH_INFO)) {
      SQLFreeHandle(SQL_HANDLE_ENV, hEnv);
      hEnv = 0;
    }
  }

  return hEnv;
} // end ClaBcpInit
// ------------------------------------------------------------------------

DllExport int ClaBcpKill() {

  if (hDbc > (HDBC)0) {
    SQLFreeHandle(SQL_HANDLE_DBC, hDbc);
    hDbc = 0;
  }
  if (hEnv > (HENV)0) {
    SQLFreeHandle(SQL_HANDLE_ENV, hEnv);
    hEnv = 0;
  }

  return 0;
} // end ClaBcpKill
// -----------------------------------------------------------------------

DllExport HDBC ClaBcpConnect(char* connStr) {

  unsigned char		sqlState[6];
  SQLINTEGER	errPtr;
  unsigned char 		msgTxt[256];
  SQLSMALLINT txtLen;
  SQLRETURN result;
  SQLWCHAR		  outconnStr[2048];
  SQLSMALLINT	connStrLen;
  CString cs = connStr;

  result = SQLAllocConnect(hEnv, &hDbc);
  if (result != SQL_SUCCESS && result != SQL_SUCCESS_WITH_INFO)  {
    SQLGetDiagRecA(SQL_HANDLE_ENV, hEnv, 1, sqlState, &errPtr, msgTxt, 255, &txtLen);
    return hDbc;
  }

  result = SQLSetConnectAttr(hDbc, SQL_COPT_SS_BCP, (void *)SQL_BCP_ON, SQL_IS_INTEGER);

  if (result != SQL_SUCCESS && result != SQL_SUCCESS_WITH_INFO) {
    SQLFreeConnect(hDbc);
    hDbc = NULL;
    return hDbc;
  }

  result = SQLDriverConnect(hDbc, NULL, cs.GetBuffer(), cs.GetLength(), outconnStr, sizeof(outconnStr) / 2, &connStrLen, SQL_DRIVER_NOPROMPT);
  if (result != SQL_SUCCESS && result != SQL_SUCCESS_WITH_INFO) {
    SQLFreeConnect(hDbc);
    hDbc = NULL;
    return hDbc;
  }

  return hDbc;
} // end ClaBcpConnect
// ------------------------------------------------------------------------

DllExport bool Bcp_init(LPCTSTR tName, LPCTSTR dataFile, LPCTSTR logFile, INT direction) {
  
  bool retv = true;

  if (bcp_init(hDbc, tName, dataFile, logFile, direction) == FAIL) {
    retv = false;
  }
  
  return retv;
} // end init_bcp
// -----------------------------------------------------------

DllExport bool Bcp_exec(LPDBINT pnRowsProcessed) {

  bool retv = true;

  if (bcp_exec(hDbc, pnRowsProcessed) == FAIL) {
    retv = false; 
  }
  
  return retv;
}

DllExport RETCODE Bcp_control(INT eOption, void* iValue) {

  RETCODE retv;

  retv = bcp_control(hDbc, eOption, iValue);
  
  return retv;  
}

DllExport RETCODE Bcp_setbulkmode(INT property, void* pField, INT cbField, void* pRow, INT cbRow) {

  RETCODE retv;
  char ColTerm[] = "\t";
  char RowTerm[] = "\r\n";
  //wchar_t wColTerm[] = L"\t";
  //wchar_t wRowTerm[] = L"\r\n";
  BYTE* pColTerm = NULL;
  int cbColTerm = NULL;
  BYTE* pRowTerm = 0;
  int cbRowTerm = 0;
  int bulkmode = -1;

  pColTerm = (BYTE*)ColTerm;
  pRowTerm = (BYTE*)RowTerm;
  cbColTerm = 1;
  cbRowTerm = 2;
  retv = bcp_setbulkmode(hDbc, BCP_OUT_WIDE_CHARACTER_MODE, pColTerm, cbColTerm, pRowTerm, cbRowTerm);

  return retv;
}

DllExport bool sendRow_Bcp() {

  bool retv = true;
  
  if (bcp_sendrow(hDbc) == FAIL) {
    retv = false;
  }

  return retv;
} // end sendRow_bcp 
// -----------------------------------------------------------------

DllExport long batch_bcp() {

  long retv;

  retv = bcp_batch(hDbc);

  return retv;
} // end batch_bcp
// ----------------------------------------------------------------

DllExport int done_Bcp() {

  int retv;

  retv = bcp_done(hDbc);

  return retv;
} // end done_bcp
// ------------------------------------------------------------------

#pragma region numbers

// calls bcp_bind for the data type
DllExport bool bind_Byte(byte *colv, long colOrd) {

  bool retv = true;

  if (bcp_bind(hDbc, (LPCBYTE)colv, 0, sizeof(byte), NULL, 0, SQLINT1, colOrd) == FAIL) {
    retv = false;
  }

  return retv;
} // end bind_Bcp
// -------------------------------------------------------------

DllExport bool bind_Short(short *colv, long colOrd) {

  bool retv = true;

  if (bcp_bind(hDbc, (LPCBYTE)colv, 0, sizeof(short), NULL, 0, SQLINT2, colOrd) == FAIL) {
    retv = false;
  }

  return retv;
} // end bind_Bcp
// -------------------------------------------------------------

// calls bcp_bind for the data type
DllExport bool bind_Long(long *colv, long colOrd) {

  bool retv = true;

  if (bcp_bind(hDbc, (LPCBYTE)colv, 0, sizeof(long), NULL, 0, SQLINT4, colOrd) == FAIL) {
    retv = false;
  }

  return retv;
} // end bind_Bcp
// -------------------------------------------------------------

DllExport bool bind_Real(double* colv, long colOrd) {

  bool retv = true;

  if (bcp_bind(hDbc, (LPCBYTE)colv, 0, sizeof(double), NULL, 0, SQLFLT8, colOrd) == FAIL) {
    retv = false;
  }

  return retv;
} // end bind_Bcp
// -------------------------------------------------------------

DllExport bool bind_Float(float* colv, long colOrd) {

  bool retv = true;

  if (bcp_bind(hDbc, (LPCBYTE)colv, 0, sizeof(float), NULL, 0, SQLFLT4, colOrd) == FAIL) {
    retv = false;
  }

  return retv;
} // end bind_Bcp
// -----------------------------------------------------------

DllExport bool bind_Bool(bool* colv, long colOrd) {

  bool retv = true;

  if (bcp_bind(hDbc, (LPCBYTE)colv, 0, sizeof(bool), NULL, 0, SQLBIT, colOrd) == FAIL) {
    retv = false;
  }

  return retv;
} // end bind_Bcp
// -------------------------------------------------------------

#pragma endregion

#pragma region strings 

DllExport bool bind_String(char colv[], long colOrd, long slen) {

  bool retv = true;

  if (bcp_bind(hDbc, (LPCBYTE)colv, 0, slen, NULL, 0, SQLCHARACTER, colOrd) == FAIL) {
    retv = false;
  }

  return retv;
} // end bind_Bcp
// -------------------------------------------------------------

DllExport bool bind_CString(char colv[], long colOrd) {

  bool retv = true;

  if (bcp_bind(hDbc, (LPCBYTE)colv, 0, SQL_VARLEN_DATA, (LPCBYTE)"", 1, SQLCHARACTER, colOrd) == FAIL) {
    retv = false;
  }

  return retv;
} // end bind_Bcp
// -----------------------------------------------------------

#pragma endregion 

#pragma region Date times

DllExport bool bind_Date(DATE_STRUCT *colv, long colOrd) {

  bool retv = true;

  if (bcp_bind(hDbc, (LPCBYTE)colv, 0, sizeof(DATE_STRUCT), NULL, 0, SQLDATEN, colOrd) == FAIL) {
    retv = false;
  }

  return retv;
} // end bind_Bcp
// -------------------------------------------------------------

DllExport bool bind_DateTime(char *colv, long colOrd) {

  bool retv = true;

  //if (bcp_bind(hDbc, (LPCBYTE)colv, 0, sizeof(SQL_TYPE_TIMESTAMP), NULL, 0, SQLDATETIME, colOrd) == FAIL) {
  if (bcp_bind(hDbc, (LPCBYTE)colv, 0, 19, NULL, 0, SQLCHARACTER, colOrd) == FAIL) {
    retv = false;
  }

  return retv;
} // end bind_Bcp
// -------------------------------------------------------------

DllExport bool bind_Time(char *colv, long colOrd) {

  bool retv = true;

  if (bcp_bind(hDbc, (LPCBYTE)colv, 0, 8, NULL, 0, SQLCHARACTER, colOrd) == FAIL) {
    retv = false;
  }

  return retv;
} // end bind_Bcp
// -----------------------------------------------------------

#pragma endregion