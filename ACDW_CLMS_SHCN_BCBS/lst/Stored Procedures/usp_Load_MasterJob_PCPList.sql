

CREATE PROCEDURE [lst].[usp_Load_MasterJob_PCPList](@ClientKey INT, @DataDate DATE)
AS

BEGIN

EXECUTE  [ast].[usp_01LoadPCPIntoStg]@ClientKey--,@DataDate

END



BEGIN

EXECUTE  [lst].[usp_02LoadPCPFromStg]

END


	