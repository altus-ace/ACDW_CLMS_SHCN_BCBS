

	CREATE PROCEDURE	[ast].[plsBCBSCareoppsMonthlyGaps]( ---  [ast].[plsBCBSCareoppsMonthlyGaps]'2021-03-19',20,'2021-03-01'  
							@QMDATE DATE
							,@ClientKey INT
							,@DataDate DATE)
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
					DECLARE @SrcName VARCHAR(100) = '[adi].[Steward_BCBS_MONTHLY_GAPS_IN_CAREDETAIL]'
					DECLARE @DestName VARCHAR(100) = '[ACECAREDW].[ast].[QM_ResultByMember_History]'
					DECLARE @ErrorName VARCHAR(100) = 'NA';
					DECLARE @InpCnt INT = -1;
					DECLARE @OutCnt INT = -1;
					DECLARE @ErrCnt INT = -1;
					DECLARE @OutputTbl TABLE (ID INT) 

	IF OBJECT_ID('tempdb..#BCBSCareOpps') IS NOT NULL DROP TABLE #BCBSCareOpps
	

	CREATE TABLE  #BCBSCareOpps ([pstQM_ResultByMbr_HistoryKey] [int] IDENTITY(1,1) NOT NULL,[astRowStatus] [varchar](20) DEFAULT'P' NOT NULL,
								[srcFileName] [varchar](150) NULL,
								[adiTableName] [varchar](100) NOT NULL,	[adiKey] [int] NOT NULL,[LoadDate] [date] NOT NULL,	
								[CreateDate] [datetime] NOT NULL,
								[CreateBy] [varchar](50) NOT NULL,[ClientKey] [int] NOT NULL,[ClientMemberKey] [varchar](50) NOT NULL 
								,[QmMsrId] [varchar](100) NOT NULL,[QmCntCat] [varchar](10) NOT NULL,[QMDate] [date] NULL
								,[MemberStatus] VARCHAR(50) NOT NULL
								)
							
					
					SELECT				@InpCnt = COUNT(adiKey)
					FROM				#BCBSCareOpps
								
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
		
		BEGIN			----  DECLARE @QMDATE DATE = '2021-02-20' DECLARE @DataDate DATE = '2021-03-01' 
		
		INSERT INTO	#BCBSCareOpps(
					[srcFileName]
					, [adiTableName]
					, [adiKey]
					, [LoadDate] --Becomes Data date of the file
					, [CreateDate]
					, [CreateBy]
					, [ClientKey]
					, [ClientMemberKey]
					, [MemberStatus]
					, [QmMsrId]
					, [QmCntCat]
					, [QMDate])
		OUTPUT		inserted.adiKey INTO @OutputTbl(ID)
		SELECT		a.SrcFileName
					,a.AdiTableName
					,a.Adikey
					,a.DataDate
					,a.CreateDate
					,a.CreateBy
					,a.ClientKey
					,a.PatientID AS [ClientMemberKey]
					,a.IncludedInNumerator AS [MemberStatus]
					,a.QM
					,a.QmCntCat
					,a.QMDate

		FROM		(   -- Calculating for DEN --  SELECT * FROM (
						SELECT		MONTHLYGAPSINCAREDETAILKey AS AdiKey,src.SrcFileName,DataDate,MeasureName
									,(SELECT ClientKey FROM lst.list_client WHERE ClientShortName = 'SHCN_BCBS') ClientKey
									,IncludedInNumerator,Exclusion,DateTest,Lab_Test,Test_Result
									,PatientID,CONVERT(DATE,CreateDate) AS CreateDate
									,'[adi].[Steward_BCBS_MONTHLY_GAPS_IN_CAREDETAIL]' AS AdiTableName
									,SUSER_NAME()[CreateBy]
									,ROW_NUMBER()OVER(PARTITION BY PatientID,MeasureName ORDER BY DataDate DESC)RwCnt
									,CASE  WHEN IncludedInNumerator = 'Y' AND Exclusion = 'N' 
												OR MeasureName = 'Use of Spirometry Testing in the Assessment and Diagnosis of COPD' THEN 'DEN'
										   WHEN IncludedInNumerator = 'N' AND Exclusion = 'N' 
												OR MeasureName = 'Use of Spirometry Testing in the Assessment and Diagnosis of COPD'  THEN 'DEN'
									END QmCntCat
									,QM,QM_DESC
									, @QMDATE AS QMDATE --  '2021-02-20' QMDATE  --
						FROM		[ACDW_CLMS_SHCN_BCBS].[adi].[Steward_BCBS_MONTHLY_GAPS_IN_CAREDETAIL] src
						JOIN		lst.LIST_QM_Mapping lk
						ON			src.MeasureName = lk.QM_DESC
						JOIN		(	SELECT		CLIENT_SUBSCRIBER_ID
										FROM		ACECAREDW.dbo.vw_ActiveMembers vw
										WHERE		ClientKey = 20
									) vw
						ON			src.PatientID = vw.CLIENT_SUBSCRIBER_ID
						WHERE		IncludedInNumerator IN ('Y','N')
						AND			DataDate = @DataDate --  '2021-03-01' --
						AND			Status = 0
						
					)a
		WHERE		RwCnt = 1
		AND			QmCntCat = 'DEN'
		
		END

		--  SELECT * FROM #BCBSCareOpps ORDER BY QmMsrId DESC
		BEGIN
		--Insert NUM
		INSERT INTO	#BCBSCareOpps(
					[srcFileName]
					, [adiTableName]
					, [adiKey]
					, [LoadDate]
					, [CreateDate]
					, [CreateBy]
					, [ClientKey]
					, [ClientMemberKey]
					, [MemberStatus]
					, [QmMsrId]
					, [QmCntCat]
					, [QMDate])
		SELECT		srcFileName
					,AdiTableName
					,adiKey
					,LoadDate
					,[CreateDate]
					,[CreateBy]
					,ClientKey
					,ClientMemberKey
					,[MemberStatus]
					,[QmMsrId]
					,'NUM'
					,[QMDate]
		FROM		#BCBSCareOpps
		WHERE		MemberStatus = 'Y'
		
		END

		BEGIN
		--Insert COP
		INSERT INTO	#BCBSCareOpps(
					[srcFileName]
					, [adiTableName]
					, [adiKey]
					, [LoadDate]
					, [CreateDate]
					, [CreateBy]
					, [ClientKey]
					, [ClientMemberKey]
					, [MemberStatus]
					, [QmMsrId]
					, [QmCntCat]
					, [QMDate])
		SELECT		srcFileName
					,AdiTableName
					,adiKey
					,LoadDate
					,[CreateDate]
					,[CreateBy]
					,ClientKey
					,ClientMemberKey
					,[MemberStatus]
					,[QmMsrId]
					,'COP'
					,[QMDate]
		FROM		#BCBSCareOpps
		WHERE		MemberStatus = 'N'

		END


		-- Insert into staging
		BEGIN

		INSERT INTO		[ast].[QM_ResultByMember_History](
						[astRowStatus]
						, [srcFileName]
						, [adiTableName]
						, [adiKey]
						, [LoadDate]
						, [CreateDate]
						, [CreateBy]
						, [ClientKey]
						, [ClientMemberKey]
						, [QmMsrId]
						, [QmCntCat]
						, [QMDate])
		
		SELECT			'Exported'
						, [srcFileName]
						, [adiTableName]
						, [adiKey]
						, [LoadDate]
						, [CreateDate]
						, [CreateBy]
						, [ClientKey]
						, [ClientMemberKey]
						, [QmMsrId]
						, [QmCntCat]
						, [QMDate]
		FROM			#BCBSCareOpps
		
	
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

		DROP TABLE #BCBSCareOpps

		COMMIT
		END TRY

		BEGIN CATCH
		EXECUTE [dbo].[usp_QM_Error_handler]
		END CATCH

		END
		

		/*

		SELECT COUNT(*)RecCnt, DataDate
		FROM [ACDW_CLMS_SHCN_BCBS].[adi].[Steward_BCBS_MONTHLY_GAPS_IN_CAREDETAIL]
		GROUP BY DataDate
		ORDER BY DataDate DESC

		*/
		--Validation
		SELECT          COUNT(*)
                        ,[QmMsrId]
                        ,[QmCntCat]
        FROM            [ast].[QM_ResultByMember_History]
        WHERE           QMDate = @QMDATE
        AND             ClientKey = 20
        GROUP BY        [QmMsrId]
                        ,[QmCntCat]
        ORDER BY        [QmMsrId]


		