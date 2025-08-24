
!ABCIncludeFile

  OMIT('_EndOfInclude_',_bcpImporter_)
_bcpImporter_   EQUATE(1)
  
  include('bcpImportVarType.inc'),once
  include('IbcpImportVar.inc'),once
  include('queueDefines.inc'),once
  include('bcpFileAccess.inc'),once

!!!<summary>
!!! file definition for the tps file used by the demo 
!!!</summary>
TpsTable  file,driver('topSpeed')
Pk_Bei       key(BusinessEntityID),primary            
Record                    record,pre()
BusinessEntityID      long
FirstName                  cstring(51) 
MiddleName              cstring(51)
LastName                  cstring(51)
EmailPromotion        long
                                end
                     end  

!!!<summary>
!!! used to import the testTable values from a queue.  the queue will contain 100,000 rows, all 100,000 rows are written in one call
!!!<summary>
testTableImport  class,implements(IbcpImportVar),type,module('bcpImporter.clw'),link('bcpImporter.clw',1),dll(0)
impQueue              &testTableQueue
importVar               &bcpImportVarType,private
!!!<summary>
!!! used for the bind calls when a date is used.  SQL server uses 3 bytes for a date and Clarion uses 4 bytes.
!!! there are other ways to handle the diference but this is easy to implement and understand and the server accepts
!!!<summary>
dateBinder             group(DATE_STRUCT),private
                                 end
!!!<summary>
!!! used for the bind calls when a time is used.  SQL server uses differnt size bytes for the time, the default is time(7), five bytes.  
!!! converting to a string works and again is fairly easy. If fractions of seconds are needed adjust the string size.  just be sure to use @t02 for the format or the server will not accept 
!!! single digits in the hour, minute and second fields 
!!!<summary>
timeBinder              string(8),private
!!!<summary>
!!! used for the bind calls when a decimal or numeric is used.  SQL server has an implict conversion for sting to decimal.
!!! 38 is max number of bytes for a decimal data type in SQL Server
!!!<summary>
decimalBinder        string(38),private
init                            procedure(*bcpImportVarType iv) 
destruct                   procedure(),virtual
readDataRow         procedure(long cnt),bool,virtual 
                             end

!!!<summary>
!!! used to import the testTableTwo values from a queue.  the queue will contain 100,000 rows and this one turns on batch mode and sets the 
!!! batch size to 24,000 rows.  
!!! recommend a review of batch mode is read on MSDN, there are some differences and they are important to understand. 
!!!<summary>
!!!<remarks> |
!!! this table has GUID in the third column with a default value of newid(), when calling the the bindColumns the third column is skipped.
!!! the system will handle
!!!</remarks> |
testTableTwoImport  class,implements(IbcpImportVar),type,module('bcpImporter.clw'),link('bcpImporter.clw',1),dll(0)
impQueue                       &testTableTwoQueue
importVar                        &bcpImportVarType,private
init                                    procedure(*bcpImportVarType iv) 
!!!<summary>
!!! used for the bind calls when a DateTime is used.  these are 8 bytes on the server.  the string is set to yyyy-mm-dd for the date portion 
!!! converting to a string works and again is fairly easy. just be sure to use @t02 for the format, except the year,  or the server will not accept 
!!! single digits in the month, day, hour, minute and second fields 
!!!<summary>
dateTimeBinder             string(19),private
destruct                           procedure(),virtual
readDataRow                 procedure(long cnt),bool,virtual 
                                     end

!!!<summary>
!!! used to import a TPS file.  does not have a queue the file fields are bound. As each row is read they are sent to the server. 
!!!<summary>
testTableThreeImport class,implements(IbcpImportVar),type,module('bcpImporter.clw'),link('bcpImporter.clw',1),dll(0)
fileAccess                         &bcpFileAccessType,private
importVar                          &bcpImportVarType,private
init                                      procedure(*bcpImportVarType iv) 
destruct                             procedure(),virtual
readDataRow                   procedure(long cnt),bool,virtual 
setupFile                           procedure(),bool 
                                       end 

  _EndOfInclude_