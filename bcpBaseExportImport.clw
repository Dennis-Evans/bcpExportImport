
member()
  
  include('odbcTypes.inc'),once
  include('bcpBaseExportImport.inc'),once  
  include('svcom.inc'),once
  
  map
     module('bcpcode')
       !!!<summary>
       !!! allocates the ODBC enviorment hadle and set the ODBC version 
       !!! Current defult ODBC version is 3.8
        !!!</summary>
       ClaBcpInit(),long,name('ClaBcpInit')

       !!!<summary>
       !!! connects to the database and sets the connection attribute to enable BCP operations 
       !!!</summary>
       !!!<param name='cs'>
       !!!  a cstring primed with a connection string
       !!!</param name>
       ClaBcpConnect(*cstring cs),long,raw,c,name('ClaBcpConnect')

       !!!<summary>
       !!! init's the BCP for a table.  
       !!!</summary>
       !!!<param name='tName'>
       !!!  the table name to be processed, formatted as schma.table 
       !!!</param name>
       !!!<param name='dataFile'>
       !!!  the full path for the data file the table is exported into
       !!!</param name>
       !!!<param name='logFile'>
       !!!  the full path for the log file. will typically be an empty file, only logs errors if any
       !!!</param name>
       !!!<param name='direction'>
       !!!  the direction, will be DB_IN or DB_OUT 
       !!!</param name>
       !!!<remarks>
       !!!  the log file is optional and not needed to execute the BCP process.
       !!! Recommend that a log file is always used, some times things go wrong.    
       !!!</remarks>
       Bcp_init(long tName, long dataFile, long logFile, short direction),bool,c,raw,name('Bcp_init')

       !!!<summary>
       !!! calls the bcp_control function to set an attribute 
       !!!</summary>
       !!!<param name='eOption'>
       !!!  option value to be set
       !!!</param name>
      !!!<param name='eOption'>
       !!!  value for the option, on or off true/false.  for a list of option see the bcp_control page on MSDN
       !!!</param name>
       bcp_control(long eOption, *long iValue),retCode,c,raw,name('Bcp_Control')

       !!!<summary>
       !!! releases the hEnv and hDbc handles in the C code
       !!!</summary>
       ClaBcpKill(),long,c,proc,name('ClaBcpKill')
     end
  end

!region construct destruct init

bcpBaseExportImportType.Construct procedure()

  code 

    self.tableName &= new(CWideStr)
    self.outFileName &= new(CWideStr)
    self.logFileName &= new(CWideStr)

  return
! -----------------------------------------------------------------------------------

bcpBaseExportImportType.destruct procedure()

   code

    ClaBcpKill()
    dispose(self.tableName)
    dispose(self.outFileName)
    dispose(self.logFileName)

    return
! -----------------------------------------------------------------------------------

bcpBaseExportImportType.init procedure(string outPath)

   code

   self.outputPath = outPath

   ! set the defaults, change, change with the setters 
    self.dataFileExt = 'expDat'
    self.logFileExt = 'expLog'

   return
! -----------------------------------------------------------------------------------

!endregion construct destruct init

!region setters and getters 

bcpBaseExportImportType.getoutputPath        procedure() !,string

  code
  return self.outputPath
! ---------------------------------------------------------------------------------

bcpBaseExportImportType.setDataFileExt        procedure(string s)
 
   code 
 
    self.dataFileExt = s

    return
! --------------------------------------------------------------------------------

bcpBaseExportImportType.getDataFileExt        procedure() !,string

   code
   return self.dataFileExt
! -----------------------------------------------------------------------------

bcpBaseExportImportType.setLogFileExt          procedure(string s)

   code 
 
    self.logFileExt = s

    return
! --------------------------------------------------------------------------------

!endregion setters and getters 

!region bcp interface 

! the returned hEnv is only used for an error check
! the handle is in the c dll
bcpBaseExportImportType.BcpInit procedure() 

hEnv   SQLHENV,auto
retv     bool(true)

  code 

  if (self.outputPath = '')
    retv = false
  else 
    hEnv = ClaBcpInit()
    if (hEnv <= 0) 
      retv = false
    end 
  end 

  return retv
! end ClaBcpInit
! ------------------------------------------------------------------------

! the returned hDbc is only used for an error check
! the handle is in the c dll
bcpBaseExportImportType.BcpConnect procedure(*cstring connStr) ! bool

retv   bool(true)
hdbc SQLHDBC,auto

  code 

  hDbc = ClaBcpConnect(connStr)
  if (hDbc <= 0) 
    retv = false
  end
  
  return retv
! end ClaBcpConnect
! ------------------------------------------------------------------------

bcpBaseExportImportType.init_bcp  procedure(string tName, string sName, short direction) !,bool

retv retcode,auto

    code
    
    retv = self.prepWideStr(tName, sName)
    
    if (retv = bcp_success) 
      retv = self.callInit_bcp(direction)
    end

    return retv
! -----------------------------------------------------------------------------------

bcpBaseExportImportType.callInit_bcp  procedure(short direction) !,bool

retv retcode,auto

    code
    
    retv = Bcp_init(self.tableName.GetWideStr(), self.outFileName.GetWideStr(), self.logFileName.GetWideStr(), direction) 

    return retv
! -----------------------------------------------------------------------------------

bcpBaseExportImportType.bcp_Control  procedure(long eOption, *long iValue) !bool

retv bool(true)

  code

  if (Bcp_control(eOption,  ivalue) = bcp_fail)
    retv = false
   end

  return retv
! -------------------------------------------------------------------------------

!endregion bcp interface 

!region private workers 

! build the table name and the file names
bcpBaseExportImportType.prepWideStr procedure(*string tName, *string sName) !,private,retCode

retv         retcode(bcp_success)
worker    string(sysNameLen*2),auto
fullName string(sysNameLen*2),auto

  code

   fullName = clip(sName) & '.' & tName   
   if (self.initWideStr(self.tableName, fullName) = false)
      retv = bcp_fail
   end

    worker = self.buildFileName(fullName, self.dataFileExt)
    if (self.initWideStr(self.outFileName, worker) = false) 
       retv =  bcp_Fail
    end
    
    worker = self.buildFileName(fullName, self.logFileExt)
    if (self.initWideStr(self.logFileName, worker) = false)
       retv =  bcp_Fail
    end
   
   return retv
! -----------------------------------------------------------------------------------

! release the string and then fill it from the input
bcpBaseExportImportType.initWideStr procedure(CWideStr cw, *string s) !,private,bool
 
retv            bool,auto 
numBytes long,auto

  code

  cw.Release()
  numBytes = cw.Init(s)
  if (numBytes <= 0) 
    retv = false
  else 
    retv = true
  end

  return retv
! -----------------------------------------------------------------------------------

! replacing the period with an undersocre is not required, but makes the file names a tad bit simpler to read.
bcpBaseExportImportType.buildFileName procedure(string tn, string ext) !string

retv string(256),auto 
ptr signed,auto 
id cstring('.')

  code
  
  ptr = instring('.', tn)  
  tn[ptr] = '_'
  retv =  clip(self.outputPath) & '\' & clip(tn) & '.' &  ext
  
  return retv
! -----------------------------------------------------------------------------------

!endregion