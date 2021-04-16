

CREATE PROCEDURE	[lst].[usp_lstAllClientDRG]
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
	'[lstDrgKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,	'+
	'[DRG_CODE] [varchar](20) NULL,	'+
	'[DRG_DESC] [varchar](5000) NULL,'+
	'[DRG_MDC_MajorDiagnosticCategory] [varchar](150) NULL,	'+
	'[MDC_DESC] [varchar](300) NULL,'+
	'[MedMorSurgP] [varchar](20) NULL,'+
	'[DRG_VER] [int] NULL,'+
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
		+	'[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName]
		, [lstDrgKey], [DRG_CODE], [DRG_DESC], [DRG_MDC_MajorDiagnosticCategory]
		, [MDC_DESC], [MedMorSurgP], [DRG_VER], [ACTIVE], [EffectiveDate], [ExpirationDate]'   + ')' +

		'SELECT		[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName]
		, [lstDrgKey], [DRG_CODE], [DRG_DESC], [DRG_MDC_MajorDiagnosticCategory]
		, [MDC_DESC], [MedMorSurgP], [DRG_VER], [ACTIVE], [EffectiveDate], [ExpirationDate]	'
				+
		' FROM		[AceMasterData].[lst].[LIST_DRG]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[List_DRG]
	--Targets
	/*
	SELECT * FROM ACDW_CLMS_CCACO.lst.LIST_DRG
	SELECT * FROM ACDW_CLMS_NLH.dbo.LIST_DRG
	SELECT * FROM Ace_Portal_Staging.dbo.List_DRG
	SELECT * FROM ACECAREDW_TEST.dbo.List_DRG
	*/
	
	/** USAGE
	EXECUTE [lst].[usp_lstAllClientDRG]'ACECAREDW_TEST.dbo.List_DRG'
	**/
