

CREATE PROCEDURE adw.pnm_NewMembersForTheMonth

AS

	DECLARE @LoadDateCur DATE = '2021-02-19' 
	DECLARE @LoadDatePri DATE = (	SELECT		DISTINCT LoadDate
									FROM		ACDW_CLMS_SHCN_BCBS.adw.fctmembership
									WHERE		LoadDate 
									NOT IN		(	SELECT MAX(LoadDate) 
													FROM ACDW_CLMS_SHCN_BCBS.adw.fctmembership 
												)
								)
	--Retrieving new members for the month
	---Recent Load
	SELECT		ClientMemberKey
	FROM		ACDW_CLMS_SHCN_BCBS.adw.fctmembership
	WHERE		LoadDate = @LoadDateCur  
	EXCEPT
	--Prior Load
	SELECT		ClientMemberKey
	FROM		ACDW_CLMS_SHCN_BCBS.adw.fctmembership
	WHERE		LoadDate = @LoadDatePri     ----     