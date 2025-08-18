
member()
  
  include('bcpFileAccess.inc'),once
  
  map
  end

bcpFileAccessType.init procedure(*file f, *key k)

  code

  self.f &= f
  self.k &= k

  return
! -------------------------------------------------------------------------------

bcpFileAccessType.openFile procedure() 

retv bool(true) 
 
  code

   open(self.f)
   if (errorcode() <> 0) 
      retv = false
   end

   if (retv = true) 
     set(self.k)
     if (errorcode() <> 0) 
        retv = false
      end
   end 

  return true
! ------------------------------------------------------------------------------------------

bcpFileAccessType.closeFile procedure() 
 
  code

  close(self.f)

  return
! ------------------------------------------------------------------------------------------

bcpFileAccessType.readRow procedure() 

retv bool(true)
 
  code

  next(self.f)
  if (errorcode() <> 0) 
    retv = false
  end

  return retv
! ----------------------------------------------------------------------------------
