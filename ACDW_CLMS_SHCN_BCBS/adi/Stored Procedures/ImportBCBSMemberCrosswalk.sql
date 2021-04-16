
-- =============================================
-- Author:		Bing Yu
-- Create date: 09/09/2020
-- Description:	Insert BCBS Institutioanl claims  to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportBCBSMemberCrosswalk]
    
	@SrcFileName [varchar](100) ,
	--[CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) ,
	@OriginalFileName [varchar](100) ,
	@LastUpdatedBy [varchar](100),
	--[LastUpdatedDate] [datetime] NULL,
	@DataDate varchar(10),
	@PatientID varchar(50),
	@SubscriberID [varchar](30) ,
	@MemberFirstName [varchar](35) ,
	@MemberMiddle [varchar](35),
	@MemberLastName [varchar](35),
	@MemberDateBirth varchar(10),
	@MemberGender [char](1),
	@MemberGenderDescription [varchar](8),
	@MemberLast4SSNdigits [char](4),
	@ExtractID [char](14),
	@MemberOriginalEffectiveDate varchar(10),
	@Indicator834 [char](1),
	@RiskScore varchar(10),
	@OpportunityScore varchar(10),
	@HealthStatus [varchar](20),
	@AssignmentIndicator [char](3) ,
	@ProgramIndicator [char](10),
	@PriorPatientID [varchar](18) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--DECLARE @DateFromFile DATE
	--SET @DateFromFile = CONVERT(DATE, LEFT(RIGHT(@SrcFileName,12), 8))
	
    INSERT INTO [adi].[Steward_BCBS_MemberCrosswalk]
    (
    [SrcFileName] ,
	[CreateDate] ,
	[CreateBy] ,
	[OriginalFileName] ,
	[LastUpdatedBy],
	[LastUpdatedDate] ,
	[DataDate],
	[PatientID],
	[SubscriberID],
	[MemberFirstName] ,
	[MemberMiddle] ,
	[MemberLastName] ,
	[MemberDateBirth] ,
	[MemberGender] ,
	[MemberGenderDescription] ,
	[MemberLast4SSNdigits] ,
	[ExtractID] ,
	[MemberOriginalEffectiveDate],
	[Indicator834],
	[RiskScore] ,
	[OpportunityScore] ,
	[HealthStatus] ,
	[AssignmentIndicator] ,
	[ProgramIndicator] ,
	[PriorPatientID] 

	)
		
 VALUES  (
  
   	@SrcFileName ,
	GETDATE(),
	--[CreateDate] [datetime] NULL,
	@CreateBy  ,
	@OriginalFileName ,
	@LastUpdatedBy ,
	GETDATE(),
	--[LastUpdatedDate] [datetime] NULL,
	CASE WHEN @DataDate =''
	THEN NULL
	ELSE CONVERT(DATE,@DataDate)
	END ,
	CASE WHEN @PatientID =''
	THEN NULL
	ELSE CONVERT(decimal(18,0),@PatientID)
	END ,
	@SubscriberID  ,
	@MemberFirstName  ,
	@MemberMiddle,
	@MemberLastName ,
	CASE WHEN @MemberDateBirth =''
	THEN NULL
	ELSE CONVERT(DATE, @MemberDateBirth)
	END ,
	@MemberGender ,
	@MemberGenderDescription ,
	@MemberLast4SSNdigits ,
	@ExtractID ,
	CASE WHEN @MemberOriginalEffectiveDate  =''
	THEN NULL
	ELSE CONVERT(DATE, @MemberOriginalEffectiveDate )
	END ,
	@Indicator834 ,
	CASE WHEN @RiskScore  =''
	THEN NULL
	ELSE CONVERT(decimal(5,0), @RiskScore)
	END ,
	CASE WHEN @OpportunityScore   =''
	THEN NULL
	ELSE CONVERT(decimal(5,0), @OpportunityScore )
	END ,	
	@HealthStatus ,
	@AssignmentIndicator ,
	@ProgramIndicator ,
	@PriorPatientID 
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

