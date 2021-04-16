CREATE PROCEDURE	[lst].[usp_lstAllClientAhrTips] 
					(@ConnectionString NVARCHAR(MAX))

AS

BEGIN
				--DECLARE @ConnectionString NVARCHAR(MAX) = '[ACDW_CLMS_WLC_ECAP].lst.LIST_AHRTIPS'
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
	'[CreatedDate] [datetime] DEFAULT (getdate()) NOT NULL, ' +		
	'[CreatedBy] [varchar](50) DEFAULT (suser_sname()) NOT NULL, ' +	
	'[LastUpdated] [datetime] DEFAULT (getdate()) NOT NULL,	' +
	'[LastUpdatedBy] [varchar](50) DEFAULT (suser_sname()) NOT NULL,' +
	'[SrcFileName] [varchar](50) NULL,' +
	'[AhrTipsKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,' +
	'[QMID] [varchar](20) NOT NULL,	' +
	'[QMDesc] [varchar](100) NOT NULL,' +
	'[Gender] [varchar](5) NULL,' +
	'[StartAgeMth] [int] NULL,' +
	'[EndAgeMth] [int] NULL,' +
	'[Line] [tinyint] NULL,	' +
	'[Documentation] [varchar](250) NULL,' +
	'[Tips] [varchar](250) NULL,' +
	'[Codes] [varchar](250) NULL,' +
	'[VersionDate] [date] NOT NULL,' +
	'[ACTIVE] [char](1) NULL,' +
	'[EffectiveDate] [date] DEFAULT GETDATE() NULL,' +
	'[ExpirationDate] [date] DEFAULT ''2099-12-31''NULL' +
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+ '[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName],[AhrTipsKey]
		, [QMID], [QMDesc], [Gender], [StartAgeMth], [EndAgeMth], [Line], [Documentation], [Tips]
		, [Codes], [VersionDate], [ACTIVE], [EffectiveDate], [ExpirationDate]' + ')' +

		'SELECT		[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], ''[AceMasterData].[lst].[LIST_AHRTips]''
					,[AhrTipsKey],[QMID],[QMDesc], [Gender], [StartAgeMth]
					, [EndAgeMth], [Line], [Documentation], [Tips]
					, [Codes], [VersionDate], [ACTIVE], [EffectiveDate], [ExpirationDate]'
				+
		' FROM		[AceMasterData].[lst].[LIST_AHRTips]'
				+
		'SET IDENTITY_INSERT' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [AceMasterData].[lst].[LIST_AHRTips]
	--Targets
	--SELECT * FROM [ACDW_CLMS_CCACO].lst.LIST_AHRTIPS
	--SELECT * FROM [ACDW_CLMS_WLC].lst.LIST_AHRTIPS
	--SELECT * FROM [ACDW_CLMS_WLC_ECAP].lst.LIST_AHRTIPS
	--SELECT * FROM [ACECAREDW_TEST].lst.LIST_AHRTIPS
	--SELECT * FROM [ACDW_CLMS_AET_TX_COM].lst.LIST_AHRTIPS
	--SELECT * FROM [ACDW_CLMS_OKC].lst.LIST_AHRTIPS
	--SELECT * FROM [ACDW_CLMS_DHTX].lst.LIST_AHRTIPS
