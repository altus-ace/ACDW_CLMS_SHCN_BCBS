

CREATE PROCEDURE	[lst].[usp_GetClientQMMapping]
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
	'[CreatedDate] [datetime] DEFAULT GETDATE()  NOT NULL ,	'+
	'[CreatedBy] [varchar](50) DEFAULT suser_sname()  NOT NULL ,'+
	'[LastUpdated] [datetime]  DEFAULT GETDATE()  NOT NULL ,'+
	'[LastUpdatedBy] [varchar](50) DEFAULT suser_sname()  NOT NULL ,'+
	'[SrcFileName] [varchar](100) NULL,'+
	'[QmKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,'+
	'[QM] [varchar](100) NOT NULL,'+
	'[QM_DESC] [varchar](500) NULL,	'+
	'[AHR_QM_DESC] [varchar](500) NULL,	'+
	'[ACTIVE] [char](1) DEFAULT ''Y'' NULL,	'+
	'[EffectiveDate] [date] DEFAULT ''2017-01-01'' NULL,'+
	'[ExpirationDate] [date] DEFAULT ''2099-12-31'' NULL,' +
	'[ClientKey] [INT] DEFAULT 0,' + --- Added ClientKey
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	'[SrcFileName], [QmKey]
		, [QM], [QM_DESC], [AHR_QM_DESC], [ACTIVE], [EffectiveDate], [ExpirationDate],[ClientKey]'   + ')' +

		'SELECT	[SrcFileName], [QmKey]
		, [QM], [QM_DESC], [AHR_QM_DESC], [ACTIVE], [EffectiveDate], [ExpirationDate],[ClientKey]'
				+
		' FROM		[AceMasterData].[lst].[LIST_QM_Mapping]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].LIST_QM_Mapping
	--Targets
	/*
	--SELECT * FROM ACDW_CLMS_SHCN_MSSP.[lst].[LIST_QM_Mapping]
	--SELECT * FROM ACDW_CLMS_UHC.[lst].LIST_QM_Mapping
	--SELECT * FROM ACDW_CLMS_WLC.[lst].LIST_QM_Mapping
	--SELECT * FROM ACECAREDW_TEST.[lst].LIST_QM_Mapping
	  SELECT * FROM ACECAREDW.[lst].LIST_QM_Mapping
	  SELECT * FROM DEV_ACECAREDW.[lst].LIST_QM_Mapping
	  SELECT * FROM ACDW_CLMS_DHTX.[lst].LIST_QM_Mapping
	*/
	
	
		
