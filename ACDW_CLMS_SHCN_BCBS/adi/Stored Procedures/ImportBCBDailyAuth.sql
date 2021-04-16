

-- =============================================
-- Author:		Bing Yu
-- Create date: 09/09/2020
-- Description:	Insert BCBS Institutioanl claims  to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportBCBDailyAuth]
    
	@SrcFileName [varchar](100) ,
	--[CreateDate] [datetime] ,
	@CreateBy [varchar](100) ,
	@OriginalFileName [varchar](100) ,
	@LastUpdatedBy [varchar](100),
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate varchar(10),
	@ICDVersionCode [char](2),
	@PatientID varchar(50),
	@SubscriberID [varchar](30) ,
	@MemberGender [char](1) ,
	@MemberGenderDescription [varchar](25) ,
	@MemberBirthDate varchar(10),
	@MemberFirstName [varchar](35) ,
	@MemberLastName [varchar](35) ,
	@MemberZip char(5),
	@MemberZipCode_4 [char](4),
	@ProviderTypeDescription [char](10),
	@FacilityName varchar(75) ,
	@ProviderNPI [char](10),
	@ProviderSpecialtyDescription [varchar](35) ,
	@ProviderPhoneNumber [char](10) ,
	@ProviderStreetAddress1 [varchar](35) ,
	@ProviderStreetAddress2 [varchar](35) ,
	@ProviderCity [varchar](28) ,
	@ProviderState [char](2) ,
	@ProviderZipCode [char](5),
	@AttendingProviderTypeDescription [varchar](35) ,
	@AttendingProviderID_NPI [char](10) ,
	@AttendingProviderSpecialtyDescription [varchar](35),
	@AttendingProviderPhoneNumber [char](10) ,
	@AttendingProviderFirstName [varchar](35) ,
	@AttendingProviderLastName [varchar](35) ,
	@AttendingProviderStreetAddress1 [varchar](55) ,
	@AttendingProviderStreetAddress2 [varchar](35) ,
	@AttendingProviderCity [varchar](28) NULL,
	@AttendingProviderState [char](2),
	@AttendingProviderZipCode [char](5),
	@AuthorizationNumber [varchar](30),
	@NotificationDate varchar(10),
	@AdmissionDate varchar(10),
	@DischargeDate varchar(10),
	@RequestedAdmissionDate varchar(10),
	@RequestedDischargeDate varchar(10),
	@TypeServiceCode [char](5),
	@TypeServiceDescription [varchar](100),
	@TreatmentSettingCode [varchar](10) ,
	@TreatmentSettingDescription [varchar](100),
	@DiagnosisCode [char](10) ,
	@DiagnosisCodeDescription [varchar](200) ,
	@PrimaryDiagnosisFlag [char](1) ,
	@PatientDischargeStatusCode [char](10) ,
	@PatientDischargeCodeDescription [char](32),
	@TreatmentUrgencyDescription [varchar](100) ,
	@ExtractID [char](4)
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	 DECLARE @DateFromFile VARCHAR(10)
	 SET @DateFromFile = SUBSTRING(@SrcFileName,29,8)
	-- ACO.PREAUTH.STEWARD.1009417.17122020.073531320.TXT
	 --CONVERT(DATE, LEFT(RIGHT(@SrcFileName,12), 8))
	
    INSERT INTO [adi].[Steward_BCBS_DailyAuth]
    (
	[SrcFileName],
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate],
	[DataDate] ,
	[ICDVersionCode] ,
	[PatientID] ,
	[SubscriberID] ,
	[MemberGender] ,
	[MemberGenderDescription] ,
	[MemberBirthDate] ,
	[MemberFirstName] ,
	[MemberLastName] ,
	[MemberZip] ,
	[MemberZipCode_4] ,
	[ProviderTypeDescription] ,
	[FacilityName] ,
	[ProviderNPI] ,
	[ProviderSpecialtyDescription] ,
	[ProviderPhoneNumber] ,
	[ProviderStreetAddress1] ,
	[ProviderStreetAddress2] ,
	[ProviderCity] ,
	[ProviderState] ,
	[ProviderZipCode] ,
	[AttendingProviderTypeDescription],
	[AttendingProviderID_NPI] ,
	[AttendingProviderSpecialtyDescription] ,
	[AttendingProviderPhoneNumber] ,
	[AttendingProviderFirstName] ,
	[AttendingProviderLastName] ,
	[AttendingProviderStreetAddress1] ,
	[AttendingProviderStreetAddress2] ,
	[AttendingProviderCity] ,
	[AttendingProviderState] ,
	[AttendingProviderZipCode],
	[AuthorizationNumber] ,
	[NotificationDate] ,
	[AdmissionDate] ,
	[DischargeDate] ,
	[RequestedAdmissionDate] ,
	[RequestedDischargeDate] ,
	[TypeServiceCode] ,
	[TypeServiceDescription] ,
	[TreatmentSettingCode] ,
	[TreatmentSettingDescription] ,
	[DiagnosisCode] ,
	[DiagnosisCodeDescription] ,
	[PrimaryDiagnosisFlag] ,
	[PatientDischargeStatusCode] ,
	[PatientDischargeCodeDescription] ,
	[TreatmentUrgencyDescription] ,
	[ExtractID] 

   
	)
		
 VALUES  (
  
   @SrcFileName  ,
   GETDATE(),
	--[CreateDate] [datetime] ,
	@CreateBy  ,
	@OriginalFileName  ,
	@LastUpdatedBy ,
	GETDATE(),
	--[LastUpdatedDate] [datetime] NULL,
	--@DataDate ,
	--GETDATE(),
	CONVERT(DATE, SUBSTRING(@DateFromFile, 5,4) +'-'+ SUBSTRING(@DateFromFile, 3,2) +'-'+ SUBSTRING(@DateFromFile, 1,2)),
	--SUBSTRING('ACO.PREAUTH.ACONAME.GENKEY.DDMMYYYY.HHMMSSsss.txt',28,8),
	@ICDVersionCode ,
	@PatientID ,
	@SubscriberID  ,
	@MemberGender  ,
	@MemberGenderDescription ,
	@MemberBirthDate ,
	@MemberFirstName ,
	@MemberLastName  ,
	@MemberZip ,
	@MemberZipCode_4 ,
	@ProviderTypeDescription ,
	@FacilityName ,
	@ProviderNPI ,
	@ProviderSpecialtyDescription  ,
	@ProviderPhoneNumber  ,
	@ProviderStreetAddress1  ,
	@ProviderStreetAddress2  ,
	@ProviderCity  ,
	@ProviderState  ,
	@ProviderZipCode ,
	@AttendingProviderTypeDescription  ,
	@AttendingProviderID_NPI  ,
	@AttendingProviderSpecialtyDescription ,
	@AttendingProviderPhoneNumber  ,
	@AttendingProviderFirstName  ,
	@AttendingProviderLastName  ,
	@AttendingProviderStreetAddress1,
	@AttendingProviderStreetAddress2  ,
	@AttendingProviderCity ,
	@AttendingProviderState ,
	@AttendingProviderZipCode ,
	@AuthorizationNumber ,
	@NotificationDate ,
	@AdmissionDate ,
	@DischargeDate ,
	@RequestedAdmissionDate ,
	@RequestedDischargeDate ,
	@TypeServiceCode ,
	@TypeServiceDescription ,
	@TreatmentSettingCode  ,
	@TreatmentSettingDescription ,
	@DiagnosisCode  ,
	@DiagnosisCodeDescription  ,
	@PrimaryDiagnosisFlag ,
	@PatientDischargeStatusCode  ,
	@PatientDischargeCodeDescription ,
	@TreatmentUrgencyDescription  ,
	@ExtractID
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


