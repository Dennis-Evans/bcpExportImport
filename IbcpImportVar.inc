
  OMIT('_EndOfInclude_',_IbcpImportVar_)
_IImportVar_   EQUATE(1)

IbcpImportVar          interface,type
bindColumns              procedure(),bool,virtual
processDataSource  procedure(),bool,virtual
                                  end

   _EndOfInclude_