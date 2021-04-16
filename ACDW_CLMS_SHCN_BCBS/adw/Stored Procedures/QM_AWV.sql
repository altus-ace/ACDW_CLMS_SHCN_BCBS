
--add @qmdate, @codeeffectivedate

CREATE PROCEDURE [adw].[QM_AWV](@ConnectionStringProd		NVarChar(100) = '[adw].[QM_ResultByMember_History]',
								@QMDATE DATE,
								@CodeEffectiveDate DATE,
								@MeasurementYear			INT,
								@ClientKeyID				Varchar(2),
								@MbrEffectiveDate			DATE)
AS 
  /* 
  **Set Logging Parameters
  */
    --Declare @batchDate Date	= '2019-03-17'; 
	DECLARE @RUNDATE1 DATE					= @QMDATE
	DECLARE @InsertCount INT;
	DECLARE	@SourceCount INT;
	DECLARE @QueryCount INT					= 0;    
	DECLARE @Audit_ID INT					= 0;
	DECLARE @ClientKey INT					= (SELECT ClientKey FROM Lst.List_client WHERE ClientShortName = 'SHCN_MSSP');
	DECLARE @qmFx VARCHAR(100);
	DECLARE @Destination VARCHAR(100)		= 'adw.QM_ResultByMember_History';
	DECLARE @JobName VARCHAR(100)			= '[AceMasterQMCalc]sp_Calc_QM_All';
	DECLARE @StartTime DATETIME2;
	DECLARE @OutputTbl Table (ID INT)
	DECLARE @srcQMDATE1 DATE
	DECLARE @trgQMDATE1 DATE
	DECLARE @LoadDateAthena_AWV1 DATE
	DECLARE @DataDate DATE
	DECLARE @LoadDateAthena1 DATE
	DECLARE @LoadDate DATE

	--INSERT INTO @OutputTbl (ID)
	--SELECT urn FROM [adw].[QM_ResultByMember_TESTING] 
	--SELECT @SourceCount = COUNT(*) FROM @OutputTbl 
   
   -- Audit Status     1	In process,     2	Success,    3	Fail-- Job Type        4	Move File,    5	ETL Data,     6	Export Data
   /*
   ***The logging calls is called inside the QM Procedure 
   ***Set Open logging
   ***Set Close logging
   */


	--------- Process Ace AWV  
	SET @StartTime = GETDATE();	   
	SET @qmFx = 'sp_2020_Calc_QM_ACE_PREV_AWV'; 
	EXEC AceMetaData.amd.sp_AceEtlAudit_Open @AuditID = @Audit_ID OUTPUT,   @AuditStatus = 1, @JobType = 5, @ClientKey = @ClientKey,@JobName = @JobName,
	                   @ActionStartTime = @StartTime, @InputSourceName = @qmFx, @DestinationName = @Destination, @ErrorName = 'Check table , AceEtlAuditErrorLog' 
	EXEC [adw].[sp_2020_Calc_QM_ACE_PREV_AWV] '[adw].[QM_ResultByMember_History]',@QMDATE,@CodeEffectiveDate,@MeasurementYear,@ClientKey,@MbrEffectiveDate;
	SET @StartTime = GETDATE();	   
	EXEC AceMetaData.amd.sp_AceEtlAudit_Close @auditid = @Audit_ID, @ActionStopTime = @StartTime, @SourceCount = @SourceCount, @DestinationCount = @SourceCount,@ErrorCount = @@ERROR;  

