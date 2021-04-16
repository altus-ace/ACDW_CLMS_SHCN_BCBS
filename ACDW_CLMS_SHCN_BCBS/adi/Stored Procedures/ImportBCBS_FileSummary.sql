-- =============================================
-- Author:		Bing Yu
-- Create date: 09/09/2020
-- Description:	Insert BCBS Institutioanl claims  to DB
-- =============================================
CREATE PROCEDURE [adi].[ImportBCBS_FileSummary]
    @SrcFileName [varchar](100),
	-- [CreateDate] [datetime] NULL,
	@CreateBy [varchar](100) ,
	@OriginalFileName [varchar](100),
	@LastUpdatedBy [varchar](100) ,
	--@LastUpdatedDate [datetime] NULL,
	@DataDate varchar(10),
	@FieldType varchar(100),
    @RecordCount varchar(10),
    @FileName varchar(100),
    @ClaimCount varchar(10)	
            
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	--DECLARE @DateFromFile DATE
	--SET @DateFromFile = CONVERT(DATE, LEFT(RIGHT(@SrcFileName,12), 8))
	
    INSERT INTO [adi].[Steward_BCBS_FileSummary]
    (
      [SrcFileName]
      ,[CreateDate]
      ,[CreateBy]
      ,[OriginalFileName]
      ,[LastUpdatedBy]
      ,[LastUpdatedDate]
      ,[DataDate]
      ,[FieldType]
      ,[RecordCount]
      ,[FileName]
      ,[ClaimCount]	
	)
		
 VALUES  (
  
    @SrcFileName ,
	GETDATE(),
	-- [CreateDate] [datetime] NULL,
	@CreateBy  ,
	@OriginalFileName,
	@LastUpdatedBy,
	GETDATE(),
	--@LastUpdatedDate [datetime] NULL,
	@DataDate,
	@FieldType ,
	CASE WHEN @RecordCount = ''
    THEN NULL
	ELSE CONVERT(INT, @RecordCount)
	END ,
    @FileName,
	CASE WHEN @ClaimCount = ''
    THEN NULL
	ELSE CONVERT(INT, @ClaimCount)
	END 
)
    
END
