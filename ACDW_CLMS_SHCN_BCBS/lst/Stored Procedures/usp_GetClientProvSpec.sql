
CREATE PROCEDURE	[lst].[usp_GetClientProvSpec]
					(@ConnectionString NVARCHAR(MAX))

AS

BEGIN
				--DECLARE @ConnectionString NVARCHAR(MAX) = 'ACDW_CLMS_CCACO.lst.LIST_PROV_SPECIALTY_CODES'
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
	'[CreatedBy] [varchar](50) DEFAULT suser_sname() NOT NULL,'+
	'[LastUpdated] [datetime] DEFAULT GETDATE()  NOT NULL,'+
	'[LastUpdatedBy] [varchar](50) DEFAULT suser_sname() NOT NULL,'+
	'[SrcFileName] [varchar](50) NULL,'+
	'[ProvSpecKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,'+
	'[Code] [varchar](20) NOT NULL,'+
	'[CodeDesc] [varchar](200) NOT NULL,'+
	'[ACTIVE] [char](1) NULL,'+
	'[EffectiveDate] [date] DEFAULT GETDATE() NULL,'+
	'[ExpirationDate] [date] DEFAULT ''2099-12-31'' NULL,' +
	'[Prov_Class] [VARCHAR](50)' +
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	' [SrcFileName]
			, [ProvSpecKey], [Code], [CodeDesc], [ACTIVE], [EffectiveDate], [ExpirationDate], [Prov_Class]'   + ')' +

		'SELECT	 [SrcFileName], [ProvSpecKey]
					, [Code], [CodeDesc], [ACTIVE], [EffectiveDate], [ExpirationDate], [Prov_Class]'
				+
		' FROM		[AceMasterData].[lst].[LIST_PROV_SPECIALTY_CODES]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[LIST_PROV_SPECIALTY_CODES]
	--Targets
	--SELECT * FROM ACDW_CLMS_CCACO.lst.LIST_PROV_SPECIALTY_CODES
	--SELECT * FROM ACECAREDW.dbo.LIST_PROV_SPECIALTY_CODES
	--SELECT * FROM [ACDW_CLMS_WLC].lst.LIST_PROV_SPECIALTY_CODES
	--SELECT * FROM [ACDW_CLMS_WLC_ECAP].lst.LIST_PROV_SPECIALTY_CODES
	--SELECT * FROM [ACECAREDW_TEST].[lst].LIST_PROV_SPECIALTY_CODES
	--SELECT * FROM [ACDW_CLMS_AET_TX_COM].lst.LIST_PROV_SPECIALTY_CODES
	--SELECT * FROM [ACDW_CLMS_OKC].lst.LIST_PROV_SPECIALTY_CODES
	--SELECT * FROM [ACDW_CLMS_DHTX].lst.LIST_PROV_SPECIALTY_CODES
	--SELECT * FROM [ACECAREDW].DBO.LIST_PROV_SPECIALTY_CODES

	
