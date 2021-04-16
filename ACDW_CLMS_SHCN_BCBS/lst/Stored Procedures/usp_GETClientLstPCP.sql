

CREATE PROCEDURE	[lst].[usp_GETClientLstPCP]
					(@ConnectionString NVARCHAR(MAX))

AS

BEGIN
				--DECLARE @ConnectionString NVARCHAR(MAX) = 'ACDW_CLMS_AET_TX_COM.lst.list_Pcp'
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
	'[LastUpdatedBy] [varchar](50) DEFAULT SUSER_SNAME()  NOT NULL,'+
	'[SrcFileName] [varchar](50) NULL,'+
	'[lstPCPKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,	'+
	'[CLIENT_ID] [varchar](50) NULL,'+
	'[PCP_NPI] [varchar](50) NULL,'+
	'[PCP_FIRST_NAME] [varchar](50) NULL,'+
	'[PCP_MI] [varchar](50) NULL,'+
	'[PCP_LAST_NAME] [varchar](50) NULL,'+
	'[PCP__ADDRESS] [varchar](50) NULL,	'+
	'[PCP__ADDRESS2] [varchar](50) NULL,'+
	'[PCP_CITY] [varchar](50) NULL,	'+
	'[PCP_STATE] [varchar](50) NULL,'+
	'[PCP_ZIP] [varchar](50) NULL,	'+
	'[PCP_PHONE] [varchar](50) NULL,'+
	'[PCP_CLIENT_ID] [varchar](50) NULL,'+
	'[PCP_PRACTICE_TIN] [varchar](50) NULL,	'+
	'[PCP_PRACTICE_TIN_NAME] [varchar](50) NULL,'+
	'[PRIM_SPECIALTY] [varchar](100) NULL,	'+
	'[PROV_TYPE] [varchar](20) NULL,'+
	'[PCP_FLAG] [varchar](1) NULL,	'+
	'[CAMPAIGN_RUN_ID] [int] NULL,	'+
	'[T_Modify_by] [varchar](50) NULL,'+
	'[ACTIVE] [char](1) DEFAULT ''Y'' NULL,'+
	'[EffectiveDate] [date] DEFAULT GETDATE() NULL,'+
	'[ExpirationDate] [date] DEFAULT ''2099-12-31'' NULL' +
	 '[Status] [char](1) NULL,	'+
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	'[SrcFileName], [lstPCPKey]
		, [CLIENT_ID], [PCP_NPI], [PCP_FIRST_NAME], [PCP_MI], [PCP_LAST_NAME], [PCP__ADDRESS]
		, [PCP__ADDRESS2], [PCP_CITY], [PCP_STATE], [PCP_ZIP], [PCP_PHONE], [PCP_CLIENT_ID]
		, [PCP_PRACTICE_TIN], [PCP_PRACTICE_TIN_NAME], [PRIM_SPECIALTY], [PROV_TYPE]
		, [PCP_FLAG], [CAMPAIGN_RUN_ID], [T_Modify_by], [ACTIVE], [EffectiveDate], [ExpirationDate]'   + ')' +

		'SELECT	[SrcFileName], [lstPCPKey]
		, [CLIENT_ID], [PCP_NPI], [PCP_FIRST_NAME], [PCP_MI], [PCP_LAST_NAME], [PCP__ADDRESS]
		, [PCP__ADDRESS2], [PCP_CITY], [PCP_STATE], [PCP_ZIP], [PCP_PHONE], [PCP_CLIENT_ID]
		, [PCP_PRACTICE_TIN], [PCP_PRACTICE_TIN_NAME], [PRIM_SPECIALTY], [PROV_TYPE]
		, [PCP_FLAG], [CAMPAIGN_RUN_ID], [T_Modify_by], [ACTIVE], [EffectiveDate], [ExpirationDate]'
				+
		' FROM		[AceMasterData].[lst].[LIST_PCP]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[LIST_PCP]
	--Targets
	/*
	SELECT * FROM  ACDW_CLMS_AET_TX_COM.lst.list_Pcp
	SELECT * FROM  ACDW_CLMS_SHCN.lst.list_Pcp
	SELECT * FROM  ACDW_CLMS_WLC.lst.list_Pcp
	SELECT * FROM  Ace_Portal_Staging.dbo.list_Pcp
	SELECT * FROM  ACECAREDW_TEST.lst.list_Pcp
	SELECT * FROM ACDW_CLMS_UHC.lst.List_PCP
	SELECT * FROM ACDW_CLMS_DHTX.lst.List_PCP
	*/
	
	
