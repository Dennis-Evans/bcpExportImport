program

  include('odbcConnStrCl.inc'),once
  include ('bcpExportImport.inc'),once
  include ('bcpImportVarType.inc'),once
  include ('odbcTypes.inc'),once
  include('abwindow.inc'),once

  map
    !!!<summary>
    !!! small worker function to allocate the objects used by the demo.
    !!!</summary>
    !!!<remarks>
    !!! used to keep the code a little cleaner.  
    !!!</remarks>
    createLocalObjects()
    runImp() 
   MODULE('importVarBcp.clw')
     startImport()
    END
  end

!region fields 

!!!<summary>
!!! name or label of the server in use
!!!</summary>
srvName string(sysNameLen)

!!!<summary>
!!! name or label of the database in use
!!!</summary>
dbName string(sysNameLen)

!!!<summary>
!!! instance for the connection string 
!!!</summary>
connStr           &MSConnStrClType

!!!<summary>
!!! instance for the BCP
!!!</summary>
bcp                  &bcpExportImportType

!!!<summary>
!!! queue to hold the table names that will be exported or inported.
!!!</summary>
tableQ  queue
!!!<summary>
!!! table name to be proccessed. 
!!!</summary>
tName      string(sysNameLen)
!!!<summary>
!!! schema name of the table to be proccessed. 
!!!</summary>
sName      string(sysNameLen)
!!!<summary>
!!! full file path for the data file.  If this is an empty string the data file name is built from the 
!!! schema and table name.  If it contains a value then that value will be used for the data file.
!!!</summary>
!!!<remarks>
!!! this is included to provide some flexability during the inport.  An exported data file can be used 
!!! for the import 
!!!</remarks>
dName       string(256)
              end

!endregion fields 

Window WINDOW('Caption'),AT(,,363,173),GRAY,FONT('Segoe UI',9)
    PROMPT('Server '),AT(33,27,34),USE(?prmSrver)
    ENTRY(@s128),AT(65,28,116),USE(srvName)
    PROMPT('Database'),AT(33,50,34),USE(?prmDatabase)
    ENTRY(@s128),AT(65,51,116),USE(dbName)    
    BUTTON('Setup Connection'),AT(33,74),USE(?btnSetConnection)
    BUTTON('Export'),AT(33,91,70,14),USE(?btnExport),DISABLE
    STRING('Number of Rows'),AT(112,91,157,14),USE(?rowsMsg)
    BUTTON('Import'),AT(33,108,70,14),USE(?btnImport),DISABLE
    STRING('Elapsed Time'),AT(112,108,167,14),USE(?elapsedTime)
    BUTTON('Import Variables'),AT(33,131,70,14),USE(?btnVarImport)
   BUTTON('&Done'),AT(292,131,42,14),USE(?doneButton)
  END

!!!<summary>
!!! window manager for use in the demo 
!!!</summary>
demoWindow     class(windowmanager),type

TakeFieldEvent   procedure(),virtual,byte 
!!!<summary>
!!! fills the table queue with the tables to be exported or imported.
!!! Adjust as needed for production
!!!</summary>
fillTableList          procedure(short direction) 

!!!<summary>
!!! sets up the connection string.  Then calls the init and bcpConnect functions.
!!! When this function completes a database  connection with the BCP option set 
!!! has been established
!!!</summary>
!!!<returns>
!!!  True for success and False for failure
!!!</returns>
!!!<remarks>
!!! for this demo the connection is made and remains active until the demo ends. 
!!! in production code this would not be a good practice.
!!!</remarks>
connectBcp          procedure(),bool

!!!<summary>
!!! init's the connection string with the server name and the database name.
!!! turns trusted connection on
!!!</summary>
setupConnStr      procedure() 

!!!<summary>
!!! export or import a table based on the direction input.
!!!</summary>
!!!<param name = 'direction'>
!!! direction for the BCP process. Must be one of the two values, DB_IN or DB_OUT.
!!!</param name>
exportImport         procedure(short direction) 

!!!<summary>
!!! enables the export button and disables the set up connection button. 
!!! export or inport should not be called until the connection is made.
!!!</summary>
!!!<remarks>
!!! once the connection is made it remains active and does not need to be done a second time. 
!!!</remarks>
toggleControls    procedure()

!!!<summary>
!!! init's the current table for the BCP process, called for both DB_IN or DB_OUT
!!!</summary>
!!!<param name = 'direction'>
!!! direction for the BCP process. Must be one of the two values.
!!!</param name>
initTable              procedure(short direction),bool

