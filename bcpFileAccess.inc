
!ABCIncludeFile

  OMIT('_EndOfInclude_',_bcpFileAccess_)
_bcpFileAccess_   EQUATE(1)

!!!<summary>
!!! 
!!!</summary>
bcpFileAccessType class,type,module('bcpFileAccess.clw'),link('bcpFileAccess.clw',1),dll(0)

!!!<summary>
!!!  file t be processed 
!!!</summary>
f                &file,private 

!!!<summary>
!!!  key to use for the processing, used by the set command
!!!</summary>
k               &key,private

!!!<summary>
!!! sets the data members
!!!</summary>
init             procedure(*file f, *key k)
!!!<summary>
!!!  opens the fiel and calls set(k)
!!!</summary>
openFile   procedure(),bool
!!!<summary>
!!! close the file 
!!!</summary>
closeFile   procedure()
!!!<summary>
!!! reads the next row from the file 
!!!</summary>
readRow   procedure(),bool
    end

  _EndOfInclude_