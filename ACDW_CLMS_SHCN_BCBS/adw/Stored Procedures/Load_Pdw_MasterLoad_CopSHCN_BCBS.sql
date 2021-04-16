
CREATE PROCEDURE [adw].[Load_Pdw_MasterLoad_CopSHCN_BCBS](
				 @QMDATE DATE
				 ,@ClientKey INT
				 ,@DataDate DATE
				 ,@RUNDATE DATE
				 )

AS

	BEGIN
		--Process into staging
		EXECUTE [ast].[plsBCBSCareoppsMonthlyGaps]@QMDATE,@ClientKey,@DataDate
	
	END

	BEGIN
		--Update row status
		UPDATE		[ACDW_CLMS_SHCN_BCBS].[adi].[Steward_BCBS_MONTHLY_GAPS_IN_CAREDETAIL]
		SET	Status	= 1
		WHERE		DataDate = @DataDate

	END
	
	BEGIN
			--process into DW
		EXECUTE [adw].[pdwCOP_SHCN_BCBS]@QMDATE,@ClientKey
	
	END

	