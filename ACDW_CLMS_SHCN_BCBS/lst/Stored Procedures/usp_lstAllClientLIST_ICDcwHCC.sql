

CREATE PROCEDURE	[lst].[usp_lstAllClientLIST_ICDcwHCC]
					(@ConnectionString NVARCHAR(MAX))

AS

BEGIN
				--DECLARE @ConnectionString NVARCHAR(MAX) = 'ACDW_CLMS_SHCN_MSSP.[lst].[LIST_ICDcwHCC]'
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
	'[CreatedBy] [varchar](50) DEFAULT suser_sname() NOT NULL,'+
	'[LastUpdated] [datetime] DEFAULT GETDATE()  NOT NULL,'+
	'[LastUpdatedBy] [varchar](50) DEFAULT suser_sname() NOT NULL,'+
	'[SrcFileName] [varchar](50) NULL,'+
	'[ICDcwHCCKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,'+
	'[ICDCode] [varchar](20) NULL,'+
	'[Description] [varchar](150) NULL,'+
	'[HCC] [varchar](10) NULL,'+
	'[VER] [varchar](10) NULL,'+
	'[ACTIVE] [char](1)  DEFAULT ''Y'' NULL,'+
	'[EffectiveDate] [date]  DEFAULT ''2017-01-01'' NULL,'+
	'[ExpirationDate] [date]  DEFAULT ''2099-12-31'' NULL' +
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	'[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName]
		, [ICDcwHCCKey], [ICDCode], [Description], [HCC], [VER], [ACTIVE], [EffectiveDate]
		, [ExpirationDate]'   + ')' +

		'SELECT		[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName]
		, [ICDcwHCCKey], [ICDCode], [Description], [HCC], [VER], [ACTIVE]
		, [EffectiveDate], [ExpirationDate]	'
				+
		' FROM		[AceMasterData].[lst].[LIST_ICDcwHCC]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[LIST_ICDcwHCC]
	--Targets
	/*
	--SELECT * FROM ACDW_CLMS_SHCN_MSSP.[lst].[LIST_ICDcwHCC]
	--SELECT * FROM ACDW_CLMS_UHC.[lst].[LIST_ICDcwHCC]
	--SELECT * FROM ACDW_CLMS_WLC.[lst].[LIST_ICDcwHCC]
	--SELECT * FROM ACECAREDW_TEST.[lst].[LIST_ICDcwHCC]
	  SELECT * FROM ACECAREDW.lst.[LIST_ICDcwHCC]
	  SELECT * FROM DEV_ACECAREDW.[lst].[LIST_ICDcwHCC]
	  SELECT * FROM ACDW_CLMS_DHTX.[lst].[LIST_ICDcwHCC]
	  SELECT * FROM ACDW_CLMS_CCACO.[lst].[LIST_ICDcwHCC]
	  SELECT * FROM ACDW_CLMS_WLC_ECAP.[lst].[LIST_ICDcwHCC]
	*/
	
	
	
