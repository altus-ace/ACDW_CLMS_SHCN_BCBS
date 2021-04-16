




CREATE VIEW [dbo].[vw_Dashboard_Specialist]
AS 
    SELECT DISTINCT 
       hdr.[SEQ_CLAIM_ID], 
       hdr.[SUBSCRIBER_ID], 
       hdr.[CLAIM_NUMBER], 
       hdr.[CATEGORY_OF_SVC] AS CLAIMS_CATEGORY_OF_SVC, 
       hdr.[PAT_CONTROL_NO], 
       hdr.[ICD_PRIM_DIAG], 
       dtl.Procedure_Code,
       YEAR(hdr.[PRIMARY_SVC_DATE]) AS YEAR_SVC_DATE,           
       hdr.[SVC_TO_DATE], 
       hdr.[CLAIM_THRU_DATE], 
       hdr.[POST_DATE], 
       hdr.[CHECK_DATE], 
       hdr.[CHECK_NUMBER], 
       hdr.[DATE_RECEIVED], 
       hdr.[ADJUD_DATE], 
       pr.PrimaryQuadrant, 
       pr.PrimaryPOD, 
       pr.PrimaryZipcode, 
       PCP_NPI, 
       PCP_PRACTICE_NAME, 
       hdr.[SVC_PROV_ID], 
       hdr.[SVC_PROV_FULL_NAME], 
       hdr.[SVC_PROV_NPI], 
       hdr.[PROV_SPEC], 
       hdr.[PROV_TYPE], 
       hdr.[PROVIDER_PAR_STAT], 
       hdr.[ATT_PROV_ID], 
       hdr.[ATT_PROV_FULL_NAME], 
       hdr.[ATT_PROV_FULL_NAME] AS ATT_PROV_FULL_NAME1, 
       hdr.[ATT_PROV_NPI], 
       hdr.[REF_PROV_ID], 
       hdr.[REF_PROV_FULL_NAME], 
       hdr.[VENDOR_ID], 
       hdr.[VEND_FULL_NAME], 
       dtl.PLACE_OF_SVC_CODE1, 
       hdr.[IRS_TAX_ID],
       CASE
           WHEN dtl.REVENUE_CODE BETWEEN 450 AND 459
           THEN 'ER'
           ELSE hdr.CATEGORY_OF_SVC
       END AS CALC_CATEGORY_OF_SVC,           
       dtl.REVENUE_CODE, 
       hdr.[BILL_TYPE], 
       hdr.[ADMISSION_DATE], 
       hdr.[AUTH_NUMBER], 
       hdr.[ADMIT_SOURCE_CODE], 
       hdr.[ADMIT_HOUR], 
       hdr.[DISCHARGE_HOUR], 
       hdr.[PATIENT_STATUS], 
       hdr.[CLAIM_STATUS], 
       hdr.[PROCESSING_STATUS], 
       hdr.[CLAIM_TYPE], 
       hdr.[TOTAL_BILLED_AMT], 
       hdr.[TOTAL_PAID_AMT],
       CASE
           WHEN pf.npi IS NOT NULL
           THEN 'INN'
           ELSE 'OON'
       END AS Network  ,    
	   CASE WHEN Pr.AccountType IN ('ACE', 'SHCN_AFF', 'SHCN_SMG') THEN 'INN'	-- JK passed on this change from Network, it may evolve.	  
		  ELSE 'OON'
	   END AS ProviderNetwork,	  
       -- ,CASE WHEN pf.npi is NOT NULL THEN 'INN' ELSE 'OON' end as Network1
       -- , pf.npi         
       hdr.[BENE_PTNT_STUS_CD], 
       hdr.[DISCHARGE_DISPO]
	   ,pr.Chapter
    FROM [adw].[Claims_Headers] hdr
	    LEFT JOIN [adw].[Claims_Details] dtl ON hdr.SEQ_CLAIM_ID = dtl.SEQ_CLAIM_ID
	    LEFT JOIN [ACDW_CLMS_SHCN_MSSP].[lst].[lstPreferredFacility] pf ON pf.NPI = hdr.SVC_PROV_NPI         
	    LEFT JOIN [ACECAREDW].[dbo].[vw_AllClient_ProviderRoster] PR ON PR.NPI = hdr.SVC_PROV_NPI
	    LEFT JOIN (	SELECT	ClientMemberKey,CreatedDate --- Getting latest members set
							,NPI  AS PCP_NPI
							,ProviderPracticeName AS PCP_PRACTICE_NAME
					FROM	(
							SELECT		MAX(DataDate) DataDate
							FROM		ACDW_CLMS_SHCN_BCBS.adw.FctMembership
							)src
					JOIN	(SELECT	ClientMemberKey,DataDate,CONVERT(DATE,CreatedDate) CreatedDate
									,NPI,ProviderPracticeName
							 FROM	ACDW_CLMS_SHCN_BCBS.adw.FctMembership
							 WHERE	Active = 1
							 )z
					ON		src.DataDate = z.DataDate
					) Mbr 
	ON mbr.ClientMemberKey = hdr.SUBSCRIBER_ID     
	AND hdr.PRIMARY_SVC_DATE  between DATEFROMPARTS( YEAR(CONVERT(DATE,mbr.CreatedDate)), MONTH(CONVERT(DATE,mbr.CreatedDate)), 20) 
	AND DATEADD(day, -1, DATEADD(MONTH, 1, (DATEFROMPARTS( YEAR(CONVERT(DATE,mbr.CreatedDate)), MONTH(CONVERT(DATE,mbr.CreatedDate)), 20))) )
    WHERE hdr.Primary_svc_date >= '1/1/2019' -- And '12/31/2099'--IN ('2018','2019','2020','2021')     
	   AND hdr.SVC_PROV_NPI  in (SELECT SvcProvNpi.SVC_PROV_NPI FROM [adw].[Claims_Headers] SvcProvNpi WHERE SvcProvNpi.ATT_PROV_NPI <> 'UNKNOWN' GROUP BY SvcProvNpi.SVC_PROV_NPI ) 
    ;

