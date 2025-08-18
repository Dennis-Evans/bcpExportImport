
!ABCIncludeFile

  OMIT('_EndOfInclude_',_bcpVarFuncs_)
_bcpVarFuncs_   EQUATE(1)

  include('odbcTypes.inc'),once
  include('svcom.inc'),once

!!!<summary>
!!! object to expose the BCP calls for importing var's
!!!</summary>
bcpVarFuncsType  class,type,module('bcpVarFuncsType.clw'),link('bcpVarFuncsType.clw',1),dll(0)

!region fields 

!region BCP interface

!region strings
!!!<summary>
!!! Bind a string variable for the import 
!!!</summary>
!!!<param name = 'colv'>
!!! pointer to the field to be used 
!!!</param name>
!!!<param name = 'colOrd'>
!!! ordinal position of the column in the db table
!!!</param name>
!!!<remarks> 
!!! all the other bind calls are the same except for the specific data type.
!!!</remarks> 
bindString procedure(*string colv, long colOrd),bool
!!!<summary>
!!! Bind a cstring variable for the import 
!!!</summary>
!!!<param name = 'colv'>
!!! pointer to the field to be used 
!!!</param name>
!!!<param name = 'colOrd'>
!!! ordinal position of the column in the db table
!!!</param name>
bindCString procedure(*cstring colv, long colOrd),bool
!endregion strings 

!region whole numbers 
!!!<summary>
!!! Bind a long variable for the import 
!!!</summary>
bindLong procedure(*long colv, long colOrd),bool
!!!<summary>
!!! Bind a byte variable for the import 
!!!</summary>
bindByte procedure(*byte colv, long colOrd),bool
!!!<summary>
!!! Bind a short variable for the import 
!!!</summary>
bindShort procedure(*short colv, long colOrd),bool
!!!<summary>
!!! Bind a bool variable for the import 
!!!</summary>
!!!<remarks>
!!! not really a number but as good a place as any
!!!</remarks>
bindBool  procedure(*bool colv, long colOrd),bool
!endregion whole numbers 

!region date and times 
!!!<summary>
!!! binds a date structire, year, month and day 
!!!</summary>
bindDate          procedure(*DATE_STRUCT colv, long colOrd),bool
!!!<summary>
!!! binds a dateTime structire using as sting format is yyyy-mm-dd hh:mm:ss
!!!</summary>
bindDateTime procedure(*string colv, long colOrd),bool
!!!<summary>
!!! binds a time structire, hours, minutes, seconds and fractions of seconds. 
!!!</summary>
bindTime         procedure(*string colv, long colOrd),bool
!endregion date and times 

!region floating point 
!!!<summary>
!!! binds a real variable 8 bytes, float on the back end 
!!!</summary>
bindReal procedure(*real colv, long colOrd),bool
!!!<summary>
!!! binds a sreal variable 4 bytes, real on the back end 
!!!</summary>
bindSReal procedure(*sreal colv, long colOrd),bool
!endregion floating point 

!region writes 
!!!<summary>
!!! send a row of data to the server.  this is sent but not written 
!!! the data is written by the batchBcp or the doneBcp calls
!!!</summary>
sendRowBcp procedure(),bool
!!!<summary>
!!! writes a batch of rows, the rows were sent and the bacth size for the import process 
!!! has been reached.  
!!!</summary>
batchbcp procedure(),long
!!!<summary>
!!! writes any remaining rows that were not written by a call to the batchBcp
!!! does some clean up o nthe server, bound columns and table are released 
!!!</summary>
doneBcp procedure(),bool
!endregion writes 

!endregion BCP interface

                         end

  _EndOfInclude_