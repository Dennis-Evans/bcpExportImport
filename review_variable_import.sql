
/* -----------------------------------------------------------------------
run this script to after the import from variabels to check the data was added
the tables are truncated for the next test
-------------------------------------------------------------------------- */

select *
from dbo.testTable;

truncate table dbo.testtable

select *
from dbo.testTableTwo

truncate table dbo.testtabletwo

select *
from dbo.testTableThree

truncate table dbo.testTableThree
