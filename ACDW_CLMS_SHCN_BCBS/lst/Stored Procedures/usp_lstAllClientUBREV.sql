


CREATE PROCEDURE	[lst].[usp_lstAllClientUBREV]
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
	'[SrcFileName] [varchar](50) NULL,	'+
	'[lstUBREVKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,'+
	'[UBREV_CODE] [varchar](10) NULL,'+
	'[UBREV_DESC] [varchar](150) NULL,	'+
	'[LOAD_DATE] [date] NULL,'+
	'[LOAD_USER] [varchar](25) NULL,'+
	'[ACTIVE] [char](1) DEFAULT ''Y'' NULL,'+
	'[EffectiveDate] [date] DEFAULT GETDATE() NULL,'+
	'[ExpirationDate] [date] DEFAULT ''2099-12-31'' NULL,' +
	'[UBREV_CODE_PADDED] [varchar](10) NULL' +
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	'[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName]
		, [lstUBREVKey], [UBREV_CODE], [UBREV_DESC], [LOAD_DATE], [LOAD_USER]
		, [ACTIVE], [EffectiveDate], [ExpirationDate],[UBREV_CODE_PADDED]'   + ')' +

		'SELECT		[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName]
		, [lstUBREVKey], [UBREV_CODE], [UBREV_DESC], [LOAD_DATE], [LOAD_USER]
		, [ACTIVE], [EffectiveDate], [ExpirationDate],[UBREV_CODE_PADDED]	'
				+
		' FROM		[AceMasterData].[lst].[LIST_UBREV]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[LIST_ICD10CM]
	--Targets
	/*
	SELECT COUNT(*) FROM ACDW_CLMS_AET_TX_COM.lst.List_UBREV
	SELECT COUNT(*) FROM ACDW_CLMS_SHCN_MSSP.lst.List_UBREV
	SELECT COUNT(*) FROM ACDW_CLMS_UHC.lst.List_UBREV
	SELECT COUNT(*) FROM ACDW_CLMS_WLC.lst.List_UBREV
	SELECT COUNT(*) FROM ACECAREDW.lst.List_UBREV
	SELECT COUNT(*) FROM ACECAREDW_TEST.lst.List_UBREV
	SELECT * FROM ACDW_CLMS_DHTX.lst.List_UBREV
	*/
	
	
