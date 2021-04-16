



CREATE PROCEDURE	[lst].[usp_lstAllClient[CCSR]
					(@ConnectionString NVARCHAR(MAX))

AS

BEGIN
				--DECLARE @ConnectionString NVARCHAR(MAX) = 'ACDW_CLMS_AET_TX_COM.lst.LIST_ICD10CM'
				DECLARE	@SqlString NVARCHAR(MAX)
				

			-----Step 4
--Drop all Targets A
--Creates all Targets B
--Insert into all Target C

--A Drop all Targets
	SET @SqlString = N'DROP TABLE ' +  @ConnectionString 
	EXECUTE sp_executesql @SqlString
		--PRINT @SqlString
 
--B Create all Targets
  
--Create Triggers 
	SET @SqlString = 
	N'CREATE TABLE ' + @ConnectionString + '(' +
	'[CreatedDate] [datetime] DEFAULT GETDATE() NOT NULL,'+
	'[CreatedBy] [varchar](50) DEFAULT SUSER_SNAME() NOT NULL,'+
	'[LastUpdated] [datetime] DEFAULT GETDATE() NOT NULL,'+
	'[LastUpdatedBy] [varchar](50) DEFAULT SUSER_SNAME()  NOT NULL,	'+
	'[SrcFileName] [varchar](50) NULL,'+
	'[lstCCSRKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,'+
	'[ICD-10-CM CODE] [varchar](50) NULL,	'+
	'[ICD-10-CM CODE DESCRIPTION] [varchar](1000) NULL,'+
	'[Default CCSR CATEGORY] [varchar](20) NULL,'+
	'[Default CCSR CATEGORY DESCRIPTION] [varchar](1000) NULL,'+
	'[CCSR CATEGORY 1] [varchar] (50) NULL,'+
	'[CCSR CATEGORY 1 DESCRIPTION] [varchar](1000) NULL,'+
	'[CCSR CATEGORY 2] [varchar](50) NULL,'+
	'[CCSR CATEGORY 2 DESCRIPTION] [varchar](1000) NULL,'+
	'[CCSR CATEGORY 3] [varchar](50) NULL,'+
	'[CCSR CATEGORY 3 DESCRIPTION] [varchar](1000) NULL,'+
	'[CCSR CATEGORY 4] [varchar](50) NULL,'+
	'[CCSR CATEGORY 4 DESCRIPTION] [varchar](1000) NULL,'+
	'[CCSR CATEGORY 5] [varchar](50) NULL,'+
	'[CCSR CATEGORY 5 DESCRIPTION] [varchar](1000) NULL,'+
	'[ACTIVE] [char](1) DEFAULT ''Y'' NULL,'+
	'[EffectiveDate] [date] DEFAULT GETDATE() NULL,	'+
	'[ExpirationDate] [date] DEFAULT ''2099-12-31'' NULL' +
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	'[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName], [ACTIVE], [EffectiveDate]
		, [ExpirationDate], [lstCCSRKey], [ICD-10-CM CODE], [ICD-10-CM CODE DESCRIPTION], [Default CCSR CATEGORY]
		, [Default CCSR CATEGORY DESCRIPTION], [CCSR CATEGORY 1], [CCSR CATEGORY 1 DESCRIPTION], [CCSR CATEGORY 2]
		, [CCSR CATEGORY 2 DESCRIPTION], [CCSR CATEGORY 3], [CCSR CATEGORY 3 DESCRIPTION], [CCSR CATEGORY 4]
		, [CCSR CATEGORY 4 DESCRIPTION], [CCSR CATEGORY 5], [CCSR CATEGORY 5 DESCRIPTION]'   + ')' +

		' SELECT  [CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName], [ACTIVE]
		, [EffectiveDate], [ExpirationDate], [lstCCSRKey], [ICD-10-CM CODE], [ICD-10-CM CODE DESCRIPTION]
		, [Default CCSR CATEGORY], [Default CCSR CATEGORY DESCRIPTION], [CCSR CATEGORY 1]
		, [CCSR CATEGORY 1 DESCRIPTION], [CCSR CATEGORY 2], [CCSR CATEGORY 2 DESCRIPTION]
		, [CCSR CATEGORY 3], [CCSR CATEGORY 3 DESCRIPTION], [CCSR CATEGORY 4]
		, [CCSR CATEGORY 4 DESCRIPTION], [CCSR CATEGORY 5], [CCSR CATEGORY 5 DESCRIPTION]	'
				+
		' FROM		[AceMasterData].[lst].[List_CCSR]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [AceMasterData].[lst].[List_CCSR]
	--Targets
	/*
	 SELECT * FROM ACDW_CLMS_SHCN_MSSP.[lst].[List_CCSR]
	 SELECT * FROM ACECAREDW.[lst].[List_CCSR]
	 SELECT * FROM ACDW_CLMS_DHTX.[lst].[List_CCSR]
	 SELECT * FROM ACECAREDW_TEST.[lst].[List_CCSR]
	*/
	
	
