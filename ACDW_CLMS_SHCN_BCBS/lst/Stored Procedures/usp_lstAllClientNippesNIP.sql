

CREATE PROCEDURE	[lst].[usp_lstAllClientNippesNIP]
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
	'[ExpirationDate] [date] NULL,' + 
	'[OtherProviderIdentifier_1] [varchar](50) NULL,'+
	'[OtherProviderIdentifierTypeCode_1] [varchar](50) NULL,'+
	'[OtherProviderIdentifierState_1] [varchar](50) NULL,'+
	'[OtherProviderIdentifierIssuer_1] [varchar](50) NULL,'+
	'[OtherProviderIdentifier_2] [varchar](50) NULL,'+
	'[OtherProviderIdentifierTypeCode_2] [varchar](50) NULL,'+
	'[OtherProviderIdentifierState_2] [varchar](50) NULL,'+
	'[OtherProviderIdentifierIssuer_2] [varchar](50) NULL,'+
	'[OtherProviderIdentifier_3] [varchar](50) NULL,'+
	'[OtherProviderIdentifierTypeCode_3] [varchar](50) NULL,'+
	'[OtherProviderIdentifierState_3] [varchar](50) NULL,'+
	'[OtherProviderIdentifierIssuer_3] [varchar](50) NULL,'+
	'[OtherProviderIdentifier_4] [varchar](50) NULL,'+
	'[OtherProviderIdentifierTypeCode_4] [varchar](50) NULL,'+
	'[OtherProviderIdentifierState_4] [varchar](50) NULL,'+
	'[OtherProviderIdentifierIssuer_4] [varchar](50) NULL,'+
	'[OtherProviderIdentifier_5] [varchar](50) NULL,'+
	'[OtherProviderIdentifierTypeCode_5] [varchar](50) NULL,'+
	'[OtherProviderIdentifierState_5] [varchar](50) NULL,'+
	'[OtherProviderIdentifierIssuer_5] [varchar](50) NULL,'+
	'[IsSoleProprietor] [char](1) NULL,'+
	'[IsOrganizationSubpart] [char](1) NULL,'+
	'[ParentOrganizationLBN] [varchar](50) NULL,'+
	'[ParentOrganizationTIN] [varchar](20) NULL,'+
	'[CertificationDate] [date] NULL'+
	')'

	--PRINT @SqlString
	EXECUTE sp_executesql @SqlString


--C Insert into all Target 

SET  @SqlString = 
		'SET IDENTITY_INSERT ' + @ConnectionString + ' ON ' +
		N'INSERT INTO ' + @ConnectionString + '('
		+	'[LstNppesNPIKey], [srcFileName], [DataDate], [CreatedDate]
		, [CreatedBy], [LastUpdatedDate], [LastUpdatedBy], [NPI], [EntityType]
		, [EIN], [LBN], [LBN_Name], [LastName], [FirstName], [PracticeAddress1]
		, [PracticeAddress2], [PracticeCity], [PracticeState], [PracticeZip]
		, [PracticePhone], [PracticeFax], [PracticeLastUpdate], [Taxonomy1]
		, [Taxonomy2], [Taxonomy3], [Active], [EffectiveDate], [ExpirationDate]
		, [OtherProviderIdentifier_1], [OtherProviderIdentifierTypeCode_1]
		, [OtherProviderIdentifierState_1], [OtherProviderIdentifierIssuer_1]
		, [OtherProviderIdentifier_2], [OtherProviderIdentifierTypeCode_2]
		, [OtherProviderIdentifierState_2], [OtherProviderIdentifierIssuer_2]
		, [OtherProviderIdentifier_3], [OtherProviderIdentifierTypeCode_3]
		, [OtherProviderIdentifierState_3], [OtherProviderIdentifierIssuer_3]
		, [OtherProviderIdentifier_4], [OtherProviderIdentifierTypeCode_4]
		, [OtherProviderIdentifierState_4], [OtherProviderIdentifierIssuer_4], [OtherProviderIdentifier_5]
		, [OtherProviderIdentifierTypeCode_5], [OtherProviderIdentifierState_5]
		, [OtherProviderIdentifierIssuer_5], [IsSoleProprietor], [IsOrganizationSubpart]
		, [ParentOrganizationLBN], [ParentOrganizationTIN], [CertificationDate]'   + ')' +

		'SELECT		[LstNppesNPIKey], [srcFileName], [DataDate], [CreatedDate]
		, [CreatedBy], [LastUpdatedDate], [LastUpdatedBy], [NPI], [EntityType]
		, [EIN], [LBN], [LBN_Name], [LastName], [FirstName], [PracticeAddress1]
		, [PracticeAddress2], [PracticeCity], [PracticeState], [PracticeZip]
		, [PracticePhone], [PracticeFax], [PracticeLastUpdate], [Taxonomy1]
		, [Taxonomy2], [Taxonomy3], [Active], [EffectiveDate], [ExpirationDate]
		, [OtherProviderIdentifier_1], [OtherProviderIdentifierTypeCode_1]
		, [OtherProviderIdentifierState_1], [OtherProviderIdentifierIssuer_1]
		, [OtherProviderIdentifier_2], [OtherProviderIdentifierTypeCode_2]
		, [OtherProviderIdentifierState_2], [OtherProviderIdentifierIssuer_2]
		, [OtherProviderIdentifier_3], [OtherProviderIdentifierTypeCode_3]
		, [OtherProviderIdentifierState_3], [OtherProviderIdentifierIssuer_3]
		, [OtherProviderIdentifier_4], [OtherProviderIdentifierTypeCode_4]
		, [OtherProviderIdentifierState_4], [OtherProviderIdentifierIssuer_4]
		, [OtherProviderIdentifier_5], [OtherProviderIdentifierTypeCode_5]
		, [OtherProviderIdentifierState_5], [OtherProviderIdentifierIssuer_5]
		, [IsSoleProprietor], [IsOrganizationSubpart], [ParentOrganizationLBN]
		, [ParentOrganizationTIN], [CertificationDate]	'
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
	
	
