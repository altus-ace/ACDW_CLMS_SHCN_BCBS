

CREATE PROCEDURE	[lst].[usp_lstAllClientDrugProduct]
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
	'[LastUpdatedDate] [datetime] DEFAULT GETDATE() NOT NULL,'+
	'[LastUpdatedBy] [varchar](50) DEFAULT SUSER_SNAME()  NOT NULL,	'+
	'[SrcFileName] [varchar](100) NULL,	'+
	'[lstNdcDrugProductKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,	'+
	'[PRODUCTID] [varchar](60) NULL,'+
	'[PRODUCTNDC] [varchar](20) NULL,'+
	'[PRODUCTTYPENAME] [varchar](50) NULL,	'+
	'[PROPRIETARYNAME] [varchar](2500) NULL,'+
	'[PROPRIETARYNAMESUFFIX] [varchar](250) NULL,'+
	'[NONPROPRIETARYNAME] [varchar](1000) NULL,	'+
	'[DOSAGEFORMNAME] [varchar](50) NULL,'+
	'[ROUTENAME] [varchar](500) NULL,	'+
	'[STARTMARKETINGDATE] [varchar](10) NULL,'+
	'[ENDMARKETINGDATE] [varchar](10) NULL,		'+
	'[MARKETINGCATEGORYNAME] [varchar](50) NULL,'+
	'[APPLICATIONNUMBER] [varchar](20) NULL,'+
	'[LABELERNAME] [varchar](400) NULL,	'+
	'[SUBSTANCENAME] [varchar](5000) NULL,	'+
	'[ActiveNumeratorStrength] [varchar](5000) NULL,	'+
	'[ActiveIngredUnit] [varchar](5000) NULL,	'+
	'[PharmClasses] [varchar](5000) NULL,	'+
	'[DEASCHEDULE] [varchar](10) NULL,	'+
	'[NdcExcludeFlag] [char](1) NULL,'+
	'[ListingRecordCertifiedThrough] DATE NULL,'+
	'[ACTIVE] [char](1) DEFAULT ''Y'' NULL,	'+
	'[EffectiveDate] [date] DEFAULT GETDATE() NULL,	'+
	'[ExpirationDate] [date] DEFAULT ''2099-12-31'' NULL,' +
	'[Status] [char](1) NULL '+
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	'[SrcFileName], [lstNdcDrugProductKey]
		, [PRODUCTID], [PRODUCTNDC], [PRODUCTTYPENAME], [PROPRIETARYNAME], [PROPRIETARYNAMESUFFIX]
		, [NONPROPRIETARYNAME], [DOSAGEFORMNAME], [ROUTENAME], [STARTMARKETINGDATE], [ENDMARKETINGDATE]
		, [MARKETINGCATEGORYNAME], [APPLICATIONNUMBER], [LABELERNAME], [SUBSTANCENAME], [ActiveNumeratorStrength]
		, [ActiveIngredUnit], [PharmClasses], [DEASCHEDULE],[NDCEXCLUDEFLAG],[ListingRecordCertifiedThrough]
		, [ACTIVE], [EffectiveDate], [ExpirationDate]'   + ')' +

		'SELECT	[SrcFileName], [lstNdcDrugProductKey]
		, [PRODUCTID], [PRODUCTNDC], [PRODUCTTYPENAME], [PROPRIETARYNAME], [PROPRIETARYNAMESUFFIX]
		, [NONPROPRIETARYNAME], [DOSAGEFORMNAME], [ROUTENAME], [STARTMARKETINGDATE], [ENDMARKETINGDATE]
		, [MARKETINGCATEGORYNAME], [APPLICATIONNUMBER], [LABELERNAME], [SUBSTANCENAME], [ActiveNumeratorStrength]
		, [ActiveIngredUnit], [PharmClasses], [DEASCHEDULE], [NDCEXCLUDEFLAG],[ListingRecordCertifiedThrough]
		, [ACTIVE], [EffectiveDate], [ExpirationDate]'
				+
		' FROM		[AceMasterData].[lst].[lstNdcDrugProduct]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[lstNdcDrugProduct] 
	--Targets
	/*
	SELECT * FROM ACECAREDW_TEST.dbo.[lstNdcDrugProduct] 
	SELECT * FROM [ACDW_CLMS_SHCN_MSSP].[lstNdcDrugProduct] 
	SELECT * FROM ACDW_CLMS_UHC.lst.L[lstNdcDrugProduct] 
	SELECT * FROM ACDW_CLMS_DHTX.[lst].[lstNdcDrugProduct] 
	*/
	
	
	
