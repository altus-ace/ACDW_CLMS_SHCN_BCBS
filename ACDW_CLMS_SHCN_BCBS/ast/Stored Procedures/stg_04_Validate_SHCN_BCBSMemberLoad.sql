
CREATE PROCEDURE [ast].[stg_04_Validate_SHCN_BCBSMemberLoad](@DataDate DATE
														, @MbrCrWkDataDate DATE
														,@EffectiveDate DATE) --  [ast].[stg_04_Validate_SHCN_BCBSMemberLoad]'2021-03-19','2021-03-19','2021-03-01'

AS

BEGIN
	-----To fill in later.

	--Validate qualified records
	--  DECLARE @DataDate DATE = '2021-01-20'
	CREATE TABLE #Output(Cnt INT)
	INSERT INTO #Output
	OUTPUT inserted.Cnt
	SELECT		COUNT(*) LatestRecordCntBCBS
	FROM		(
					SELECT	a.PatientID,a.AttributedPrimaryCareProviderNPI,PCP_NPI
							, ROW_NUMBER()OVER(PARTITION BY patientid, pcp_npi ORDER BY datadate)RwCnt
					FROM	(	SELECT DISTINCT a.PatientID,b.PatientID mbrID,AttributedPrimaryCareProviderNPI,b.DataDate,Indicator834 
								FROM			adi.Steward_BCBS_Membership a
								JOIN			(	SELECT		* 
													FROM		adi.Steward_BCBS_MemberCrosswalk
													WHERE		DataDate = @MbrCrWkDataDate
													AND			Indicator834 = 'Y'
													AND			Status = 0
												) b
								ON				a.PatientID = b.PatientID
								WHERE			a.Status = 0
								AND				a.DataDate = @DataDate
																
							) a
	JOIN			(	
							SELECT  PCP_NPI
									,PCP_PRACTICE_TIN
									,PCP_POD
									,EffectiveDate
									,ExpirationDate
									,TinHPEffectiveDate
									,TinHPExpirationDate
							FROM    (
							SELECT	*
									,ROW_NUMBER()OVER(PARTITION BY PCP_NPI ORDER BY EffectiveDate DESC)RwCnt
							FROM	lst.List_Pcp e  
							WHERE	@EffectiveDate BETWEEN EffectiveDate AND	ExpirationDate 
							AND		@EffectiveDate BETWEEN TinHPEffectiveDate AND	TinHPExpirationDate
									)src
							WHERE	RwCnt = 1
							) b
	ON			AttributedPrimaryCareProviderNPI = PCP_NPI 
	WHERE		a.DataDate = @DataDate --  '2021-01-20' -- 
				)a
	WHERE		RwCnt = 1
	--SELECT * FROM #Output
	
	DROP TABLE #Output
END

--Validate AceID

	SELECT	 COUNT(*) RecCnt, MstrMrnKey
    FROM	 ast.MbrStg2_MbrData
    WHERE	 DataDate =  @DataDate 
	GROUP BY MstrMrnKey
	HAVING	 COUNT(*) >1

	/*
	--Developed script for Correction when count >1
	--step 1
	--  drop table #Moi  DECLARE @DataDate DATE = '2021-02-18'
	--BEGIN
		SELECT * INTO #Moi  
		FROM (
				SELECT			a.MstrMrnKey,b.MstrMrnKey aceid,mbrFirstName,mbrLastName,mbrDob,mbrGENDER,DataDate
								,ClientSubscriberId,mbrMiddleName,[mbrStg2_MbrDataUrn]
								, ROW_NUMBER()OVER(PARTITION BY a.MstrMrnKey ORDER BY datadate)rwcnt ,MbrState,AdiKey
						FROM	(
									SELECT	 COUNT(*) RecCnt, MstrMrnKey
									FROM	 ast.MbrStg2_MbrData
									WHERE	 DataDate = @DataDate --27492
									GROUP BY MstrMrnKey
									HAVING	 COUNT(*) >1
								)a
				JOIN	ast.MbrStg2_MbrData b
				ON		a.MstrMrnKey = b.MstrMrnKey
				WHERE	DataDate = @DataDate
				--order by a.MstrMrnKey
		)a WHERE rwcnt = 1
		--  SELECT * FROM #Moi
		--step 2
		update #moi set mbrgender = ''

		--step 3
			TRUNCATE TABLE [AceMPI].[ast].[MPI_SourceTable] 

			TRUNCATE TABLE [AceMPI].[ast].[MPI_OUTPUTTABLE] 

		INSERT INTO [AceMPI].[ast].[MPI_SourceTable] (
						[ClientSubscriberId]
						, [ClientKey]
						, [MstrMrnKey]
						, [mbrLastName]
						, [mbrFirstName]
						, [mbrMiddleName]
						, [mbrGENDER]
						, [mbrDob]
						, [SrcFileName]
						, [AdiTableName]
						, [ExternalUniqueID]
						, [MbrState]
						, [AdiKey]
						, [LoadDate])
	SELECT		[ClientSubscriberId]
						, 20
						, [MstrMrnKey]
						, [mbrLastName]
						, [mbrFirstName]
						, [mbrMiddleName]
						, [mbrGENDER]
						, [mbrDob]
						, 'BCBS_Membership'
						, 'BCBS_Membership'
						, [AdiKey]
						, 'TX'
						, [mbrStg2_MbrDataUrn]
						, Datadate
			FROM		#Moi a

			-- Select * from [AceMPI].[ast].[MPI_SourceTable] 
			--step 4 Run the update piece of code to update corrected records [ast].[stg_03_Pts_RunMpiForMbrMember]
			IF (SELECT COUNT(*) FROM [AceMPI].[ast].[MPI_SourceTable]) >= 1
			EXECUTE ACEMPI.adw.[Load_MasterJob_MPI]
			
	
			--Step 5 Update those set of records
			UPDATE		ast.MbrStg2_MbrData
			SET			MstrMrnKey = z.MstrMrn
			-- SELECT		z.ClientSubscriberId,a.ClientKey,MstrMrn,a.MstrMrnKey,a.ClientSubscriberId,z.ClientKey --a.ExternalUniqueID,b.ExternalUniqueID,
			FROM		ast.MbrStg2_MbrData a
			JOIN		(	SELECT		ClientSubscriberId, ClientKey,a.ExternalUniqueID,b.ExternalUniqueID bExternalUniqueID
										,MstrMrnKey,MstrMrn
							FROM		AceMPI.ast.MPI_SourceTable a
							JOIN		AceMPI.ast.MPI_OutputTable b
							ON			a.ExternalUniqueID = b.ExternalUniqueID
						)z
			ON			a.ClientSubscriberId = z.ClientSubscriberId
			WHERE		a.ClientKey = 20
			AND			LoadDate =  (	SELECT	MAX(LoadDate) 
										FROM	ast.MbrStg2_MbrData 
										WHERE	ClientKey = 20
									)
									*/