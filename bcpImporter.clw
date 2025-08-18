
member()
  
  include('odbcTypes.inc'),once
  include('bcpImporter.inc'),once  
    
  map
  end

!region test table 
testTableImport.init procedure(*bcpImportVarType iv)

  code

  self.importVar &= iv

  return
! ------------------------------------------------------------------------------------------

testTableImport.destruct procedure() !,virtual

  code

  free(self.impQueue)
  dispose(self.impQueue)

  return
! -----------------------------------------------------------------------------------------

testTableImport.readDataRow procedure(long cnt) !bool,virtual 

retv bool(true)
timeString  string(10)

   code 

   get(self.impQueue, cnt)  
   if (errorcode() <> 0) 
      retv = false
   else    
     self.dateBinder.year = year(self.impQueue.dValue)
     self.dateBinder.month = month(self.impQueue.dValue)
     self.dateBinder.day = day(self.impQueue.dValue) 
 
     self.timeBinder = format(self.impQueue.tValue, @t04)
   end 

    return retv
! ---------------------------------------------------------------------------------------------

testTableImport.IbcpImportVar.processDataSource procedure() !,bool,virtual

retv bool ,auto
cnt long,auto

  code
  
  ! if a call fails just break the loop 
  ! in production there should be some logging added for each step 
   loop cnt = 1 to records(self.impQueue)   
      retv = self.readDataRow(cnt)
      if (retv = false) 
         break
      end    
      retv = self.importVar.sendRowBcp()
      if (retv = false) 
         break
      end    
  end ! loop cnt 
  
   return retv
! -------------------------------------------------------------------------------------------------

testTableImport.IbcpImportVar.bindColumns  procedure() !bool,virtual

retv bool,auto

  code 

  retv = self.importVar.bcpFuncs.bindLong(self.impQueue.longValue, 2)

  if (retv = true) 
    retv = self.importVar.bcpFuncs.bindString(self.impQueue.strValue, 3)
  end 
  
  if (retv = true) 
    retv = self.importVar.bcpFuncs.bindCString(self.impQueue.cStrValue, 4)
  end

  if (retv = true) 
    retv = self.importVar.bcpFuncs.bindDate(self.dateBinder, 5)
  end 
  
  if (retv = true) 
    retv = self.importVar.bcpFuncs.bindByte(self.impQueue.byteValue, 6)
  end 

  if (retv = true) 
    retv = self.importVar.bcpFuncs.bindShort(self.impQueue.shortValue, 7)
  end 

  if (retv = true) 
    retv = self.importVar.bcpFuncs.bindReal(self.impQueue.realValue, 8)
  end 

  if (retv = true) 
    retv = self.importVar.bcpFuncs.bindSReal(self.impQueue.floatValue, 9)
  end 

  if (retv = true) 
    retv = self.importVar.bcpFuncs.bindBool(self.impQueue.boolValue, 10)
  end 

  if (retv = true) 
    retv = self.importVar.bcpFuncs.bindTime(self.timeBinder, 11)
  end 

  return retv
! -----------------------------------------------------------------------------------------------
!endregion test table 

!region test table two 
testTableTwoImport.init procedure(*bcpImportVarType iv)

  code

  self.importVar &= iv

  return
! ------------------------------------------------------------------------------------------

testTableTwoImport.destruct procedure() !,virtual

  code

  free(self.impQueue)
  dispose(self.impQueue)

  return
! -----------------------------------------------------------------------------------------

testTableTwoImport.readDataRow procedure(long cnt) !bool,virtual 

retv     bool(true)
tstring cstring(9) 
dstring cstring(11)

   code 

   get(self.impQueue, cnt)  
   if (errorcode() <> 0) 
     retv = false
   end 
   
   tstring = format(self.impQueue.dateTime.hour, @n02) & ':' & format(self.impQueue.dateTime.minute, @N02) & ':' & format(self.impQueue.dateTime.second, @n02)
   dstring = self.impQueue.dateTime.year & '-' & format(self.impQueue.dateTime.month, @n02) & '-' & format(self.impQueue.dateTime.day, @n02)
   self.datetimebinder = dstring & ' ' & tstring
  
    return retv
! ---------------------------------------------------------------------------------------------

testTableTwoImport.IbcpImportVar.processDataSource procedure() !,bool,virtual

retv bool ,auto
cnt long,auto

  code
  
  ! turn on batch mode for this table in the demo 
   self.importVar.setBatchMode()
   ! the table uses 100,000 rows in the process so use a number that will 
   ! leave some rows that will be written when the done bcp is called
   self.importVar.setBatchSize(24000)

  ! if a call fails just break the loop 
  ! in production there should be some logging added for each step 
   loop cnt = 1 to records(self.impQueue)
      retv = self.readDataRow(cnt)
      if (retv = false) 
         break
      end
      retv =  self.importVar.sendRowBcp()
      if (retv = false) 
         break
      else 
        retv = self.importVar.checkBatchSize() 
        if (retv = false) 
          break
        end
      end    
  end ! loop cnt 
  
   return retv
! -------------------------------------------------------------------------------------------------

testTableTwoImport.IbcpImportVar.bindColumns  procedure() !bool,virtual

retv bool,auto

  code 

  retv = self.importVar.bcpFuncs.bindLong(self.impQueue.longValue, 1)
  
  if (retv = true) 
    retv = self.importVar.bcpFuncs.bindCString(self.impQueue.cStrValue, 2)
  end

  if (retv = true) 
    retv = self.importVar.bcpFuncs.bindLong(self.impQueue.longValue, 4)
  end

  if (retv = true) 
    retv = self.importVar.bcpFuncs.bindDateTime(self.dateTimeBinder, 5)
  end

  return retv
! -----------------------------------------------------------------------------------------------

!endregion test table two 

!region test table three 
testTableThreeImport.init procedure(*bcpImportVarType iv)

  code

  self.importVar &= iv

  return
! ------------------------------------------------------------------------------------------

testTableThreeImport.destruct procedure() !,virtual

  code

  dispose(self.fileAccess)

  return
! -----------------------------------------------------------------------------------------

testTableThreeImport.readDataRow procedure(long cnt) !,bool,virtual 

retv bool,auto

  code
 
  retv = self.fileAccess.readRow()
  
  return retv
! --------------------------------------------------------------------------------------------------

testTableThreeImport.setupFile procedure() !bool

retv bool,auto

  code

  self.fileAccess &= new(bcpFileAccessType)
  self.fileAccess.init(TpsTable, TpsTable.Pk_Bei)
  
  retv = self.fileAccess.openFile()

  return retv
! -------------------------------------------------------------------------------------------------
 
testTableThreeImport.IbcpImportVar.processDataSource procedure() !,bool,virtual

retv bool ,auto
cnt long,auto

  code
  
  if (self.setupFile() = false) 
    return false
  end 

  retv = self.readDataRow(0) 
  loop while (retv = true)   
      retv = self.importVar.sendRowBcp()
      if (retv = false) 
         break
      end  
     retv = self.readDataRow(0) 
  end ! loop cnt 

   self.fileAccess.closeFile()

   return retv
! -------------------------------------------------------------------------------------------------

testTableThreeImport.IbcpImportVar.bindColumns  procedure() !bool,virtual

retv bool,auto

  code 

  retv = self.importVar.bcpFuncs.bindLong(TpsTable.BusinessEntityID, 1)
  
  if (retv = true) 
    retv = self.importVar.bcpFuncs.bindCString(TpsTable.FirstName, 2)
  end

  if (retv = true) 
    retv = self.importVar.bcpFuncs.bindCString(TpsTable.MiddleName, 3)
  end

  if (retv = true) 
    retv = self.importVar.bcpFuncs.bindCString(TpsTable.LastName, 4)
  end

  if (retv = true) 
    retv = self.importVar.bcpFuncs.bindLong(TpsTable.EmailPromotion, 5)
  end

  return retv
! -----------------------------------------------------------------------------------------------
!endregion test table three