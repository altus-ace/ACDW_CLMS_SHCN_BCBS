
------DO NOT PROCESS SP UNTIL VALIDATED WITH COUNT FROM SOURCE FILE
CREATE PROCEDURE [adw].[Load_Pdw_05_DeDupPartAProcs] (
    @MaxDataDate Date 
    )
AS 
    /* -- 5. de dup procedures

	   get procs sets by claim and line and adj and ???
	   deduplicate for cases:
		  1. deal with duplicates: all relavant details are the same
		  2. deal with adjustments: if details sub line code is different
		  3. deal with???? will determin as we move forward

	   sort by file date or???
	   
	   insert into ast claims dedup procedure urns table
    */

	DECLARE @DataDate DATE;

    DECLARE @AuditId INT;    
    DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt = 9	  -- 9: Ast Load, 10: Ast Transform, 11:Ast Validation	
    DECLARE @ClientKey INT	 = 16; -- mssp
    DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_BCBS_InstitutionalClaim'
    DECLARE @DestName VARCHAR(100) = 'ast.pstcPrcDeDupUrns'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
    
    CREATE TABLE #OutputTbl (srcAdiKey INT NOT NULL, srcClaimType CHAR(5) NOT NULL,  PRIMARY KEY(srcAdiKey,srcClaimType));	
    TRUNCATE table ast.Claim_05_Procs_Dedup;

begin -- inst proc 
    set @SrcName = 'adi.Steward_BCBS_InstitutionalClaim'

    SELECT @InpCnt = SUM (src.cnt)    
    FROM (   
	   SELECT COUNT(cp.InstitutionalClaimKey) cnt
	   FROM ast.Claim_03_Header_LatestEffective ast
	       JOIN adi.Steward_BCBS_InstitutionalClaim cp ON ast.LatestClaimAdiKey = cp.InstitutionalClaimKey
	   WHERE ISNULL(ProcedureCode1, '') <> ''   and cp.DataDate <= @MaxDataDate  
		  AND ast.SrcClaimType = 'INST'
	   UNION    
	   SELECT COUNT(cp.InstitutionalClaimKey) cnt
	   FROM ast.Claim_03_Header_LatestEffective ast
	       JOIN adi.Steward_BCBS_InstitutionalClaim cp ON ast.LatestClaimAdiKey = cp.InstitutionalClaimKey
	   WHERE ISNULL(ProcedureCode2, '') <> '' and cp.DataDate <= @MaxDataDate
		  AND ast.SrcClaimType = 'INST'
	   UNION    
	   SELECT COUNT(cp.InstitutionalClaimKey) cnt
	   FROM ast.Claim_03_Header_LatestEffective ast
	       JOIN adi.Steward_BCBS_InstitutionalClaim cp ON ast.LatestClaimAdiKey = cp.InstitutionalClaimKey
	   WHERE ISNULL(ProcedureCode3, '') <> '' and cp.DataDate <= @MaxDataDate
		  AND ast.SrcClaimType = 'INST'
	   UNION
	   SELECT COUNT(cp.InstitutionalClaimKey ) cnt
	   FROM ast.Claim_03_Header_LatestEffective ast
	       JOIN adi.Steward_BCBS_InstitutionalClaim cp ON ast.LatestClaimAdiKey = cp.InstitutionalClaimKey
		  AND ast.SrcClaimType = 'INST'
	   WHERE ISNULL(ProcedureCode4, '') <> '' and cp.DataDate <= @MaxDataDate
		  AND ast.SrcClaimType = 'INST'
	   UNION    
	   SELECT COUNT(cp.InstitutionalClaimKey ) cnt
	   FROM ast.Claim_03_Header_LatestEffective ast
	       JOIN adi.Steward_BCBS_InstitutionalClaim cp ON ast.LatestClaimAdiKey = cp.InstitutionalClaimKey
	   WHERE ISNULL(ProcedureCode5, '') <> '' and cp.DataDate <= @MaxDataDate
		  AND ast.SrcClaimType = 'INST'
        ) src;    
	
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
	   	
    INSERT INTO ast.Claim_05_Procs_Dedup  (ProcAdiKey, ProcNumber)
    OUTPUT inserted.ClaimProcDedupKey, inserted.SrcClaimType INTO #OutputTbl(srcAdiKey, srcClaimType)
    SELECT src.InstitutionalClaimKey AS AdiKey, src.ProcNum
    FROM (SELECT cp.ClaimID, cp.InstitutionalClaimKey , cp.ProcedureCode1 AS ProcCode, 1 AS ProcNum
		  FROM ast.Claim_03_Header_LatestEffective ast
			 JOIN adi.Steward_BCBS_InstitutionalClaim cp ON ast.LatestClaimAdiKey = cp.InstitutionalClaimKey
		  WHERE ISNULL(ProcedureCode1, '') <> ''     and cp.DataDate <= @MaxDataDate
			 AND ast.SrcClaimType = 'INST'
		  UNION     
		  SELECT cp.ClaimID, cp.InstitutionalClaimKey , cp.ProcedureCode2 AS ProcCode, 2 AS ProcNum
		  FROM ast.Claim_03_Header_LatestEffective ast
		      JOIN adi.Steward_BCBS_InstitutionalClaim cp ON ast.LatestClaimAdiKey = cp.InstitutionalClaimKey
		  WHERE ISNULL(ProcedureCode2, '') <> ''  and cp.DataDate <= @MaxDataDate
			 AND ast.SrcClaimType = 'INST'
		  UNION    
		  SELECT cp.ClaimID, cp.InstitutionalClaimKey , cp.ProcedureCode3 AS ProcCode, 3 AS ProcNum
		  FROM ast.Claim_03_Header_LatestEffective ast
		      JOIN adi.Steward_BCBS_InstitutionalClaim cp ON ast.LatestClaimAdiKey = cp.InstitutionalClaimKey
		  WHERE ISNULL(ProcedureCode3, '') <> '' and cp.DataDate <= @MaxDataDate
			 AND ast.SrcClaimType = 'INST'
		  UNION
		  SELECT cp.ClaimID, cp.InstitutionalClaimKey , cp.ProcedureCode4 AS ProcCode, 4 AS ProcNum
		  FROM ast.Claim_03_Header_LatestEffective ast
		      JOIN adi.Steward_BCBS_InstitutionalClaim cp ON ast.LatestClaimAdiKey = cp.InstitutionalClaimKey
		  WHERE ISNULL(ProcedureCode4, '') <> '' and cp.DataDate <= @MaxDataDate
			 AND ast.SrcClaimType = 'INST'
		  UNION
		  SELECT cp.ClaimID, cp.InstitutionalClaimKey , cp.ProcedureCode5 AS ProcCode, 5 AS ProcNum
		  FROM ast.Claim_03_Header_LatestEffective ast
		      JOIN adi.Steward_BCBS_InstitutionalClaim cp ON ast.LatestClaimAdiKey = cp.InstitutionalClaimKey
		  WHERE ISNULL(ProcedureCode5, '') <> '' and cp.DataDate <= @MaxDataDate
			 AND ast.SrcClaimType = 'INST'
    ) src;
		
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
END -- inst proc

/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*/

begin -- Prof proc 
    -- no proc codes to load in Prof Claim set
    set @SrcName = 'adi.Steward_BCBS_InstitutionalClaim'    
END -- Prof proc

/* XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*/
begin -- RX proc 
    set @SrcName = 'adi.Steward_BCBS_RXClaim'
    -- No Procs in the RX claimsd
END -- RX proc
