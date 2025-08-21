
member()
  
  include('odbcTypes.inc'),once
  include('bcpImportVarType.inc'),once  
  include('svcom.inc'),once
  
  map
  end

!region setters 
! default is off for batch mode, 
bcpImportVarType.setBatchMode procedure()

  code

  self.batchMode = true

  return 
! ----------------------------------------------------------------------

bcpImportVarType.setBatchSize   procedure(long numberRows)

  code

  self.batchSize = numberRows

  return
! ----------------------------------------------------------------------
!endregion setters 

!region construct destruct init

bcpImportVarType.Construct procedure()

  code 
 
  self.tableQ &= new(tableQueue)

  return
! -----------------------------------------------------------------------------------

bcpImportVarType.destruct procedure()

   code
   return
! -----------------------------------------------------------------------------------

bcpImportVarType.init procedure(string outPath)

   code

   parent.init(outPath)
   if (self.tableQ &= null) 
     self.tableQ &= new(tableQueue)
   end 

   return
! -----------------------------------------------------------------------------------

!endregion construct destruct init

!region bcp interface 

bcpImportVarType.init_bcp  procedure(string tName, string sName) !,bool

retv retcode,auto

    code
    
    retv = self.prepWideStr(tName, sName)
    ! import variables always DB_IN
    if (retv = bcp_Success) 
      retv = self.callInit_bcp(DB_IN)
    end

    return retv
! -----------------------------------------------------------------------------------

!region writes 

bcpImportVarType.sendRowBcp procedure() !,bool

retv bool,auto 

   code

   retv = self.bcpFuncs.sendRowBcp();

   return retv;
! -------------------------------------------------------------------------------------------

bcpImportVarType.batchbcp procedure() !,long

retv long,auto

  code

  retv = self.bcpFuncs.batchbcp()

  return retv
! -----------------------------------------------------------------------------------------

bcpImportVarType.doneBcp procedure() !bool

retv long ,auto 

   code

   retv = self.bcpFuncs.doneBcp();

   return retv;
! -------------------------------------------------------------------------------------------

!endregion writes 

!endregion bcp interface 

!!!region tables 
bcpImportVarType.processTables procedure() !,bool,virtual

retv                 bool(false)
tableCnt         long,auto
numberRows long,auto

  code

   loop tableCnt = 1 to records(self.tableQ)
     get(self.tableQ, tableCnt)
     retv = self.init_bcp(self.tableQ.tName, self.tableQ.sName) 
     if (retv = false) 
       break
     else    
       !self.bcpSetbulkmode()
       retv = self.processData(self.tableQ.importVar)
       ! call the done function even if the processData call fails 
       ! the bound columns and the table need to be cleaned up
       ! if not called the next process will error
       numberRows = self.bcpFuncs.doneBcp();
       ! remove comment for a simple visual for the rows in each of the three processes
       !message('the table ' & clip(self.tableQ.sName) & '.' & clip(self.tableQ.tName) & ' ' & format(numberRows, @n7) & ' rows.', 'Number rows')
    end

   end ! loop 

  return retv
! ------------------------------------------------------------------------------------    

bcpImportVarType.AddTable procedure(string tName, string sName, *IbcpImportVar importer) 

  code

   self.tableQ.tName = tName
   self.tableQ.sName = sName
   self.tableQ.importVar &= importer

   add(self.tableQ)

  return
! -------------------------------------------------------------------------------------------
!endregion tables 

!region bcp process 

bcpImportVarType.processData procedure(*IbcpImportVar importer) 

retv bool,auto

  code

   retv = importer.bindColumns()
   if (retv = true) 
     retv = importer.processDataSource()
  end 

  return retv
! ---------------------------------------------------------------------------------------

bcpImportVarType.checkBatchSize procedure() !long

numberOf long,auto

  code

   if (self.BatchMode = true)
      self.rows += 1
      if (self.Rows >= self.BatchSize)
        numberOf = self.batchbcp()
         self.totalRows += numberOf
         self.Rows = 0
     end
  end 
   
   return numberOf
! ----------------------------------------------------------------------------------------------

bcpImportVarType.prepWideStr procedure(*string tName, *string sName) !,private,retCode

retv         retcode(bcp_success)
fullName string(sysNameLen*2),auto

  code

   fullName = clip(sName) & '.' & tName   
   if (self.initWideStr(self.tableName, fullName) = false)
      retv = bcp_fail
   end
  
    fullName = self.buildFileName(fullName, self.logFileExt)
    if (self.initWideStr(self.logFileName, fullName) = false)
       retv =  bcp_Fail
    end
   
   return retv
! ---------------------------------------------------------------------------

!endregion bcp process 
