




--- last modify 02/12/2021 - new code from Si

CREATE  VIEW [adw].[vw_Exp_TexasADTMsg] 
AS 

-- Get the latest Membership that belongs to SHCN
WITH CTE AS (			
	SELECT
       m.ClientMemberKey
      ,m.Ace_ID
		,m.FirstName
      ,m.MiddleName
      ,m.LastName
      ,m.Gender
      ,m.DOB
      ,m.DOD
      ,m.NPI
      ,m.PcpPracticeTIN
      ,p.AccountType		as ProviderNetwork	
      ,m.MbrMonth
      ,m.MbrYear
		,p.AccountType 
		,m.PlanName AS PlanName
		,m.PlanID AS PlanID
		,m.LOB AS LOB
	FROM [adw].[vw_Dashboard_Membership] m
	LEFT JOIN lst.LIST_PCP p
	ON m.NPI	= p.PCP_NPI
	WHERE m.Active = 1
	AND m.MbrYear = (SELECT MAX(MbrYear) FROM [adw].[vw_Dashboard_Membership])
	AND m.MbrMonth = (SELECT MAX(MbrMonth) FROM [adw].[vw_Dashboard_Membership] 
		WHERE MbrYear = (SELECT MAX(MbrYear) FROM [adw].[vw_Dashboard_Membership]))
	AND p.AccountType	IN ('SHCN_SMG','SHCN_AFF')
)

  
SELECT 
	 NTF.NtfGhhNotificationKey
	,CODE.ACE_Definition			AS 'Facility Name' 
	,''								AS 'Facility NPI'
	,''								AS 'Facility City'
	,''								AS 'Facility State'
	,''								AS 'Facility Type' 
	,NTF.AceClientMemberID			AS 'Visit ID'   --- change it to AceClientMemberID from PatientVisitID 03/05/2021 BY	
	,CASE NTF.EventType WHEN 'A03' THEN 'Discharge' END AS 'Status'
	,CONVERT(DATE, NTF.AdmitDateTime)		AS 'AdmitDate'
	,CONVERT(DATE, NTF.DischargeDateTime)	AS 'DischargeDate'
	,'' AS Setting
	,Mbr.AceClientMemberId AS 'Patient ID'
	,Mbr.LastName AS 'Last Name'
	,Mbr.FirstName AS 'First Name'
	,Mbr.MiddleName AS 'Middle Name'
	,'' AS Suffix
	,Mbr.DateOfBirth AS DOB
	,Mbr.Gender AS Gender
	,Mbr.HomeAddress1 AS Address1
	,Mbr.HomeAddress2 AS Address2
	,'' AS Address3
    ,Mbr.HomeCity AS City
    ,Mbr.HomeState AS [State]
    ,Mbr.HomeZip AS Zip
    ,Mbr.MobilePhone AS 'Mobile Phone'
    ,MBr.HomePhone AS 'Home Phone'
	,'' AS 'Patient Phone Number (Unknown source)'
	,FMP.ClientMemberKey AS 'Primary Insurance Number'
	,FMP.LOB AS 'Primary Insurer'
	,FMP.PlanName AS 'Primary Insurance Plan'
	,'' AS 'Insurance Billed'
    ,'' AS 'Other Practices'
	,'' AS 'Other Providers'
	,'' AS 'Other Programs'
	,NTF.PatientVisitID AS 'Facility Visit Id'
	,MBR.AceClientMemberId AS 'Account Number'
	,NTF.AdmitSource AS 'Admitted From'
	,NTF.DischargeDisposition AS 'Discharged Disposition'
	,NTF.DischargedLocation AS 'Discharge Location'
