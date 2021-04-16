



CREATE PROCEDURE [lst].[usp_02LoadPCPFromStg_OLD]
AS

BEGIN ---SELECT * FROM lst.list_pcp

		BEGIN TRAN 
		
		MERGE				lst.LIST_PCP trg
		USING				ast.List_PCP src
		ON					trg.Client_ID = src.Client_ID
		AND					trg.[PCP_NPI] = src.[PCP_NPI]
		AND					trg.[PCP_FIRST_NAME] = src.[PCP_FIRST_NAME]
		AND					trg.[PCP_LAST_NAME] = src.[PCP_LAST_NAME]
		AND					trg.[PCP_PRACTICE_TIN_NAME] = src.[PCP_PRACTICE_TIN_NAME]
		AND					trg.[PCP_PRACTICE_TIN] = src.[PCP_PRACTICE_TIN]
		WHEN MATCHED
		THEN UPDATE
		SET					trg.[EffectiveDate] = src.[EffectiveDate]
							,trg. [ExpirationDate] = src.[ExpirationDate]
		WHEN NOT MATCHED BY TARGET
		THEN INSERT				([SrcFileName]
								 ,	[CLIENT_ID]
								 ,	[PCP_NPI]
								 ,	[PCP_FIRST_NAME]
								 ,	[PCP_MI]
								 ,  [PCP_LAST_NAME]
								 ,	[PCP__ADDRESS]
								 ,	[PCP__ADDRESS2]
								 ,  [PCP_CITY]
								 ,	[PCP_STATE]		
								 ,  [PCP_ZIP]
								 ,  [PCP_PHONE]
								 ,	[PCP_CLIENT_ID]
								 ,	[PCP_PRACTICE_TIN]		
								 ,  [PCP_PRACTICE_TIN_NAME]
								 ,  [PRIM_SPECIALTY]
								 ,  [PROV_TYPE]
								 ,	[PCP_FLAG]
								 ,  [CAMPAIGN_RUN_ID]
								 ,	[T_Modify_by]
								 ,	[ACTIVE]
								 ,	[EffectiveDate]
								 ,  [ExpirationDate]
								 ,	[AccountType]
								 ,	[PCP_POD]
								 ,	[County]
								 ,  [Sub_Speciality])
		VALUES					([SrcFileName]
								 ,src.[CLIENT_ID]
								 ,src.[PCP_NPI]
								 ,src.[PCP_FIRST_NAME]
								 ,src.[PCP_MI]
								 ,src.[PCP_LAST_NAME]
								 ,src.[PCP__ADDRESS]
								 ,src.[PCP_CITY]
								 ,src.[PCP_CITY]
								 , src.[PCP_STATE]
								 ,src.[PCP_ZIP]
								 ,src.[PCP_PHONE]
								 ,src.[PCP_CLIENT_ID]
								 ,src.[PCP_PRACTICE_TIN]
								 ,src.[PCP_PRACTICE_TIN_NAME]
								 ,src.[sub_speciality]
								 ,src.[PROV_TYPE]
								 ,src.[PCP_FLAG]
								 ,src.[CAMPAIGN_RUN_ID]
								 ,src.[T_Modify_by]
								 ,src.[Active]
								 ,src.effectivedate
								 ,src.expirationdate
								 ,src.[AccountType]
								 ,src.[PCP_POD]
								 ,src.[County]
								 ,src.[Sub_Speciality])
		;
	COMMIT
	
	END
		

		BEGIN
			--Validate DEDUPS
				SELECT		a.PCP_NPI,b.PCP_NPI,b.PCP_PRACTICE_TIN,b.PCP_PRACTICE_TIN_NAME,b.PCP__ADDRESS, b.PCP_FIRST_NAME,b.PCP_LAST_NAME
				FROM		(
				SELECT		COUNT(*)RecCnt, PCP_NPI 
				FROM		lst.List_PCP
				GROUP BY	PCP_NPI
				HAVING		COUNT(*) > 1
							)a
				JOIN		lst.List_PCP b
				ON			a.PCP_NPI = b.PCP_NPI
				ORDER BY	b.PCP_NPI

		END
		

		
