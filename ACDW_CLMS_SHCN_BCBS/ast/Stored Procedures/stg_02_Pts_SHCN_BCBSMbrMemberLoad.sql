


CREATE PROCEDURE [ast].[stg_02_Pts_SHCN_BCBSMbrMemberLoad] --  [ast].[stg_02_Pts_SHCN_BCBSMbrMemberLoad]'2020-12-20','2020-12-20','2020-12-01'
							(@MbrShipDataDate Date,
							@MbrCrsWkDataDate Date,
							@EffectiveDate DATE)

AS      ------- PLEASE REMEMBER TO ENABLE THE ROWSTATUS COLUMN

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
						DECLARE @DestName VARCHAR(100) = 'ast.[MbrStg2_MbrData]'
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
			/* Doing a join on both Membership tables to produce a member set for the month
			 if a member does not exist in the Members Cross walk file, then he is filtered off */
		IF OBJECT_ID('tempdb..#Bcbs') IS NOT NULL DROP TABLE #Bcbs  --- DECLARE @MbrCrsWkDataDate DATE = '2021-03-19' DECLARE @MbrShipDataDate DATE = '2021-03-19'
		SELECT			* 
		INTO			#Bcbs 
		FROM			(
		SELECT			DISTINCT a.PatientID,[adi].[udf_ConvertToCamelCase](a.[MemberFirstName]) [MemberFirstName]
						,CASE WHEN [MemberMiddleName] <> '9' THEN [MemberMiddleName]
							ELSE ''
							END [MemberMiddleName]
						,[adi].[udf_ConvertToCamelCase](a.[MemberLastName]) [MemberLastName]
						,a.[MemberBirthDate]
						,a.[MemberGender]
						, a.[SubscriberID]
						,a.[MemberLast4DigitsSSN]
						, b.MemberOriginalEffectiveDate
						, a.MemberEffectiveDate
						, '2099-12-31' MemberTerminateDate   --- Recent Changes
						,(	SELECT	DISTINCT SourceValue 
							FROM	[adi].[Steward_BCBS_MemberCrosswalk] a
							JOIN	ACECAREDW.lst.lstPlanMapping b
							ON		ProgramIndicator = SourceValue
							WHERE	Indicator834 = 'Y'
							AND		ClientKey = 20) AS [ProgramIndicator] 
						,CASE WHEN [AttributedPrimaryCareProviderNPI] <> ''  THEN [AttributedPrimaryCareProviderNPI]
						    ELSE AttributedSpecialistNPI
						    END [AttributedPrimaryCareProviderNPI]
						,a.[AttributedPrimaryCareProviderFirstName],a.[AttributedPrimaryCareProviderLastName]
						,[adi].[udf_ConvertToCamelCase](a.[MemberHomeAddress1]) [MemberHomeAddress1]
						,CASE WHEN [adi].[udf_ConvertToCamelCase]([MemberHomeAddress2]) = 'MY ADDRESS 2' THEN ''
							ELSE [adi].[udf_ConvertToCamelCase]([MemberHomeAddress2])
							END [MemberHomeAddress2]
						,[adi].[udf_ConvertToCamelCase](a.MemberCity)MemberCity
						, a.MemberState, a.MemberZip
						,[adi].[udf_ConvertToCamelCase](a.MemberCounty)MemberCounty
						,CASE WHEN [MemberPrimaryPhone] IN ('9999999998','8888888888') THEN ''
							ELSE [MemberPrimaryPhone]
							END AS [MemberPrimaryPhone]
						,CASE WHEN MemberSecondaryPhone IN ('9999999998','8888888888') THEN ''
							ELSE MemberSecondaryPhone
							END AS MemberSecondaryPhone
						, CASE  MemberAttributedStatus 
							WHEN  MemberAttributedStatus THEN MemberAttributedStatus		
							ELSE 'Unknown'
							END  MemberAttributedStatus
						,b.RiskScore
						,b.OpportunityScore
						,a.MembershipKey
						,a.SrcFileName
						,a.DataDate
						,b.Indicator834
						,'2021-01-01'    AS prvClientEffective   ---- To extract from provider roster in future
						,'2099-12-31'		AS prvClientExpiration
		FROM			[adi].[Steward_BCBS_Membership]	a
		JOIN			(	SELECT		*
							FROM		[adi].[Steward_BCBS_MemberCrosswalk] 
							WHERE		Indicator834 = 'Y'
							AND			DataDate = @MbrCrsWkDataDate
							--AND			Status = 0
						) b
		ON				a.PatientID = b.PatientID
		AND				a.SubscriberID = b.SubscriberID
		WHERE			a.DataDate =   @MbrShipDataDate -- '2021-01-21' --
		--AND				a.Status = 0
						)drv
		WHERE			MemberAttributedStatus IN ('ADD','REINSTATE','CONTINUE')
		

		/*Retrieving Members PCP from the list PCP - If any member does not have a PCP assigned, then he is filtered off
		--Derive members chapter from the lst pcp
		*/
		UPDATE			#Bcbs
		SET				ProgramIndicator = PCP_POD
		-- SELECT			DISTINCT [AttributedPrimaryCareProviderNPI], PCP_NPI,PCP_POD,ProgramIndicator
		FROM			#Bcbs a
		JOIN			lst.List_PCP b
		ON				AttributedPrimaryCareProviderNPI = PCP_NPI

		
		--Derive Members chapters from LstPlanMapping
		  -- select * from #Bcbs  where ProgramIndicator = 'COMM_Market is unknown'
		  --Derving Members program by using the PCP county
		UPDATE			#Bcbs
		SET				ProgramIndicator = 
						(CASE  WHEN ProgramIndicator LIKE '%East%' THEN (SELECT TargetValue FROM AceMasterData.lst.lstPlanMapping WHERE ClientKey = 20 
																	AND TargetValue = 'BCBSTX_COMM_East and Central' AND TargetSystem = 'ACDW')
							   WHEN ProgramIndicator LIKE '%Austin%' THEN (SELECT TargetValue FROM AceMasterData.lst.lstPlanMapping WHERE ClientKey = 20 
																	AND TargetValue = 'BCBSTX_COMM_Austin' AND TargetSystem = 'ACDW')
							   WHEN ProgramIndicator LIKE '%West' THEN (SELECT TargetValue FROM AceMasterData.lst.lstPlanMapping WHERE ClientKey = 20 
																	AND TargetValue = 'BCBSTX_COMM_West' AND TargetSystem = 'ACDW')
							   WHEN ProgramIndicator LIKE '%San Antonio%' THEN (SELECT TargetValue FROM AceMasterData.lst.lstPlanMapping WHERE ClientKey = 20 
																	AND TargetValue = 'BCBSTX_COMM_San Antonio' AND TargetSystem = 'ACDW')
							   WHEN ProgramIndicator LIKE '%South%' THEN (SELECT TargetValue FROM AceMasterData.lst.lstPlanMapping WHERE ClientKey = 20 
																	AND TargetValue = 'BCBSTX_COMM_South' AND TargetSystem = 'ACDW')
							   WHEN ProgramIndicator LIKE '%Dallas%' THEN (SELECT TargetValue FROM AceMasterData.lst.lstPlanMapping WHERE ClientKey = 20 
																	AND TargetValue = 'BCBSTX_COMM_Dallas and Fort Worth' AND TargetSystem = 'ACDW')
							   WHEN ProgramIndicator LIKE '%Houston%' THEN (SELECT TargetValue FROM AceMasterData.lst.lstPlanMapping WHERE ClientKey = 20 
																	AND TargetValue = 'BCBSTX_COMM_Houston' AND TargetSystem = 'ACDW')
						ELSE 'COMM_Market is unknown'
						END )
		

