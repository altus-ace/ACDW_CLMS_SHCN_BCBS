



CREATE PROCEDURE	[lst].[usp_lstAllClientICDCCS]
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
	'[lstIcdCcsKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,'+
	'[srcFileName] [varchar](100) NULL,'+
	'[DataDate] [date] NULL,'+
	'[CreatedDate] [datetime] DEFAULT GETDATE() NOT NULL,'+
	'[CreatedBy] [varchar](50) DEFAULT SUSER_SNAME() NOT NULL,'+
	'[LastUpdatedDate] [datetime] DEFAULT GETDATE() NOT NULL,'+
	'[LastUpdatedBy] [varchar](50) DEFAULT SUSER_SNAME() NOT NULL,'+
	'[EffectiveDate] [date] NOT NULL,'+
	'[ExpirationDate] [date] NOT NULL,'+
	'[ICD-10-CM_CODE] [varchar](500) NULL,'+
	'[CCS_CATEGORY] [varchar](500) NULL,'+
	'[ICD-10-CM_CODE_DESCRIPTION] [varchar](500) NULL,'+
	'[CCS_CATEGORY_DESCRIPTION] [varchar](500) NULL,'+
	'[MULTI_CCS_LVL1] [varchar](500) NULL,'+
	'[MULTI_CCS_LVL1_LABEL] [varchar](500) NULL,'+
	'[MULTI_CCS_LVL2] [varchar](500) NULL,'+
	'[MULTI_CCS_LVL2_LABEL] [varchar](500) NULL,'+
	'[MULTI_CCS_LVL3] [varchar](500) NULL,'+
	'[MULTI_CCS_LVL3_LABEL] [varchar](500) NULL,'+
	'[MULTI_CCS_LVL4] [varchar](500) NULL,'+
	'[MULTI_CCS_LVL4_LABEL] [varchar](500) NULL,'+
	'[Version] [varchar](50) NULL' +
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	'[lstIcdCcsKey], [srcFileName], [DataDate], [CreatedDate], [CreatedBy]
		, [LastUpdatedDate], [LastUpdatedBy], [EffectiveDate], [ExpirationDate]
		, [ICD-10-CM_CODE], [CCS_CATEGORY], [ICD-10-CM_CODE_DESCRIPTION]
		, [CCS_CATEGORY_DESCRIPTION], [MULTI_CCS_LVL1], [MULTI_CCS_LVL1_LABEL]
		, [MULTI_CCS_LVL2], [MULTI_CCS_LVL2_LABEL], [MULTI_CCS_LVL3]
		, [MULTI_CCS_LVL3_LABEL], [MULTI_CCS_LVL4], [MULTI_CCS_LVL4_LABEL], [Version]'   + ')' +

		'SELECT		[lstIcdCcsKey], [srcFileName], [DataDate], [CreatedDate]
		, [CreatedBy], [LastUpdatedDate], [LastUpdatedBy], [EffectiveDate]
		, [ExpirationDate], [ICD-10-CM_CODE], [CCS_CATEGORY], [ICD-10-CM_CODE_DESCRIPTION]
		, [CCS_CATEGORY_DESCRIPTION], [MULTI_CCS_LVL1], [MULTI_CCS_LVL1_LABEL]
		, [MULTI_CCS_LVL2], [MULTI_CCS_LVL2_LABEL], [MULTI_CCS_LVL3]
		, [MULTI_CCS_LVL3_LABEL], [MULTI_CCS_LVL4], [MULTI_CCS_LVL4_LABEL], [Version]	'
				+
		' FROM		[lst].[LIST_ICDCCS]'
		
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[LIST_ICDCCS]
	--Targets
	/*
	SELECT * FROM ACDW_CLMS_SHCN_MSSP.[lst].[LIST_ICDCCS]
	SELECT * FROM ACDW_CLMS_DHTX.[lst].[LIST_ICDCCS]
	 SELECT * FROM ACECAREDW.[lst].[LIST_ICDCCS]
	*/
	
	
