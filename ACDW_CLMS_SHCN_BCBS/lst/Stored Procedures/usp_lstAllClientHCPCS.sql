


CREATE PROCEDURE	[lst].[usp_lstAllClientHCPCS]
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
	'[lstHCPCSKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,'+
	'[HCPC_MOD] [varchar](20) NULL,	'+
	'[ACTION_CD] [varchar](20) NULL,	'+
	'[SHORT_DESC] [varchar](50) NULL,'+
	'[LONG_DESC] [varchar](8000)NULL,	'+
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
		, [lstHCPCSKey], [HCPC_MOD], [ACTION_CD], [SHORT_DESC], [LONG_DESC], [ACTIVE]
		, [EffectiveDate], [ExpirationDate]'   + ')' +

		'SELECT		[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName]
		, [lstHCPCSKey], [HCPC_MOD], [ACTION_CD], [SHORT_DESC], [LONG_DESC], [ACTIVE]
		, [EffectiveDate], [ExpirationDate]	'
				+
		' FROM		[AceMasterData].[lst].[LIST_HCPCS]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[LIST_HCPCS]
	--Targets
	/*
	SELECT * FROM ACDW_CLMS_CCACO.lst.LIST_HCPCS
	SELECT	 * FROM ACDW_CLMS_NLH.lst.LIST_HCPCS
	SELECT	 *  FROM Ace_Portal_Staging.dbo.LIST_HCPCS
	SELECT	*  FROM ACECAREDW_TEST.lst.LIST_HCPCS
	SELECT	* FROM ACECAREDW_TEST.lst.LIST_HCPCS
	SELECT * FROM ACDW_CLMS_UHC.lst.LIST_HCPCS
	SELECT * FROM ACDW_CLMS_DHTX.lst.LIST_HCPCS
	SELECT * FROM ACDW_CLMS_WLC_ECAP.lst.LIST_HCPCS
	*/
	

	