END
		CREATE TABLE		#OutputTbl (ID INT NOT NULL );
BEGIN		
		--Load Members Demos
		INSERT INTO		[ast].[MbrStg2_MbrData]	-- select * from [ast].[MbrStg2_MbrData]				
						(	[ClientSubscriberId] 
						,[ClientKey]																				
						,[MstrMrnKey]		
						,[mbrLastName]
						,[mbrMiddleName]
						,[mbrFirstName]
						,[mbrGENDER]
						,[mbrDob]
						,[HICN]
						,[MBI]
						,[mbrPrimaryLanguage]
						,[prvNPI]
						,[prvTIN]
						,[prvAutoAssign]
						,[plnProductPlan]
						,[plnProductSubPlan]
						,[plnProductSubPlanName]
						,[plnMbrIsDualCoverage]
						,[Member_Dual_Eligible_Flag] 
						,[plnClientPlanEffective]
						,[SrcFileName]
						,[AdiTableName]
						,[AdiKey]
						,[stgRowStatus]
						,[LoadDate]
						,[DataDate]
						,[plnClientPlanEndDate]
						,[MbrState] 
						--,[MemberOriginalEffectiveDate]
						,[MbrCity]
						,[SubscriberID_SHCN_BCBS]
						,[Indicator834]
						,[RiskScore]
						,[OpportunityScore]
						,[MemberStatus]
						,[MemberOriginalEffectiveDate]
						,[ProviderChapter]
						,[prvClientEffective]
						,[prvClientExpiration]
						 )-- Declare @datadate date = '2020-09-06'
		OUTPUT			inserted.mbrStg2_MbrDataUrn INTO #OutputTbl(ID)
		SELECT			DISTINCT	    --1 Member / pcp select 
						PatientID								AS [ClientSubscriberId]
						,(SELECT ClientKey FROM [AceMasterData].[lst].[List_Client] WHERE ClientShortName = 'SHCN_BCBS') AS [ClientKey]
						,000									AS [MstrMrnKey]
						,src.[MemberLastName]					AS [mbrLastName]
						,src.MemberMiddleName					AS [mbrMiddleName]
						,src.MemberFirstName					AS [mbrFirstName]
						,src.MemberGender						AS [mbrGENDER]
						,src.MemberBirthDate					AS [mbrDob]
						,''										AS [HICN]
						,''										AS [MBI]
						,''										AS [mbrPrimaryLanguage]
						,src.AttributedPrimaryCareProviderNPI	AS [prvNPI]
						,''										AS [prvTIN]
						,''										AS [prvAutoAssign]
						,src.ProgramIndicator					AS [plnProductPlan] ---ProgramIndicator comes in here
						,src.ProgramIndicator					AS [plnProductSubPlan] --ProgramIndicator comes in here
						,src.ProgramIndicator					AS [plnProductSubPlanName] --ProgramIndicator comes in here
						,0										AS [plnMbrIsDualCoverage] 
						,''										AS [Member_Dual_Eligible_Flag]
						,@EffectiveDate							AS [plnClientPlanEffective] --- Add Back @EffectiveDate
						,src.[SrcFileName]						AS [SrcFileName]
						,'[adi].[Steward_BCBS_Membership]'		AS [AdiTableName]
						,src.MembershipKey						AS [AdiKey]
						,'Valid'								AS [stgRowStatus]
						,src.DataDate							AS LoadDate
						,src.DataDate							AS [DataDate]
						,'2099-12-31'							AS [plnClientPlanEndDate]
						,src.MemberState						AS [MbrState]
						,src.MemberCity							AS [MbrCity]
						,src.SubscriberID						AS [SubscriberID_SHCN_BCBS]
						,src.Indicator834						AS [Indicator834]
						,src.RiskScore							AS [RiskScore]
						,src.OpportunityScore					AS [OpportunityScore]
						,src.MemberAttributedStatus				AS [MemberStatus]
						,src.MemberOriginalEffectiveDate		AS [MemberOriginalEffectiveDate]
						,vw.[PCP_POD]							AS [ProviderChapter]
						,vw.EffectiveDate						AS [prvClientEffective]
						,vw.ExpirationDate						AS [prvClientExpiration]
		FROM			#Bcbs src
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
							) vw 
		ON				src.AttributedPrimaryCareProviderNPI = vw.PCP_NPI 
		ORDER BY		PatientID

