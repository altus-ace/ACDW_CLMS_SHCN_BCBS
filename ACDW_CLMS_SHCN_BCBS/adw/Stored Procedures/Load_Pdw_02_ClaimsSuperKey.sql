
CREATE PROCEDURE [adw].[Load_Pdw_02_ClaimsSuperKey]( 
    @LatestDataDate DATE = '12/31/2099'
    )
/* PURPOSE:  Create a ClaimNumber. : list of business key fields and the calculated seq_claim_id 
		  We also do filtering for "ace valid cliams" here

		  THIS IS AT THE GRAIN OF THE DETAIL
    */
AS 
    
	DECLARE @lLoadDate Date;
	IF @LatestDataDate = '12/31/2099'
	   BEGIN 
		  SELECT @lLoadDate = Max(s.datadate)
		  FROM adi.Steward_BCBS_InstitutionalClaim s
	   END
    ELSE SET @lLoadDate = @LatestDataDate;
	

	/* prepare logging */
    DECLARE @AuditId INT;    
    DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt = 9	  -- AST load
    DECLARE @ClientKey INT	 = 16; -- mssp
    DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_BCBS_InstitutionalClaim'
    DECLARE @DestName VARCHAR(100) = 'ast.pstCclfClmKeyList'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
    
    CREATE TABLE #OutputTbl (SrcAdiKey  VARCHAR(50) NOT NULL, SrcClaimType CHAR(5) NOT NULL, PRIMARY KEY(SrcAdiKey, SrcClaimType));	
    TRUNCATE TABLE ast.Claim_02_HeaderSuperKey;
