
CREATE PROCEDURE adw.Validate_Claims_PostLoad
AS
BEGIN
    /* ast state */
    SELECT 'Claim_01_Header_Dedup' [Stage table], c.SrcClaimType, c.LoadDate,count(*) count
    FROM ast.Claim_01_Header_Dedup c
    group by c.SrcClaimType, c.LoadDate
    with rollup
    

    SELECT 'Claim_01_Header_Dedup' [table], c.SrcClaimType, count(*)
    FROM ast.Claim_01_Header_Dedup c
    group by c.SrcClaimType
    with rollup
    
    SELECT 'Claim_02_HeaderSuperKey' [table], c.SrcClaimType, count(*)
    FROM ast.Claim_02_HeaderSuperKey c
    group by c.SrcClaimType
    with rollup
    
    SELECT 'Claim_03_Header_LatestEffective' [table], c.SrcClaimType, count(*)
    FROM ast.Claim_03_Header_LatestEffective c
    group by c.SrcClaimType
    with rollup
    
    SELECT 'Claim_04_Detail_Dedup' [table], c.SrcClaimType, count(*)
    FROM ast.Claim_04_Detail_Dedup c
    group by c.SrcClaimType
    with rollup
    
    SELECT 'Claim_05_Procs_Dedup' [table], c.SrcClaimType, count(*)
    FROM ast.Claim_05_Procs_Dedup c
    group by c.SrcClaimType
    with rollup
    
    SELECT 'Claim_06_Diag_Dedup' [table], c.SrcClaimType, count(*)
    FROM ast.Claim_06_Diag_Dedup c
    group by c.SrcClaimType
    with rollup

    /* adw state  */

    SELECT count(*), 'Hdrs' FROm adw.Claims_Headers
    SELECT count(*), 'dtls' FROm adw.Claims_Details
    SELECT count(*), 'diag' FROm adw.Claims_Diags
    SELECT count(*), 'Proc' FROm adw.Claims_Procs
    SELECT count(*), 'cond' FROm adw.Claims_Conditions
    SELECT count(*), 'CMbr' FROm adw.Claims_member



    --Example a:
    
    SELECT 'Lineage Example' TestCase, adw.SrcAdiKey AS adwSourceKey, adi.* 
    FROM adi.Steward_BCBS_InstitutionalClaim  adi
	   LEFT JOIN (select h.SEQ_CLAIM_ID, h.SUBSCRIBER_ID, h.SrcAdiKey
				FROM adw.Claims_Headers  h
				WHERE SrcAdiTableName = 'Steward_BCBS_InstitutionalClaim' 
				    and SUBSCRIBER_ID = '718338947' and  SEQ_CLAIM_ID = '000020190866210N530H'
			 ) Adw ON adi.InstitutionalClaimKey = adw.SrcAdiKey
    WHERE adi.PatientID = '718338947'
	   AND adi.ClaimID = '000020190866210N530H'
    
     
    --Example b:
    SELECT 'Lineage Example' TestCase, adw.srcAdiKey adwSourceKey, adi.* 
    FROM adi.Steward_BCBS_InstitutionalClaim adi
	   LEFT JOIN (SELECT  h.SEQ_CLAIM_ID, h.SUBSCRIBER_ID, h.SrcAdiKey
				FROM adw.Claims_Headers h
				WHERE SrcAdiTableName = 'Steward_BCBS_InstitutionalClaim' 			
		  ) adw ON adi.InstitutionalClaimKey = adw.SrcAdiKey
    WHERE adi.PatientID = '721972375'    AND  adi.ClaimID = '0000202020550B94630X'
    
         
    --Example c:
    SELECT H.SEQ_CLAIM_ID, h.SUBSCRIBER_ID, h.SrcAdiKey, adi.DataDate
    FROM adw.Claims_Headers H
        JOIN (select distinct PatientID, ClaimID, count(distinct HLPaidAmount) as CntDistAmt 
    	   FROM adi.Steward_BCBS_InstitutionalClaim 
    	   GROUP BY PatientID, ClaimID 
    	   HAVING count(distinct HLPaidAmount)>1
    	   ) MultiSourceRows
    	   ON h.SUBSCRIBER_ID = MultiSourceRows.PatientID
    	   and h.SEQ_CLAIM_ID = MultiSourceRows.ClaimID 
        JOIN adi.Steward_BCBS_InstitutionalClaim Adi On h.SrcAdiKey = adi.InstitutionalClaimKey
    
    --Example d:
--    select * 
--    FROM adi.Steward_BCBS_InstitutionalClaim 
--    WHERE PatientID = '745137958' AND ClaimID = '0000202032260072T50H'
--    
--    select h.SEQ_CLAIM_ID, h.SUBSCRIBER_ID, h.SrcAdiKey
--    FROM adw.Claims_Headers h
--    WHERE h.SrcAdiTableName = 'Steward_BCBS_InstitutionalClaim' 
--        and h.SUBSCRIBER_ID = '745137958' AND h.SEQ_CLAIM_ID = '0000202032260072T50H'
--        --and SrcAdiKey IN (818376,406617,1221843)
--    
     
    End