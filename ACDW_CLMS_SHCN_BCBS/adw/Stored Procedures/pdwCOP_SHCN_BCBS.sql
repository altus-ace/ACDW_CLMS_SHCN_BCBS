

	CREATE PROCEDURE	[adw].[pdwCOP_SHCN_BCBS]( ---  [adw].[pdwCOP_SHCN_BCBS]'2021-02-20',20 
							@QMDATE DATE
							,@ClientKey INT)
	AS


	BEGIN
	BEGIN TRY
	BEGIN TRAN

					DECLARE @AuditId INT;    
					DECLARE @JobStatus tinyInt = 1    
					DECLARE @JobType SmallInt = 9	  
					DECLARE @ClientID INT	 = @ClientKey; 
					DECLARE @JobName VARCHAR(100) = 'SHCN_BCBS_CareOpps';
					DECLARE @ActionStart DATETIME2 = GETDATE();
					DECLARE @SrcName VARCHAR(100) = '[ast].[QM_ResultByMember_History]'
					DECLARE @DestName VARCHAR(100) = '[adw].[QM_ResultByMember_History]'
					DECLARE @ErrorName VARCHAR(100) = 'NA';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
					DECLARE @OutputTbl TABLE (ID INT) 

								
					
					SELECT				@InpCnt = COUNT(adiKey)
					FROM				[ast].[QM_ResultByMember_History] 
								
					--SELECT				 @InpCnt  

		EXEC		amd.sp_AceEtlAudit_Open 
					@AuditID = @AuditID OUTPUT
					, @AuditStatus = @JobStatus
					, @JobType = @JobType
					, @ClientKey = @ClientKey
					, @JobName = @JobName
					, @ActionStartTime = @ActionStart
					, @InputSourceName = @SrcName
					, @DestinationName = @DestName
					, @ErrorName = @ErrorName
		
		BEGIN		
		
		/*---Insert into DW -- Headers Tables  */
		INSERT	INTO	[adw].[QM_ResultByMember_History]
						(ClientKey
						,ClientMemberKey
						,QmMsrId
						,QmCntCat
						,QMDate
						,CreateDate
						,CreateBy
						,AdiKey)
		OUTPUT			inserted.adiKey INTO @OutputTbl(ID)
		SELECT			ClientKey
						,ClientMemberKey
						,QmMsrId
						,QmCntCat
						,QMDate
						,CreateDate
						,CreateBy
						,AdiKey
		FROM			[ast].[QM_ResultByMember_History]  
		WHERE			ClientKey = @ClientKey 
		AND				QMDate = @QMDate

			
		END
			
		
		BEGIN
					/*---Insert into DW -- Details Tables  */
					INSERT INTO adw.QM_ResultByValueCodeDetails_History(
						ClientKey
						,ClientMemberKey
						,ValueCodeSystem
						,ValueCode
						,ValueCodePrimarySvcDate
						,QmMsrID
						,QmCntCat
						,QMDate
						,SEQ_CLAIM_ID
						,SVC_TO_DATE)
		SELECT			ClientKey
						,ClientMemberKey
						,'0'			AS ValueCodeSystem
						,'0'			AS ValueCode
						,LoadDate		AS ValueCodePrimarySvcDate
						,QmMsrId
						,QmCntCat
						,QMDate
						,'0'			AS SEQ_CLAIM_ID
						,''				AS SVC_TO_DATE
		FROM			[ast].[QM_ResultByMember_History]  
		WHERE			ClientKey = @ClientKey 
		AND				QMDate =	@QMDate
		AND				QmCntCat IN ('DEN','NUM')

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
		EXECUTE [dbo].[usp_QM_Error_handler]
		END CATCH

		END
		
		--Validation
		SELECT          COUNT(*)
                        ,[QmMsrId]
                        ,[QmCntCat]
        FROM            [adw].[QM_ResultByMember_History]
        WHERE           QMDate = @QMDATE
        AND             ClientKey = 20
        GROUP BY        [QmMsrId]
                        ,[QmCntCat]
        ORDER BY        [QmMsrId]

		
		

	