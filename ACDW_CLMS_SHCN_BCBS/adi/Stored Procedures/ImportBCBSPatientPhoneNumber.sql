-- =============================================
-- Author:		Bing Yu
-- Create date: 04/04/2019
-- Description:	Insert CareGaps Claim file to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportBCBSPatientPhoneNumber]
    @SrcFileName [varchar](100),
	--[CreateDate] [datetime] NOT NULL,
	@CreateBy [varchar](100) ,
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy [varchar](100),
	@DataDate varchar(10),
	@PatientPolicyidNumber [varchar](50) ,
	@PatientFirstName [varchar](50),
	@PatientLastName [varchar](50),
	@PatientHomePhone varchar(15),
	@PatientMobilePhone [varchar](15) 
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
    INSERT INTO [adi].[BCBSPatientPhoneNumber]
    (
	   [SrcFileName]
      ,[CreateDate]
      ,[CreateBy]
      ,[LastUpdatedDate]
      ,[LastUpdatedBy]
      ,[DataDate]
      ,[PatientPolicyidNumber]
      ,[PatientFirstName]
      ,[PatientLastName]
      ,[PatientHomePhone]
      ,[PatientMobilePhone]
	
	)
		
 VALUES  (
    @SrcFileName ,
	GETDATE(),
	--[CreateDate] [datetime] NOT NULL,
	@CreateBy ,
	GETDATE(),
	--[LastUpdatedDate] [datetime] NOT NULL,
	@LastUpdatedBy ,
	CASE WHEN @DataDate = ''
	THEN NULL
	ELSE CONVERT(DATE, @DataDate)
	END,
	@PatientPolicyidNumber ,
	@PatientFirstName ,
	@PatientLastName ,
	@PatientHomePhone ,
	@PatientMobilePhone  
  ) 
   

 END
