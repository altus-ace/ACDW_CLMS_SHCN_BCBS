


CREATE PROCEDURE	[lst].[usp_lstAllClientPreferredFacility]
					(@ConnectionString NVARCHAR(MAX), @ClientKey NVARCHAR(5))

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
	'[CreatedDate] [datetime] DEFAULT GETDATE() NOT NULL,'+
	'[CreatedBy] [varchar](50) DEFAULT SUSER_SNAME() NOT NULL,'+
	'[LastUpdatedDate] [datetime] DEFAULT GETDATE() NOT NULL,'+
	'[LastUpdatedBy] [varchar](50) DEFAULT SUSER_SNAME()  NOT NULL,	'+
	'[LoadDate] [Date] NOT NULL ,	'+
	'[DataDate] [Date] NOT NULL,	'+
	'[SourceJobName] [varchar](50) NULL,'+
	'[PreferredFacilityKey] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,'+
	'[ClientKey] INT NOT NULL,'+
	'[FacilityName] [varchar](50) NULL,	'+
	'[FacilityType] [varchar](10) NULL,'+
	'[State] [varchar](35) NULL,'+
	'[Region] [varchar](35) NULL,'+
	'[NPI] [varchar](10) NULL,'+
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
		+	'[CreatedDate], [CreatedBy], [LastUpdatedDate], [LastUpdatedBy], [SourceJobName]
		, [LoadDate], [DataDate], [PreferredFacilityKey],ClientKey,[FacilityName]
		, [FacilityType], [State],[Region],[NPI], [ACTIVE], [EffectiveDate], [ExpirationDate]'   + ')' +

		'SELECT		[CreatedDate], [CreatedBy], [LastUpdatedDate], [LastUpdatedBy], [SourceJobName]
		, [LoadDate], [DataDate], [PreferredFacilityKey],ClientKey,[FacilityName]
		, [FacilityType], [State],[Region],[NPI], [ACTIVE], [EffectiveDate], [ExpirationDate]	'
				+
		' FROM		[lst].[lstPreferredFacility]'
				+
		' WHERE ClientKey = ' + @ClientKey 
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[List_DRG]
	--Targets
	/*
	SELECT * FROM ACDW_CLMS_SHCN_MSSP.[lst].[lstPreferredFacility]
	SELECT * FROM ACDW_CLMS_DHTX.[lst].[lstPreferredFacility]
	 SELECT * FROM ACECAREDW.[lst].[lstPreferredFacility]
	*/
	
	
