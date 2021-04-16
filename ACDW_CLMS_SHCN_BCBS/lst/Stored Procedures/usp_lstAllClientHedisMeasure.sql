
CREATE PROCEDURE	[lst].[usp_lstAllClientHedisMeasure]
					(@ConnectionString NVARCHAR(MAX))

AS

BEGIN
				--DECLARE @ConnectionString NVARCHAR(MAX) = 'ACDW_CLMS_CCACO.lst.LIST_HEDIS_MEASURE'
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
	'[SrcFileName] [varchar](50) NOT NULL,'+
	'[HedisMeasureKey] INT PRIMARY KEY IDENTITY (1,1),'+
	'[MEASURE_ID] [varchar](5) NOT NULL,'+
	'[MEASURE_NAME] [varchar](255) NULL,'+
	'[VALUE_SET_NAME] [varchar](100) NULL,'+
	'[VALUE_SET_OID] [varchar](100) NULL,'+
	'[A_LAST_UPDATE_DATE] [datetime] DEFAULT GETDATE() NULL,'+
	'[A_LAST_UPDATE_BY] [varchar](20)  NULL,'+
	'[A_LAST_UPDATE_FLAG] [varchar](1) DEFAULT ''Y'' NULL,'+
	'[ACTIVE] [char](1) NULL,'+
	'[EffectiveDate] [date] DEFAULT GETDATE() NULL,	'+
	'[ExpirationDate] [date] DEFAULT ''2099-12-31'' NULL' +
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	'[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName]
		, [HedisMeasureKey], [MEASURE_ID], [MEASURE_NAME], [VALUE_SET_NAME], [VALUE_SET_OID]
		, [A_LAST_UPDATE_DATE], [A_LAST_UPDATE_BY], [A_LAST_UPDATE_FLAG], [ACTIVE]
		, [EffectiveDate], [ExpirationDate]'   + ')' +

		'SELECT		[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName]
		, [HedisMeasureKey], [MEASURE_ID], [MEASURE_NAME], [VALUE_SET_NAME]
		, [VALUE_SET_OID], [A_LAST_UPDATE_DATE], [A_LAST_UPDATE_BY]
		, [A_LAST_UPDATE_FLAG], [ACTIVE], [EffectiveDate], [ExpirationDate]'
				+
		' FROM		[AceMasterData].[lst].[LIST_HEDIS_MEASURE]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [AceMasterData].[lst].[LIST_HEDIS_MEASURE]
	--Targets
	/*
	
	SELECT * FROM ACDW_CLMS_CCACO.lst.LIST_HEDIS_MEASURE
	SELECT * FROM ACDW_CLMS_NLH.dbo.LIST_HEDIS_MEASURE
	SELECT * FROM ACDW_CLMS_OKC.lst.LIST_HEDIS_MEASURE
	SELECT * FROM ACDW_CLMS_SHCN.lst.LIST_HEDIS_MEASURE
	SELECT * FROM ACDW_CLMS_WLC.lst.LIST_HEDIS_MEASURE
	SELECT * FROM ACECAREDW_TEST.dbo.LIST_HEDIS_MEASURE
	SELECT * FROM ACDW_CLMS_WLC_ECAP.lst.LIST_HEDIS_MEASURE
	SELECT * FROM Ace_Portal_Staging.dbo.LIST_HEDIS_MEASURE
	SELECT * FROM ACECAREDW.dbo.LIST_HEDIS_MEASURE
	SELECT * FROM AceCareDw_Qa.dbo.LIST_HEDIS_MEASURE
	SELECT * FROM ACDW_CLMS_DHTX.lst.LIST_HEDIS_MEASURE
	*/
	
	
