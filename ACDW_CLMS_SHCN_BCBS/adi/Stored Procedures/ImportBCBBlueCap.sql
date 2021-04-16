


-- =============================================
-- Author:		Bing Yu
-- Create date: 09/09/2020
-- Description:	Insert BCBS Institutioanl claims  to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportBCBBlueCap]
    @SrcFileName [varchar](100) ,
	--[CreateDate] [datetime] ,
	@reateBy varchar(100),
	@OriginalFileName [varchar](100),
	@LastUpdatedBy [varchar](100) ,
	--@LastUpdatedDate [datetime] NULL,
	@DataDate varchar(10),
	@MemberNumber [varchar](11) ,
	@Filler_11 [char](1) ,
	@MemberName [varchar](30),
	@MemberDateBirth varchar(10),
	@MemberGender [varchar](1) ,
	@MemberBenefitCode [varchar](10),
	@AccountControlNumber [varchar](10),
	@BenefitAgreementControlNumber [varchar](10) ,
	@ServiceProviderID [varchar](10),
	@CapitationPeriodDate varchar(10) ,
	@PaymentCode [char](1) ,
	@Filler_4 [char](4),
	@SpecialistCopayAmount [decimal](7, 0) ,
	@RadiologyCopayAmount [decimal](7, 0) ,
	@Filler_82 [char](82) ,
	@NetChargePaymentAmount [decimal](6, 0) ,
	@Filler_6 [char](6) ,
	@Filler_7_1 [char](7) ,
	@Filler_7_2 [char](7) ,
	@MedicalHomeManagementFee [decimal](7, 0) ,
	@Filler_7_3 [char](7) ,
	@Filler_7_4 [char](7) ,
	@Filler_7_5 [char](7) ,
	@MedicareStatusIndicator [varchar](2) ,
	@OfficeVisitCopayAmount [decimal](7, 0) ,
	@Filler_1_2 [char](1) ,
	@RetroactivityIndicator [char](1) ,
	@Filler_31 [char](31) ,
	@PatientID [varchar](18) ,
	@ProgramIndicator [varchar](10),
	@PaymentDate [date] NULL,
	@CorporateEntityCode [varchar](3),
	@ProductTypeCode [varchar](3),
	@AttributedPrimaryCareProviderNPI [char](10)

            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--DECLARE @DateFromFile DATE
	--SET @DateFromFile = CONVERT(DATE, LEFT(RIGHT(@SrcFileName,12), 8))
	
    INSERT INTO [adi].[Steward_BCBS_BlueCap]
    (
   	[SrcFileName] ,
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName],
	[LastUpdatedBy] ,
	[LastUpdatedDate] ,
	[DataDate] ,
	[MemberNumber] ,
	[Filler_11] ,
	[MemberName] ,
	[MemberDateBirth] ,
	[MemberGender] ,
	[MemberBenefitCode] ,
	[AccountControlNumber] ,
	[BenefitAgreementControlNumber] ,
	[ServiceProviderID] ,
	[CapitationPeriodDate] ,
	[PaymentCode] ,
	[Filler_4] ,
	[SpecialistCopayAmount] ,
	[RadiologyCopayAmount] ,
	[Filler_82] ,
	[NetChargePaymentAmount],
	[Filler_6] ,
	[Filler_7_1] ,
	[Filler_7_2] ,
	[MedicalHomeManagementFee] ,
	[Filler_7_3] ,
	[Filler_7_4] ,
	[Filler_7_5] ,
	[MedicareStatusIndicator] ,
	[OfficeVisitCopayAmount] ,
	[Filler_1_2] ,
	[RetroactivityIndicator] ,
	[Filler_31] ,
	[PatientID] ,
	[ProgramIndicator] ,
	[PaymentDate] ,
	[CorporateEntityCode],
	[ProductTypeCode] ,
	[AttributedPrimaryCareProviderNPI] 
	)
		
 VALUES  (
  
    @SrcFileName  ,
	GETDATE(),
	--[CreateDate] [datetime] ,
	@reateBy ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	GETDATE(),
	--@LastUpdatedDate [datetime] NULL,
	@DataDate ,
	@MemberNumber  ,
	@Filler_11  ,
	@MemberName ,
	@MemberDateBirth ,
	@MemberGender  ,
	@MemberBenefitCode ,
	@AccountControlNumber ,
	@BenefitAgreementControlNumber  ,
	@ServiceProviderID ,
	@CapitationPeriodDate ,
	@PaymentCode ,
	@Filler_4 ,
	@SpecialistCopayAmount  ,
	@RadiologyCopayAmount  ,
	@Filler_82  ,
	@NetChargePaymentAmount ,
	@Filler_6 ,
	@Filler_7_1 ,
	@Filler_7_2 ,
	@MedicalHomeManagementFee  ,
	@Filler_7_3  ,
	@Filler_7_4  ,
	@Filler_7_5  ,
	@MedicareStatusIndicator ,
	@OfficeVisitCopayAmount  ,
	@Filler_1_2 ,
	@RetroactivityIndicator  ,
	@Filler_31 ,
	@PatientID ,
	@ProgramIndicator ,
	@PaymentDate ,
	@CorporateEntityCode ,
	@ProductTypeCode ,
	@AttributedPrimaryCareProviderNPI 
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



