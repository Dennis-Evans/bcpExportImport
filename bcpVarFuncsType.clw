
member()
  
  include('odbcTypes.inc'),once
  include('bcpVarFuncs.inc'),once  
    
  map
     module('bcpcodeImp')
       bind_Long(*long colv, long colOrd),bool,c,name('bind_Long')
       bind_String(*string colv, long colOrd, long slen),bool,c,raw,name('bind_String')
       bind_CString(*cstring colv, long colOrd),bool,c,raw,name('bind_CString')
       bind_Date(*DATE_STRUCT colv, long colOrd),bool,c,raw,name('bind_Date')
       bind_DateTime(*string colv, long colOrd),bool,c,raw,name('bind_DateTime')
       bind_Time(*string colv, long colOrd),bool,c,raw,name('bind_Time')
       bind_Byte(*byte colv, long colOrd),bool,c,name('bind_Byte')
       bind_Short(*short colv, long colOrd),bool,c,name('bind_Short')
       bind_Real(*real colv, long colOrd),bool,c,name('bind_Real')
       bind_Float(*sreal colv, long colOrd),bool,c,name('bind_Float')
       bind_Bool(*bool colv, long colOrd),bool,c,name('bind_Bool')
       sendRow_Bcp(),bool,c,name('sendRow_Bcp')
       batch_bcp(),long,c,name('batch_bcp');
       done_Bcp(),long,c,name('done_Bcp')
     end
  end

!region bcp interface 

!region numbers 

bcpVarFuncsType.bindByte procedure(*byte colv, long colOrd) !,bool

retv bool,auto

  code 

  retv = bind_Byte(colv, colOrd)     

  return retv
! ------------------------------------------------------------------------------------------

bcpVarFuncsType.bindShort procedure(*short colv, long colOrd) !bool

retv bool,auto

  code 

  retv = bind_Short(colv, colOrd)     

  return retv
! ------------------------------------------------------------------------------------------

bcpVarFuncsType.bindLong procedure(*long colv, long colOrd) !,bool

retv bool,auto

  code 

  retv = bind_long(colv, colOrd)     

  return retv
! ------------------------------------------------------------------------------------------

bcpVarFuncsType.bindReal procedure(*real colv, long colOrd) !bool

retv bool,auto

  code 

  retv = bind_Real(colv, colOrd)     

  return retv
! ------------------------------------------------------------------------------------------

bcpVarFuncsType.bindSReal procedure(*sreal colv, long colOrd) !bool

retv bool,auto

  code 

  retv = bind_Float(colv, colOrd)     

  return retv
! ------------------------------------------------------------------------------------------

bcpVarFuncsType.bindBool  procedure(*bool colv, long colOrd) !bool

retv bool,auto

  code 

  retv = bind_Bool(colv, colOrd)     

  return retv
! ------------------------------------------------------------------------------------------

!endregion numbers 

!region strings 

bcpVarFuncsType.bindString procedure(*string colv, long colOrd) !bool

retv bool,auto

  code 

  retv = bind_string(colv, colOrd, size(colv))

  return retv
! ------------------------------------------------------------------------------------------

bcpVarFuncsType.bindCString procedure(*cstring colv, long colOrd) !bool

retv bool,auto

  code 

  retv = bind_cstring(colv, colOrd)     

  return retv
! ------------------------------------------------------------------------------------------

!endregion strings 

!region dates and time

bcpVarFuncsType.bindDate procedure(*DATE_STRUCT colv, long colOrd) !,bool

retv bool,auto 

  code

  retv = bind_Date(colv, colOrd)

  return retv
! ----------------------------------------------------------------------------------------- 

bcpVarFuncsType.bindDateTime procedure(*string colv, long colOrd) !,bool

retv bool,auto 

  code

  retv = bind_DateTime(colv, colOrd)

  return retv
! ----------------------------------------------------------------------------------------- 

bcpVarFuncsType.bindTime procedure(*string colv, long colOrd) !bool

retv bool,auto

  code

  retv = bind_Time(colv, colOrd)

  return retv
! ----------------------------------------------------------------------------------------- 

!endregion dates and time

!region writes 

bcpVarFuncsType.sendRowBcp procedure() !,bool

retv bool,auto 

   code

   retv = sendRow_Bcp();

   return retv;
! -------------------------------------------------------------------------------------------

bcpVarFuncsType.batchbcp procedure() !,long

retv long,auto

  code

  retv = batch_bcp()

  return retv
! -----------------------------------------------------------------------------------------

bcpVarFuncsType.doneBcp procedure() !bool

retv long ,auto 

   code

   retv = done_Bcp();

   return retv;
! -------------------------------------------------------------------------------------------

!endregion writes 

!endregion bcp interface 