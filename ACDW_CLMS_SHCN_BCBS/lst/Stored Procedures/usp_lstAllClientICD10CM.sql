

CREATE PROCEDURE	[lst].[usp_lstAllClientICD10CM]
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
	'[CreatedDate] [datetime] DEFAULT GETDATE() NOT NULL,' +
	'[CreatedBy] [varchar](50) DEFAULT SUSER_SNAME() NOT NULL,'+
	'[LastUpdated] [datetime] DEFAULT GETDATE() NOT NULL,'+
	'[LastUpdatedBy] [varchar] (50) DEFAULT SUSER_SNAME() NOT NULL,'+
	'[SrcFileName] [varchar](50) NULL,'+
	'[ACTIVE] [char](1) NULL,'+
	'[EffectiveDate] [date] NULL,'+
	'[ExpirationDate] [date] NULL,'+
	'[lstIcd10CmKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,'+
	'[VALUE_CODE] [varchar](50) NULL,'+
	'[VALUE_CODE_NAME] [varchar](2000) NULL' +
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	'[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy]
		, [SrcFileName], [ACTIVE], [EffectiveDate], [ExpirationDate]
		, [lstIcd10CmKey], [VALUE_CODE], [VALUE_CODE_NAME]'   + ')' +

		'SELECT		[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy]
		, [SrcFileName], [ACTIVE], [EffectiveDate], [ExpirationDate]
		, [lstIcd10CmKey], [VALUE_CODE], [VALUE_CODE_NAME]	'
				+
		' FROM		[AceMasterData].[lst].[LIST_ICD10CM]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[LIST_ICD10CM]
	--Targets
	/*
	SELECT COUNT(*) FROM ACDW_CLMS_AET_TX_COM.lst.LIST_ICD10CM
	SELECT * FROM ACDW_CLMS_SHCN_MSSP.lst.LIST_ICD10CM
	SELECT COUNT(*) FROM ACDW_CLMS_UHC.lst.LIST_ICD10CM
	SELECT COUNT(*) FROM ACDW_CLMS_WLC.lst.LIST_ICD10CM
	SELECT COUNT(*) FROM ACDW_CLMS_WLC_ECAP.lst.LIST_ICD10CM
	SELECT COUNT(*) FROM ACECAREDW.dbo.LIST_ICD10CM
	SELECT COUNT(*) FROM AceCareDw_Qa.dbo.LIST_ICD10CM
	SELECT COUNT(*) FROM ACECAREDW_TEST.dbo.LIST_ICD10CM
	SELECT * FROM ACDW_CLMS_DHTX.lst.LIST_ICD10CM
	*/
	
