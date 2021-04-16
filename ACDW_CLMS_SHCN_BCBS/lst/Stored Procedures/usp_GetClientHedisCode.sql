CREATE PROCEDURE [lst].[usp_GetClientHedisCode]
				(@ConnectionString NVARCHAR(MAX))

AS

BEGIN
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
	SET  @SqlString = 
	N'CREATE TABLE ' + @ConnectionString  + ' (' +
	'[lstHedisCodeKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,' +
	'[VALUE_SET_NAME] [varchar](100) NULL,' +
	'[VALUE_SET_OID] [varchar](100) NULL,' +
	'[VALUE_SET_VER] [varchar](50) NULL, ' +
	'[VALUE_CODE] [varchar](50) NULL, ' +
	'[VALUE_CODE_WithoutDot] [varchar](50) NULL, ' +
	'[VALUE_CODE_NAME] [varchar](max) NULL,' +
	'[VALUE_CODE_SYSTEM] [varchar](50) NULL, ' +
	'[CODE_SYSTEM_OID] [varchar](50) NULL, ' +
	'[CODE_SYSTEM_VER] [varchar](50) NULL, ' +
	'[A_LAST_UPDATE_DATE] [datetime] NULL DEFAULT (getdate()), ' +
	'[A_LAST_UPDATE_BY] [varchar](20) NULL DEFAULT (suser_sname()), ' +
	'[A_LAST_UPDATE_FLAG] [varchar](1) NULL,' +
	'[ACTIVE] [char](1) NULL,' +
	'[EffectiveDate] [date] NULL DEFAULT GETDATE(),'+
	'[ExpirationDate] [date] NULL DEFAULT ''2099-12-31'','+
	'[CreatedDate] [datetime2](7) DEFAULT (getdate()) NOT NULL,' +
	'[CreatedBy] [varchar](50) NOT NULL DEFAULT (suser_sname()),' +
	'[LastUpdatedDate] [datetime2](7) DEFAULT (getdate()) NOT NULL,' +
	'[LastUpdatedBy] [varchar](50) NOT NULL DEFAULT (suser_sname()),' +
	'[SrcFileName] VARCHAR(50)' +
	'[Status] [char](1) NULL, ' +
	')';

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		N'INSERT INTO ' + @ConnectionString + '('
		+ '[VALUE_SET_NAME], [VALUE_SET_OID], [VALUE_SET_VER], [VALUE_CODE],[VALUE_CODE_WithoutDot]
		, [VALUE_CODE_NAME], [VALUE_CODE_SYSTEM], [CODE_SYSTEM_OID]
		, [CODE_SYSTEM_VER], [A_LAST_UPDATE_DATE], [A_LAST_UPDATE_BY], [A_LAST_UPDATE_FLAG], [ACTIVE]
		, [EffectiveDate], [ExpirationDate],[SrcFileName]' + ')' +
		
		' SELECT	[VALUE_SET_NAME], [VALUE_SET_OID], [VALUE_SET_VER], [VALUE_CODE]
					,[VALUE_CODE_WithoutDot]
					,[VALUE_CODE_NAME], [VALUE_CODE_SYSTEM], [CODE_SYSTEM_OID], [CODE_SYSTEM_VER]
					,[A_LAST_UPDATE_DATE], [A_LAST_UPDATE_BY], [A_LAST_UPDATE_FLAG], [ACTIVE]
					,[EffectiveDate]
					, [ExpirationDate], ''[AceMasterData].[lst].[LIST_HEDIS_CODE]''' + 
		
		'	FROM		[AceMasterData].[lst].[LIST_HEDIS_CODE]'

		--PRINT @SqlString
	EXECUTE sp_executesql @SqlString

END

	--Targets
	--ACECAREDW.dbo.LIST_HEDIS_CODE;
	--ACECAREDW_TEST.dbo.LIST_HEDIS_CODE;
	--AceMasterQMCalc.lst.LIST_HEDIS_CODE;
	--ACDW_CLMS_UHC.lst.LIST_HEDIS_CODE;
	--[ACDW_CLMS_DHTX].lst.LIST_HEDIS_CODE;
	--SELECT * FROM ACDW_CLMS_SHCN_MSSP.lst.LIST_HEDIS_CODE

	