BEGIN -- Inst Claims
    SELECT @InpCnt = COUNT(distinct s.ClaimID) 	       
    FROM adi.Steward_BCBS_InstitutionalClaim s
		JOIN ast.Claim_01_Header_Dedup ddH ON s.InstitutionalClaimKey = ddH.SrcAdiKey  -- 375849
    WHERE s.DataDate <= @lLoadDate 
	   and ddH.SrcClaimType = 'INST';

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
    
    /* create list of clmSkeys: these are all related claims grouped on the cms defined relation criteria 
        and bound under varchar(50) key made from concatenation of all the 4 component parts */
    INSERT INTO ast.Claim_02_HeaderSuperKey(
	   clmSKey
	   , PRVDR_OSCAR_NUM  -- facility
	   , BENE_EQTBL_BIC_HICN_NUM
	   , CLM_FROM_DT
	   , CLM_THRU_DT
	   , ClaimTypeCode
	   , LoadDate
	   , SrcClaimType)
    OUTPUT Inserted.clmsKey, inserted.srcClaimType INTO #OutputTbl(SrcAdiKey, SrcClaimType)
    SELECT DISTINCT 
	   --s.BillingProviderNPI + CONVERT(VARCHAR(25),CONVERT(bigint, s.PatientID))+ CONVERT(VARCHAR(10),SvcFrom.dateKey) + CONVERT(VARCHAR(10), SvcTo.dateKey) AS ClmBigKey	   
	   ClaimID AS ClmBigKey  -- use claim id for now, no big key found
	   , s.BillingProviderNPI
	   , s.PatientID
	   , s.ServiceFromDate
	   , s.ServiceToDate
	   , 'UB-INST' ClaimType--Literal from mapping
	   ,s.datadate
	   ,ddh.SrcClaimType
    FROM adi.Steward_BCBS_InstitutionalClaim s
		JOIN ast.Claim_01_Header_Dedup ddH ON s.InstitutionalClaimKey = ddH.SrcAdiKey  -- 375849
		JOIN adw.dimDate SvcFrom ON s.ServiceFromDate = SvcFrom.dDate
		JOIN adw.dimDate SvcTo	ON s.ServiceToDate = SvcTo.dDate
    WHERE s.DataDate <= @lLoadDate 
	   and ddH.SrcClaimType = 'INST';
    
    SELECT @OutCnt = COUNT(*) FROM #OutputTbl otb WHERE otb.srcClaimType = 'INST'; 
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
END
/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
BEGIN -- Prof Claims

    --declare @lLoadDate date = '01/01/2021'
    SELECT @InpCnt = COUNT(distinct s.ClaimID) 	           
    FROM adi.Steward_BCBS_ProfessionallClaim s
		JOIN ast.Claim_01_Header_Dedup ddH ON s.ProfessionalClaimKey = ddH.SrcAdiKey  -- 375849
    WHERE s.DataDate <= @lLoadDate 
	   and ClaimRecordID = 'CLM'
	   and ddH.SrcClaimType = 'PROF';    
    set @SrcName =  'adi.Steward_BCBS_ProfessionallClaim';
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
    
    /* create list of clmSkeys: these are all related claims grouped on the cms defined relation criteria 
        and bound under varchar(50) key made from concatenation of all the 4 component parts */
    INSERT INTO ast.Claim_02_HeaderSuperKey(
	   clmSKey
	   , PRVDR_OSCAR_NUM  -- facility
	   , BENE_EQTBL_BIC_HICN_NUM
	   , CLM_FROM_DT
	   , CLM_THRU_DT
	   , ClaimTypeCode
	   , LoadDate
	   , srcClaimType)
    OUTPUT Inserted.clmsKey, inserted.srcClaimType INTO #OutputTbl(SrcAdiKey, SrcClaimType)
    
    SELECT DISTINCT 
	   --s.BillingProviderNPI + CONVERT(VARCHAR(25),CONVERT(bigint, s.PatientID))+ CONVERT(VARCHAR(10),SvcFrom.dateKey) + CONVERT(VARCHAR(10), SvcTo.dateKey) AS ClmBigKey	   
	   s.ClaimID AS ClmBigKey  -- use claim id for now, no big key found
	   , s.BillingProviderNPI
	   , s.PatientID
	   , cl.MinSrvDate
	   , cl.MaxSrvDate
	   , 'PROF' ClaimType--Literal from mapping
	   ,s.datadate
	   , ddh.SrcClaimType
    FROM adi.Steward_BCBS_ProfessionallClaim s
	   JOIN ast.Claim_01_Header_Dedup ddH ON s.ProfessionalClaimKey = ddH.SrcAdiKey  -- 375849		
	   JOIN (SELECT cl.claimid, cl.datadate, min(cl.llDateService) MinSrvDate, Max(cl.LLDateService) MaxSrvDate
			 FROM adi.Steward_BCBS_ProfessionallClaim Cl
			 WHERE cl.ClaimRecordID = 'LIN'
			 GROUP BY cl.ClaimID, cl.DataDate) cl 
			 ON s.ClaimID = cl.ClaimID 
			 AND s.DataDate = cl.DataDate
    WHERE s.DataDate <= @lLoadDate 
	   AND s.ClaimRecordID = 'CLM'
	   AND ddH.SrcClaimType = 'PROF';	   
    
    SELECT @OutCnt = COUNT(*) FROM #OutputTbl otb WHERE otb.srcClaimType = 'PROF'; 
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
END;
/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
BEGIN -- rx Claims

    --declare @lLoadDate date = '01/01/2021'
    SELECT @InpCnt = COUNT(distinct s.ClaimID) 	              
    FROM adi.Steward_BCBS_RXClaim s
		JOIN ast.Claim_01_Header_Dedup ddH ON s.RXClaimKey = ddH.SrcAdiKey  -- 375849
    WHERE s.DataDate <= @lLoadDate 	   
	   and ddH.SrcClaimType = 'RX';    

    set @SrcName =  'adi.Steward_BCBS_RXClaim';
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
    
    /* create list of clmSkeys: these are all related claims grouped on the cms defined relation criteria 
        and bound under varchar(50) key made from concatenation of all the 4 component parts */
    INSERT INTO ast.Claim_02_HeaderSuperKey(
	   clmSKey
	   , PRVDR_OSCAR_NUM  -- facility
	   , BENE_EQTBL_BIC_HICN_NUM
	   , CLM_FROM_DT
	   , CLM_THRU_DT
	   , ClaimTypeCode
	   , LoadDate
	   , srcClaimType)
    OUTPUT Inserted.clmsKey, inserted.srcClaimType INTO #OutputTbl(SrcAdiKey, SrcClaimType)
    
    SELECT DISTINCT 
	   --s.BillingProviderNPI + CONVERT(VARCHAR(25),CONVERT(bigint, s.PatientID))+ CONVERT(VARCHAR(10),SvcFrom.dateKey) + CONVERT(VARCHAR(10), SvcTo.dateKey) AS ClmBigKey	   
	   s.ClaimID AS ClmBigKey  -- use claim id for now, no big key found
	   , s.ProviderNPI	   
	   , s.PatientID
	   , s.ServiceDATE
	   , s.ServiceDATE
	   , 'PROF' ClaimType--Literal from mapping
	   ,s.datadate
	   , ddh.SrcClaimType
     FROM adi.Steward_BCBS_RXClaim s
		JOIN ast.Claim_01_Header_Dedup ddH ON s.RXClaimKey = ddH.SrcAdiKey  -- 375849
    WHERE s.DataDate <= @lLoadDate 
	   --and ClaimRecordID = 'CLM'
	   and ddH.SrcClaimType = 'RX';    
    
    SELECT @OutCnt = COUNT(*) FROM #OutputTbl otb WHERE otb.srcClaimType = 'RX'; 
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
END;


