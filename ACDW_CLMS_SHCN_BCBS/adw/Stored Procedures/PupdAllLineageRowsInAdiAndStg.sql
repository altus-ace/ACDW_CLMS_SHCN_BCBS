

CREATE PROCEDURE [adw].[PupdAllLineageRowsInAdiAndStg](@DataDate DATE) --  [adw].[PupdAllLineageRowsInAdiAndStg]'2021-02-18'

AS

BEGIN
		/*Updating all lineages from adi to staging*/
		UPDATE		ast.MbrStg2_MbrData
		SET			stgRowStatus = 'Exported'
		WHERE		stgRowStatus = 'VALID'
		AND			DataDate = @DataDate

END


BEGIN

		UPDATE		adi.Steward_BCBS_Membership
		SET			Status = 1
		WHERE		Status = 0
		AND			DataDate = @DataDate

		UPDATE		adi.Steward_BCBS_MemberCrosswalk
		SET			Status = 1
		WHERE		Status = 0
		AND			DataDate = @DataDate

END
