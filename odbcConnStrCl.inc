
!ABCIncludeFile

  OMIT('_EndOfInclude_',_ODBCConnectionStrPresent_)
_ODBCConnectionStrPresent_   EQUATE(1)

  include('dynstr.inc'),once

! some default string lengths of the connections   
eDriverNameLength equate(50)  
eDefaultLength    equate(128)

! ---------------------------------------------------------------------------
! baseConnStrClType, class to handle the standard connection strings.  Each 
! vendor will use this as the starting point, derive the class for any specifics.
! 
! ---------------------------------------------------------------------------
baseConnStrClType  class,type,module('odbcConnStrCl.clw'),link('odbcConnStrCl.clw',1),dll(0)
connStr              &IDynStr,private
! connection string fields, access is through the interface 
srvName              cstring(eDefaultLength),private
dbName               cstring(eDefaultLength),private
driverName           cstring(eDriverNameLength),private
userName             cstring(eDefaultLength),private
password             cstring(eDefaultLength),private
portNumber           cstring(eDefaultLength),private
AppName              cstring(eDefaultLength),private
trustedConn          bool,private
useMars              bool,private
setDriverName        procedure(string driverName)
setDbName            procedure(string dbname)
setSrvName           procedure(string srvName)
setUserName          procedure(string  user)
setPassword          procedure(string pw)
setPortNumber        procedure(string portNumber)
setAppName           procedure(string appNamer)
! always implement this method, the actual format of the connection 
! string varies significantly
ConnectionString    procedure(),*cstring,virtual

! setup and clean up, 
! set the type and then use the interface for the fields.
init                 procedure(string srvName, string dbName),virtual
kill                 procedure(),virtual
                   end
! ---------------------------------------------------------------------------
               
MSConnStrClType  class(baseConnStrClType),type,module('odbcConnStrCl.clw'),link('odbcConnStrCl.clw',1),dll(0)
init               procedure(string srvName, string dbName),virtual
setTrustedConn     procedure(bool onOff)
setUseMars         procedure(bool onOff)
ConnectionString   procedure(),*cstring,virtual
                 end 
! ---------------------------------------------------------------------------

   _EndOfInclude_                   
