
--drop procedure adw.[FctProviderRosterFrmView]

CREATE PROCEDURE [adw].[Load_Pdw_FctProviderRosterFromView]
AS

BEGIN    
    /* 1 get dates */      
    DECLARE @d DATE = CONVERT(DATE, getdate());        
    
    /* 2 Log FACT LOAD */        
    DECLARE @AuditID INT ;    
    DECLARE @AuditStatus SmallInt= 1 -- 1 in process , 2 Completed
    DECLARE @JobType SmallInt = 8	   -- 1 adi load, 2 dw load????
    DECLARE @ClientKey INT	=   16 -- SHCN_MSSP
    DECLARE @JobName VARCHAR(200) = OBJECT_NAME(@@PROCID)  -- if it is the procedure name
    DECLARE @ActionStartTime DATETIME2 = getdate();
    DECLARE @InputSourceName VARCHAR(200) 
	   SELECT @InputSourceName = 'ACECAREDW.adw.fctProviderRoster'
    DECLARE @DestinationName VARCHAR(200) = 'No Destination Name Provided'	
	   SELECT @DestinationName = DB_NAME() + '.adw.fctProviderRoster';    
    DECLARE @ErrorName VARCHAR(200) = 'No Error Name Provided'	;
    DECLARE @SourceCount int;     
    DECLARE @DestinationCount int;	     
    DECLARE @ErrorCount int = 0
    /* close load Staging Log record */    
    DECLARE @ActionStopTime DATETIME;
    Declare @Output table (ID INT PRIMARY KEY NOT NULL) ;
    SELECT @SourceCount	  = COUNT(*) FROM adw.fctProviderRoster PR WHERE @d BETWEEN PR.RowEffectiveDate and PR.RowExpirationDate;      
            
    EXEC amd.sp_AceEtlAudit_Open
        @AuditID = @AuditID OUTPUT
        , @AuditStatus = @AuditStatus
        , @JobType = @JobType
        , @ClientKey = @ClientKey
        , @JobName = @JobName
        , @ActionStartTime = @ActionStartTime
        , @InputSourceName = @InputSourceName
        , @DestinationName = @DestinationName
        , @ErrorName = @ErrorName      
    
    /* 3 update old records setting the RowExpirationdate  */      
    -- add error handling       
    BEGIN TRAN LoadFctProviderRoster      
	   -- update tran?      
	   UPDATE PR      
		  SET PR.RowExpirationDate = DATEADD(day, -1, @d)      
	   OUTPUT inserted.fctProviderRosterSkey INTO @Output(ID)
	   FROM adw.fctProviderRoster PR      
	   WHERE @d BETWEEN PR.RowEffectiveDate and PR.RowExpirationDate;      
	     
		/* close load Staging Log record */    
	   SET @ActionStopTime = getdate();	   
	   SET @AuditStatus = 2;
	   SELECT @DestinationCount = COUNT(id) from @Output;
	   DECLARE @JobStatus tinyInt = 2

	   EXEC amd.sp_AceEtlAudit_Close 
		  @AuditId = @AuditID
		  , @ActionStopTime = @ActionStopTime
		  , @SourceCount = @SourceCount		  
		  , @DestinationCount = @DestinationCount
		  , @ErrorCount = @ErrorCount
		  , @JobStatus = @JobStatus
		  ;


	   /* Insert New PR Rows from View */      
	   
	   DELETE FROM @Output;	   
	   /* log */   
	   SELECT @SourceCount   = COUNT(*) FROM ACECAREDW.adw.fctProviderRoster;
	   SET @ActionStartTime = getdate();	   
	   SET @AuditStatus = 1;
	   SET @JobType = 8 -- adw load;
	   SELECT @DestinationCount = @SourceCount;
	   SET @JobStatus = 1;

	   EXEC amd.sp_AceEtlAudit_Open
        @AuditID = @AuditID OUTPUT
        , @AuditStatus = @AuditStatus
        , @JobType = @JobType
        , @ClientKey = @ClientKey
        , @JobName = @JobName
        , @ActionStartTime = @ActionStartTime
        , @InputSourceName = @InputSourceName
        , @DestinationName = @DestinationName
        , @ErrorName = @ErrorName
        ;

	   -- add error handling      
	   INSERT INTO adw.fctProviderRoster(             
		  [SourceJobName]        
		  , [LoadDate]        
		  , [DataDate]        
		  , IsActive        
		  , RowEffectiveDate              
		  , [ClientKey]        
		  , [LOB]        
		  , [ClientProviderID]        
		  , [NPI]        
		  , [LastName]        
		  , [FirstName]        
		  , [Degree]        
		  , [TIN]        
		  , [PrimarySpeciality]        
		  , [Sub_Speciality]        
		  , [GroupName]        
		  , [EffectiveDate]        
		  , [ExpirationDate]        
		  , [PrimaryAddress]        
		  , [PrimaryCity]        
		  , [PrimaryState]        
		  , [PrimaryZipcode]        
		  , [PrimaryPOD]        
		  , [PrimaryQuadrant]        
		  , [PrimaryAddressPhoneNum]        
		  , [BillingAddress]        
		  , [BillingCity]        
		  , [BillingState]        
		  , [BillingZipcode]        
		  , [BillingPOD]        
		  , [BillingAddressPhoneNum]        
		  , [NetworkContact]        
		  , [Comments]        
		  , HealthPlan        
		  , AccountType              
		  , Chapter
		  , AceProviderID	
		  , AceAccountID	
		  , Ethnicity		
		  , LanguagesSpoken	
		  , Provider_DOB
		  , Provider_Gender	
		  )    
	   OUTPUT inserted.fctProviderRosterSkey INTO @Output(ID)    
	   SELECT   
		  'ACECAREDW.dbo.vw_AllClient_ProviderRoster' AS SrcJobName        
		  ,GETDATE() AS LoadDate        
		  ,DATEADD(WK,0,DATEADD(DAY,2-DATEPART(WEEKDAY,GETDATE()),DATEDIFF(DD,0,GETDATE()))) AS DataDate        
		  , 1 AS IsActive        
		  , @d AS RowEffectiveDate              
		  ,ProviderRoster.CalcClientKey        
		  ,ProviderRoster.LOB        
		  ,ProviderRoster.ClientProviderID        
		  ,ProviderRoster.NPI        
		  ,ProviderRoster.LastName        
		  ,ProviderRoster.FirstName        
		  ,ProviderRoster.Degree        
		  ,ProviderRoster.TIN        
		  ,ProviderRoster.PrimarySpeciality        
		  ,ProviderRoster.Sub_Speciality        
		  ,ProviderRoster.GroupName        
		  ,ProviderRoster.EffectiveDate        
		  ,ProviderRoster.ExpirationDate        
		  ,ProviderRoster.PrimaryAddress        
		  ,ProviderRoster.PrimaryCity        
		  ,ProviderRoster.PrimaryState        
		  ,ProviderRoster.PrimaryZipcode        
		  ,ProviderRoster.PrimaryPOD        
		  ,ProviderRoster.PrimaryQuadrant        
		  ,ProviderRoster.PrimaryAddressPhoneNum
		  ,ProviderRoster.BillingAddress        
		  ,ProviderRoster.BillingCity        
		  ,ProviderRoster.BillingState        
		  ,ProviderRoster.BillingZipcode        
		  ,ProviderRoster.BillingPOD        
		  ,ProviderRoster.BillingAddressPhoneNum
		  ,ProviderRoster.NetworkContact    
		  ,ProviderRoster.Comments        
		  ,ProviderRoster.HealthPlan        
		  ,ProviderRoster.AccountType               
		  ,ProviderRoster.Chapter      
		  ,ProviderRoster.AceProviderID	
		  ,ProviderRoster.AceAccountID	
		  ,ProviderRoster.Ethnicity		
		  ,ProviderRoster.LanguagesSpoken	
		  ,ProviderRoster.Provider_DOB
		  ,ProviderRoster.Provider_Gender				   
	   FROM AceCareDw.dbo.vw_AllClient_ProviderRoster AS ProviderRoster 
	   WHERE ProviderRoster.HealthPlan = 'SHCN_MSSP'

	   SET @ActionStopTime = getdate();	   
	   SET @AuditStatus = 2;
	   SELECT @DestinationCount = COUNT(id) from @Output;
	   SET @JobStatus = 2

	   EXEC amd.sp_AceEtlAudit_Close 
		  @AuditId = @AuditID
		  , @ActionStopTime = @ActionStopTime
		  , @SourceCount = @SourceCount		  
		  , @DestinationCount = @DestinationCount
		  , @ErrorCount = @ErrorCount
		  , @JobStatus = @JobStatus
		  ;
    COMMIT TRAN LoadFctProviderRoster      
    
    /* Log load */

END
