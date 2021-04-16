

CREATE  VIEW [dbo].[vw_Exp_AH_Eligibility]
AS
    /* version history:
    04/26/2020 - first export list created by RA, this doesnot change in an given year unless members switch plans	   
    01/14/2020 - gk: make export show total time member is active as elig: ie first active month through last active month
    01/19/2020 - GK: Fix errors in Plan END data distibution from the Validation below
    02/25/2021: GK: PV ask to use the where mbr.SubgrpName <> 'COMM_Market is unknown' -- bcbs filter (these members do not have a valid plan)
	   to suppress the members with invalid plans from being sent to ahs
    */
    
    /* To VALIDATE this view:  SELECT * FROM [dbo].[vw_Exp_AH_Eligibility]
    
    1. get member count, row count should equal total membership
	   SELECT COUNT(*) FROM [dbo].[vw_Exp_AH_Eligibility] 
    2. GEt min, max start dates, should all be in possible effective period of membership (1/1/2020-12/31/2099)
	   SELECT min(e.START_DATE), max(e.START_DATE), min(e.END_DATE), max(e.END_DATE) from dbo.vw_Exp_AH_Eligibility e
    3. group by start date, and look at value distribution.
	   SELECT e.START_DATE, count(*) FROM [dbo].[vw_Exp_AH_Eligibility] e  group by e.START_DATE
    4. Group by end date and look at distribution, should be some attrition per month, and the vast majority should end 12/31/2099
	   SELECT e.END_DATE, count(*) FROM [dbo].[vw_Exp_AH_Eligibility] e group by e.END_DATE order by e.End_Date desc
	   IF the values do not make sense, sample with the below code
	   TO evaluate sample member from the result set USE :
		  /* verify active rows for a member */
		  declare @cmk varchar(50) = '2YH8UA9FC46';
		  SELECT * 
		  FROM adw.FctMembership m 
		  WHERE m.ClientMemberKey = @cmk and m.Active = 1
		  
		  /* review all rows for a members */
		  SELECT m.FctMembershipSkey, m.Ace_ID, m.ClientMemberKey, m.Active, m.Excluded, m.dod, m.RwEffectiveDate, m.RwExpirationDate
		  FROM adw.FctMembership m
		  where m.ClientMemberKey = @cmk
		  ORDER BY m.RwEffectiveDate desc
    5. Add new tests here
    */
    SELECT DISTINCT 
		 mbr.ClientMemberKey AS [MEMBER_ID], mbr.active,
		 lc.clientshortname AS CLIENT_ID, 
		 lc.CS_Export_LobName AS [LOB],
		 mbr.[BENEFIT PLAN],
		 'E' AS [INTERNAL/EXTERNAL INDICATOR], 
		 mbr.PlanEffDate AS [START_DATE], 
		 mbr.PlanExpDate AS END_DATE  		 
    FROM (SELECT m.ClientMemberKey, m.ClientKey, m.active		      
			 , m.SubgrpName AS [BENEFIT PLAN]
		      , GetMinEffDate.MinEffDate AS  PlanEffDate
			 , CASE WHEN (GetMaxEffDate.MaxRwExDate IS NULL) THEN DATEADD(day, -1, GetMinEffDate.MinEffDate)
				ELSE GetMaxEffDate.MaxRwExDate END AS PlanExpDate
		  --SELECT *
		  FROM adw.FctMembership m
		      JOIN (SELECT m.ClientMemberKey,min(m.RwEffectiveDate) MinEffDate
		  		  FROM adw.fctmembership m
		  		  WHERE m.RwEffectiveDate >= '01/01/2020' -- records from 2020 into the future
		  		  GROUP BY m.ClientMemberKey ) GetMinEffDate
		  	   ON  m.ClientMemberKey = GetMinEffDate.ClientMemberKey
		      JOIN (SELECT max(m.RwEffectiveDate) MaxEffDate from adw.FctMembership m) GetCurMonth
		  	   ON GetCurMonth.MaxEffDate between m.RwEffectiveDate and m.RwExpirationDate
		      LEFT JOIN (SELECT m.ClientMemberKey,
						  CASE WHEN (max(m.RwExpirationDate) = (SELECT max(RwExpirationDate) FROM adw.FctMembership m)) THEN '12/31/2099'
							 ELSE max(m.RwExpirationDate) END as  MaxRwExDate
		  			   FROM adw.fctmembership m
		  			   WHERE m.Active = 1 AND 
						  m.RwEffectiveDate >= '01/01/2020' -- records from 2020 into the future
						  --and m.ClientMemberKey = '1QA6VP2JY48'
		  			   GROUP BY m.ClientMemberKey) GetMaxEffDate 
		  		  ON m.ClientMemberKey = GetMaxEffDate.ClientMemberKey
		  where m.SubgrpName <> 'COMM_Market is unknown'
	   ) mbr
	   INNER JOIN lst.[List_Client] lc ON lc.ClientKey = mbr.ClientKey