,   '' AS 'MLOA Disposition'
	,'' AS 'MLOA Location'
	,NTF.AdmittingDoctor AS 'Admit Care Coordinator'
	,'' AS 'Discharge Care Coordinator'
	,'' AS 'Entry Delay'
	,Convert(VARCHAR(5), DateDiff(s, NTF.AdmitDateTime, NTF.DischargeDateTime) / 3600) + ':' + convert(VARCHAR(5), DateDiff(s, NTF.AdmitDateTime, NTF.DischargeDateTime) % 3600 / 60) + ':' + convert(VARCHAR(5), (DateDiff(s, NTF.AdmitDateTime, NTF.DischargeDateTime) % 60)) AS 'Visit Duration - (days)'
		,CASE WHEN DATEDIFF(d, NTF.DischargeDateTime, NTF.AdmitDateTime) = 0 THEN 1 ELSE DATEDIFF(d, NTF.DischargeDateTime, NTF.AdmitDateTime) END AS 'LOS'
	,'' AS 'CCD'
	,'' AS 'Attending Provider NPI'
	,'' AS 'Attending Provider Las tName'
	,'' AS 'Attending Provider First Name'
	,'Y' AS 'Active Roster Patient'
	,NTF.DiagnosisDescription AS 'Primary Diagnosis Description'
	,NTF.DiagnosisCode AS 'Primary Diagnosis Code'
	,NTF.DiagnosisType AS 'Diagnosis Category'
   ,'' AS 'Subsequent Diagnosis Codes'
	,'' AS 'High Utilizer Flag'
	,'' AS 'Readmission Risk Flag'
	,'' AS 'Recent SNF Stay Flag'
	,'' AS 'Recent Inpatient Stay Flag'
	,'' AS 'COVID_19 Flags'
	, NTF.CreatedDate AS CreateDate  

	--,CONVERT(DATE, SUBSTRING(NTF.MessageDateTime, 1, 8)) AS EventReceiveDate
	--,CONVERT(TIME, (SUBSTRING(NTF.MessageDateTime, 9,2) + ':' + SUBSTRING(NTF.MessageDateTime, 11,2) +':' + SUBSTRING(NTF.MessageDateTime, 13,2))) AS  EventReceiveTime -- MessageDateTime
	--,CONVERT(DATE, NTF.CreatedDate) AS EventProcessedDate
	--,CONVERT(TIME, NTF.CreatedDate) AS EventProcessedTime

	 

FROM (
	SELECT *											-- Get latest A03 record for AceClientMemberID
	FROM (
		SELECT *
			,CONVERT(DATE, AdmitDateTime) AS AdmitDate
			,CONVERT(DATE, DischargeDateTime) AS DischDate
			,ROW_NUMBER() OVER (PARTITION BY AceClientMemberID ORDER BY NtfGhhNotificationKey DESC) AS rn
		FROM [ACECAREDW].[adi].[NtfGhhNotifications]
		WHERE EventType = 'A03'
			AND DischargeDateTime IS NOT NULL
		  --  AND  [SendADTDate] IS NULL
			AND  CONVERT(DATE, CreatedDate) <=  CONVERT(DATE, DATEADD(day, -1, GETDATE()))
			-- DATEADD(day, -1, GETDATE())   ---  add Date filer to only get data from up to yesterday BY 02/25/2021
		) a
	WHERE rn = 1
	) NTF
	LEFT JOIN (										-- Member Demographics, latest record for AceClientMemberID
			SELECT * FROM (
			SELECT Mbr.AceClientMemberId, FirstName, LastName, MiddleName, DateOfBirth, Gender, HomeAddress1, 
			HomeAddress2,HomeCity, HomeState, HomeZip, MobilePhone, HomePhone
			,ROW_NUMBER() OVER (PARTITION BY AceClientMemberID ORDER BY MbrGhhMemberKey DESC) AS rn 
			FROM [ACECAREDW].[adi].[MbrGhhMember] Mbr
			) a
			WHERE rn = 1
		) mbr
	ON Mbr.AceClientMemberId = NTF.AceClientMemberID
	JOIN CTE FMP									-- Get the latest Membership that belongs to SHCN
		ON NTF.AceID = FMP.Ace_ID
	LEFT JOIN [lst].[lstGHHCodes] CODE		-- Get Hospital Name
		ON NTF.AdmitHospital = CODE.Code
	WHERE getdate() BETWEEN CODE.EffectiveDate AND CODE.ExpirationDate
	AND CODE.[TYPE] = 'FacilityCode'
	AND CODE.Active = 'Y'
	AND CODE.Sub_Type <> 'NA'



