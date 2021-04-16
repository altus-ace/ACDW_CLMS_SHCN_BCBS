-- =============================================
-- Author:		Bing Yu
-- Create date: 09/09/2020
-- Description:	Insert BCBS Institutioanl claims  to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportBCBSMembership]
    @SrcFileName [varchar](100) ,
	-- [CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) ,
	@OriginalFileName [varchar](100),
	@LastUpdatedBy [varchar](100) ,
	--@LastUpdatedDate [datetime] NULL,
	@DataDate varchar(10),
	@PatientID varchar(50),
	@SubscriberID varchar(30) ,
	@RelationshipCode varchar(3) ,
	@MemberPrefix varchar(4) ,
	@MemberFirstName [varchar](35) ,
	@MemberMiddleName [varchar](35) ,
	@MemberLastName [varchar](35),
	@MemberNameSuffix [varchar](6) ,
	@MemberBirthDate varchar(10),
	@MemberGender [char](1),
	@MemberLast4DigitsSSN [char](4),
	@MemberHomeAddress1 [varchar](55),
	@MemberHomeAddress2 [varchar](55),
	@MemberCity [varchar](28),
	@MemberState [char](2) ,
	@MemberZip [char](9) ,
	@MemberCounty [varchar](255),
	@MemberPrimaryPhone [char](10),
	@MemberSecondaryPhone [char](10) ,
	@MemberAttributedStatus [varchar](9),
	@MemberEffectiveDate varchar(10),
	@MemberTerminateDate varchar(10),
	@AttributedPrimaryCareProviderNPI [char](10),
	@AttributedPrimaryCareProviderPrefix [char](4) ,
	@AttributedPrimaryCareProviderFirstName [varchar](35),
	@AttributedPrimaryCareProviderMiddle [varchar](35),
	@AttributedPrimaryCareProviderLastName [varchar](35),
	@AttributedPrimaryCareProviderNameSuffix [varchar](20),
	@AttributedSpecialistNPI [char](10) ,
	@AttributedSpecialistPrefix [char](4) NULL,
	@AttributedSpecialistFirstName [varchar](35),
	@AttributedSpecialistMiddle [varchar](35),
	@AttributedSpecialistLastName [varchar](35) ,
	@AttributedSpecialistNameSuffix Varchar(20)
	
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--DECLARE @DateFromFile DATE
	--SET @DateFromFile = CONVERT(DATE, LEFT(RIGHT(@SrcFileName,12), 8))
	
	 DECLARE @DateFromFile VARCHAR(10)
	 SET @DateFromFile = SUBSTRING(@SrcFileName,28,8)
	
    INSERT INTO [adi].[Steward_BCBS_Membership]
    (
	[SrcFileName] ,
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy] ,
	[LastUpdatedDate],
	[DataDate] ,
    [PatientID] ,
	[SubscriberID] ,
	[RelationshipCode] ,
	[MemberPrefix] ,
	[MemberFirstName] ,
	[MemberMiddleName] ,
	[MemberLastName] ,
	[MemberNameSuffix] ,
	[MemberBirthDate] ,
	[MemberGender] ,
	[MemberLast4DigitsSSN] ,
	[MemberHomeAddress1] ,
	[MemberHomeAddress2] ,
	[MemberCity] ,
	[MemberState] ,
	[MemberZip] ,
	[MemberCounty] ,
	[MemberPrimaryPhone] ,
	[MemberSecondaryPhone] ,
	[MemberAttributedStatus] ,
	[MemberEffectiveDate] ,
	[MemberTerminateDate] ,
	[AttributedPrimaryCareProviderNPI] ,
	[AttributedPrimaryCareProviderPrefix] ,
	[AttributedPrimaryCareProviderFirstName] ,
	[AttributedPrimaryCareProviderMiddle] ,
	[AttributedPrimaryCareProviderLastName] ,
	[AttributedPrimaryCareProviderNameSuffix] ,
	[AttributedSpecialistNPI] ,
	[AttributedSpecialistPrefix] ,
	[AttributedSpecialistFirstName] ,
	[AttributedSpecialistMiddle] ,
	[AttributedSpecialistLastName] ,
	[AttributedSpecialistNameSuffix] 	 
	)
		
 VALUES  (
  
    @SrcFileName ,
	GETDATE(),
	-- [CreateDate] [datetime] NULL,
	@CreateBy  ,
	@OriginalFileName ,
	@LastUpdatedBy  ,
	GETDATE(),
	GETDATE(),
	--@LastUpdatedDate [datetime] NULL,
	--@DataDate ,
    --CONVERT(DATE, SUBSTRING(@DateFromFile, 1,4) +'-'+ SUBSTRING(@DateFromFile, 5,2) +'-'+ SUBSTRING(@DateFromFile, 7,2)),
	--ACO.MEMBERSHIP.ACONAME.GENKEY.YYYYMMD.HHMMSSsss.txt
	@PatientID ,
	@SubscriberID ,
	@RelationshipCode  ,
	@MemberPrefix  ,
	@MemberFirstName  ,
	@MemberMiddleName  ,
	@MemberLastName ,
	@MemberNameSuffix ,
	@MemberBirthDate ,
	@MemberGender ,
	@MemberLast4DigitsSSN ,
	@MemberHomeAddress1 ,
	@MemberHomeAddress2 ,
	@MemberCity ,
	@MemberState  ,
	@MemberZip  ,
	@MemberCounty ,
	@MemberPrimaryPhone ,
	@MemberSecondaryPhone  ,
	@MemberAttributedStatus ,
	@MemberEffectiveDate ,
	@MemberTerminateDate ,
	@AttributedPrimaryCareProviderNPI ,
	@AttributedPrimaryCareProviderPrefix ,
	@AttributedPrimaryCareProviderFirstName ,
	@AttributedPrimaryCareProviderMiddle ,
	@AttributedPrimaryCareProviderLastName ,
	@AttributedPrimaryCareProviderNameSuffix ,
	@AttributedSpecialistNPI ,
	@AttributedSpecialistPrefix ,
	@AttributedSpecialistFirstName ,
	@AttributedSpecialistMiddle ,
	@AttributedSpecialistLastName ,
	@AttributedSpecialistNameSuffix 
	
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
