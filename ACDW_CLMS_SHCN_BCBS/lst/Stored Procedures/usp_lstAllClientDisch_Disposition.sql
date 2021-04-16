

CREATE PROCEDURE	[lst].[usp_lstAllClientDisch_Disposition]
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
	'[CreatedDate] [datetime] NOT NULL,	'+
	'[CreatedBy] [varchar](50) NOT NULL,'+
	'[LastUpdated] [datetime] NOT NULL,'+
	'[LastUpdatedBy] [varchar](50) NOT NULL,'+
	'[SrcFileName] [varchar](50) NULL,'+
	'[lstDischDispositionKey] [int] IDENTITY(1,1) NOT NULL,	'+
	'[DataDate] [date] NOT NULL,'+
	'[Disch_Disp_Code] [varchar](10) NULL,'+
	'[Disch_Disp_CodeValue] [varchar](100) NULL,'+
	'[Disch_Disp_Description] [varchar](1000) NULL,	'+
	'[Version] [varchar](50) NULL,'+
	'[ACTIVE] [char](1) NULL,'+
	'[EffectiveDate] [date] NULL,'+
	'[ExpirationDate] [date] NULL,' +
	'[Disch_Disp_CodePadded] VARCHAR(10)' +
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	'[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName], [lstDischDispositionKey]
		, [DataDate], [Disch_Disp_Code], [Disch_Disp_CodeValue], [Disch_Disp_Description]
		, [Version], [ACTIVE], [EffectiveDate], [ExpirationDate],[Disch_Disp_CodePadded]'   + ')' +

		'SELECT		[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName]
		, [lstDischDispositionKey], [DataDate], [Disch_Disp_Code], [Disch_Disp_CodeValue]
		, [Disch_Disp_Description], [Version], [ACTIVE], [EffectiveDate], [ExpirationDate],[Disch_Disp_CodePadded]	'
				+
		' FROM		[AceMasterData].[lst].[LIST_Disch_Disposition]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[LIST_Disch_Disposition]
	--Targets
	/*
	SELECT * FROM ACDW_CLMS_AET_TX_COM.lst.[LIST_Disch_Disposition]
	SELECT COUNT(*) FROM ACDW_CLMS_CCACO.[lst].[LIST_Disch_Disposition]
	SELECT COUNT(*) FROM ACDW_CLMS_NLH.[dbo].[LIST_Disch_Disposition]
	SELECT COUNT(*) FROM ACDW_CLMS_OKC.[lst].[LIST_Disch_Disposition]
	SELECT * FROM ACDW_CLMS_SHCN_MSSP.[lst].[LIST_Disch_Disposition]
	SELECT COUNT(*) FROM ACDW_CLMS_UHC.[lst].[LIST_Disch_Disposition]
	SELECT COUNT(*) FROM ACDW_CLMS_WLC.[lst].[LIST_Disch_Disposition]
	SELECT COUNT(*) FROM ACDW_CLMS_WLC_ECAP.[lst].[LIST_Disch_Disposition]
	SELECT COUNT(*) FROM ACECAREDW.[lst].[LIST_Disch_Disposition]
	SELECT COUNT(*) FROM AceCareDw_Qa.[lst].[LIST_Disch_Disposition]
	SELECT COUNT(*) FROM ACECAREDW_TEST.[lst].[LIST_Disch_Disposition]
	SELECT * FROM ACDW_CLMS_DHTX.[lst].[LIST_Disch_Disposition]
	SELECT * FROM ACDW_CLMS_OSC.[lst].[LIST_Disch_Disposition]
	*/
	
	
	
