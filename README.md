A demo project to use the BCP for export and import into or out of a SQL Server database.  The demo uses the binary format of the BCP for the data files.  

The clabcp.dll is written in C, I will add the C code in near future.  There are some minor additions needed so the import can use application variables rather than a binary file.

The dll is compiled with SQL Server Native Client 11.0 so that driver will need to be installed.

The C code has been added. You will be able to build wit hte newer drivers if wanted/needed. However, that will require the C code is compiled with the header files for the driver. 
ODBC 13.x made some changes to the header files, 11.x may also made changes but I do not remember specifically. 

There is a backup of the AdventureWorks2019 database from MS that was used to create the demo.  Use any database wanted but for a quick review this may be the best option.
The backup is compressed so if you are use SQL Express you are out of luck.

The backup will be replaced soon with the scripts to create the tables used for the import, saves a little disk space. 

!TODO tasks: 
One, change the path for the output/input of the data files.
Two, change the server label and the database label if using a different database.

the demo exports seven tables from the database with 434,845 rows, takes a little more than a second.
The backup of the database contains seven additional tables used for the import.  These are copies of the seven tables used for the export with the word In appended to the table name.  This is not required but was done to simplify the demo.
The import takes about five seconds to complete.  Obviously an export is needed before the import.

The clearDemoTables.sql file can be used to clear the data after an import.  

Import from variables.
use the createtasble_variable_import.sql file to create the example tables.  These can be added to any database.
Change the server and database name as needed in the Clarion code.
Select the Import Variables control on the demo screen.  
A small screen with one button appears, select the button and wait two or three seconds. 
Once the screnn closes use the review_variable_import.sql file to view the changfes in the three demo tables.

The code is formatted as an ABC include file.  Add the files to the libsrc directory or place any where and adjust the redirection file as needed.

Send a note if you have questions, comments or suggestions.
