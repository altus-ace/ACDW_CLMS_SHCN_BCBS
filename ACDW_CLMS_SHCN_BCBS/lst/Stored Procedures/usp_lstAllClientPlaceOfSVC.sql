

CREATE PROCEDURE	[lst].[usp_lstAllClientPlaceOfSVC]
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
	'[lstPlaceOfSvcKey] [int] IDENTITY(1,1) NOT NULL,'+
	'[DataDate] [date] NOT NULL,'+
	'[Place_of_Service_Code] [varchar](10) NULL,'+
	'[Place_of_Service_Name] [varchar](100) NULL,'+
	'[Place_of_Service_Description] [varchar](1000) NULL,'+
	'[Version] [varchar](50) NULL,'+
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
		, [lstPlaceOfSvcKey], [DataDate], [Place_of_Service_Code], [Place_of_Service_Name]
		, [Place_of_Service_Description], [Version], [ACTIVE], [EffectiveDate], [ExpirationDate]'   + ')' +

		'SELECT		[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName]
		, [lstPlaceOfSvcKey], [DataDate], [Place_of_Service_Code], [Place_of_Service_Name]
		, [Place_of_Service_Description], [Version], [ACTIVE], [EffectiveDate], [ExpirationDate]	'
				+
		' FROM		[AceMasterData].[lst].[LIST_Place_of_SVC]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[LIST_Place_of_SVC]
	--Targets
	/*
	SELECT * FROM ACDW_CLMS_AET_TX_COM.lst.LIST_Place_of_SVC
	SELECT COUNT(*) FROM ACDW_CLMS_CCACO.lst.LIST_Place_of_SVC
	SELECT COUNT(*) FROM ACDW_CLMS_NLH.dbo.LIST_Place_of_SVC
	SELECT COUNT(*) FROM ACDW_CLMS_OKC.lst.LIST_Place_of_SVC
	SELECT COUNT(*) FROM ACDW_CLMS_SHCN.lst.LIST_Place_of_SVC
	SELECT COUNT(*) FROM ACDW_CLMS_UHC.lst.LIST_Place_of_SVC
	SELECT COUNT(*) FROM ACDW_CLMS_WLC.lst.LIST_Place_of_SVC
	SELECT COUNT(*) FROM ACDW_CLMS_WLC_ECAP.lst.LIST_Place_of_SVC
	SELECT COUNT(*) FROM ACECAREDW.dbo.LIST_Place_of_SVC
	SELECT COUNT(*) FROM AceCareDw_Qa.dbo.LIST_Place_of_SVC
	SELECT COUNT(*) FROM ACECAREDW_TEST.dbo.LIST_Place_of_SVC
	SELECT * FROM ACDW_CLMS_DHTX.lst.LIST_Place_of_SVC
	SELECT * FROM ACDW_CLMS_OSC.lst.LIST_Place_of_SVC
	*/
	
	
