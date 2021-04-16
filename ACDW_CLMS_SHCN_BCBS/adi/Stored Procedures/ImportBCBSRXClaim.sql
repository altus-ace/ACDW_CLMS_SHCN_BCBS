-- =============================================
-- Author:		Bing Yu
-- Create date: 09/09/2020
-- Description:	Insert BCBS Institutioanl claims  to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportBCBSRXClaim]
    @SrcFileName [varchar](100),
	-- [CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) ,
	@OriginalFileName [varchar](100),
	@LastUpdatedBy [varchar](100) ,
	--@LastUpdatedDate [datetime] NULL,
	@DataDate varchar(10),
	@ExtractID [varchar](14),
	@ClaimStatusCode [varchar](2),
	@ProviderNPI [varchar](10),
	@ServiceDATE varchar(10),
	@PatientID varchar(50),
	@MemberBirthDate varchar(10),
	@MemberGender [char](1),
	@MemberFirstName [varchar](35),
	@MemberLastName [varchar](35) ,
	@MemberHomeAddress1 [varchar](55),
	@MemberCityName [varchar](28) ,
	@MemberStateCode [varchar](2) ,
	@MemberZipCode [varchar](5),
	@MemberPrimaryPhone [varchar](10),
	@SubscriberID [varchar](12) ,
	@ClaimID [varchar](30),
	@NDCCode [varchar](14),
	@RxID [varchar](15),
	@FillDate varchar(10),
	@NumberofServiceS [varchar](5) ,
	@NumberofScriptsDispensed [varchar](2),
	@DaysSupply [varchar](4),
	@PaidDate varchar(10),
	@BrandGenericIndicator [char](1),
	@AdjustmentSequenceNumber [varchar](4) ,
	@ClaimLineNumber [char](4),
	@TherapeuticClassCode [char](2),
	@ProviderLastName [varchar](35),
	@ProviderPhoneNumber [varchar](10),
	@ProviderTIN [varchar](9) ,
	@PracticeName [varchar](30) ,
	@ProviderFirstName [varchar](30) ,
	@ProviderStreetAddress1 [varchar](30) ,
	@ProviderCity [varchar](15) NULL,
	@ProviderState [char](2) NULL,
	@ProviderZipCode [char](5) ,
	@DrugFormulation [char](2) ,
	@AWPAmount [varchar](9) 
	
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

     DECLARE @DateFromFile VARCHAR(10)
	 SET @DateFromFile = SUBSTRING(@SrcFileName,27,8)
	-- ACO.NCPDP.STEWARD.1009417.20201220.211300250.TXT
	--SELECT CONVERT(DATE, SUBSTRING('ACO.NCPDP.STEWARD.1009417.20201220.211300250.TXT', 27, 8))
	--DECLARE @DateFromFile DATE
	--SET @DateFromFile = CONVERT(DATE, LEFT(RIGHT(@SrcFileName,12), 8))
	
    INSERT INTO [adi].[Steward_BCBS_RXClaim]
    (
	[SrcFileName] ,
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate] ,
	[DataDate] ,
	[ExtractID] ,
	[ClaimStatusCode] ,
	[ProviderNPI] ,
	[ServiceDATE] ,
	[PatientID] ,
	[MemberBirthDATE] ,
	[MemberGender] ,
	[MemberFirstName] ,
	[MemberLastName] ,
	[MemberHomeAddress1] ,
	[MemberCityName] ,
	[MemberStateCode] ,
	[MemberZipCode] ,
	[MemberPrimaryPhone] ,
	[SubscriberID] ,
	[ClaimID] ,
	[NDCCode] ,
	[RxID] ,
	[FillDate] ,
	[NumberofServiceS] ,
	[NumberofScriptsDispensed] ,
	[DaysSupply] ,
	[PaidDate] ,
	[BrandGenericIndicator] ,
	[AdjustmentSequenceNumber] ,
	[ClaimLineNumber] ,
	[TherapeuticClassCode] ,
	[ProviderLastName] ,
	[ProviderPhoneNumber] ,
	[ProviderTIN] ,
	[PracticeName] ,
	[ProviderFirstName] ,
	[ProviderStreetAddress1] ,
	[ProviderCity] ,
	[ProviderState] ,
	[ProviderZipCode] ,
	[DrugFormulation] ,
	[AWPAmount] 
	)
		
 VALUES  (
  
   @SrcFileName ,
	GETDATE(),
	-- [CreateDate] [datetime] NULL,
	@CreateBy  ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	GETDATE(),
	--@LastUpdatedDate [datetime] NULL,
	--@DataDate ,
	-- CONVERT(DATE, SUBSTRING(@DateFromFile, 5,4) +'-'+ SUBSTRING(@DateFromFile, 3,2) +'-'+ SUBSTRING(@DateFromFile, 1,2)),
	CONVERT(DATE, SUBSTRING(@SrcFileName , 27, 8)),
	@ExtractID ,
	@ClaimStatusCode,
	@ProviderNPI,
	CASE WHEN @ServiceDATE  = ''
	THEN NULL
	ELSE CONVERT(DATE,@ServiceDATE )
	END ,
	CASE WHEN @PatientID = ''
	THEN NULL
	ELSE CONVERT(decimal(18,0),@PatientID)
	END ,
	CASE WHEN @MemberBirthDate = ''
	THEN NULL
	ELSE CONVERT(DATE,@MemberBirthDate)
	END ,
	@MemberGender ,
	@MemberFirstName ,
	@MemberLastName  ,
	@MemberHomeAddress1 ,
	@MemberCityName  ,
	@MemberStateCode  ,
	@MemberZipCode ,
	@MemberPrimaryPhone ,
	@SubscriberID  ,
	@ClaimID ,
	@NDCCode ,
	@RxID ,
	CASE WHEN @FillDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @FillDate)
	END ,
	@NumberofServiceS  ,
	@NumberofScriptsDispensed ,
	@DaysSupply ,
	CASE WHEN @PaidDate  = ''
	THEN NULL
	ELSE CONVERT(DATE, @PaidDate )
	END ,
	
	@BrandGenericIndicator ,
	@AdjustmentSequenceNumber  ,
	@ClaimLineNumber,
	@TherapeuticClassCode ,
	@ProviderLastName ,
	@ProviderPhoneNumber ,
	@ProviderTIN  ,
	@PracticeName  ,
	@ProviderFirstName  ,
	@ProviderStreetAddress1  ,
	@ProviderCity ,
	@ProviderState ,
	@ProviderZipCode  ,
	@DrugFormulation  ,
	@AWPAmount 
)

  --BEGIN
 --  SET @ActionStopDateTime = GETDATE()
 --  EXEC amd.sp_AceEtlAuditClose  @AuditID, @ActionStopDateTime, 1,1,0,2   	
 -- END TRY



  --BEGIN CATCH 

  -- SET @ActionStopDateTime = GETDATE()
  -- EXEC amd.sp_AceEtlAuditClose  @AuditID, @ActionStopDateTime, 1,1,0,3   	

  --END CATCH 
    
END
