
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

testTableImport  class,implements(IbcpImportVar),type,module('bcpImporter.clw'),link('bcpImporter.clw',1),dll(0)
impQueue              &testTableQueue
importVar               &bcpImportVarType,private
dateBinder             group(DATE_STRUCT),private
                                 end
timeBinder              string(8),private
init                            procedure(*bcpImportVarType iv) 
destruct                   procedure(),virtual
readDataRow         procedure(long cnt),bool,virtual 
                             end

testTableTwoImport  class,implements(IbcpImportVar),type,module('bcpImporter.clw'),link('bcpImporter.clw',1),dll(0)
impQueue                       &testTableTwoQueue
importVar                        &bcpImportVarType,private
init                                    procedure(*bcpImportVarType iv) 
dateTimeBinder             string(19),private
destruct                           procedure(),virtual
readDataRow                 procedure(long cnt),bool,virtual 
                                     end

testTableThreeImport class,implements(IbcpImportVar),type,module('bcpImporter.clw'),link('bcpImporter.clw',1),dll(0)
fileAccess                         &bcpFileAccessType,private
importVar                          &bcpImportVarType,private
init                                      procedure(*bcpImportVarType iv) 
destruct                             procedure(),virtual
readDataRow                   procedure(long cnt),bool,virtual 
setupFile                           procedure(),bool 
                                       end 

  _EndOfInclude_