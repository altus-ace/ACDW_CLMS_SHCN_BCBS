
CREATE PROCEDURE [lst].[usp_lstAllClientClientKey]
				(@ConnectionString NVARCHAR(MAX))

AS

BEGIN
				----DECLARE @ConnectionString NVARCHAR(MAX) = 'ACDW_CLMS_CCACO.lst.List_Client'
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
	'[CreatedDate] [datetime] DEFAULT GETDATE() NOT NULL,'+
	'[CreatedBy] [varchar](50) DEFAULT SUSER_SNAME() NOT NULL,'+
	'[LastUpdated] [datetime] DEFAULT GETDATE() NOT NULL,'+
	'[LastUpdatedBy] [varchar](50) DEFAULT SUSER_SNAME() NOT NULL,'+
	'[SrcFileName] [varchar](50) NULL,'+
	'[ClientKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,'+
	'[ClientName] [varchar](100) NOT NULL,'+
	'[ClientShortName] [varchar](15) NOT NULL,'+
	'[CS_Export_LobName] [varchar](20) NULL,'+
	'[IpDischargeFollupIntervalInDays] [tinyint] DEFAULT 0 NOT NULL,'+
	'[ErDischargeFollupIntervalInDays] [tinyint] DEFAULT 0 NOT NULL,'+
	'[ACTIVE] [char](1) DEFAULT ''Y'' NULL,'+
	'[EffectiveDate] [date] DEFAULT GETDATE() NULL,	'+
	'[ExpirationDate] [date] DEFAULT ''2099-12-31'' NULL' +
	')';

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+ '[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName]
		, [ClientKey], [ClientName], [ClientShortName], [CS_Export_LobName]
		, [IpDischargeFollupIntervalInDays], [ErDischargeFollupIntervalInDays]
		, [ACTIVE], [EffectiveDate], [ExpirationDate]' + ')' +
		
		' SELECT	[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName]
		, [ClientKey], [ClientName], [ClientShortName], [CS_Export_LobName]
		, [IpDischargeFollupIntervalInDays], [ErDischargeFollupIntervalInDays]
		, [ACTIVE], [EffectiveDate], [ExpirationDate]' + 
		
		'	FROM		AceMasterData.[lst].[List_Client]'
		+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
	EXECUTE sp_executesql @SqlString

END

	--Targets
	--SELECT * FROM AceMasterData.[lst].[List_Client]
	/*
	SELECT * FROM ACDW_CLMS_AET_TX_COM.lst.List_Client G
	SELECT * FROM ACDW_CLMS_CCACO.lst.list_client G
	SELECT * FROM ACDW_CLMS_CIGNA_MA.lst.list_client --active,effectivedate...
	SELECT * FROM ACDW_CLMS_SHCN_MSSP.lst.list_client
	SELECT * FROM ACDW_CLMS_UHC.lst.list_client
	SELECT * FROM ACDW_CLMS_WLC_ECAP.lst.list_client
	SELECT * FROM ACECAREDW.lst.list_client
	SELECT * FROM ACDW_CLMS_DHTX.lst.list_client --G
	SELECT * FROM AceCareDw_Qa.lst.list_client--G
	SELECT * FROM ACECAREDW_TEST.lst.list_client--G
	SELECT * FROM AceMetaData.lst.List_Client
	SELECT * FROM [ACDW_CLMS_OSC].lst.List_Client
	*/
	

	/*
	SET IDENTITY_INSERT AceMetaData.lst.List_Client ON
	INSERT INTO AceMetaData.lst.List_Client(SrcFileName,ClientKey,ClientName,ClientShortName,CS_Export_LobName,IpDischargeFollupIntervalInDays,ErDischargeFollupIntervalInDays)
	SELECT  SrcFileName,ClientKey,ClientName,ClientShortName,CS_Export_LobName,IpDischargeFollupIntervalInDays,ErDischargeFollupIntervalInDays
	FROM lst.List_Client WHERE ClientKey >=20
	SET IDENTITY_INSERT AceMetaData.lst.List_Client OFF
	*/

	SELECT * FROM ACDW_CLMS_SHCN_BCBS.lst.List_Client

	/*
	SET IDENTITY_INSERT ACDW_CLMS_UHC.lst.list_client ON
	INSERT INTO ACDW_CLMS_UHC.lst.list_client (ClientKey,ClientName,ClientShortName,CS_Export_LobName,IpDischargeFollupIntervalInDays,ErDischargeFollupIntervalInDays)
	SELECT  ClientKey,ClientName,ClientShortName,CS_Export_LobName,IpDischargeFollupIntervalInDays,ErDischargeFollupIntervalInDays
	FROM lst.List_Client WHERE ClientKey >=20
	SET IDENTITY_INSERT ACDW_CLMS_UHC.lst.list_client OFF
	*/
