


CREATE PROCEDURE	[lst].[usp_lstAllClientICD10PCScwCCSCategory]
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
	'[CreatedDate] [datetime] DEFAULT (getdate())  NULL,'+
	'[CreatedBy] [varchar](20) DEFAULT (suser_sname()) NULL,'+
	'[LastUpdatedDate] [datetime] DEFAULT (getdate())  NULL,'+
	'[LastUpdatedBy] [varchar](20) DEFAULT (suser_sname()) NULL,'+
	'[LoadDate] [date] DEFAULT (CONVERT([date],getdate())) NULL,'+
	'[ICD10PCSCCSCategoryKey] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,'+
	'[ICD10PCSCode] [varchar](50) NULL,'+
	'[CCSCategory] [Char](5) NULL,'+
	'[ICD10PCSCodeDescription] [varchar](500) NULL,'+
	'[CCSCategoryDescription] [varchar](500) NULL,'+
	'[MultiCCSLvl1] [VarChar](150) NULL,'+
	'[MultiCCSLvl1Label] [varchar](150) NULL,'+
	'[MultiCCSLvl2] VARCHAR(150) NULL,'+
	'[MultiCCSLvl2Label] [varchar](150) NULL,'+
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
		+	'[CreatedDate], [CreatedBy], [LastUpdatedDate], [LastUpdatedBy]
		, [LoadDate], [ICD10PCSCCSCategoryKey], [ICD10PCSCode], [CCSCategory]
		, [ICD10PCSCodeDescription], [CCSCategoryDescription], [MultiCCSLvl1]
		, [MultiCCSLvl1Label], [MultiCCSLvl2], [MultiCCSLvl2Label], [ACTIVE]
		, [EffectiveDate], [ExpirationDate]'   + ')' +

		'SELECT		[CreatedDate], [CreatedBy], [LastUpdatedDate], [LastUpdatedBy]
		, [LoadDate], [ICD10PCSCCSCategoryKey], [ICD10PCSCode], [CCSCategory]
		, [ICD10PCSCodeDescription], [CCSCategoryDescription], [MultiCCSLvl1]
		, [MultiCCSLvl1Label], [MultiCCSLvl2], [MultiCCSLvl2Label], [ACTIVE]
		, [EffectiveDate], [ExpirationDate]	'
				+
		' FROM		[AceMasterData].[lst].[List_ICD10PCScwCCSCategory]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END


	
	
