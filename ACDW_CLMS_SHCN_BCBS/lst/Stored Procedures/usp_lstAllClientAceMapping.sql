


CREATE PROCEDURE	[lst].[usp_lstAllClientAceMapping]
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
	SET @SqlString = 
	N'CREATE TABLE ' + @ConnectionString + '(' +
	'[CreatedDate] [datetime] DEFAULT GETDATE()  NOT NULL ,	'+
	'[CreatedBy] [varchar](50) DEFAULT suser_sname()  NOT NULL ,'+
	'[LastUpdatedDate] [datetime]  DEFAULT GETDATE()  NOT NULL ,'+
	'[LastUpdatedBy] [varchar](50) DEFAULT suser_sname()  NOT NULL ,'+
	'[SrcFileName] [varchar](50) NULL,'+
	'[lstAceMappingKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,'+
	'[ClientKey] [Int] NOT NULL,'+
	'[MappingTypeKey] [Int] NULL,	'+
	'[IsActive] [tinyint] NOT NULL,	'+
	'[Source] [varchar](150) NOT NULL,'+
	'[Destination] [varchar](150) NOT NULL, '+
	'[ACTIVE] [char](1) DEFAULT ''Y'' NULL,	'+
	'[EffectiveDate] [date] DEFAULT ''2017-01-01'' NULL,'+
	'[ExpirationDate] [date] DEFAULT ''2099-12-31'' NULL' +
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	'[lstAceMappingKey], [ClientKey], [MappingTypeKey], [IsActive]
		, [Source], [Destination], [CreatedDate], [CreatedBy]
		, [LastUpdatedDate], [LastUpdatedBy], [srcFileName]'   + ')' +

		'SELECT		[lstAceMappingKey], [ClientKey], [MappingTypeKey], [IsActive]
		, [Source], [Destination], [CreatedDate], [CreatedBy], [LastUpdatedDate]
		, [LastUpdatedBy], [srcFileName]'
				+
		' FROM		[AceMasterData].[lst].[ListAceMapping]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].LIST_QM_Mapping
	--Targets
	/*
	--SELECT * FROM ACDW_CLMS_SHCN_MSSP.[lst].[ListAceMapping]
	--SELECT * FROM ACDW_CLMS_UHC.[lst].[ListAceMapping]
	--SELECT * FROM ACDW_CLMS_WLC.[lst].[ListAceMapping]
	--SELECT * FROM ACECAREDW_TEST.[lst].[ListAceMapping]
	  SELECT * FROM ACECAREDW.[lst].[ListAceMapping]
	  SELECT * FROM DEV_ACECAREDW.[lst].[ListAceMapping]
	  SELECT * FROM ACDW_CLMS_DHTX.[lst].[ListAceMapping]
	*/
	
	
	
