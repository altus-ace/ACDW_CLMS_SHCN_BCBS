CREATE PROCEDURE [lst].[usp_CreateNippesNIP]
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

IF OBJECT_ID(@ConnectionString) IS NOT NULL
   BEGIN
      	SET @SqlString = N'DROP TABLE ' +  @ConnectionString 
	EXECUTE sp_executesql @SqlString
   END;
   ELSE
   BEGIN

		--PRINT @SqlString
 
--B Create all Targets
  
--Create Triggers 
	SET @SqlString = 
	N'CREATE TABLE ' + @ConnectionString + '(' +
	'[LstNppesNPIKey] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,'+
	'[srcFileName] [varchar](100) NOT NULL,'+
	'[DataDate] [date] NOT NULL,'+
	'[CreatedDate] [datetime]  DEFAULT getdate() NOT NULL,'+
	'[CreatedBy] [varchar](50) DEFAULT suser_sname() NOT NULL,'+
	'[LastUpdatedDate] [datetime]  DEFAULT getdate() NOT NULL,'+
	'[LastUpdatedBy] [varchar](50) DEFAULT suser_sname() NOT NULL,'+
	'[NPI] [varchar](20) NOT NULL,'+
	'[EntityType] [varchar](20) NULL,'+
	'[EIN] [varchar](50) NULL,'+
	'[LBN] [varchar](100) NULL,'+
	'[LBN_Name] [varchar](200) NULL,'+
	'[LastName] [varchar](100) NULL,'+
	'[FirstName] [varchar](100) NULL,'+
	'[PracticeAddress1] [varchar](100) NULL,'+
	'[PracticeAddress2] [varchar](50) NULL,'+
	'[PracticeCity] [varchar](100) NULL,'+
	'[PracticeState] [varchar](50) NULL,'+
	'[PracticeZip] [varchar](10) NULL,'+
	'[PracticePhone] [varchar](20) NULL,'+
	'[PracticeFax] [varchar](20) NULL,'+
	'[PracticeLastUpdate] [varchar](20) NULL,'+
	'[Taxonomy1] [varchar](50) NULL,'+
	'[Taxonomy2] [varchar](50) NULL,'+
	'[Taxonomy3] [varchar](50) NULL,'+
	'[Active] [char](1) DEFAULT ''Y'' NULL ,'+
	'[EffectiveDate] [date] DEFAULT getdate() NULL,'+
	'[ExpirationDate] [date] NULL' +
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString
END

--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	'[LstNppesNPIKey], [srcFileName], [DataDate], [CreatedDate], [CreatedBy]
		, [LastUpdatedDate], [LastUpdatedBy], [NPI], [EntityType], [EIN], [LBN]
		, [LBN_Name], [LastName], [FirstName], [PracticeAddress1], [PracticeAddress2]
		, [PracticeCity], [PracticeState], [PracticeZip], [PracticePhone], [PracticeFax]
		, [PracticeLastUpdate], [Taxonomy1], [Taxonomy2], [Taxonomy3]
		, [Active], [EffectiveDate], [ExpirationDate]'   + ')' +

		'SELECT		[LstNppesNPIKey], [srcFileName], [DataDate], ' +  Convert(varchar, GETDATE()) +',BoomiDbUser' + '
		, '+ CONVERT(varchar, GETDATE()) +', BoomiDbUser ' + ', [NPI], [EntityType], [EIN], [LBN], [LBN_Name]
		, [LastName], [FirstName], [PracticeAddress1], [PracticeAddress2], [PracticeCity]
		, [PracticeState], [PracticeZip], [PracticePhone], [PracticeFax], [PracticeLastUpdate]
		, [Taxonomy1], [Taxonomy2], [Taxonomy3], [Active], [EffectiveDate], [ExpirationDate]	'
				+
		' FROM		[AceMasterData].[lst].[LIST_NPPES_NPI]'
				+
		'SET IDENTITY_INSERT ' + @ConnectionString + ' OFF '

		--PRINT @SqlString
		EXECUTE sp_executesql @SqlString

END

	
	--Master -DONT TOUCH
	--SELECT * FROM [lst].[LIST_NPPES_NPI]
	--Targets
	/*

	*/
	
	
