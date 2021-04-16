


CREATE PROCEDURE [adw].[sp_2020_Calc_QM_All](@RUNDATE DATE
											,@srcQMDATE DATE
											,@trgQMDATE DATE
											,@LoadDateAthena_AWV DATE
											,@LoadDateAthena DATE
											,@QMDATE DATE
											,@ClientKey INT
											,@DataDate DATE
											,@LoadDate DATE
											,@ConnectionStringProd	NVarChar(100)
											,@CodeEffectiveDate DATE
											,@MeasurementYear	INT
											,@ClientKeyID Varchar(2)
											,@MbrEffectiveDate	DATE)
AS 
 

   BEGIN

			---Process CareOpps			
				EXECUTE [adw].[Load_Pdw_MasterLoad_CopSHCN_BCBS]
								 @QMDATE, @ClientKey, @DataDate, @RUNDATE
								
	END

	--------- Process Ace QM for AWV  
	BEGIN

	EXECUTE adw.QM_AWV				@ConnectionStringProd
									,@QMDATE
									,@CodeEffectiveDate
									,@MeasurementYear
									,@ClientKeyID
									,@MbrEffectiveDate		
	
	END

	WAITFOR DELAY '00:00:02'; 
	
	BEGIN
		---Process QM Addressed for Ace QM_AWV
		EXECUTE [adw].[Load_MasterJob_QM_Addressed] @DataDate
													,@ClientKey
													,@srcQMDATE
													,@trgQMDATE
													,@LoadDateAthena
													,@LoadDateAthena_AWV
													,@LoadDate
	END