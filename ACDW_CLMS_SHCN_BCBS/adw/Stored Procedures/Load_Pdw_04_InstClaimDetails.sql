
CREATE PROCEDURE [adw].[Load_Pdw_04_InstClaimDetails]
    (@MaxDataDate Date )
AS
  /* PURPOSE: -- 4. de dup claims details     */	
    DECLARE @AuditId INT;    
    DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt = 9	  -- 9: Ast Load, 10: Ast Transform, 11:Ast Validation	
    DECLARE @ClientKey INT	 = 16; -- mssp
    DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();    
    DECLARE @DestName VARCHAR(100) = 'ast.pstcLnsDeDupUrns'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
    TRUNCATE TABLE ast.Claim_04_Detail_Dedup;    
    CREATE TABLE #OutputTbl (srcAdiKey INT NOT NULL, SrcClaimType CHAR(5) NOT NULL , PRIMARY KEY (srcAdiKey, SrcClaimType));	
BEGIN -- Inst Claims Details
--declare @MaxDataDate date = '01/01/2021'
    SELECT @InpCnt = COUNT(cl.InstitutionalClaimKey)      
    FROM adi.Steward_BCBS_InstitutionalClaim ch
	   JOIN ast.Claim_03_Header_LatestEffective lr 
		  ON ch.InstitutionalClaimKey = lr.LatestClaimAdiKey
		  AND lr.LatestClaimAdiKey = lr.ReplacesAdiKey
		  AND lr.SrcClaimType = 'INST'
	   JOIN adi.Steward_BCBS_InstitutionalClaim cl
		  ON ch.ClaimID = cl.ClaimID
		  AND ch.DataDate = cl.DataDate 
		  AND cl.ClaimRecordID = 'LIN'
	WHERE ch.DataDate <= @MaxDataDate and cl.DataDate <= @MaxDataDate
    ;
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_BCBS_InstitutionalClaim'
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
    
    INSERT INTO ast.Claim_04_Detail_Dedup(ClaimDetailSrcAdiKey, ClaimDetailSrcAdiTableName, AdiDataDate, ClaimSeqClaimId, ClaimDetailLineNumber, SrcClaimType)
    OUTPUT Inserted.pstClmDetailKey, inserted.SrcClaimType INTO #OutputTbl(srcAdiKey, SrcClaimType)    
    SELECT cl.InstitutionalClaimKey, @SrcName, cl.DataDate, cl.ClaimID, cl.ClaimLinenumber, lr.SrcClaimType
    FROM adi.Steward_BCBS_InstitutionalClaim ch
	   JOIN ast.Claim_03_Header_LatestEffective  lr 
		  ON ch.InstitutionalClaimKey = lr.LatestClaimAdiKey
		  AND lr.LatestClaimAdiKey = lr.ReplacesAdiKey
		  AND lr.SrcClaimType = 'INST'
	   JOIN adi.Steward_BCBS_InstitutionalClaim cl
    		  ON ch.ClaimID = cl.ClaimID
		  AND ch.DataDate = cl.DataDate 
		  AND cl.ClaimRecordID = 'LIN'	   
	   --ORDER BY cl.ClaimID, cl.ClaimLinenumber
    ;
	-- if this fails it just stops. How should this work, structure from the WLC or AET COM care Op load, acedw do this soon.
	SELECT @OutCnt = COUNT(*) FROM #OutputTbl otb WHERE otb.SrcClaimType = 'INST'; 
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
/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
BEGIN -- PROF Claims Details
    -- declare @MaxDataDate date = '01/01/2021';
    SELECT @InpCnt = COUNT(cl.ProfessionalClaimKey)        
    FROM adi.Steward_BCBS_ProfessionallClaim ch
	   JOIN ast.Claim_03_Header_LatestEffective lr 
		  ON ch.ProfessionalClaimKey = lr.LatestClaimAdiKey
		  AND lr.LatestClaimAdiKey = lr.ReplacesAdiKey
		  AND lr.SrcClaimType = 'PROF'
	   JOIN adi.Steward_BCBS_ProfessionallClaim cl
		  ON ch.ClaimID = cl.ClaimID
		  AND ch.DataDate = cl.DataDate 
		  AND cl.ClaimRecordID = 'LIN'
	WHERE ch.DataDate <= @MaxDataDate and cl.DataDate <= @MaxDataDate
    ;

    set @SrcName = 'adi.Steward_BCBS_ProfessionallClaim';
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
    
    INSERT INTO ast.Claim_04_Detail_Dedup(ClaimDetailSrcAdiKey, ClaimDetailSrcAdiTableName, AdiDataDate, ClaimSeqClaimId, ClaimDetailLineNumber, SrcClaimType)
    OUTPUT Inserted.pstClmDetailKey, inserted.SrcClaimType INTO #OutputTbl(srcAdiKey, SrcClaimType)
    SELECT cl.ProfessionalClaimKey, @SrcName, cl.DataDate, cl.ClaimID, cl.ClaimLinenumber, lr.SrcClaimType
    FROM adi.Steward_BCBS_ProfessionallClaim ch
	   JOIN ast.Claim_03_Header_LatestEffective lr 
		  ON ch.ProfessionalClaimKey = lr.LatestClaimAdiKey
		  AND lr.LatestClaimAdiKey = lr.ReplacesAdiKey
		  AND lr.SrcClaimType = 'PROF'
	   JOIN adi.Steward_BCBS_ProfessionallClaim cl
		  ON ch.ClaimID = cl.ClaimID
		  AND ch.DataDate = cl.DataDate 
		  AND cl.ClaimRecordID = 'LIN'
	WHERE ch.DataDate <= @MaxDataDate and cl.DataDate <= @MaxDataDate
    ;
	-- if this fails it just stops. How should this work, structure from the WLC or AET COM care Op load, acedw do this soon.
	SELECT @OutCnt = COUNT(*) FROM #OutputTbl otb WHERE otb.SrcClaimType = 'PROF'; 
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
/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */
BEGIN -- RX Claims Details
    -- declare @MaxDataDate date = '01/01/2021';
    SELECT @InpCnt = COUNT(ch.RXClaimKey)            
    FROM adi.Steward_BCBS_RXClaim ch
	   JOIN ast.Claim_03_Header_LatestEffective lr 
		  ON ch.RXClaimKey = lr.LatestClaimAdiKey
		  AND lr.LatestClaimAdiKey = lr.ReplacesAdiKey	   
		  AND lr.SrcClaimType = 'RX'
	WHERE ch.DataDate <= @MaxDataDate 
    ;

    set @SrcName = 'adi.Steward_BCBS_RXClaim';
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
    
    INSERT INTO ast.Claim_04_Detail_Dedup(ClaimDetailSrcAdiKey, ClaimDetailSrcAdiTableName, AdiDataDate, ClaimSeqClaimId, ClaimDetailLineNumber, SrcClaimType)
    OUTPUT Inserted.pstClmDetailKey, inserted.SrcClaimType INTO #OutputTbl(srcAdiKey, SrcClaimType)
    SELECT ch.RXClaimKey, @SrcName, ch.DataDate, ch.ClaimID, ch.ClaimLinenumber, lr.SrcClaimType
    FROM adi.Steward_BCBS_RXClaim ch
	   JOIN ast.Claim_03_Header_LatestEffective lr 
		  ON ch.RXClaimKey = lr.LatestClaimAdiKey
		  AND lr.LatestClaimAdiKey = lr.ReplacesAdiKey	   
		  AND lr. SrcClaimType = 'RX'
	WHERE ch.DataDate <= @MaxDataDate 
    ;
	-- if this fails it just stops. How should this work, structure from the WLC or AET COM care Op load, acedw do this soon.
	SELECT @OutCnt = COUNT(*) FROM #OutputTbl otb WHERE otb.SrcClaimType = 'RX'; 
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
/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX */