/****** Script for SelectTopNRows command from SSMS  ******/


--Transform 

CREATE PROCEDURE lst.z_List_PCP_Adhoc_OneTime_Load

AS
SET ANSI_WARNINGS OFF

INSERT INTO ast.LIST_PCP ([SrcFileName]
					, [CLIENT_ID]
					, [PCP_NPI]
					, [PCP_FIRST_NAME]
					, [PCP_MI]
					, [PCP_LAST_NAME]
					, [PCP__ADDRESS]
					, [PCP__ADDRESS2]
					, [PCP_CITY]
					, [PCP_STATE]  
					, [PCP_ZIP]
					, [PCP_PHONE]
					, [PCP_CLIENT_ID]
					, [PCP_PRACTICE_TIN]
					, [PCP_PRACTICE_TIN_NAME]
					, [PRIM_SPECIALTY]
					, [Sub_Speciality]
					, [PROV_TYPE]
					, [PCP_FLAG]
					, [CAMPAIGN_RUN_ID]
					, [T_Modify_by]
					, [ACTIVE]
					, [EffectiveDate]
					, [ExpirationDate]
					, [PCP_POD]
					, [AccountType]
					, [County])




	SELECT				'[dbo].[z_BCBS_ListPcp.xlsx]'
					,20
					,[Provider_NPI_b_c]
					,[First_Name_b]
					,''					AS		MiddleName
					,[Last_Name_b]		AS		LastName
					, ''				AS     [PCP__ADDRESS]
					, ''				AS     [PCP__ADDRESS2]
					, ''				AS     [PCP_CITY]
					, ''				AS     [PCP_STATE]  
					, ''				AS     [PCP_ZIP]
					, ''				AS     [PCP_PHONE]
					, ''				AS     [PCP_CLIENT_ID]
					,[Account_Name_Tax_ID_Number] AS [PCP_PRACTICE_TIN]
					,[Account_Name_Account_Name] AS [PCP_PRACTICE_TIN_NAME]
					,''								AS  [PRIM_SPECIALTY]
					,''								AS  [Sub_Speciality]
					,[Type]							AS [PROV_TYPE]
					, CASE [Type]
						WHEN 'PCP' THEN 'Y'
						ELSE 'N'
						END							AS  [PCP_FLAG]
					, ''							AS  [CAMPAIGN_RUN_ID]
					, ''							AS  [T_Modify_by]
					, ''							AS  [ACTIVE]
					, '2021-01-01'					AS  [EffectiveDate]
					, '2099-12-31'					AS  [ExpirationDate]
					, ''							AS  [PCP_POD]
					,[Account_Name_Account_Type]	AS [AccountType]
					,''								AS [County]	
  FROM				[ACDW_CLMS_SHCN_BCBS].[dbo].[z_BCBS_ListPcp.xlsx]



  INSERT INTO lst.LIST_PCP ([SrcFileName]
					, [CLIENT_ID]
					, [PCP_NPI]
					, [PCP_FIRST_NAME]
					, [PCP_MI]
					, [PCP_LAST_NAME]
					, [PCP__ADDRESS]
					, [PCP__ADDRESS2]
					, [PCP_CITY]
					, [PCP_STATE]  
					, [PCP_ZIP]
					, [PCP_PHONE]
					, [PCP_CLIENT_ID]
					, [PCP_PRACTICE_TIN]
					, [PCP_PRACTICE_TIN_NAME]
					, [PRIM_SPECIALTY]
					, [Sub_Speciality]
					, [PROV_TYPE]
					, [PCP_FLAG]
					, [CAMPAIGN_RUN_ID]
					, [T_Modify_by]
					, [ACTIVE]
					, [EffectiveDate]
					, [ExpirationDate]
					, [PCP_POD]
					, [AccountType]
					, [County])
SELECT				[SrcFileName]
					, [CLIENT_ID]
					, [PCP_NPI]
					, [PCP_FIRST_NAME]
					, [PCP_MI]
					, [PCP_LAST_NAME]
					, [PCP__ADDRESS]
					, [PCP__ADDRESS2]
					, [PCP_CITY]
					, [PCP_STATE]  
					, [PCP_ZIP]
					, [PCP_PHONE]
					, [PCP_CLIENT_ID]
					, [PCP_PRACTICE_TIN]
					, [PCP_PRACTICE_TIN_NAME]
					, [PRIM_SPECIALTY]
					, [Sub_Speciality]
					, [PROV_TYPE]
					, [PCP_FLAG]
					, [CAMPAIGN_RUN_ID]
					, [T_Modify_by]
					, [ACTIVE]
					, [EffectiveDate]
					, [ExpirationDate]
					, [PCP_POD]
					, [AccountType]
					, [County]
	FROM			ast.LIST_PCP



--	BEGIN TRAN --  COMMIT
	UPDATE		lst.List_PCP
	SET			PCP_POD = b.Destination   ---  SELECT Source, Destination, PCP_POD
	FROM		lst.List_PCP a
	JOIN		(SELECT Source, Destination FROM lst.ListAceMapping WHERE CLIENTKEY = 20) b
	ON			a.County = b.Source

	--SELECT		 County, PCP_POD,*
	--FROM		lst.List_PCP where pcp_npi in
	--	(
	--	'1780978171',
	--	'1669472288',
	--	'1376956755',
	--	'1225124506',
	--	'1134540024',
	--	'1215137104')

