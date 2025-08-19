
/* -----------------------------------------------------------------------
run this script to create the tables used for the demo.  
they can be added to an existing database or create a new one database.
the three tables are just used by the demo wit hvarious data types
-------------------------------------------------------------------------- */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[testTable](
	[SysId] [int] IDENTITY(1,1) NOT NULL,
	[fieldOne] [int] NOT NULL,
	[fieldTwo] [char](50) NOT NULL,
	[fieldThree] [nchar](50) NOT NULL,
	[FieldFour] [date] NOT NULL,
	[fieldFive] [tinyint] NOT NULL,
	[fieldSix] [smallint] NOT NULL,
	[fieldSeven] [float] NOT NULL,
	[FieldEight] [real] NOT NULL,
	[fieldNine] [bit] NOT NULL,
	[fieldTen] [time](7) NOT NULL
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[testTableTwo](
	[fieldOne] [int] NOT NULL,
	[fieldTwo] [nchar](50) NOT NULL,
	[fieldThree] [uniqueidentifier] NOT NULL,
	[fieldFour] [nchar](50) NOT NULL,
	[FieldFive] [datetime] NOT NULL,
 CONSTRAINT [PK_testTableTwo] PRIMARY KEY CLUSTERED (
	[fieldThree] ASC
  ) 
) ON [PRIMARY]
GO
CREATE TABLE [dbo].[testTableThree](
	[BusinessEntityID] [int] NOT NULL,
	[FirstName] [nchar](50) NOT NULL,
	[MiddleName] [nchar](50) NOT NULL,
	[LastName] [nchar](50) NOT NULL,
	[emailPromotion] [int] NOT NULL
) ON [PRIMARY]