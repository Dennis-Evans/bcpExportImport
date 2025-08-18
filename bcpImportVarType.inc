
!ABCIncludeFile

  OMIT('_EndOfInclude_',_bcpImportVar_)
_bcpImportVar_   EQUATE(1)

  include('odbcTypes.inc'),once
  include('svcom.inc'),once
  include('bcpBaseExportImport.inc'),once
  include('IbcpImportVar.inc'),once
  include('bcpVarFuncs.inc'),once
  include('queueDefines.inc'),once

!!!<summary>
!!! queue to hold the table names that will be imported.
!!!</summary>
tableQueue  queue(tableNameQue),type
importVar       &IbcpImportVar
               end

!!!<summary>
!!! object to import data from program variables into an SQL Server instance.  
!!!</summary>
bcpImportVarType  class(bcpBaseExportImportType),type,module('bcpImportVarType.clw'),link('bcpImportVarType.clw',1),dll(0)

!region fields 

bcpFuncs   &bcpVarFuncsType

!!!<summary>
!!! a list of the tables that will be imported 
!!!</summary>
tableQ        &tableQueue,private
!!!<summary>
!!! flag to indicate if using batch mode is one, default is off
!!!</summary>
batchMode bool,private
!!!<summary>
!!! rows that have been processed
!!!</summary>
rows            long,private
!!!<summary>
!!! if batch mode is on this is the size of the batch
!!!</summary>
batchSize   long,private
!!!<summary>
!!! total rows that have been processed, incremented when batch mode is on
!!!</summary>
totalRows    long,private
!endregion fields

!region setters 
!!!<summary>
!!! sets the rows processed to zero 
!!!</summary>
setBatchMode procedure()
setBatchSize   procedure(long numberRows)
!endregion setters 

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

!region writes 
!!!<summary>
!!! sends a row to theserver, called for each row in the data source
!!!</summary>
!!!<returns>
!!! treu for success, false for failure
!!!</returns>
sendRowBcp procedure(),bool

!!!<summary>
!!! writes the data to the server when the size of the batch has been reached. 
!!!</summary>
!!!<returns>
!!! the number of rows written by the batch 
!!!</returns>
batchbcp procedure(),long

!!!<summary>
!!! ends the BCP for the table.  Any rows not written during the recent batchBcp call will be written
!!!</summary>
!!!<returns>
!!! the number of rows, if any, written.  there may not be any rows left to write whn this is called 
!!! or there may be some left, depends on the batch size 
!!!</returns>
doneBcp procedure(),long

!endregion writes 

!!!<summary>
!!! init the bcp for the table, called once for each table 
!!!</summary>
!!!<returns>
!!! true for success, false for failure
!!!</returns>
init_bcp  procedure(string tName, string sName),bool

!endregion BCP interface

!!!<summary>
!!! adds a table to the queue of tables that will be processed or imported
!!!</summary>
!!!<param name = 'tName'>
!!! table name to be added to the table queue 
!!!</param name>
!!!<param name = 'sName'>
!!! schema name for the table
!!!</param name>
!!!<param name = 'importer'>
!!! instance of the interface used to import the table
!!!</param name>
AddTable            procedure(string tName, string sName, *IbcpImportVar importer),virtual

!!!<summary>
!!! processes the data from the source
!!!</summary>
processData       procedure(*IbcpImportVar importer),bool,virtual

!!!<summary>
!!! iterates of the queue of tabels and processes each 
!!!</summary>
!!!<returns>
!!! true for success, false for failure
!!!</returns>
!!!<remarks>
!!! if a table fails then continue processing or end the process, will vary some depending of the use case 
!!!</remarks>
processTables   procedure(),bool,virtual

!!!<summary>
!!! checks the number of rows processed in the batch, if rows >= to the batch size the 
!!! bach bcp function is called and the rows are written and the count is reset to zero 
!!!</summary>
checkBatchSize procedure(),bool,virtual 

!!!<summary>
!!! prepares the CWideStr objects for the BCP call. 
!!!</summary>
!!!<param name = 'tName'> 
!!! the current table name 
!!!</param name>
!!!<param name = 'sName'> 
!!! the schema name for the table name
!!!</param name>
!!!<returns>
!!! retCode value indicating success or failure.
!!!</returns>
!!!<remarks>
!!! typical use is for the import when the bcp binary data file is not used. 
!!! when importing from variables there is no data file used.
!!! this is called once for each table.
!!!</remarks>
prepWideStr procedure(*string tName, *string sName),retCode,protected,virtual

                         end

  _EndOfInclude_