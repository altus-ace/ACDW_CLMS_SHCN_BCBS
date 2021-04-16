


CREATE PROCEDURE	[lst].[usp_lstAllClientDrugPackage]
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
	'[CreatedBy] [varchar](50) DEFAULT SUSER_SNAME() NOT NULL,	'+
	'[LastUpdatedDate] [datetime] DEFAULT GETDATE() NOT NULL,'+
	'[LastUpdatedBy] [varchar](50) DEFAULT SUSER_SNAME()  NOT NULL,	'+
	'[SrcFileName] [varchar](100) NULL,	'+
	'[lstNdcDrugPackageKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,	'+
	'[PRODUCTID] [varchar](60) NOT NULL,'+
	'[PRODUCTNDC] [varchar](20) NOT NULL,'+
	'[NDCPACKAGECODE_SRC] [varchar](100) NOT NULL,'+
	'[NdcPackageCode_Clean] [varchar](100) NOT NULL,'+
	'[PACKAGEDESCRIPTION] [varchar](1000)  NULL,	'+
	'[srcStartMarketingDate] [varchar](100)  NULL,'+
	'[srcEndMarketingDate] [varchar](100)  NULL,'+
	'[StartMarketingDate] [varchar](50)  NULL,'+
	'[EndMarketingDate] [varchar](50)  NULL,'+
	'[NdcExcludeFlag] [varchar](50)  NULL,'+
	'[SamplePackage] [varchar](50)  NULL,'+
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
		+	'[CreatedDate], [CreatedBy], [LastUpdatedDate], [LastUpdatedBy], [SrcFileName]
		, [lstNdcDrugPackageKey], [PRODUCTID], [PRODUCTNDC], [NDCPACKAGECODE_Src],[NdcPackageCode_Clean]
		, [PACKAGEDESCRIPTION],[srcStartMarketingDate],[srcEndMarketingDate],[StartMarketingDate]
		, [EndMarketingDate],[NdcExcludeFlag] ,[SamplePackage]
		, [ACTIVE], [EffectiveDate], [ExpirationDate]'   + ')' +

		'SELECT		[CreatedDate], [CreatedBy], [LastUpdatedDate], [LastUpdatedBy], [SrcFileName]
		, [lstNdcDrugPackageKey], [PRODUCTID], [PRODUCTNDC], [NDCPACKAGECODE_Src],[NdcPackageCode_Clean]
		, [PACKAGEDESCRIPTION],[srcStartMarketingDate],[srcEndMarketingDate],[StartMarketingDate]
		, [EndMarketingDate],[NdcExcludeFlag] ,[SamplePackage]
		, [ACTIVE], [EffectiveDate], [ExpirationDate]'
				+
		' FROM		[AceMasterData].[lst].[lstNdcDrugPackage]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[lstNdcDrugPackage]
	--Targets
	/*
	SELECT * FROM ACDW_CLMS_NLH.dbo.[lstNdcDrugPackage]
	SELECT * FROM ACECAREDW_TEST.lst.[lstNdcDrugPackage]
	SELECT * FROM ACECAREDW_TEST.dbo.[lstNdcDrugPackage]
	select * from ACDW_CLMS_SHCN_MSSP.lst.[lstNdcDrugPackage]
	SELECT * FROM ACDW_CLMS_DHTX.lst.[lstNdcDrugPackage]
	*/
	
	


	
	
