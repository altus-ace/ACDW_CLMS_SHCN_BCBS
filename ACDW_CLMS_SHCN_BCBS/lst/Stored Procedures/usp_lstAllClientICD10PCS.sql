


CREATE PROCEDURE	[lst].[usp_lstAllClientICD10PCS]
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
	'[lstICD10PCSKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,'+
	'[ICD10PCS_Code] [varchar](20) NULL,	'+
	'[ICD10PCS_Desc]  [varchar](1000) NULL,'+
	'[ICD10PCS_CodeCategory] [varchar](20) NULL,'+
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
		, [lstICD10PCSKey], [ICD10PCS_Code], [ICD10PCS_Desc],[ICD10PCS_CodeCategory], [ACTIVE], [EffectiveDate], [ExpirationDate]'   + ')' +

		'SELECT		[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName], [lstICD10PCSKey]
		, [ICD10PCS_Code], [ICD10PCS_Desc],[ICD10PCS_CodeCategory], [ACTIVE], [EffectiveDate], [ExpirationDate]	'
				+
		' FROM		[AceMasterData].[lst].[LIST_ICD10PCS]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [AceMasterData].[lst].[LIST_ICD10PCS]
	--Targets
	/*
	SELECT * FROM ACECAREDW_TEST.[lst].[LIST_ICD10PCS]
	SELECT * FROM Ace_Portal_Staging.dbo.[LIST_ICD10PCS]
	SELECT * FROM [ACDW_CLMS_SHCN_MSSP].[lst].[LIST_ICD10PCS]
	*/
	
	
