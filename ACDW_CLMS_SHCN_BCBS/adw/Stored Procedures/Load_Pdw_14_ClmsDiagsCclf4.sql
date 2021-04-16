
CREATE PROCEDURE [adw].[Load_Pdw_14_ClmsDiagsCclf4]
AS 
   
   /* prepare logging */
    DECLARE @AuditId INT;    
    DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt = 8	  -- AST load
    DECLARE @ClientKey INT	 = 16; -- mssp
    DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_MSSPPartAClaimDiagnosisCode'
    DECLARE @DestName VARCHAR(100) = 'adw.Claims_Diags'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(*) 
    SELECT COUNT(*) 
    FROM adi.Steward_BCBS_InstitutionalClaim cp 		
	   JOIN ast.Claim_06_Diag_Dedup ast 
		  ON cp.InstitutionalClaimKey = ast.DiagAdiKey
		  and SrcClaimType = 'INST'
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
        , @ErrorName	   = @ErrorName
        ;
    CREATE TABLE #OutputTbl (ID INT NOT NULL PRIMARY KEY);	
    INSERT INTO  adw.Claims_Diags
           ([SEQ_CLAIM_ID]
           ,[SUBSCRIBER_ID]
           ,[ICD_FLAG]
           ,[diagNumber]
           ,[diagCode]
           ,[diagPoa]
		   ,LoadDate
		   ,SrcAdiTableName
		   ,SrcAdiKey)
    OUTPUT INSERTED.URN INTO #OutputTbl(ID)
    SELECT	   dg.ClaimID				AS SEQ_CLAIM_ID   
			 , dg.PatientID			AS SUBSCRIBER_ID
			 , dg.ICDVersionCode		AS ICD_FLAG   
			 , ast.DiagNum	  			AS diagNumber     			
			 , CASE  WHEN (ast.DiagNum = 1 ) THEN dg.HLPrimaryDiagnosisCode
				    WHEN (ast.DiagNum = 2 ) THEN dg.HLDiagnosisCode2
				    WHEN (ast.DiagNum = 3 ) THEN dg.HLDiagnosisCode3
				    WHEN (ast.DiagNum = 4 ) THEN dg.HLDiagnosisCode4
				    WHEN (ast.DiagNum = 5 ) THEN dg.HLDiagnosisCode5
				    WHEN (ast.DiagNum = 6 ) THEN dg.HLDiagnosisCode6
				    WHEN (ast.DiagNum = 7 ) THEN dg.HLDiagnosisCode7
				    WHEN (ast.DiagNum = 8 ) THEN dg.HLDiagnosisCode8
				    WHEN (ast.DiagNum = 9 ) THEN dg.HLDiagnosisCode9
				    WHEN (ast.DiagNum = 10) THEN dg.HLDiagnosisCode10
				    WHEN (ast.DiagNum = 11) THEN dg.HLDiagnosisCode11
				    WHEN (ast.DiagNum = 12) THEN dg.HLDiagnosisCode12
				    END as DiagCode
			 , ''				     AS DiagPoa
			 , getDate()			     AS LoadDate
			 , 'Steward_BCBS_InstitutionalClaim' AS SrcAdiTableName
			 , ast.DiagAdiKey			as adiKey			 
    FROM ast.Claim_06_Diag_Dedup ast
	   JOIN adi.Steward_BCBS_InstitutionalClaim dg ON ast.DiagAdiKey = dg.InstitutionalClaimKey		
	   And SrcClaimType = 'INST'
    ORDER BY dg.ClaimID, ast.DiagNum;

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
