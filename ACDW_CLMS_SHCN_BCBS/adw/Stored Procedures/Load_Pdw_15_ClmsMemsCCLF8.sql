---DONT RUN SP UNTIL VALIDATION FROM ADI
CREATE PROCEDURE [adw].[Load_Pdw_15_ClmsMemsCCLF8]
    (@MaxDataDate DATE = '12/31/2099')
AS -- insert Claims.Members
    DECLARE @DataDate Date = @maxDataDate;
	/* prepare logging */
    DECLARE @AuditId INT;    
    DECLARE @JobStatus tinyInt = 1    -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt = 8	  -- Adw load
    DECLARE @ClientKey INT	 = 16; -- mssp
    DECLARE @JobName VARCHAR(100) = OBJECT_SCHEMA_NAME(@@PROCID) + '.' + OBJECT_NAME(@@PROCID);
    DECLARE @ActionStart DATETIME2 = GETDATE();
    DECLARE @SrcName VARCHAR(100) = 'adi.Steward_BCBS_InstitutionalClaim'
    DECLARE @DestName VARCHAR(100) = 'adw.Claims_Member'
    DECLARE @ErrorName VARCHAR(100) = 'NA';
    DECLARE @InpCnt INT = -1;
    DECLARE @OutCnt INT = -1;
    DECLARE @ErrCnt INT = -1;
	
    SELECT @InpCnt = COUNT(*) 
    --declare @datadate date = '01/01/2021'
    --SELECT * 
    FROM (SELECT *
        , ROW_NUMBER() OVER (PARTITION BY PatientID oRDER BY DataDate, MemberZip, MemberGender, MemberLastName, MemberFirstName, MemberMiddleInitial asc) arn
	       FROM (
    			 SELECT src.PatientID, src.SubscriberID, src.MemberBirthDate, src.MemberLastName, src.MemberMiddleInitial, src.MemberFirstName, src.MemberGender, src.MemberZip, src.DataDate
    			 FROM (
    				SELECT m.PatientID, m.SubscriberID, m.MemberBirthDate, m.MemberLastName, m.MemberMiddleInitial, m.MemberFirstName, m.MemberGender, m.MemberZip, m.DataDate
    	       		, ROW_Number() OVER (PARTITION BY m.PatientID ORDER BY m.DataDate desc) aRn
    				FROM adi.Steward_BCBS_InstitutionalClaim m    
    				    JOIN ast.Claim_03_Header_LatestEffective ast	   
    				    ON m.InstitutionalClaimKey = ast.LatestClaimAdiKey
    	       		    and ast.SrcClaimType = 'INST'
    				WHERE m.datadate <= @DataDate
    	   			)src
    			 WHERE src.arn = 1 
    			 UNION
    			 SELECT  src.PatientID, src.SubscriberID, src.MemberBirthDate, src.MemberLastName, src.MemberMiddleInitial, src.MemberFirstName, src.MemberGender, src.MemberZip, src.DataDate
    			 FROM (
    			   SELECT  m.PatientID, m.SubscriberID, m.MemberBirthDate, m.MemberLastName, m.MemberMiddleInitial, m.MemberFirstName, m.MemberGender, m.MemberZip, m.DataDate
    			 	 , ROW_Number() OVER (PARTITION BY m.PatientID ORDER BY m.DataDate desc) aRn
    			   FROM adi.Steward_BCBS_ProfessionallClaim m    
    			       JOIN ast.Claim_03_Header_LatestEffective ast
    			       ON m.ProfessionalClaimKey = ast.LatestClaimAdiKey    
    			       and ast.SrcClaimType = 'PROF'
    			   WHERE m.datadate <= @DataDate
    			 	   )src
    			 WHERE src.arn = 1
    			 UNION
    			 SELECT  src.PatientID, src.SubscriberID, src.MemberBirthDate, src.MemberLastName, src.MemberMiddleInitial, src.MemberFirstName, src.MemberGender, src.MemberZip, src.DataDate
    			 FROM (
    			   SELECT m.PatientID, m.SubscriberID, m.MemberBirthDate, m.MemberLastName, '' MemberMiddleInitial, m.MemberFirstName, CASE WHEN (m.MemberGender = 1) THEN 'M' ELSE 'F'END as memberGender, '' MemberZip, m.DataDate
    			      , ROW_Number() OVER (PARTITION BY m.PatientID ORDER BY m.DataDate desc) aRn
    			   FROM adi.Steward_BCBS_RXClaim m    
    			       JOIN ast.Claim_03_Header_LatestEffective ast
    			       ON m.RXClaimKey = ast.LatestClaimAdiKey
    			       and ast.SrcClaimType = 'RX'
    			   WHERE m.datadate <= @DataDate
    			   )src
    			 WHERE src.arn = 1
		  ) Mbrs	
	   ) s
    WHERE s.aRn = 1

    
     

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
	CREATE TABLE #OutputTbl (ID VARCHAR(50) NOT NULL PRIMARY KEY);	

    INSERT INTO adw.Claims_Member
           (SUBSCRIBER_ID
		   , IsActiveMember
           ,DOB
           ,MEMB_LAST_NAME
           ,MEMB_MIDDLE_INITIAL
           ,MEMB_FIRST_NAME        
		   ,MEDICAID_NO
		   ,MEDICARE_NO
           ,Gender
           ,MEMB_ZIP
		   ,COMPANY_CODE
		   ,LINE_OF_BUSINESS_DESC
		   ,SrcAdiTableName
		   ,SrcAdiKey
		   ,LoadDate
		   )
	OUTPUT inserted.SUBSCRIBER_ID INTO #OutputTbl(ID)
    SELECT 
	   s.PatientID				AS SUBSCRIBER_ID		    
		,1									AS IsActiveMember
		,s.MemberBirthDate							AS DOB				  	   
		,s.MemberLastName							AS MEMB_LAST_NAME		    
		,s.MemberMiddleInitial						AS MEMB_MIDDLE_INITIAL	    
		,s.MemberFirstName					AS MEMB_FIRST_NAME	    
		, ''								AS MEDICAID_NO
		, ''								  AS MEDICARE_NO
		,s.MemberGender							AS GENDER			    
		,s.MemberZip						  	AS MEMB_ZIP			    
		,''									AS COMPANY_CODE
		,''									AS LINE_OF_BUSINESS_DESC
		,'Steward_BCBS_InstitutionalClaim' AS SrcAdiTableName
		, s.adiKey	AS SrcAdiKey
		, GetDate()							AS LoadDate
		-- implicit: CreatedDate, CreatedBy, LastUpdatedDate, LastUpdatedBy
	   FROM (SELECT *
			 , ROW_NUMBER() OVER (PARTITION BY PatientID oRDER BY DataDate, MemberZip, MemberGender, MemberLastName, MemberFirstName, MemberMiddleInitial asc) arn
	       FROM (
    			 SELECT src.PatientID, src.SubscriberID, src.MemberBirthDate, src.MemberLastName, src.MemberMiddleInitial, src.MemberFirstName, src.MemberGender, src.MemberZip, src.DataDate, AdiKey
    			 FROM (
    				SELECT m.PatientID, m.SubscriberID, m.MemberBirthDate, m.MemberLastName, m.MemberMiddleInitial, m.MemberFirstName, m.MemberGender, m.MemberZip, m.DataDate, m.InstitutionalClaimKey AdiKey
    	       		, ROW_Number() OVER (PARTITION BY m.PatientID ORDER BY m.DataDate desc) aRn
    				FROM adi.Steward_BCBS_InstitutionalClaim m    
    				    JOIN ast.Claim_03_Header_LatestEffective ast	   
    				    ON m.InstitutionalClaimKey = ast.LatestClaimAdiKey
    	       		    and ast.SrcClaimType = 'INST'
    				WHERE m.datadate <= @DataDate
    	   			)src
    			 WHERE src.arn = 1 
    			 UNION
    			 SELECT  src.PatientID, src.SubscriberID, src.MemberBirthDate, src.MemberLastName, src.MemberMiddleInitial, src.MemberFirstName, src.MemberGender, src.MemberZip, src.DataDate, AdiKey
    			 FROM (
    			   SELECT  m.PatientID, m.SubscriberID, m.MemberBirthDate, m.MemberLastName, m.MemberMiddleInitial, m.MemberFirstName, m.MemberGender, m.MemberZip, m.DataDate, m.ProfessionalClaimKey AdiKey
    			 	 , ROW_Number() OVER (PARTITION BY m.PatientID ORDER BY m.DataDate desc) aRn
    			   FROM adi.Steward_BCBS_ProfessionallClaim m    
    			       JOIN ast.Claim_03_Header_LatestEffective ast
    			       ON m.ProfessionalClaimKey = ast.LatestClaimAdiKey    
    			       and ast.SrcClaimType = 'PROF'
    			   WHERE m.datadate <= @DataDate
    			 	   )src
    			 WHERE src.arn = 1
    			 UNION
    			 SELECT  src.PatientID, src.SubscriberID, src.MemberBirthDate, src.MemberLastName, src.MemberMiddleInitial, src.MemberFirstName, src.MemberGender, src.MemberZip, src.DataDate, AdiKey
    			 FROM (
    			   SELECT m.PatientID, m.SubscriberID, m.MemberBirthDate, m.MemberLastName, '' MemberMiddleInitial, m.MemberFirstName, CASE WHEN (m.MemberGender = 1) THEN 'M' ELSE 'F'END as memberGender, '' MemberZip, m.DataDate, m.RXClaimKey AdiKey
    			      , ROW_Number() OVER (PARTITION BY m.PatientID ORDER BY m.DataDate desc) aRn
    			   FROM adi.Steward_BCBS_RXClaim m    
    			       JOIN ast.Claim_03_Header_LatestEffective ast
    			       ON m.RXClaimKey = ast.LatestClaimAdiKey
    			       and ast.SrcClaimType = 'RX'
    			   WHERE m.datadate <= @DataDate
    			   )src
    			 WHERE src.arn = 1
		  ) Mbrs	
	   ) s
    WHERE s.aRn = 1	;

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
