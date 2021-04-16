

CREATE PROCEDURE	[lst].[usp_GetClientMDC]
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
	'[lstMDCKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,'+
	'[Mdc_Code] [varchar](20) NULL,	'+
	'[Mdc_Desc] [varchar](300) NULL,'+
	'[MS_DRG] [varchar](20) NULL,'+
	'[Type] [varchar](20) NULL,'+
	'[ACTIVE] [char](1) DEFAULT ''Y'' NULL,'+
	'[EffectiveDate] [date] DEFAULT GETDATE() NULL,	'+
	'[ExpirationDate] [date] DEFAULT ''2099-12-31'' NULL' +
	'[Status] [char](1) NULL,'+
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	' [SrcFileName]
		, [lstMDCKey], [Mdc_Code], [Mdc_Desc],[MS_DRG], [Type], [ACTIVE], [EffectiveDate], [ExpirationDate]'   + ')' +

		'SELECT	[SrcFileName], [lstMDCKey]
		, [Mdc_Code], [Mdc_Desc],[MS_DRG], [Type], [ACTIVE], [EffectiveDate], [ExpirationDate]	'
				+
		' FROM		[AceMasterData].[lst].[LIST_MDC]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[LIST_MDC]
	--Targets
	/*
	SELECT * FROM ACECAREDW_TEST.dbo.LIST_MDC
	*/
	
	