!!!<summary>
!!! executes the BCP operation for the current table.  for the demo the keep idenity option is turned on
!!!</summary>
!!!<remarks>
!!! the default for the keep idenity is Off.  Adjust as needed or remove.  This will vary a fair bit 
!!! based on the specifc table and how the import is used.
!!!</remarks>
execTable             procedure(),long
                            end
! ---------------------------------------------------------------------------

!!!<summary>
!!! Instance of the demoWindow used in the demo. 
!!!</summary>
thisW  &demoWindow

  code
 
  createLocalObjects()

  thisW.Init()
  thisW.Open(window)
 
  ! TODO set the defaullts for the demo 
   srvName  = 'dennis-ltsag\srv_3_1_18'
   dbName = 'AdventureWorks2019'
 
  thisW.run()

  return
! ------------------------------------------------------------------------------- 

!!!<summary>
!!! small worker function to allocate the objects used by the demo.
!!!</summary>
!!!<remarks>
!!! used to keep the code a little cleaner.  
!!!</remarks>
createLocalObjects procedure() 

  code

  thisW &= new(demoWindow)
  connStr &= new(MSConnStrClType)
  bcp &= new(bcpExportImportType)

  ! TODO set the path for the output file 
  bcp.init('d:\bcpout')
  
  
  return
! ----------------------------------------------------------------------------

! =============================================================
! window manager 
! =============================================================

!!!<summary>
!!! enables the export button and disables the set up connection button. 
!!! export or inport should not be called until the connection is made.
!!!</summary>
!!!<remarks>
!!! once the connection is made it remains active and does not need to be done a second time. 
!!!</remarks>
demoWindow.toggleControls    procedure()

  code

   enable(?btnExport)
   enable(?btnImport)

   disable(?btnSetConnection)

  return
! --------------------------------------------------------------------------------------------------------------

!!!<summary>
!!! overloaded function to handle the accepted event for the screen controls 
!!!</summary>
!!!<returns>
!!! level:benign 
!!!</returns>
demoWindow.TakeFieldEvent procedure() 
 
retv  long(Level:Benign)

  code
  
  case event() 
    of event:Accepted
       case field() 
         of ?doneButton
            dispose(bcp)
            dispose(connStr)
            post(event:CloseWindow)
        of ?btnSetConnection
          retv = thisW.connectBcp()
        of ?btnExport
           self.exportImport(DB_OUT)
        of ?btnImport
           self.exportImport(DB_IN)
        of ?btnVarImport
          runImp()
       end

  end

  return retv
! ---------------------------------------------------------------------------- 

runImp procedure() 

  code

  startImport()

  return
!---------------------------------------------------------------------------------- 

!!!<summary>
!!! init's the connection string with the server name and the database name.
!!! turns trusted connection on
!!!</summary>
demoWindow.setupConnStr procedure() 

  code

  connStr.init(srvName, dbName)
  connStr.setTrustedConn(true)

  return
! ------------------------------------------------------------------------

!!!<summary>
!!! sets up the connection string.  Then calls the init and bcpConnect functions.
!!! When this function completes a database  connection with the BCP option set 
!!! has been established
!!!</summary>
!!!<returns>
!!!  True for success and False for failure
!!!</returns>
!!!<remarks>
!!! for this demo the connection is made and remains active until the demo ends. 
!!! in production code this would not be a good practice.
!!!</remarks>
demoWindow.connectBcp procedure() !bool

retv bool,auto

  code

  self.setupConnStr()

  retv = bcp.BcpInit() 
  
  if (retv = true) 
    retv = bcp.BcpConnect(connStr.ConnectionString())
  end

  if (retv = true)
    self.toggleControls()
  end

  return retv
! ---------------------------------------------------------------------------------------------

!!!<summary>
!!! export or import a table based on the direction input.
!!!</summary>
!!!<param name = 'direction'>
!!! direction for the BCP process. Must be one of the two values, DB_IN or DB_OUT.
!!!</param name>
demoWindow.exportImport procedure(short direction) 

ndx                 long,auto 
startTime       long,auto
totalRows       long(0)

  code 

  self.fillTableList(direction)
 
  startTime = clock()
  
  loop ndx = 1 to records(tableQ)
    get(tableQ, ndx)
    if (self.initTable (direction) = true)
       totalRows += self.execTable ()
    end 
  end 

  ! this for the demo, just used to simply show that the process did some work
  ?rowsMsg{prop:text} = 'Number of rows processed ->' & format(totalRows, @n9)
  ?elapsedTime{prop:text} = 'Elapsed time -> ' & format(clock() - startTime, @T4_) & ' ' & 'Clock ticks -> ' & clock() - startTime

  return
