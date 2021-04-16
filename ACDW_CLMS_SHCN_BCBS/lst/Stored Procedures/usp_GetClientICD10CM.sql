

CREATE PROCEDURE	[lst].[usp_GetClientICD10CM]
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
	'[LastUpdatedBy] [varchar](50) DEFAULT SUSER_SNAME()  NOT NULL,'+
	'[SrcFileName] [varchar](50) NULL,'+
	'[lstICD10CMKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,'+
	'[VALUE_SET_NAME] [varchar](100) NULL,	'+
	'[VALUE_SET_OID] [varchar](100) NULL,'+
	'[VALUE_SET_VER] [varchar](50) NULL,'+
	'[VALUE_CODE] [varchar](50) NULL,	'+
	'[VALUE_CODE_NAME] [varchar](max) NULL,	'+
	'[VALUE_CODE_SYSTEM] [varchar](50) NULL,'+
	'[CODE_SYSTEM_OID] [varchar](50) NULL,'+
	'[CODE_SYSTEM_VER] [varchar](50) NULL,'+
	'[A_LAST_UPDATE_DATE] [datetime] NULL,'+
	'[A_LAST_UPDATE_BY] [varchar](20) NULL,	'+
	'[A_LAST_UPDATE_FLAG] [varchar](1) NULL,'+
	'[ACTIVE] [char](1) DEFAULT ''Y'' NULL,	'+
	'[EffectiveDate] [date] DEFAULT GETDATE() NULL,'+
	'[ExpirationDate] [date] DEFAULT ''2099-12-31'' NULL' +
	'[Status] [char](1) NULL,	'+
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	'[SrcFileName], [lstICD10CMKey]
		, [VALUE_SET_NAME], [VALUE_SET_OID], [VALUE_SET_VER], [VALUE_CODE], [VALUE_CODE_NAME]
		, [VALUE_CODE_SYSTEM], [CODE_SYSTEM_OID], [CODE_SYSTEM_VER], [A_LAST_UPDATE_DATE]
		, [A_LAST_UPDATE_BY], [A_LAST_UPDATE_FLAG], [ACTIVE], [EffectiveDate], [ExpirationDate]'   + ')' +

		'SELECT	 [SrcFileName], [lstICD10CMKey]
		, [VALUE_SET_NAME], [VALUE_SET_OID], [VALUE_SET_VER], [VALUE_CODE], [VALUE_CODE_NAME]
		, [VALUE_CODE_SYSTEM], [CODE_SYSTEM_OID], [CODE_SYSTEM_VER], [A_LAST_UPDATE_DATE]
		, [A_LAST_UPDATE_BY], [A_LAST_UPDATE_FLAG], [ACTIVE], [EffectiveDate], [ExpirationDate]	'
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
	SELECT COUNT(*) FROM ACDW_CLMS_CCACO.lst.LIST_ICD10CM
	SELECT COUNT(*) FROM ACDW_CLMS_NLH.dbo.LIST_ICD10CM
	SELECT COUNT(*) FROM ACDW_CLMS_OKC.lst.LIST_ICD10CM
	SELECT COUNT(*) FROM ACDW_CLMS_SHCN.lst.LIST_ICD10CM
	SELECT COUNT(*) FROM ACDW_CLMS_UHC.lst.LIST_ICD10CM
	SELECT COUNT(*) FROM ACDW_CLMS_WLC.lst.LIST_ICD10CM
	SELECT COUNT(*) FROM ACDW_CLMS_WLC_ECAP.lst.LIST_ICD10CM
	SELECT COUNT(*) FROM ACECAREDW.dbo.LIST_ICD10CM
	SELECT COUNT(*) FROM AceCareDw_Qa.dbo.LIST_ICD10CM
	SELECT COUNT(*) FROM ACECAREDW_TEST.dbo.LIST_ICD10CM
	SELECT * FROM ACDW_CLMS_DHTX.lst.LIST_ICD10CM
	*/
	
