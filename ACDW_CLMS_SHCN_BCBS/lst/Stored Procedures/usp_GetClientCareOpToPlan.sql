

CREATE PROCEDURE	[lst].[usp_GetClientCareOpToPlan]
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
	'[lstCareOpToPlanKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,	'+
	'[ClientKey] [int] NOT NULL,'+
	'[CsPlan] [varchar](50) NOT NULL,'+
	'[MeasureID] [varchar](20) NOT NULL,'+
	'[MeasureDesc] [varchar](400) NOT NULL,'+
	'[SubMeasure] [varchar](100) NOT NULL,'+
	'[ACTIVE] [char](1) DEFAULT ''Y'' NULL,	'+
	'[EffectiveDate] [date] DEFAULT GETDATE() NULL,	'+
	'[ExpirationDate] [date] DEFAULT ''2099-12-31'' NULL' +
	'[Status] [char](1) NOT NULL,'+
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	'[SrcFileName]
		, [lstCareOpToPlanKey], [ClientKey], [CsPlan], [MeasureID], [MeasureDesc]
		, [SubMeasure], [ACTIVE], [EffectiveDate], [ExpirationDate]'   + ')' +

		'SELECT	[SrcFileName]
		, [lstCareOpToPlanKey], [ClientKey], [CsPlan], [MeasureID], [MeasureDesc]
		, [SubMeasure], [ACTIVE], [EffectiveDate], [ExpirationDate]	'
				+
		' FROM		[AceMasterData].[lst].[lstCareOpToPlan]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[lstCareOpToPlan]
	--Targets
	/*
	  SELECT * FROM ACDW_CLMS_UHC.lst.lstCareOpToPlan
	  SELECT * FROM ACDW_CLMS_WLC.lst.lstCareOpToPlan
	  SELECT * FROM ACECAREDW_TEST.lst.lstCareOpToPlan
	  SELECT * FROM ACECAREDW.lst.lstCareOpToPlan
	  SELECT * FROM DEV_ACECAREDW.lst.lstCareOpToPlan
	  SELECT * FROM ACDW_CLMS_DHTX.lst.lstCareOpToPlan
	  SELECT * FROM ACDW_CLMS_SHCN_MSSP.lst.lstCareOpToPlan
	*/
	
