
!ABCIncludeFile

  OMIT('_EndOfInclude_',_bcpExportImport_)
_bcpExportImport_   EQUATE(1)

  include('odbcTypes.inc'),once
  include('svcom.inc'),once
  include('bcpBaseExportImport.inc'),once
  
!!!<summary>
!!! object to export or import data tables from an SQL Server instance.  This object uses the binary file format from the BCP for the data file in or out.
!!!</summary>
bcpExportImportType  class(bcpBaseExportImportType),type,module('bcpExportImport.clw'),link('bcpExportImport.clw',1),dll(0)

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
init                             procedure(string outPath),virtual

!endregion construct destruct init

!region BCP interface

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
bcp_Exec            procedure(*long numberRows),bool 

!endregion BCP interface

!!!<summary>
!!! prepares the CWideStr objects for the BCP call. 
!!!</summary>
!!!<param name = 'tName'> 
!!! the current table name 
!!!</param name>
!!!<param name = 'sName'> 
!!! the schema name for the table name
!!!</param name>
!!!<param name = 'dataFileName'>
!!! the full path, including the file name, for the data file used for import or exported into
!!!</param name>
!!!<returns>
!!! retCode value indicating success or failure.
!!!</returns>
!!!<remarks>
!!! typical use is for the import whne the data files do not match the patteren from the schema.table 
!!! can be used for export if needed/wanted.
!!! this is called once for each table.
!!!</remarks>
prepWideStr procedure(*string tName, *string sName, string dataFileName),retCode,protected

                         end

  _EndOfInclude_