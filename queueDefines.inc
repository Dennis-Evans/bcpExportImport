
  OMIT('_EndOfInclude_',_queueDefines_)
_queueDefines_   EQUATE(1)

!!!<summary>
!!! queue to hold the table names that will be imported.
!!!</summary>
tableNameGrp  group,type
!!!<summary>
!!! table name to be proccessed. 
!!!</summary>
tName      string(sysNameLen)
!!!<summary>
!!! schema name of the table to be proccessed. 
!!!</summary>
sName      string(sysNameLen)
               end

tableNameQue queue(tableNameGrp),type
                            end

!!!<summary>
!!! a group and queue definition for the test tbale one.  
!!! just a set of fields with different data types 
!!!</summary>
testTableGrp group,type
longValue         long
strValue            string(50)
cStrValue         cstring(50)
dValue              date
byteValue         byte
shortValue       short
realValue         real
floatValue        sreal
boolValue        bool
datetimeValue string(8)
tValue               time
                       end

testTableQueue  queue(testTableGrp),type
                               end


!!!<summary>
!!! a group and queue definition for the test table two
!!! some fields with different data types 
!!!</summary>
testTableTwoGrp group,type
longValue                  long
cStrValue                   cstring(50)
GuidValue                  cstring(36)
cStrTwoValue           cstring(50)
dateTime                   group(TIMESTAMP_STRUCT)
                                    end
                               end

testTableTwoQueue queue(testTableTwoGrp)
                               end


_EndOfInclude_