END

BEGIN
				--Load Members Email, addresses and Phone

		INSERT INTO		[ast].[MbrStg2_PhoneAddEmail]
						(							 
						[ClientMemberKey]
						,[SrcFileName]
						,[LoadType]
						,[LoadDate]
						,[DataDate]
						,[AdiTableName]
						,[AdiKey]
						,[lstPhoneTypeKey]
						,[PhoneNumber]
						,[PhoneCarrierType]
						,[PhoneIsPrimary]
						,[lstAddressTypeKey] --RETRIEVE VALUES FROM SELECT * FROM lst.lstAddressType
						,[AddAddress1]
						,[AddAddress2]
						,[AddCity]
						,[AddState]
						,[AddZip]
						,[AddCounty]
						,[lstEmailTypeKey]
						,[EmailAddress]
						,[EmailIsPrimary]
						,[stgRowStatus]
						,[ClientKey]
						)--  DECLARE @DATE DATE = GETDATE()
		SELECT			DISTINCT																
						PatientID								AS [ClientMemberKey]
						,src.SrcFileName						AS [SrcFileName]
						,'P'									AS [LoadType]
						,src.DataDate							AS [LoadDate]
						,src.DataDate							AS [DataDate]
						,'[adi].[Steward_BCBS_Membership]'		AS [AdiTableName]
						,src.MembershipKey						AS [AdiKey]	
						,1										AS [lstPhoneTypeKey]
						,src.MemberPrimaryPhone					AS [PhoneNumber]
						,0										AS [PhoneCarrierType]
						,0										AS [PhoneIsPrimary]
						,1										AS [lstAddressTypeKey]
						,src.MemberHomeAddress1					AS [AddAddress1]
						,src.MemberHomeAddress2					AS [AddAddress2]
						,src.MemberCity							AS [AddCity]
						,src.MemberState						AS [AddState]
						,src.MemberZip							AS [AddZip]
						,src.MemberCounty						AS [AddCounty]
						,0										AS [lstEmailTypeKey]
						,''										AS [EmailAddress]
						,0										AS [EmailIsPrimary]
						,'Valid'								AS [stgRowStatus]
						,(SELECT ClientKey FROM [lst].[List_Client] WHERE ClientShortName = 'SHCN_BCBS') AS [ClientKey]								
		FROM			#Bcbs src
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
							) vw 
		ON				src.AttributedPrimaryCareProviderNPI = vw.PCP_NPI 
		ORDER BY		PatientID

		BEGIN
					--Update TINs
		UPDATE			ast.MbrStg2_MbrData
		SET				prvTIN = PCP_PRACTICE_TIN  --  SELECT  prvTIN,PCP_PRACTICE_TIN,prvNPI,PCP_NPI
		FROM			ast.MbrStg2_MbrData a
		JOIN			lst.List_PCP b
		ON				a.prvNPI = b.PCP_NPI
		
		END

		DROP TABLE #Bcbs
END
	

BEGIN	----Update MembersCell and HomePhone in staging
		EXECUTE ast.Pts_UpdateMembersCellAndHomePhone;
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
select * from [ast].[MbrStg2_PhoneAddEmail] 
where ClientKey = 20 and loaddate = (select MAX(LoadDate) from [ast].[MbrStg2_PhoneAddEmail] where ClientKey = 20) 

select * from [ast].[MbrStg2_MbrData]	
where ClientKey = 20 and loaddate = (select MAX(LoadDate) from [ast].[MbrStg2_MbrData] where ClientKey = 20)
*/

