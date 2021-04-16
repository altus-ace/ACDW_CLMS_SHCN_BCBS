
USE ACDW_CLMS_SHCN_BCBS
GO

ALTER PROCEDURE [ast].[usp_01LoadPCPIntoStg_OLD](@ClientKey INT, @DataDate DATE) --  [ast].[usp_01LoadPCPIntoStg]20,'2021-03-25'
AS
---Insert into stg and transform
--stg table shud be same structure as list pcp
--insert into Acemasterdata list pcp
	--			 SELECT MAX(DataDate) FROM ACECAREDW.adw.fctProviderRoster
BEGIN
--Step 1: Insert into Staging

--Step 1
		
		INSERT INTO			ast.LIST_PCP (  -- SELECT * FROM lst.LIST_PCP
							[SrcFileName]
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
		--DECLARE @DATE DATE = GETDATE()
		SELECT				[SrcFileName]
							,[CLIENT_ID]
							,[PCP_NPI]
							,[PCP_FIRST_NAME]
							,[PCP_MI]
							,[PCP_LAST_NAME]
							,[PCP__ADDRESS]
							,[PCP__ADDRESS2]
							,[PCP_CITY]
							,[PCP_STATE]
							,[PCP_ZIP]
							,[PCP_PHONE]
							,[PCP_CLIENT_ID]
							,[PCP_PRACTICE_TIN]
							,[PCP_PRACTICE_TIN_NAME]
							,[PRIM_SPECIALTY]
							,[Sub_Speciality]
							,[PROV_TYPE]
							,[PCP_FLAG]
							,[CAMPAIGN_RUN_ID]
							,[T_Modify_by]
							,[ACTIVE]
							,[EffectiveDate]
							,[ExpirationDate]			
							,[PCP_POD]
							,[AccountType]
							,[County]
							--,[RwCnt]
		FROM				(
									SELECT			DISTINCT [SourceJobName]									AS [SrcFileName]
													, [ClientKey]											AS [CLIENT_ID]
													, [NPI]														AS [PCP_NPI]
													, [adi].[udf_ConvertToCamelCase]([FirstName])				AS [PCP_FIRST_NAME]
													, ''														AS [PCP_MI]
													, [adi].[udf_ConvertToCamelCase]([LastName])				AS [PCP_LAST_NAME]
													, PrimaryAddress											AS [PCP__ADDRESS]
													, ''														AS [PCP__ADDRESS2]
													, PrimaryCity												AS [PCP_CITY]
													, PrimaryState												AS [PCP_STATE]
													, PrimaryZipcode											AS [PCP_ZIP]
													, PrimaryAddressPhoneNum									AS [PCP_PHONE]
													, ''														AS [PCP_CLIENT_ID]
													, [TIN]														AS [PCP_PRACTICE_TIN]
													, [adi].[udf_ConvertToCamelCase]([GroupName])				AS [PCP_PRACTICE_TIN_NAME]
													, [adi].[udf_ConvertToCamelCase]([PrimarySpeciality])		AS [PRIM_SPECIALTY]
													, [adi].[udf_ConvertToCamelCase](a.[Sub_Speciality])		AS [Sub_Speciality]
													, [ProviderType]											AS [PROV_TYPE]
													, CASE [ProviderType]
													   WHEN 'PCP' THEN 'Y'
													   ELSE 'N'
													   END														AS [PCP_FLAG]
													, ''														AS [CAMPAIGN_RUN_ID]
													, ''														AS [T_Modify_by]
													, 'Y'														AS [ACTIVE]
													, a.[EffectiveDate]											AS [EffectiveDate]
													, a.[ExpirationDate]										AS [ExpirationDate]						
													, [Chapter]													AS [PCP_POD]
													, a.[AccountType]											AS [AccountType]
													, [PrimaryCounty]											AS [County]
													, ROW_NUMBER() OVER (PARTITION BY NPI, TIN ORDER BY DataDate DESC) RwCnt
									FROM			ACECAREDW.adw.fctProviderRoster a
									LEFT JOIN		lst.List_PCP b
									ON				a.NPI = b.PCP_NPI
									WHERE			ClientKey =   @ClientKey -- 20 --
									AND				DataDate =   @DataDate --  '2021-03-09'  ---
									AND				b.PCP_NPI IS NULL 
									
							)drv
		WHERE				RwCnt = 1
END


BEGIN					

--Step 2: Transform Data
		
		UPDATE				ast.LIST_PCP
		SET					--[PCP__ADDRESS] =  [adi].[udf_ConvertToCamelCase](ISNULL([PCP__ADDRESS],''))
							--,[PCP_CITY]   =   [adi].[udf_ConvertToCamelCase](ISNULL([PCP_CITY],''))
							--,[PCP_FIRST_NAME]   =   [adi].[udf_ConvertToCamelCase](ISNULL(PCP_FIRST_NAME,''))
							--,PCP_LAST_NAME   =   [adi].[udf_ConvertToCamelCase](ISNULL(PCP_LAST_NAME,''))
							--,PCP_PRACTICE_TIN_NAME   =   [adi].[udf_ConvertToCamelCase](ISNULL(PCP_PRACTICE_TIN_NAME,''))
							--,PRIM_SPECIALTY   =   [adi].[udf_ConvertToCamelCase](ISNULL(PRIM_SPECIALTY,'')),
							County   =   [adi].[udf_ConvertToCamelCase](ISNULL(County,''))
		FROM				ast.LIST_PCP lst

		UPDATE				ast.List_PCP
		SET					PCP__ADDRESS = ''
		WHERE				PCP__ADDRESS IS NULL

		UPDATE				ast.List_PCP
		SET					PCP__ADDRESS2 = ''
		WHERE				PCP__ADDRESS2 IS NULL

		UPDATE				ast.LIST_PCP
		SET					PCP_PRACTICE_TIN = 'No TIN'
		WHERE				PCP_PRACTICE_TIN IS NULL

		UPDATE				ast.LIST_PCP
		SET					PCP_PRACTICE_TIN_NAME = 'No TINName'
		WHERE				PCP_PRACTICE_TIN_NAME IS NULL


			--d Format PCP_Phone
		UPDATE				ast.LIST_PCP
		SET					PCP_PHONE = [lst].[fnStripNonNumericChar](PCP_PHONE)
		
		UPDATE				ast.LIST_PCP
		SET					County = [adi].[udf_ConvertToCamelCase](County)
	
	
			-- Derive PCP_POD from Counties
	 	UPDATE		ast.LIST_PCP
		SET			PCP_POD = Destination
		---  SELECT		a.County,a.PCP_POD,b.Source,b.Destination
		FROM			ast.LIST_PCP a
		JOIN			lst.ListAceMapping b
		ON			a.County = b.Source
		WHERE			a.SrcFileName <> '[dbo].[z_BCBS_ListPcp.xlsx]'

END

/*
USUAGE: EXECUTE [ast].[usp_01LoadPCPIntoStg]20,'2021-03-01'
*/

--SELECT * FROM ast.LIST_PCP  -- 792

--SELECT		* 
--FROM		ACECAREDW.adw.fctProviderRoster
--WHERE		DataDate = '2021-03-01' AND ClientKey = 20

--Validation
SELECT		COUNT(*), PCP_NPI
FROM		ast.LIST_PCP 	
GROUP BY	PCP_NPI
HAVING		COUNT(*)>1
/*
		NPIs with Double TINs
		SELECT PCP_NPI,PCP_PRACTICE_TIN,PCP_PRACTICE_TIN_NAME, CreatedDate FROM lst.LIST_PCP WHERE PCP_NPI IN
		(
		'1326209354',
		'1518157213',
		'1811939606',
		'1871026401')
		ORDER BY PCP_NPI

		*/

	
	
