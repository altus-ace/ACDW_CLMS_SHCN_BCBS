
CREATE PROCEDURE [adw].[Load_Pdw_01_ClaimHeader_01_Deduplicate]
    ( @LatestDataDate DATE = '12/31/2099')
AS
	-- Claims Dedup: Use this table to remove any duplicated input rows, they will be duplicated and versioned.. 
	-- Ensure records loaded tallies with cclf1 records (validation)
    DECLARE @DataDate DATE;
     
    DECLARE @AuditId INT;    
    DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt = 9	  -- AST load
    DECLARE @ClientKey INT	 = 16; -- mssp
    DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_BCBS_ProfessionallClaim'
    DECLARE @DestName VARCHAR(100) = 'ast.PstDeDupClmsHdr'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    /* load INST CLAIMS */
BEGIN -- Inst Claims
    IF @LatestDataDate = '12/31/2099'
	   BEGIN
	   SELECT @DataDate = MAX(ch.DataDate)
		  FROM adi.Steward_BCBS_InstitutionalClaim ch
	   END
	   ELSE SET @DataDate = @LatestDataDate;   

    SELECT @InpCnt = COUNT(*) 
    FROM (SELECT ch.InstitutionalClaimKey ClaimSKey, ch.ClaimID, ch.OriginalFileName, DataDate, 
	           ROW_NUMBER() OVER(PARTITION BY ch.ClaimID ORDER BY ch.DataDate DESC, ch.OriginalFileName ASC) arn
		  FROM adi.Steward_BCBS_InstitutionalClaim ch
		  WHERE ch.ClaimRecordID = 'CLM'
			 AND  ch.DataDate <= @DataDate
	    ) s
	WHERE s.arn = 1
	      AND DataDate <= @DataDate; -- count all rows 

	
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
	
	CREATE TABLE #OutputTbl (
		  srcAdiKey INT NOT NULL
		  , SrcClaimType CHAR(5)
		  ,PRIMARY KEY CLUSTERED 
		   ([SrcAdiKey] ASC,[SrcClaimType] ASC
		   )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
		  ) ON [PRIMARY];	

	TRUNCATE TABLE ast.Claim_01_Header_Dedup;
	
	-- start tran
	/* load INST Claims */
	INSERT INTO ast.Claim_01_Header_Dedup(SrcAdiKey, SeqClaimId, OriginalFileName, LoadDate, SrcClaimType)
	OUTPUT inserted.SrcAdiKey, inserted.SrcClaimType INTO #OutputTbl(srcAdiKey, SrcClaimType)
	SELECT s.ClaimSKey, s.ClaimID, s.OriginalFileName, s.datadate, 'INST'
	FROM (SELECT ch.InstitutionalClaimKey ClaimSKey, ch.ClaimID, ch.OriginalFileName, DataDate, 
	           ROW_NUMBER() OVER(PARTITION BY ch.ClaimID ORDER BY ch.DataDate DESC, ch.OriginalFileName ASC) arn
		  FROM adi.Steward_BCBS_InstitutionalClaim ch
		  WHERE ch.ClaimRecordID = 'CLM'
			 AND  ch.DataDate <= @DataDate
		  ) s
	WHERE s.arn = 1
	      ---AND DataDate <= @DataDate;

    SELECT @OutCnt = COUNT(*) FROM #OutputTbl otb WHERE otb.srcClaimType = 'INST';
    SET @ActionStart  = GETDATE();
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
BEGIN -- PROF claims 

    IF @LatestDataDate = '12/31/2099'
	   BEGIN
	   SELECT @DataDate = MAX(ch.DataDate)	   
		  FROM adi.Steward_BCBS_ProfessionallClaim ch
	   END
	   ELSE SET @DataDate = @LatestDataDate;   

    SELECT @InpCnt = COUNT(*) 
    FROM (SELECT ch.ProfessionalClaimKey ClaimSKey, ch.ClaimID, ch.OriginalFileName, DataDate, 
	           ROW_NUMBER() OVER(PARTITION BY ch.ClaimID ORDER BY ch.DataDate DESC, ch.OriginalFileName ASC) arn
		  FROM adi.Steward_BCBS_ProfessionallClaim ch
		  WHERE ch.ClaimRecordID = 'CLM'
			 AND  ch.DataDate <= @DataDate
	    ) s
	WHERE s.arn = 1
	      AND DataDate <= @DataDate; -- count all rows 
	
    SET  @SrcName = 'adi.Steward_BCBS_ProfessionallClaim'	 	
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
	/* Get Prof Claims */ 
	-- start tran	
	INSERT INTO ast.Claim_01_Header_Dedup(SrcAdiKey, SeqClaimId, OriginalFileName, LoadDate, SrcClaimType)
	OUTPUT inserted.SrcAdiKey, inserted.SrcClaimType INTO #OutputTbl(srcAdiKey, SrcClaimType)
	SELECT s.ClaimSKey, s.ClaimID, s.OriginalFileName, s.datadate, 'PROF'
	FROM (SELECT ch.ProfessionalClaimKey ClaimSKey, ch.ClaimID, ch.OriginalFileName, DataDate, 
	           ROW_NUMBER() OVER(PARTITION BY ch.ClaimID ORDER BY ch.DataDate DESC, ch.OriginalFileName ASC) arn
		  FROM adi.Steward_BCBS_ProfessionallClaim ch
		  WHERE ch.ClaimRecordID = 'CLM'
			 AND  ch.DataDate <= @DataDate
		  ) s
	WHERE s.arn = 1
	      ---AND DataDate <= @DataDate;

    SELECT @OutCnt = COUNT(*) FROM #OutputTbl otb WHERE otb.srcClaimType = 'PROF';
    SET @ActionStart  = GETDATE();
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
BEGIN -- RX CLAIMS
    IF @LatestDataDate = '12/31/2099'
	   BEGIN
	   SELECT @DataDate = MAX(ch.DataDate)	   
		  FROM adi.Steward_BCBS_RXClaim ch
	   END
	   ELSE SET @DataDate = @LatestDataDate;   

    SELECT @InpCnt = COUNT(*) 
    FROM (SELECT ch.RXClaimKey ClaimSKey, ch.ClaimID, ch.OriginalFileName, DataDate, 
	           ROW_NUMBER() OVER(PARTITION BY ch.ClaimID ORDER BY ch.DataDate DESC, ch.OriginalFileName ASC) arn
		  FROM adi.Steward_BCBS_RXClaim ch
		  WHERE ch.DataDate <= @DataDate
	    ) s
	WHERE s.arn = 1
	      AND DataDate <= @DataDate; -- count all rows 
	
    SET  @SrcName = 'adi.Steward_BCBS_RXClaim'	 	
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
	/* Get Prof Claims */ 
	-- start tran	
    INSERT INTO ast.Claim_01_Header_Dedup(SrcAdiKey, SeqClaimId, OriginalFileName, LoadDate, SrcClaimType)
    OUTPUT inserted.SrcAdiKey, inserted.SrcClaimType INTO #OutputTbl(srcAdiKey, SrcClaimType)
    SELECT s.ClaimSKey, s.ClaimID, s.OriginalFileName, s.datadate, 'RX'
    FROM (SELECT ch.RXClaimKey ClaimSKey, ch.ClaimID, ch.OriginalFileName, DataDate, 
	           ROW_NUMBER() OVER(PARTITION BY ch.ClaimID ORDER BY ch.DataDate DESC, ch.OriginalFileName ASC) arn
		  FROM adi.Steward_BCBS_RXClaim ch
		  WHERE ch.DataDate <= @DataDate
		  ) s
    WHERE s.arn = 1
	   AND DataDate <= @DataDate;

    SELECT @OutCnt = COUNT(*) FROM #OutputTbl otb WHERE otb.srcClaimType = 'RX';
    SET @ActionStart  = GETDATE();
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