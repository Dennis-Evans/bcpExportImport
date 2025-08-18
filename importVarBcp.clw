
  member('exportImportBcp.clw')

  include('odbcConnStrCl.inc'),once
  include ('bcpImportVarType.inc'),once
  include ('odbcTypes.inc'),once
  include('abwindow.inc'),once
  include('IbcpImportVar.inc'),once
  include('queueDefines.inc'),once
  include('bcpImporter.inc'),once

  map
    !!!<summary>
    !!! small worker function to allocate the objects used by the demo.
    !!!</summary>
    !!!<remarks>
    !!! used to keep the code a little cleaner.  
    !!!</remarks>
    impCreateLocalObjects()
    !!!<summary>
    !!! init's the connection string with the server name and the database name.
    !!! turns trusted connection on
    !!!</summary>
    setupConnStr() 
    !!!<summary>
    !!! adds the tables to the queue.  allocates the table import instances 
    !!! fills the two queues used by the demo wit hrandom values 
    !!!</summary>
    addTables() 

!region queue workers 
    ! local workers to fill up te demo 
    !!!<summary>
    !!! fills the queue used for the test tbale 
    !!!</summary>    
    fillTestTableQueue()
    !!!<summary>
    !!! fills the queue used for the test table two 
    !!!</summary>    
    fillTestTableTwoQueue()
    !!!<summary>
    !!! fills a string variable with random characters 
    !!!</summary>       
    fillString(),string 
    !!!<summary>
    !!! fills a cstring variable with random characters 
    !!!</summary>       
    fillCString(),*cstring
    !!!<summary>
    !!! generates a rsndom date 
    !!!</summary>       
    generateDate(*date d) 
    !!!<summary>
    !!! generates a rsndom datetime structure  
    !!!</summary>       
    generateDateTime(*TIMESTAMP_STRUCT d) 
    !!!<summary>
    !!! generates a rsndom time value
    !!!</summary>       
    generateTime(*time t) 
!endregion queue workers 
  end

!!!<summary>
!!! sets the number of rows adde to the two demo queues 
!!! adjust as needed for testing.  this is just used for the demo 
!!!</summary>       
maxRows long(100000),static

!!!<summary>
!!! the importer object 
!!! runs the import for the different tables 
!!!</summary>       
bcpImporter                &bcpImportVarType

!region table importers 
!!!<summary>
!!! the importer object for dbo.testTable 
!!!</summary>       
tableOneImport          &testTableImport
!!!<summary>
!!! the importer object for dbo.testTableTwo
!!!</summary>       
tableTwoImport          &testTableTwoImport
!!!<summary>
!!! the importer object for dbo.testTableThree
!!!</summary>       
tableThreeImport       &testTableThreeImport
!endregion table importers 

! start the import 
startImport procedure() 

impWindow WINDOW('Caption'),AT(,,173,74),GRAY,ICON(ICON:Application), |
      FONT('Segoe UI',9)
    BUTTON('Import Variables'),AT(48,29,70,14),USE(?btnImportVar)
  END

!!!<summary>
!!! window manager for use in the demo 
!!!</summary>
impDemoWindow class(windowmanager)
Kill                         procedure(),byte,virtual,proc
TakeFieldEvent   procedure(),virtual,byte 
import                    procedure()
connectBcp          procedure(),bool
                           end
! ---------------------------------------------------------------------------

!region procdure level 

   code
   
   impCreateLocalObjects()
   setupConnStr()

   impDemoWindow.Init()
   impDemoWindow.Open(impWindow)
  
   impDemoWindow.run() 

   return
! --------------------------------------------------------------------------

!!!<summary>
!!! small worker function to allocate the objects used by the demo.
!!!</summary>
!!!<remarks>
!!! used to keep the code a little cleaner.  
!!!</remarks>
impCreateLocalObjects procedure() 

  code

  connStr &= new(MSConnStrClType)
  bcpImporter &= new(bcpImportVarType)  
  ! TODO set the path for the output file, this is import from vatiables so the output will be error log files, no data files
  bcpImporter.init('d:\bcpout')
  
  return
! ----------------------------------------------------------------------------

!!!<summary>
!!! init's the connection string with the server name and the database name.
!!! turns trusted connection on
!!!</summary>
setupConnStr procedure() 

  code

   srvName  = 'dennis-ltsag\srv_3_1_18'
   dbName = 'testDb' !'AdventureWorks2019'

  connStr.init(srvName, dbName)
  connStr.setTrustedConn(true)

  return
! ------------------------------------------------------------------------

!endregion procdure level 

impDemoWindow.kill procedure() !byte,proc
 
retv bool,auto 

   code 

   retv = parent.kill() 

   dispose(tableOneImport)
   dispose(tableTwoImport)
   dispose(tableThreeImport)
   dispose(bcpImporter)

   dispose(connStr)

    post(event:CloseWindow)
   
   return retv
! ---------------------------------------------------------------------------

