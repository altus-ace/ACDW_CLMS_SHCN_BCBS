CREATE PROCEDURE [adw].[Load_Pdw_32_ClmsDetailsPartDPharma]
AS 
    /* prepare logging */
    DECLARE @AuditId INT;    
    DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt = 8	  -- ADW load
    DECLARE @ClientKey INT	 = 16; -- mssp
    DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_BCBS_RXClaim'
    DECLARE @DestName VARCHAR(100) = 'adw.Claims_Details'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(cl.RXClaimKey)    
    FROM ast.Claim_04_Detail_Dedup ast
	   JOIN adi.Steward_BCBS_RXClaim cl
		  ON ast.ClaimDetailSrcAdiKey = cl.RXClaimKey
		  and ast.SrcClaimType = 'RX'


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
               (CLAIM_NUMBER                
			,SUBSCRIBER_ID				
			,SEQ_CLAIM_ID                
			,LINE_NUMBER                 
			,SUB_LINE_CODE               
			,DETAIL_SVC_DATE             
			,SVC_TO_DATE                 
			,PROCEDURE_CODE              
			,MODIFIER_CODE_1             
			,MODIFIER_CODE_2             
			,MODIFIER_CODE_3             
			,MODIFIER_CODE_4             
			,REVENUE_CODE                
			,PLACE_OF_SVC_CODE1          
			,PLACE_OF_SVC_CODE2          
			,PLACE_OF_SVC_CODE3          
			,QUANTITY                    
			,BILLED_AMT                  
			,PAID_AMT                    
			,NDC_CODE                    
			,RX_GENERIC_BRAND_IND        
			,RX_SUPPLY_DAYS              
			,RX_DISPENSING_FEE_AMT       
			,RX_INGREDIENT_AMT           
			,RX_FORMULARY_IND            
			,RX_DATE_PRESCRIPTION_WRITTEN
			,RX_DATE_PRESCRIPTION_FILLED
			,PRESCRIBING_PROV_TYPE_ID	   
			,PRESCRIBING_PROV_ID			
			,BRAND_NAME                  
			,DRUG_STRENGTH_DESC          
			,GPI                         
			,GPI_DESC                    
			,CONTROLLED_DRUG_IND         
			,COMPOUND_CODE           
			,srcAdiTableName
			,SrcAdiKey                   
			, LoadDate                    				
				)
    OUTPUT Inserted.ClaimsDetailsKey INTO #OutputTbl(ID)	
    SELECT           
		 cl.ClaimID						  AS CLAIM_NUMBER				   --CLAIM_NUMBER                CLAIM_NUMBER                
		,cl.PatientID		  				  AS SUBSCRIBER_ID				   --SUBSCRIBER_ID				SUBSCRIBER_ID				
		,cl.ClaimID						  AS SEQ_CLAIM_ID				   --SEQ_CLAIM_ID                SEQ_CLAIM_ID                
		,cl.ClaimLineNumber	 				  AS LINE_NUMBER				   --LINE_NUMBER                 LINE_NUMBER                 
		,''					 			  AS SUB_LINE_CODE				   --SUB_LINE_CODE               SUB_LINE_CODE               
		,cl.ServiceDATE			    		  AS DETAIL_SVC_DATE			   --DETAIL_SVC_DATE             DETAIL_SVC_DATE             
		,cl.ServiceDATE					  AS SVC_TO_DATE				   --SVC_TO_DATE                 SVC_TO_DATE                 
		,''								  AS PROCEDURE_CODE				   --PROCEDURE_CODE              PROCEDURE_CODE              
		,''								  AS MODIFIER_CODE_1			   --MODIFIER_CODE_1             MODIFIER_CODE_1             
		,''								  AS MODIFIER_CODE_2			   --MODIFIER_CODE_2             MODIFIER_CODE_2             
		,''								  AS MODIFIER_CODE_3			   --MODIFIER_CODE_3             MODIFIER_CODE_3             
		,''								  AS MODIFIER_CODE_4			   --MODIFIER_CODE_4             MODIFIER_CODE_4             
		,''								  AS REVENUE_CODE				   --REVENUE_CODE                REVENUE_CODE                
		,''								  AS PLACE_OF_SVC_CODE1			   --PLACE_OF_SVC_CODE1          PLACE_OF_SVC_CODE1          
		,''								  AS PLACE_OF_SVC_CODE2			   --PLACE_OF_SVC_CODE2          PLACE_OF_SVC_CODE2          
		,''								  AS PLACE_OF_SVC_CODE3			   --PLACE_OF_SVC_CODE3          PLACE_OF_SVC_CODE3          
		,NULL		   					  AS QUANTITY			   --QUANTITY                    	   --QUANTITY                    GK I DON't think this is right
		,''								  AS BILLED_AMT				   --BILLED_AMT                  BILLED_AMT                  
		,null	    						  AS PAID_AMT					   --PAID_AMT                    PAID_AMT                    
		,cl.NDCCode						  AS NDC_CODE					   --NDC_CODE                    NDC_CODE                    
		,cl.BrandGenericIndicator			  AS RX_GENERIC_BRAND_IND		   --RX_GENERIC_BRAND_IND        RX_GENERIC_BRAND_IND        
		,cl.DaysSupply	   					  AS RX_SUPPLY_DAYS				   --RX_SUPPLY_DAYS              RX_SUPPLY_DAYS              
		,''					 			  AS RX_DISPENSING_FEE_AMT		   --RX_DISPENSING_FEE_AMT       RX_DISPENSING_FEE_AMT       
		,''								  AS RX_INGREDIENT_AMT			   --RX_INGREDIENT_AMT           RX_INGREDIENT_AMT           
		,''								  AS RX_FORMULARY_IND			   --RX_FORMULARY_IND            RX_FORMULARY_IND            
		,''								  AS RX_DATE_PRESCRIPTION_WRITTEN	   --RX_DATE_PRESCRIPTION_WRITTENRX_DATE_PRESCRIPTION_WRITTEN
		,cl.FillDate				    		  AS RX_DATE_PRESCRIPTION_FILLED	   --RX_DATE_PRESCRIPTION_FILLEDRX_DATE_PRESCRIPTION_FILLED
		,''								  AS PRESCRIBING_PROV_TYPE_ID		   --PRESCRIBING_PROV_TYPE_ID	   PRESCRIBING_PROV_TYPE_ID	   
		,cl.ProviderNPI					  AS PRESCRIBING_PROV_ID			   --PRESCRIBING_PROV_ID			PRESCRIBING_PROV_ID			   
		,''								  AS BRAND_NAME				   --BRAND_NAME                  BRAND_NAME                  
		,''								  AS DRUG_STRENGTH_DESC			   --DRUG_STRENGTH_DESC          DRUG_STRENGTH_DESC          
		,''								  AS GPI						   --GPI                         GPI                         
		,''								  AS GPI_DESC					   --GPI_DESC                    GPI_DESC                    
		,''								  AS CONTROLLED_DRUG_IND			   --CONTROLLED_DRUG_IND         CONTROLLED_DRUG_IND         
		,''								  AS COMPOUND_CODE				   --COMPOUND_CODE           COMPOUND_CODE               
		,'Steward_BCBS_RXClaim'				  AS SrcAdiTableName			   --srcAdiTableNameSrcAdiTableName
		, cl.RXClaimKey					  AS SrcAdiKey					   --SrcAdiKey                      --SrcAdiKey                   	
		, GetDate()						  AS LoadDate					   --LoadDate                    				LoadDate	 
    FROM ast.Claim_04_Detail_Dedup ast
	   JOIN adi.Steward_BCBS_RXClaim cl
		  ON ast.ClaimDetailSrcAdiKey = cl.RXClaimKey
		  and ast.SrcClaimType = 'RX'
    ;

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


	-- Use header to update the place of service code 1 & 2
