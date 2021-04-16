CREATE PROCEDURE [adw].[Load_Pdw_13_ClmsProcsCclf3]
AS
    --Task 3 Insert Proc: -- Insert to proc    
	/* prepare logging */
    DECLARE @AuditId INT;    
    DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt = 8	  -- AST load
    DECLARE @ClientKey INT	 = 16; -- mssp
    DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_MSSPPartAClaimProcedureCode'
    DECLARE @DestName VARCHAR(100) = 'adw.Claims_Procs'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(*) 	
    FROM adi.Steward_BCBS_InstitutionalClaim cl
	   JOIN ast.Claim_05_Procs_Dedup ast ON cl.InstitutionalClaimKey = ast.ProcAdiKey
    WHERE ast.SrcClaimType = 'INST'
	   ;	

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
    
    INSERT INTO adw.Claims_Procs
               (SEQ_CLAIM_ID
				,SUBSCRIBER_ID
				,ProcNumber
				,ProcCode
				,ProcDate
				,LoadDate
				,SrcAdiTableName
				,SrcAdiKey	)	
    OUTPUT Inserted.URN INTO #OutputTbl(ID)
    SELECT cp.ClaimID						AS SEQ_CLAIM_ID
        , cp.PatientID			 			AS subscriberID
        , ast.ProcNumber			 			AS ProcNum
        , CASE WHEN (ast.ProcNumber = 1) THEN cp.ProcedureCode1 
		  WHEN (ast.ProcNumber = 2) THEN cp.ProcedureCode2
		  WHEN (ast.ProcNumber = 3) THEN cp.ProcedureCode3 
		  WHEN (ast.ProcNumber = 4) THEN cp.ProcedureCode4 
		  WHEN (ast.ProcNumber = 5) THEN cp.ProcedureCode5 
		  END AS ProcCode
        , cp.ServiceFromDate	  				AS ProcDate
	   , getdate()							AS LoadDate
	   , 'adi.Steward_BCBS_InstitutionalClaim'	AS SrcAdiTableName
	   , ast.ProcAdiKey					   	AS SrcAdiKey
		-- implicit: 	CreatedDate,CreatedBy,LastUpdatedDate,LastUpdatedBy
    FROM adi.Steward_BCBS_InstitutionalClaim cp
        JOIN ast.Claim_05_Procs_Dedup ast ON cp.InstitutionalClaimKey = ast.ProcAdiKey AND ast.SrcClaimType = 'INST'
    ORDER BY cp.ClaimID, ast.ProcNumber;

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