!!!<summary>
!!! overloaded function to handle the accepted event for the screen controls 
!!!</summary>
!!!<returns>
!!! level:benign 
!!!</returns>
impDemoWindow.TakeFieldEvent procedure() 
 
retv  long(Level:Benign)

  code
  
  case event() 
    of event:Accepted
       case field() 
        of ?btnImportVar
           AddTables()
           self.import()
       end
  end 

  return retv
! ---------------------------------------------------------------------------- 

impDemoWindow.import procedure()

retv bool,auto
cnt long,auto 

  code 

  retv = self.connectBcp()
      
  if (retv = true) 
    retv = bcpImporter.processTables()    
  end

  self.kill()

  return
! ---------------------------------------------------------------------------------------------

impDemoWindow.connectBcp procedure() ! bool

retv bool,auto

  code

  retv = bcpImporter.BcpInit()   

  if (retv = true) 
    retv = bcpImporter.BcpConnect(connStr.ConnectionString())
  end

  return retv
! ------------------------------------------------------------------------

AddTables procedure()

  code

   tableOneImport &= new(testTableImport)
   fillTestTableQueue()      
   tableOneImport.init(bcpImporter)
   bcpImporter.addTable('testTable',  'dbo',  tableOneImport.IbcpImportVar)
  
  tableTwoImport &= new(testTableTwoImport)
  fillTestTableTwoQueue()  
  tableTwoImport.init(bcpImporter)
  bcpImporter.addTable('testTableTwo',  'dbo',  tableTwoImport.IbcpImportVar)

  tableThreeImport &= new(testTableThreeImport)
  tableThreeImport.init(bcpImporter)
  bcpImporter.addTable('testTableThree',  'dbo',  tableThreeImport.IbcpImportVar)

  return 
! -----------------------------------------------------------------------
 
!region queue workers 

! the following just fill the queue wit hsome random data, do not care what the actual value is, just some data to use
fillTestTableQueue    procedure()

cnt long,auto

  code

  if (tableOneImport.impQueue &= null) 
    tableOneImport.impQueue &= new(testTableQueue)
  end

  loop cnt = 1 to maxRows
    tableOneImport.impQueue.longValue = random(550, 200000) 
    tableOneImport.impQueue.strValue = fillString() 
    tableOneImport.impQueue.cStrValue = fillCString() 

    generateDate(tableOneImport.impQueue.dValue)

    tableOneImport.impQueue.byteValue  = random(1, 200) 
    tableOneImport.impQueue.shortValue = random(1, 32000) 
    tableOneImport.impQueue.realValue = random(456, 3000000)    
    tableOneImport.impQueue.floatValue = random(500000, 3000000)
    if (random(1, 50) >= 30)
      tableOneImport.impQueue.boolValue = false
    else 
      tableOneImport.impQueue.boolValue = true
    end
    generateTime(tableOneImport.impQueue.tValue)

    add(tableOneImport.impQueue)
 end
    
  return
! -----------------------------------------------------------------------------------------------

fillTestTableTwoQueue    procedure()

cnt long,auto

  code

  if (tableTwoImport.impQueue &= null) 
    tableTwoImport.impQueue &= new(testTableTwoQueue)
  end

  loop cnt = 1 to maxRows
    tableTwoImport.impQueue.longValue = random(550, 200000) 
    tableTwoImport.impQueue.cStrValue = fillCString() 

    tableTwoImport.impQueue.cStrTwoValue = fillCString() 
    generateDateTime(tableTwoImport.impQueue.dateTime)

    add(tableTwoImport.impQueue)
 end
    
  return
! -----------------------------------------------------------------------------------------------

fillString procedure() 

retv string(50),auto
numChars long,auto
ndx long,auto

  code 

  numchars = random(1,48)
  loop ndx = 1 to numChars
     retv[ndx] = chr(random(97, 122))
  end 

  return retv
! -----------------------------------------------------------------------------------------------

fillCString procedure() 

retv cstring(50),auto
numChars long,auto
ndx long,auto

  code 

  numchars = random(1,48)
  loop ndx = 1 to numChars
     retv[ndx] = chr(random(97, 122))
  end 
  retv[ndx + 1] = '\ 0'

  return retv
! -----------------------------------------------------------------------------------------------

generateTime procedure(*time t) 

  code

  t = random(2000, 800000)
  
  return
! ----------------------------------------------------------------------------------------------

generateDate procedure(*date d) 


  code

  d = date(random(1990, 2025), random(1, 12), random(1, 28) )

  return;
! ------------------------------------------------------------------------------------------------

generateDateTime procedure(*TIMESTAMP_STRUCT d) 


  code

  d.year = random(1990, 2025)
  d.month = random(1, 12)
  d.day  = random(1, 28) 
  d.hour = random(1, 23)
  d.minute = random(1,59)
  d.second = random(1,59)
  d.fraction = 0

  return;
! ------------------------------------------------------------------------------------------------

!endregion queue workers 
