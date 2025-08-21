
member()
  
  include('odbcTypes.inc'),once
  include('bcpExportImport.inc'),once  
  include('svcom.inc'),once
  
  map
     module('bcpcodeExpImp')
       !!!<summary>
       !!! executes the BCP import or export for the current table.
       !!!</summary>
       !!!<param name='numRows'>
       !!!  the number of rows that were processed. 
       !!!</param name>
       !!!<returns>
       !!! true for success, false for failure.  zero rows may not indicate a failure, some times tabls are empty
       !!!</returns>
       bcp_Exec(*long numRows),bool,c,raw,name('Bcp_exec');
     end
  end

!region construct destruct init

bcpExportImportType.Construct procedure()

  code 
    
  return
! -----------------------------------------------------------------------------------

bcpExportImportType.destruct procedure()

   code

    parent.destruct()

    return
! -----------------------------------------------------------------------------------

bcpExportImportType.init procedure(string outPath)

   code

   parent.init(outPath)

   return
! -----------------------------------------------------------------------------------

!endregion construct destruct init

!region bcp interface 

bcpExportImportType.init_bcp  procedure(string tName, string sName, string dataFilePath, short direction) !,bool

on    long(1)
retv retcode,auto

    code
    
    retv = self.prepWideStr(tName, sName, dataFilePath)
    
    if (retv = bcp_Success) 
      retv = self.callInit_bcp(direction)
    end

    return retv
! -----------------------------------------------------------------------------------

bcpExportImportType.bcp_Exec procedure(*long numberRows)

retv bool,auto

  code 

  retv = bcp_Exec(numberRows)

  return retv
! -----------------------------------------------------------------------------------

bcpExportImportType.prepWideStr procedure(*string tName, *string sName, string dataFileName) !,private,retCode

retv         retcode(bcp_success)
worker    string(sysNameLen*2),auto
fullName string(sysNameLen*2),auto

  code

   fullName = clip(sName) & '.' & tName   
   if (self.initWideStr(self.tableName, fullName) = false)
      retv = bcp_fail
   end

    if (self.initWideStr(self.outFileName, dataFileName) = false) 
       retv =  bcp_Fail
    end
    
    worker = self.buildFileName(fullName, self.logFileExt)
    if (self.initWideStr(self.logFileName, worker) = false)
       retv =  bcp_Fail
    end
   
   return retv
! -----------------------------------------------------------------------------------

!endregion bcp interface 

