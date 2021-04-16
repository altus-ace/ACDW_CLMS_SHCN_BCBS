CREATE PROCEDURE	[lst].[usp_lstAllClientHccCodes]
					(@ConnectionString NVARCHAR(MAX))

AS

BEGIN
				--DECLARE @ConnectionString NVARCHAR(MAX) = '[AceMasterData].[lst].[LIST_HCC_CODES]'
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
	'[CreatedDate] [datetime] DEFAULT (getdate())  NULL,'+
	'[CreatedBy] [varchar](50) DEFAULT (suser_sname()) NULL,'+
	'[LastUpdated] [datetime] DEFAULT (getdate())  NULL,'+
	'[LastUpdatedBy] [varchar](50) DEFAULT (suser_sname()) NULL,'+
	'[SrcFileName] [varchar](50) NULL,'+
	'[HccSkey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,'+
	'[HCC_No] [int] NOT NULL,'+
	'[HCC_VERSION] [varchar](20) NULL,'+
	'[HCC_Description] [nvarchar](max) NULL,'+
	'[Disease_Hier] [nvarchar](50) NULL,'+
	'[ACTIVE] [char](1) DEFAULT ''Y'' NULL,'+
	'[EffectiveDate] [date] DEFAULT GETDATE() NULL,'+
	'[ExpirationDate] [date] DEFAULT ''2099-12-31'' NULL' +
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	'[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName], [HccSkey], [HCC_No]
		, [HCC_VERSION], [HCC_Description], [Disease_Hier], [ACTIVE], [EffectiveDate], [ExpirationDate]'   + ')' +

		'SELECT		[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], ''[AceMasterData].[lst].[LIST_HCC_CODES]'', [HccSkey], [HCC_No]
					, [HCC_VERSION], [HCC_Description], [Disease_Hier], [ACTIVE], [EffectiveDate], [ExpirationDate]'
				+
		' FROM		[AceMasterData].[lst].[LIST_HCC_CODES]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [AceMasterData].[lst].[LIST_HCC_CODES]
	--Targets
	--SELECT * FROM [ACDW_CLMS_CCACO].[lst].[LIST_HCC_CODES]
	--SELECT * FROM [ACDW_CLMS_WLC].[lst].[LIST_HCC_CODES]
	--SELECT * FROM [ACDW_CLMS_WLC_ECAP].[lst].[LIST_HCC_CODES]
	--SELECT * FROM [ACECAREDW_TEST].[lst].[LIST_HCC_CODES]
	--SELECT * FROM [ACDW_CLMS_AET_TX_COM].[lst].[LIST_HCC_CODES]
	--SELECT * FROM [ACDW_CLMS_OKC].[lst].[LIST_HCC_CODES]
	--SELECT * FROM [ACDW_CLMS_DHTX].[lst].[LIST_HCC_CODES]
	--SELECT * FROM [ACECAREDW].[lst].[LIST_HCC_CODES]

	