! ----------------------------------------------------------------------------------------------------

!!!<summary>
!!! init's the current table for the BCP process, called for both DB_IN or DB_OUT
!!!</summary>
!!!<param name = 'direction'>
!!! direction for the BCP process. Must be one of the two values.
!!!</param name>
demoWindow.initTable procedure(short direction) 
 
retv          bool,auto

   code

   case direction 
   of DB_OUT
      retv = bcp.init_bcp(tableQ.tName, tableQ.sName, direction) 
    of DB_IN 
        retv = bcp.init_bcp(tableQ.tName, tableQ.sName, tableQ.dName, direction) 
    else 
       retv = false;
    end 

  return retv
! ------------------------------------------------------------------------------------------------------

!!!<summary>
!!! executes the BCP operation for the current table.  for the demo the keep idenity option is turned on
!!!</summary>
!!!<remarks>
!!! the default for the keep idenity is Off.  Adjust as needed or remove.  This will vary a fair bit 
!!! based on the specifc table and how the import is used.
!!!</remarks>
demoWindow.execTable procedure()  ! long
 
retv bool,auto
numberRows long,auto 
keepId long(1)

   code

   retv = bcp.bcp_Control(BCPKEEPIDENTITY, keepid)
   if (retv = true)
     retv = bcp.bcp_Exec(numberRows)     
   end

   return numberRows
! ------------------------------------------------------------------------------------------------------

!!!<summary>
!!! fills the table queue with the tables to be exported or imported.
!!!</summary>
!!!<remarks>
!!! this was written for the demo.  How the queue is filled will obviously be different in production.
!!!</remarks>
demoWindow.fillTableList procedure(short direction) 

fileExt    string(7),auto
filePath  string(256),auto

  code

  free(tableQ)
 
  if (direction = DB_OUT) 
    tableQ.tName = 'WorkOrder'
    tableQ.sName = 'production' 
    add(tableQ)
  
    tableQ.tName = 'WorkOrderRouting'
    tableQ.sName = 'production' 
    add(tableQ)

    tableQ.tName = 'BusinessEntity'
    tableQ.sName = 'person' 
    add(tableQ)

     tableQ.tName = 'BusinessEntityAddress'
     tableQ.sName = 'person' 
     add(tableQ)

     tableQ.tName = 'person'
     tableQ.sName = 'person' 
     add(tableQ)

     tableQ.tName = 'TransactionHistory'
     tableQ.sName = 'production' 
     add(tableQ)

     tableQ.tName = 'SalesOrderDetail'
     tableQ.sName = 'sales'
     add(tableQ)    
  else 
    fileExt = '.' & bcp.getDataFileExt()
    filePath  = bcp.getoutputPath()

    tableQ.tName = 'WorkOrderin'
    tableQ.sName = 'production' 
   tableQ.dName = clip(filePath) &'\' & 'production_workorder' & fileExt
    add(tableQ)
  
    tableQ.tName = 'WorkOrderRoutingin' 
    tableQ.sName = 'production' 
    tableQ.dName = clip(filePath) &'\' & 'production_WorkOrderRouting' & fileExt
    add(tableQ)

    tableQ.tName = 'BusinessEntityIn'
    tableQ.sName = 'person' 
    tableQ.dName = clip(filePath) &'\' & 'person_BusinessEntity' & fileExt
    add(tableQ)

     tableQ.tName = 'BusinessEntityAddressIn'
     tableQ.sName = 'person' 
     tableQ.dName = clip(filePath) &'\' & 'person_BusinessEntityAddress' & fileExt
     add(tableQ)

     tableQ.tName = 'personIn'
     tableQ.sName = 'person' 
     tableQ.dName = clip(filePath) &'\' & 'person_person'  & fileExt
     add(tableQ)

     tableQ.tName = 'TransactionHistoryIn'
     tableQ.sName = 'production' 
      tableQ.dName = clip(filePath) &'\' & 'production_TransactionHistory' & fileExt
     add(tableQ)

     tableQ.tName = 'SalesOrderDetailIn'
     tableQ.sName = 'sales' 
      tableQ.dName = clip(filePath) &'\' & 'sales_SalesOrderDetail' & fileExt
     add(tableQ)
  end 

  return
! ----------------------------------------------------------------------------------------------------