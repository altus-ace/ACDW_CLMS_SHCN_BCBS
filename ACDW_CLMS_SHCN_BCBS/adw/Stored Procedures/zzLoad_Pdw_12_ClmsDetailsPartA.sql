Create PROCEDURE [adw].[zzLoad_Pdw_12_ClmsDetailsPartA]
AS
	/* prepare logging */
    DECLARE @AuditId INT;    
    DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt = 8	  -- AST load
    DECLARE @ClientKey INT	 = 16; -- mssp
    DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_MSSPPartAClaimLineItem'
    DECLARE @DestName VARCHAR(100) = 'adw.Claims_Details'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(*) 
    FROM adi.Steward_MSSPPartAClaimLineItem cl
		JOIN ast.ClaimHeader_02_ClaimSuperKey ck 
		  ON ck.PRVDR_OSCAR_NUM = cl.CMSCertificationNBR
		  AND ck.BENE_EQTBL_BIC_HICN_NUM	= cl.MedicareBeneficiaryID
            AND ck.CLM_FROM_DT				= cl.ClaimStartDTS
            AND ck.CLM_THRU_DT				= cl.ClaimEndDTS		  
		JOIN ast.ClaimHeader_03_LatestEffectiveClaimsHeader lr 
		  ON ck.clmSKey = lr.clmSKey
		  AND lr.LatestClaimAdiKey = lr.ReplacesAdiKey
        JOIN adi.Steward_MSSPPartAClaim ch 
		  ON lr.LatestClaimAdiKey = ch.MSSPPartAClaimKey;

	EXEC amd.sp_AceEtlAudit_Open 
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
	CREATE TABLE #OutputTbl (ID INT NOT NULL PRIMARY KEY);	

    INSERT INTO adw.Claims_Details
		  (SEQ_CLAIM_ID,
			CLAIM_NUMBER,
			LINE_NUMBER,
			SUB_LINE_CODE,
			[SUBSCRIBER_ID],
			DETAIL_SVC_DATE,
			SVC_TO_DATE,
			REVENUE_CODE,
			QUANTITY,
			PAID_AMT,
			BILLED_AMT,
			PROCEDURE_CODE,
			MODIFIER_CODE_1,
			MODIFIER_CODE_2,
			MODIFIER_CODE_3,
			MODIFIER_CODE_4,
			PLACE_OF_SVC_CODE1,
			PLACE_OF_SVC_CODE2,
			PLACE_OF_SVC_CODE3,
			NDC_CODE,
			RX_GENERIC_BRAND_IND,
			RX_SUPPLY_DAYS,
			RX_DISPENSING_FEE_AMT,
			RX_INGREDIENT_AMT,
			RX_FORMULARY_IND,
			RX_DATE_PRESCRIPTION_WRITTEN,
			RX_DATE_PRESCRIPTION_FILLED,
			PRESCRIBING_PROV_TYPE_ID,	
			PRESCRIBING_PROV_ID,
			BRAND_NAME,
			DRUG_STRENGTH_DESC,
			GPI,
			GPI_DESC,
			CONTROLLED_DRUG_IND,
			COMPOUND_CODE,
			SrcAdiTableName,
			SrcAdiKey,
			LoadDate)		  
		OUTPUT Inserted.ClaimsDetailsKey INTO #OutputTbl(ID)
		SELECT  cl.ClaimID						AS seq_Claim_ID				--SEQ_CLAIM_ID,					
			,ck.clmSKey						AS claim_number 				--CLAIM_NUMBER,					
			,cl.LineNBR						AS line_Number 				--LINE_NUMBER,					
			,ch.AdjustmentTypeCD				AS SUB_LINE_CODE 				--SUB_LINE_CODE,				
			,ch.MedicareBeneficiaryID			AS Subscriber_ID				--[SUBSCRIBER_ID],				
			,ISNULL(cl.StartDTS, '1/1/1900')		AS DETAIL_SVC_DATE 				--DETAIL_SVC_DATE,				
			,ISNULL(cl.EndDTS, '1/1/1900')		AS SVC_TO_DATE 				--SVC_TO_DATE,						
			,cl.RevenueCenterCD					AS REVENUE_CODE 			  	--REVENUE_CODE,					
			,cl.[AllowedUnitCNT]  				AS QUANTITY					--QUANTITY,							
			,cl.PaymentAMT						AS Paid_amt      				--PAID_AMT,									
			, ''								AS BILLED_AMT				  	--BILLED_AMT,				
			,cl.HCPCS							AS PROCEDURE_CODE				--PROCEDURE_CODE,				
			,cl.HCPCSModifier01CD				AS MODIFIER_CODE_1 				--MODIFIER_CODE_1,				
			,cl.HCPCSModifier02CD				AS MODIFIER_CODE_2 				--MODIFIER_CODE_2,				
		  	,cl.HCPCSModifier03CD				AS MODIFIER_CODE_3 				--MODIFIER_CODE_3,				
			,cl.HCPCSModifier04CD				AS MODIFIER_CODE_4 				--MODIFIER_CODE_4,							
			,''								AS PLACE_OF_SVC_CODE1			--PLACE_OF_SVC_CODE1,																			
			,''								AS PLACE_OF_SVC_CODE2 			--PLACE_OF_SVC_CODE2,				
			,'' 								AS PLACE_OF_SVC_CODE3			--PLACE_OF_SVC_CODE3,			
			,''								AS NDC_CODE					--NDC_CODE,				
			,''								AS RX_GENERIC_BRAND_IND			--RX_GENERIC_BRAND_IND,
			,''								AS RX_SUPPLY_DAYS				--RX_SUPPLY_DAYS,			
			,''								AS RX_DISPENSING_FEE_AMT			 --RX_DISPENSING_FEE_AMT,																			
			,''								AS RX_INGREDIENT_AMT			--RX_INGREDIENT_AMT,			
			,''								AS RX_FORMULARY_IND				--RX_FORMULARY_IND,				
			,''								AS RX_DATE_PRESCRIPTION_WRITTEN    --RX_DATE_PRESCRIPTION_WRITTEN,	
			,''								AS RX_DATE_PRESCRIPTION_FILLED	--RX_DATE_PRESCRIPTION_FILLED
			,''								AS PRESCRIBING_PROV_TYPE_ID		--PRESCRIBING_PROV_TYPE_ID	   
			,''								AS PRESCRIBING_PROV_ID			--PRESCRIBING_PROV_ID			   
			,''								AS BRAND_NAME					--BRAND_NAME,					
			,''								AS DRUG_STRENGTH_DESC			--DRUG_STRENGTH_DESC,			
			,''								AS GPI							--GPI,							
			,''								AS GPI_DESC						--GPI_DESC,						
			,''								AS CONTROLLED_DRUG_IND			--CONTROLLED_DRUG_IND,			
			,''								AS COMPOUND_CODE				--COMPOUND_CODE,				
			,'Steward_MSSPPartAClaimLineItem'		AS SrcAdiTableName
			,cl.MSSPPartAClaimLineItemKey			AS SrcAdiKey					--SrcAdiKey,					
			,GetDate()						AS LoadDate						--LoadDate				
			  -- implicit CreatedDate, CreatedBy, LastUpdatedDate, LastUpdatedBy
       FROM adi.Steward_MSSPPartAClaimLineItem cl
		  JOIN ast.pstcLnsDeDupUrns Details ON cl.MSSPPartAClaimLineItemKey = Details.URN
		  JOIN ast.ClaimHeader_02_ClaimSuperKey ck 
			 ON ck.PRVDR_OSCAR_NUM = cl.CMSCertificationNBR
			 AND ck.BENE_EQTBL_BIC_HICN_NUM	= cl.MedicareBeneficiaryID
			 AND ck.CLM_FROM_DT				= cl.ClaimStartDTS
			 AND ck.CLM_THRU_DT				= cl.ClaimEndDTS		  
		  JOIN ast.ClaimHeader_03_LatestEffectiveClaimsHeader lr 
			 ON ck.clmSKey = lr.clmSKey
			 AND lr.LatestClaimAdiKey = lr.ReplacesAdiKey
		  JOIN adi.Steward_MSSPPartAClaim ch 
			 ON lr.LatestClaimAdiKey = ch.MSSPPartAClaimKey
       ORDER BY cl.ClaimID,
                cl.LineNBR;
	-- if this fails it just stops. How should this work, structure from the WLC or AET COM care Op load, acedw do this soon.
	SELECT @OutCnt = COUNT(*) FROM #OutputTbl; 
	SET @ActionStart = GETDATE();    
	SET @JobStatus =2  -- complete
    
	EXEC amd.sp_AceEtlAudit_Close 
        @AuditId = @AuditID
        , @ActionStopTime = @ActionStart
        , @SourceCount = @InpCnt		  
        , @DestinationCount = @OutCnt
        , @ErrorCount = @ErrCnt
        , @JobStatus = @JobStatus
	   ;
