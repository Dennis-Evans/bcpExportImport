
  OMIT('_EndOfInclude_',_IbcpImportVar_)
_IImportVar_   EQUATE(1)

!!!<summary>
!!! interface for the BCP variable import.
!!! the bind columns will be different for each table imported
!!! the processDataSource will vary depending on the data source used for the table
!!! this function calls the readDataRow for eack row of input.  
!!!</summary>
IbcpImportVar          interface,type
!!!<summary>
!!! binds the columns or local variables to the bcp process
!!! each variable is bound and the ordinal position the variable is added must match the table DDL
!!!</summary>
bindColumns              procedure(),bool,virtual

!!!<summary>
!!! iterates over the queue, file or what ever the data source is, then calls the readDataRow and then sendRowBcp if the read passess. 
!!! the type of data source can vary.
!!!</summary>
processDataSource  procedure(),bool,virtual
                                  end

   _EndOfInclude_