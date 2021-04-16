


CREATE PROCEDURE [ast].[stg_01_pls_SHCN_BCBSMbrMemberLoad]
							(@MbrShipDataDate  DATE
							,@MbrCrsWkDataDate Date)

AS

BEGIN
BEGIN TRAN
BEGIN TRY
						DECLARE @AuditId INT;    
						DECLARE @JobStatus tinyInt = 1    
						DECLARE @JobType SmallInt = 9	  
						DECLARE @ClientKey INT	 = 20; 
						DECLARE @JobName VARCHAR(100) = 'SHCN_BCBS MbrMember';
						DECLARE @ActionStart DATETIME2 = GETDATE();
						DECLARE @SrcName VARCHAR(100) = '[adi].[Steward_BCBS_Membership]'
						DECLARE @DestName VARCHAR(100) = ''
						DECLARE @ErrorName VARCHAR(100) = 'NA';
						DECLARE @InpCnt INT = -1;
						DECLARE @OutCnt INT = -1;
						DECLARE @ErrCnt INT = -1;
	SELECT				@InpCnt = COUNT(mbrStg2_MbrDataUrn)    
	FROM				[ast].[MbrStg2_MbrData] 
	WHERE				DataDate = @MbrShipDataDate  
	
	SELECT				@InpCnt, @MbrShipDataDate
	
	
	EXEC				amd.sp_AceEtlAudit_Open 
						@AuditID = @AuditID OUTPUT
						, @AuditStatus = @JobStatus
						, @JobType = @JobType
						, @ClientKey = @ClientKey
						, @JobName = @JobName
						, @ActionStartTime = @ActionStart
						, @InputSourceName = @SrcName
						, @DestinationName = @DestName
						, @ErrorName = @ErrorName
						;

BEGIN
		
		SELECT			a.PatientID
						,b.PatientID
						,Indicator834
						,MemberAttributedStatus
						,a.DataDate
						,b.DataDate
		FROM			[adi].[Steward_BCBS_Membership]	a
		JOIN			(	
							SELECT		*
							FROM		[adi].[Steward_BCBS_MemberCrosswalk] 
							WHERE		Indicator834 = 'Y'
							AND			DataDate = @MbrCrsWkDataDate
							AND			Status = 0
						) b
		ON				a.PatientID = b.PatientID
		AND				a.SubscriberID = b.SubscriberID
		WHERE			a.DataDate =   @MbrShipDataDate -- '2021-01-21' --
		AND				a.Status = 0
		AND				MemberAttributedStatus IN ('ADD','REINSTATE','CONTINUE')
END
		SET					@ActionStart  = GETDATE();
		SET					@JobStatus =2  
	    				
		EXEC				amd.sp_AceEtlAudit_Close 
							@AuditId = @AuditID
							, @ActionStopTime = @ActionStart
							, @SourceCount = @InpCnt		  
							, @DestinationCount = @OutCnt
							, @ErrorCount = @ErrCnt
							, @JobStatus = @JobStatus

COMMIT
END TRY
BEGIN CATCH
EXECUTE [adw].[usp_MPI_Error_handler]
END CATCH

END



/*
USAGE: EXEC [ast].[stg_01_pls_SHCN_BCBSMbrMemberLoad]'2020-12-20','2020-12-20'
*/