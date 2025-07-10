
/* ====================================================================
clear the tables used by the demo import process.

The demo sets the BCP option to keep identity values on.  
Run this script after an import to clear the tables of any data.
If not cleared additional imports will fail.
======================================================================= */
truncate table production.workorderin;
truncate table production.WorkOrderRoutingIn;
truncate table person.BusinessEntityIn;
truncate table person.BusinessEntityAddressIn;
truncate table person.personin;
truncate table production.TransactionHistoryIn;
truncate table sales.SalesOrderDetailIn;