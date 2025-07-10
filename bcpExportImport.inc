
!ABCIncludeFile

  OMIT('_EndOfInclude_',_bcpExportImport_)
_bcpExportImport_   EQUATE(1)

  include('odbcTypes.inc'),once
  include('svcom.inc'),once
  
!!!<summary>
!!! object to export or import data tables from an SQL Server instance.  This object uses the binary file format from the BCP for the data file in or out.
!!!</summary>
bcpExportImportType  class,type,module('bcpExportImport.clw'),link('bcpExportImport.clw',1),dll(0)

!region fields 

!!!<summary>
!!! name of the table that will be processed 
!!!</summary>
tableName             &CWideStr,private
!!!<summary>
!!! full path for the table to be exported into or used to import from 
!!!</summary>
outFileName          &CWideStr,private
!!!<summary>
!!! full path for the log file if there are any errors. 
!!!</summary>
logFileName          &CWideStr,private
!!!<summary>
!!! path for the data file and the log file
!!!</summary>
!!!<remarks>
!!! set from the init procedure parameter and is required
!!!</remarks>
outputPath             string(256),private
!!!<summary>
!!! file extension used for the data file 
!!!</summary>
dataFileExt              string(6),private
!!!<summary>
!!! file extension used for the log file 
!!!</summary>
logFileExt                string(6),private

!endregion fields 

!region setters and getters 

!!!<summary>
!!! gets the output path 
!!!</summary>
getoutputPath        procedure(),string
!!!<summary>
!!! sets the file extension for the data file
!!! call before starting the BCP process
!!!</summary>
setDataFileExt        procedure(string s)
!!!<summary>
!!! gets the file extension for the data file
!!!</summary>
getDataFileExt        procedure(),string
!!!<summary>
!!! sets the file extension for the log file
!!! call before starting the BCP process
!!!</summary>
setLogFileExt          procedure(string s)

!endregion setters and getters 

!region construct destruct init

!!!<summary>
!!! constructor for the object.  Allocates the wide strings that will be used.
!!!</summary>
construct                 procedure()
!!!<summary>
!!! destructor for the object.  deletes the wide strings that were used.
!!!</summary>
destruct                   procedure(),virtual

!!!<summary>
!!! init function used to set the path for the data files and the log files 
!!!</summary>
!!!<param name='outPath'>
!!! path for the data and log files.  The path must exists before use.
!!!</param name'>
!!!<remarks>
!!! sets default values for the log and data files.
!!! this must be called once after the object is created and before any process is started. 
!!! if not called the BCP process will fail.
!!!</remarks>
init                             procedure(string outPath)

!endregion construct destruct init

!region BCP interface

!!!<summary>
!!! interface to the C code, calls the ClaBcpInit function to allocate the enviorment handle and set the ODBC version
!!!</summary>
BcpInit                  procedure(),bool

!!!<summary>
!!! interface to the C code, calls the ClaBcpConnect function to make the database connection and sets the BCP, turned on, option for the connection handle 
!!!</summary>
!!!<param name = 'cs'>
!!! an instsnce of the connection string primed.
!!!</param name>
BcpConnect         procedure(*cstring connStr),bool

!!!<summary>
!!! interface to the C code, calls the init_Bcp to initialize the BCP for each table.  
!!! calls prepWideStr to set up the table and schema names, the data file name and the log file name
!!!</summary>
!!!<param name = 'tName'>
!!! table name that will be imported or exported
!!!<//param name = 'tName'>
!!!<param name = 'sName'>
!!! schema name for the tbale 
!!!</param name = 'tName'>
!!!<remarks>
!!! data file and log file will be full paths, including the file name. the file names are built from the table name
!!! this is called once for each table.
!!!</remarks>
init_bcp                procedure(string tName, string sName, short direction),retcode

!!!<summary>
!!! overloaded function
!!! interface to the C code, calls the init_Bcp to initialize the BCP for each table.  
!!! calls prepWideStr to set up the table and schema names, 
!!! the data file path value input will be used for the process
!!!</summary>
!!!<param name = 'tName'>
!!! table name that will be imported or exported
!!!</param name>
!!!<param name = 'sName'>
!!! schema name for the table 
!!!</param name>
!!!<param name = 'dataFilePath'>
!!! full path for the data file. 
!!!</param name>
!!!<remarks>
!!! the log file will be built from the table name and the data file will use 
!!! the full path from the input.
!!! this is called once for each table.
!!!</remarks>
init_bcp                procedure(string tName, string sName, string dataFilePath, short direction),bool

!!!<summary>
!!! interface to the C code, calls the bcp_Exec function to execute the process
!!!</summary>
!!!<param name = 'numberRows'> |
!!! the number of rows processed is ouput 
!!!</param name>
!!!<remarks>
!!! this is called once for each table.
!!!</remarks>
bcp_Exec            procedure(*long numberRows) 

!!!<summary>
!!! interface to the C code, bcp_control function to set one of the various options 
!!!</summary>
!!!<param name = 'eOption'> |
!!! the constant value used to indicate the option 
!!!</param name>
!!!<param name = 'eOption'> |
!!! value on or off for the option, true/false
!!!</param name>
!!!<remarks>
!!! this can called called once for each table.
!!! The options can be the same for each table of different options may be used.
!!! currently the only option used is keep idenity column values.  
!!! adjust based on the situation for the specific tables
!!!</remarks>
bcp_Control        procedure(long eOption, *long iValue),bool

!endregion BCP interface

!region private workers 

!!!<summary>
!!! sets up the CWideStr for use in the process.  calls initWideStr for each string
!!! calls buildFileName for the data file and log file
!!!</summary>
!!!<param name = 'tName''> |
!!! the table name to be processed
!!!</param name>
!!!<param name = 'tName''> |
!!! the schecma name to be processed
!!!</param name>
!!!<returns>
!!! retCode with the value of bcp_Success or bcp_Fail
!!!</returns>
prepWideStr      procedure(*string tName, *string sName),private,retCode

!!!<summary>
!!! sets up the CWideStr for use in the process.  calls initWideStr for each string
!!! calls buildFileName for the log file
!!!</summary>
!!!<param name = 'tName''> 
!!! the table name to be processed
!!!</param name>
!!!<param name = 'tName''> 
!!! the schecma name to be processed
!!!</param name>
!!!<param name = 'dataFile''> 
!!! the complete path for the data file.  this will be called when the table queue dFile field is primed
!!!</param name>
!!!<returns>
!!! retCode with the value of bcp_Success or bcp_Fail
!!!</returns>
prepWideStr     procedure(*string tName, *string sName, *string dataFile),private,retCode

!!!<summary>
!!! init's a CWdieStr for use. Calls Release to clear the object and then the strings Init function.
!!!</summary>
!!!<param name = 'cw''>
!!! instance to be cleared and assigned
!!!</param name>
!!!<param name = 's''> 
!!! source string or value for the wide string
!!!</param name>
!!!<returns>
!!! true for success, false for failure. 
!!!</returns>
initWideStr         procedure(CWideStr cw, *string s),private,bool

!!!<summary>
!!! builds the file names for the data and log files, not called for the table name
!!! the file name will have the '.' replaced with an '_'
!!!</summary>
!!!<param name = 'tn''> 
!!! the table name that is used to build the file names
!!!</param name>
!!!<param name = 'ext''>
!!! the file extension for the specific file
!!!</param name>
!!!<returns>
!!! string primed with the file path to use 
!!!</returns>
buildFileName   procedure(string tn, string ext),string,private

!endregion private workers 

                         end

  _EndOfInclude_