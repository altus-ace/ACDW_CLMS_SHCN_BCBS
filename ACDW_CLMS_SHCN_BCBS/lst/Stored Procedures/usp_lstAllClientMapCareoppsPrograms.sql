


CREATE PROCEDURE	[lst].[usp_lstAllClientMapCareoppsPrograms]
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
	'[lstMapCareoppsPrograms] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,	'+
	'[SOURCE] [varchar](50) NULL,'+
	'[SOURCE_MEASURE_NAME] [varchar](1000) NULL,'+
	'[SOURCE_SUB_MEASURE_NAME] [varchar](1000) NULL,'+
	'[DESTINATION] [varchar](50) NULL,'+
	'[DESTINATION_PROGRAM_NAME] [varchar](1000) NULL,'+
	'[IS_ACTIVE] [int] NULL,'+
	'[Criteria] [char](10) NULL,'+
	'[ACE_PROG_ID] [varchar](50) NULL,'+
	'[ACTIVE] [char](1) DEFAULT ''Y'' NULL,'+
	'[EffectiveDate] [date] DEFAULT GETDATE() NULL,	'+
	'[ExpirationDate] [date] DEFAULT ''2099-12-31'' NULL,' +
	'[ClientKey] [INT] DEFAULT 0,' + --- Added ClientKey
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	'[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName]
		, [lstMapCareoppsPrograms], [SOURCE], [SOURCE_MEASURE_NAME]
		, [SOURCE_SUB_MEASURE_NAME], [DESTINATION], [DESTINATION_PROGRAM_NAME]
		, [IS_ACTIVE], [Criteria], [ACE_PROG_ID], [ACTIVE], [EffectiveDate], [ExpirationDate], [ClientKey] '   + ')' +

		'SELECT		[CreatedDate], [CreatedBy], [LastUpdated], [LastUpdatedBy], [SrcFileName]
		, [lstMapCareoppsPrograms], [SOURCE], [SOURCE_MEASURE_NAME], [SOURCE_SUB_MEASURE_NAME]
		, [DESTINATION], [DESTINATION_PROGRAM_NAME], [IS_ACTIVE], [Criteria], [ACE_PROG_ID]
		, [ACTIVE], [EffectiveDate], [ExpirationDate],[ClientKey] '
				+
		' FROM		[AceMasterData].[lst].[lstMapCareoppsPrograms]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[lstMapCareoppsPrograms]
	--Targets
	/*
	
	--SELECT * FROM ACDW_CLMS_UHC.lst.lstMapCareoppsPrograms
	--SELECT * FROM ACDW_CLMS_WLC.lst.lstMapCareoppsPrograms
	--SELECT * FROM ACECAREDW_TEST.lst.lstMapCareoppsPrograms
	  SELECT * FROM ACECAREDW.lst.lstMapCareoppsPrograms
	  SELECT * FROM DEV_ACECAREDW.lst.lstMapCareoppsPrograms
	  SELECT * FROM ACDW_CLMS_DHTX.lst.lstMapCareoppsPrograms
	  SELECT * FROM ACDW_CLMS_SHCN_MSSP.lst.lstMapCareoppsPrograms
	*/
	
	
	
	
