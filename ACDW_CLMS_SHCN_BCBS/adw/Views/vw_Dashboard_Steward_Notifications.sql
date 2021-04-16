

CREATE VIEW [adw].[vw_Dashboard_Steward_Notifications]
AS

SELECT  [DischargedMedicarePatientsKey]
      ,stwntf.[SrcFileName]
      ,[CreateDate]
      ,[CreateBy]
      ,[OriginalFileName]
      ,stwntf.[LastUpdatedBy]
      ,stwntf.[LastUpdatedDate]
      ,stwntf.[DataDate]
      ,[FIN]
      ,[PriInsurance]
      ,[InsuranceMemberID]
      ,[FName]
      ,[LName]
      ,[Birth]
      ,[IPAdmitDateTime]
      ,[NurseUnit]
      ,[Room]
      ,[Address]
      ,[Phone]
      ,[GMLOS]
      ,[DRG]
      ,[DRGDescription]
      ,[DischargeDateTime]
      ,[DischargeDisposition]
      ,[Attending]
      ,[AttendingNPI]
      ,[Surgeon]
      ,[Sex]
      ,[MRN]
      ,[Loc]
      ,[HospitalName]
      ,[HospNPI]
      ,[Status]
FROM				[ACDW_CLMS_SHCN_MSSP].[adi].[Steward_MSSPDischargedMedicarePatients] stwntf
 join [adw].[vw_Dashboard_Membership] mbr on
 mbr.ClientMemberKey= stwntf.InsuranceMemberID --and mbr.MbrMonth =MONTH(stwntf.DataDate) and mbr.MbrYear = year(stwntf.DataDate)

WHERE				CONVERT(DATE,stwntf.DataDate) BETWEEN DATEADD(DAY,-7,CONVERT(DATE,GETDATE())) AND CONVERT(DATE,GETDATE())
















